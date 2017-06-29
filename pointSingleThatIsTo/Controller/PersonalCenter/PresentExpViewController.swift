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
/// 购物积分
class PresentExpViewController:BaseViewController{
    /// table视图
    private var table:UITableView?
    /// table头部视图
    private var tableHeaderView:UIView?
    /// 数据源
    private var arr=NSMutableArray()
    /// 空视图提示
    private var lblNilTitle:UILabel?
    /// 加载页数
    private var currentPage=0
    /// 剩余积分
    private var integral:Int?
    /// 剩余积分
    private var lblIntegral:UILabel?
    override func viewDidLoad(){
        super.viewDidLoad()
        httpQueryMemberIntegral()
        self.title="点单商城"
        self.view.backgroundColor=UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(title:"兑换记录", style: UIBarButtonItemStyle.Plain, target:self, action:"pushRecordOfConversion")
        
        tableHeaderView=UIView(frame:CGRectMake(0,64,boundsWidth,120))
        self.view.addSubview(tableHeaderView!)
        
        let imgView=UIImageView(frame:tableHeaderView!.bounds)
        imgView.image=UIImage(named: "jf_jl_bj")
        tableHeaderView!.addSubview(imgView)
        
        let lblSurplusIntegral=UILabel(frame:CGRectMake(0,50,boundsWidth/2,20))
        lblSurplusIntegral.text="剩余积分"
        lblSurplusIntegral.textColor=UIColor.whiteColor()
        lblSurplusIntegral.font=UIFont.boldSystemFontOfSize(18)
        lblSurplusIntegral.textAlignment = .Center
        tableHeaderView!.addSubview(lblSurplusIntegral)
        
        lblIntegral=UILabel(frame:CGRectMake(boundsWidth/2,50,boundsWidth/2,20))
        lblIntegral!.textColor=UIColor.whiteColor()
        lblIntegral!.font=UIFont.boldSystemFontOfSize(18)
        lblIntegral!.textAlignment = .Center
        tableHeaderView!.addSubview(lblIntegral!)
        
        table=UITableView(frame:CGRectMake(0,CGRectGetMaxY(tableHeaderView!.frame),boundsWidth,boundsHeight-64-120), style: UITableViewStyle.Plain)
        table!.dataSource=self
        table!.delegate=self
        self.view.addSubview(table!)
        //设置cell下边线全屏
        table?.layoutMargins=UIEdgeInsetsZero
        table?.separatorInset=UIEdgeInsetsZero
        //移除空单元格
        table!.tableFooterView = UIView(frame:CGRectZero)
        table!.addHeaderWithCallback{
            self.currentPage=1
            self.httpQueryIntegralMallForSubStation(self.currentPage,isRefresh:true)
        }
        table!.addFooterWithCallback{
            self.currentPage+=1
            self.httpQueryIntegralMallForSubStation(self.currentPage,isRefresh:false)
        }
        //加载等待视图
        SVProgressHUD.showWithStatus("数据加载中")
        table!.headerBeginRefreshing()
    }
}
// MARK: - 实现table协议
extension PresentExpViewController:UITableViewDelegate,UITableViewDataSource,PresentExpTableViewCellDelegate{
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell=tableView.dequeueReusableCellWithIdentifier("PresentExpId") as? PresentExpTableViewCell
        if cell == nil{
            //加载xib
            cell=NSBundle.mainBundle().loadNibNamed("PresentExpTableViewCell", owner:self, options: nil).last as? PresentExpTableViewCell
        }
        //设置cell下边线全屏
        cell?.layoutMargins=UIEdgeInsetsZero
        cell?.separatorInset=UIEdgeInsetsZero
        if arr.count > 0{
            let entity=arr[indexPath.row] as! IntegralGoodExchangeEntity
            cell!.index=indexPath
            cell!.updateCell(entity)
            cell!.delegate=self
        }
        return cell!
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
}
// MARK: - 网络请求
extension PresentExpViewController{
    func httpExchangeInfo(entity: IntegralGoodExchangeEntity,index:NSIndexPath) {
        SVProgressHUD.showWithStatus("正在加载...", maskType: SVProgressHUDMaskType.Clear)
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
                    let alert=UIAlertController(title:"点单即到", message:"兑换\(entity.goodsName!)成功", preferredStyle: UIAlertControllerStyle.Alert)
                    let ok=UIAlertAction(title:"OK", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                        self.table!.headerBeginRefreshing()
                    })
                    alert.addAction(ok)
                    self.presentViewController(alert, animated:true, completion:nil)
                }else if megInfo == "1"{
                    SVProgressHUD.showInfoWithStatus("兑换失败")
                }else if megInfo == "2"{
                    SVProgressHUD.showInfoWithStatus("商品数量不足")
                }else if megInfo == "3"{
                    SVProgressHUD.showInfoWithStatus("积分余额不足")
                }
                break
            case "memberBalance":
                SVProgressHUD.showInfoWithStatus("积分余额不足")
                break
            case "memberNull":
                SVProgressHUD.showInfoWithStatus("会员不存在")
                break
            case "goodsNotEnough":
                SVProgressHUD.showInfoWithStatus("商品数量不足")
                break
            case "goodsNull":
                SVProgressHUD.showInfoWithStatus("商品已经下架,不能兑换")
                break
            case "integralMallIdNull":
                SVProgressHUD.showInfoWithStatus("积分商城商品已经不存在了")
                break
            default:
                SVProgressHUD.showInfoWithStatus("发生未知错误")
                break
            }

            }) { (errorMsg) -> Void in
                SVProgressHUD.showErrorWithStatus(errorMsg)
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
                SVProgressHUD.showErrorWithStatus(errorMsg)
        }
    }
    /**
     
     发送积分商品请求
     - parameter currentPage: 第几页
     - parameter isRefresh:   是否刷新true是
     */
    func httpQueryIntegralMallForSubStation(currentPage:Int,isRefresh:Bool){
        var count=0
        let subStationId=userDefaults.objectForKey("substationId") as! String
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryIntegralMallForSubStation(subStationId: subStationId, currentPage: currentPage, pageSize: 10), successClosure: { (result) -> Void in
            let json=JSON(result)
            if isRefresh{//如果是刷新先删除数据
                self.arr.removeAllObjects()
            }
            for(_,value) in json{
                count++
                let entity=Mapper<IntegralGoodExchangeEntity>().map(value.object)
                self.arr.addObject(entity!)
            }
            if count < 10{//判断count是否小于10  如果小于表示没有可以加载了 隐藏加载状态
                self.table?.setFooterHidden(true)
            }else{//否则显示
                self.table?.setFooterHidden(false)
            }
            if self.arr.count < 1{//表示没有数据加载空
                self.lblNilTitle?.removeFromSuperview()
                self.lblNilTitle=nilTitle("还没有积分商品")
                self.lblNilTitle!.center=self.table!.center
                self.view.addSubview(self.lblNilTitle!)
            }else{//如果有数据清除
                self.lblNilTitle?.removeFromSuperview()
            }
            //关闭刷新状态
            self.table?.headerEndRefreshing()
            //关闭加载状态
            self.table?.footerEndRefreshing()
            //关闭加载等待视图
            SVProgressHUD.dismiss()
            //刷新table
            self.table?.reloadData()
            }) { (errorMsg) -> Void in
                //关闭刷新状态
                self.table?.headerEndRefreshing()
                //关闭加载状态
                self.table?.footerEndRefreshing()
                SVProgressHUD.showErrorWithStatus(errorMsg)
        }
    }
}
// MARK: - 跳转页面
extension PresentExpViewController{
    func pushRecordOfConversion(){
        let vc=RecordOfConversionViewController()
        self.navigationController!.pushViewController(vc, animated:true)
    }
}