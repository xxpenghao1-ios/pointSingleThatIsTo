//
//  RememberViewController.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/7/13.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import SVProgressHUD
import SwiftyJSON
/// 购物积分
class PresentExpViewController:BaseViewController{
    /// table视图
    fileprivate var table:UITableView?
    /// table头部视图
    fileprivate var tableHeaderView:UIView?
    /// 数据源
    fileprivate var arr=NSMutableArray()
    /// 空视图提示
    fileprivate var lblNilTitle:UILabel?
    /// 加载页数
    fileprivate var currentPage=0
    /// 剩余积分
    fileprivate var integral:Int?
    /// 剩余积分
    fileprivate var lblIntegral:UILabel?
    override func viewDidLoad(){
        super.viewDidLoad()
        httpQueryMemberIntegral()
        self.title="点单商城"
        self.view.backgroundColor=UIColor.white
        
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(title:"兑换记录", style: UIBarButtonItemStyle.plain, target:self, action:#selector(pushRecordOfConversion))
        
        tableHeaderView=UIView(frame:CGRect(x: 0,y: navHeight,width: boundsWidth,height: 120))
        self.view.addSubview(tableHeaderView!)
        
        let imgView=UIImageView(frame:tableHeaderView!.bounds)
        imgView.image=UIImage(named: "jf_jl_bj")
        tableHeaderView!.addSubview(imgView)
        
        let lblSurplusIntegral=UILabel(frame:CGRect(x: 0,y: 50,width: boundsWidth/2,height: 20))
        lblSurplusIntegral.text="剩余点单币"
        lblSurplusIntegral.textColor=UIColor.white
        lblSurplusIntegral.font=UIFont.boldSystemFont(ofSize: 18)
        lblSurplusIntegral.textAlignment = .center
        tableHeaderView!.addSubview(lblSurplusIntegral)
        
        lblIntegral=UILabel(frame:CGRect(x: boundsWidth/2,y: 50,width: boundsWidth/2,height: 20))
        lblIntegral!.textColor=UIColor.white
        lblIntegral!.font=UIFont.boldSystemFont(ofSize: 18)
        lblIntegral!.textAlignment = .center
        tableHeaderView!.addSubview(lblIntegral!)
        
        table=UITableView(frame:CGRect(x: 0,y: tableHeaderView!.frame.maxY,width: boundsWidth,height: boundsHeight-navHeight-120-bottomSafetyDistanceHeight), style: UITableViewStyle.plain)
        table!.dataSource=self
        table!.delegate=self
        self.view.addSubview(table!)
        //设置cell下边线全屏
        table?.layoutMargins=UIEdgeInsets.zero
        table?.separatorInset=UIEdgeInsets.zero
        //移除空单元格
        table!.tableFooterView = UIView(frame:CGRect.zero)
        table!.mj_header=MJRefreshNormalHeader(refreshingBlock:{
            self.currentPage=1
            self.httpQueryIntegralMallForSubStation(self.currentPage,isRefresh:true)
        })
        table!.mj_footer=MJRefreshAutoNormalFooter(refreshingBlock: {
            self.currentPage+=1
            self.httpQueryIntegralMallForSubStation(self.currentPage,isRefresh:false)
        })
        //加载等待视图
        SVProgressHUD.show(withStatus: "数据加载中")
        table!.mj_header.beginRefreshing()
    }
}
// MARK: - 实现table协议
extension PresentExpViewController:UITableViewDelegate,UITableViewDataSource,PresentExpTableViewCellDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell=tableView.dequeueReusableCell(withIdentifier: "PresentExpId") as? PresentExpTableViewCell
        if cell == nil{
            //加载xib
            cell=Bundle.main.loadNibNamed("PresentExpTableViewCell", owner:self, options: nil)?.last as? PresentExpTableViewCell
        }
        //设置cell下边线全屏
        cell?.layoutMargins=UIEdgeInsets.zero
        cell?.separatorInset=UIEdgeInsets.zero
        if arr.count > 0{
            let entity=arr[indexPath.row] as! IntegralGoodExchangeEntity
            cell!.index=indexPath
            cell!.updateCell(entity)
            cell!.delegate=self
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
}
// MARK: - 网络请求
extension PresentExpViewController{
    func httpExchangeInfo(_ entity: IntegralGoodExchangeEntity,index:IndexPath) {
        SVProgressHUD.show(withStatus: "正在加载...", maskType: SVProgressHUDMaskType.clear)
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.integralMallExchange(integralMallId: entity.integralMallId!, memberId: IS_NIL_MEMBERID()!, exchangeCount: 1), successClosure: { (result) -> Void in
            let json=JSON(result)
            let success=json["success"].stringValue
            switch success{
            case "success":
                let megInfo=json["megInfo"].stringValue
                if megInfo == "0"{
                    SVProgressHUD.dismiss()
                    self.integral!-=entity.exchangeIntegral!
                    self.lblIntegral!.text="\(self.integral!)"
                    let alert=UIAlertController(title:"点单即到", message:"兑换\(entity.goodsName!)成功,商品将在您下次购买此配送商的商品下单成功后，自动加入订单中", preferredStyle: UIAlertControllerStyle.alert)
                    let ok=UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
                        //查看剩余积分
                        self.httpQueryMemberIntegral()
                        self.table!.mj_header.beginRefreshing()
                    })
                    alert.addAction(ok)
                    self.present(alert, animated:true, completion:nil)
                }else if megInfo == "1"{
                    SVProgressHUD.showInfo(withStatus: "兑换失败")
                }else if megInfo == "2"{
                    SVProgressHUD.showInfo(withStatus: "商品数量不足")
                }else if megInfo == "3"{
                    SVProgressHUD.showInfo(withStatus: "点单币余额不足")
                }
                break
            case "memberBalance":
                SVProgressHUD.showInfo(withStatus: "点单币余额不足")
                break
            case "memberNull":
                SVProgressHUD.showInfo(withStatus: "会员不存在")
                break
            case "goodsNotEnough":
                SVProgressHUD.showInfo(withStatus: "商品数量不足")
                break
            case "goodsNull":
                SVProgressHUD.showInfo(withStatus: "商品已经下架,不能兑换")
                break
            case "integralMallIdNull":
                SVProgressHUD.showInfo(withStatus: "点单币商城商品已经不存在了")
                break
            default:
                SVProgressHUD.showInfo(withStatus: "发生未知错误")
                break
            }

            }) { (errorMsg) -> Void in
                SVProgressHUD.showError(withStatus: errorMsg)
        }
    }
    /**
     查看剩余积分
     */
    func httpQueryMemberIntegral(){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryMemberIntegral(memberId: IS_NIL_MEMBERID()!), successClosure: { (result) -> Void in
            let json=JSON(result)
            self.integral=json["success"].intValue
            self.lblIntegral!.text="\(self.integral!)"
            }) { (errorMsg) -> Void in
                SVProgressHUD.showError(withStatus: errorMsg)
        }
    }
    /**
     
     发送积分商品请求
     - parameter currentPage: 第几页
     - parameter isRefresh:   是否刷新true是
     */
    func httpQueryIntegralMallForSubStation(_ currentPage:Int,isRefresh:Bool){
        var count=0
        let subStationId=userDefaults.object(forKey: "substationId") as! String
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryIntegralMallForSubStation(subStationId: subStationId, currentPage: currentPage, pageSize: 10), successClosure: { (result) -> Void in
            let json=JSON(result)
            if isRefresh{//如果是刷新先删除数据
                self.arr.removeAllObjects()
            }
            for(_,value) in json{
                count+=1
                let entity=Mapper<IntegralGoodExchangeEntity>().map(JSONObject: value.object)
                self.arr.add(entity!)
            }
            if count < 10{//判断count是否小于10  如果小于表示没有可以加载了 隐藏加载状态
                self.table?.mj_footer.isHidden=true
            }else{//否则显示
                self.table?.mj_footer.isHidden=false
            }
            if self.arr.count < 1{//表示没有数据加载空
                self.lblNilTitle?.removeFromSuperview()
                self.lblNilTitle=nilTitle("还没有点单币商品")
                self.lblNilTitle!.center=self.table!.center
                self.view.addSubview(self.lblNilTitle!)
            }else{//如果有数据清除
                self.lblNilTitle?.removeFromSuperview()
            }
            //关闭刷新状态
            self.table?.mj_header.endRefreshing()
            //关闭加载状态
            self.table?.mj_footer.endRefreshing()
            //关闭加载等待视图
            SVProgressHUD.dismiss()
            //刷新table
            self.table?.reloadData()
            }) { (errorMsg) -> Void in
                //关闭刷新状态
                self.table?.mj_header.endRefreshing()
                //关闭加载状态
                self.table?.mj_footer.endRefreshing()
                SVProgressHUD.showError(withStatus: errorMsg)
        }
    }
}
// MARK: - 跳转页面
extension PresentExpViewController{
    @objc func pushRecordOfConversion(){
        let vc=RecordOfConversionViewController()
        self.navigationController!.pushViewController(vc, animated:true)
    }
}
