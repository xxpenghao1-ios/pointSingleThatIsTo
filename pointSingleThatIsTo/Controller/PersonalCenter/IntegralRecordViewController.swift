//
//  IntegralRecordViewController.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/7/19.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import ObjectMapper
import SwiftyJSON
/// 积分记录
class IntegralRecordViewController:BaseViewController{
    /// table
    fileprivate var table:UITableView?
    /// table头部视图
    fileprivate var tableHeaderView:UIView?
    /// 数据源
    fileprivate var arr=NSMutableArray()
    /// 空视图提示
    fileprivate var lblNilTitle:UILabel?
    /// 积分余额
    fileprivate var lblIntegral:UILabel?
    /// 加载页数
    fileprivate var currentPage=0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="点单币记录"
        self.view.backgroundColor=UIColor.white
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
        lblIntegral!.text=userDefaults.object(forKey: "balance") as? String
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
            self.httpIntegralRecord(self.currentPage,isRefresh:true)
        })
        table!.mj_footer=MJRefreshAutoNormalFooter(refreshingBlock: {
            self.currentPage+=1
            self.httpIntegralRecord(self.currentPage,isRefresh:false)
        })
        //加载等待视图
        SVProgressHUD.show(withStatus: "数据加载中")
        table!.mj_header.beginRefreshing()
        httpQueryMemberIntegral()
    }
}
// MARK: - 实现table协议
extension IntegralRecordViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell=tableView.dequeueReusableCell(withIdentifier: "IntegralRecordId") as? IntegralRecordTableViewCell
        if cell == nil{
            cell=Bundle.main.loadNibNamed("IntegralRecordTableViewCell", owner:self, options:nil)?.last as? IntegralRecordTableViewCell
        }
        cell?.layoutMargins=UIEdgeInsets.zero
        cell?.separatorInset=UIEdgeInsets.zero
        if arr.count > 0{
            let entity=arr[indexPath.row] as! MemberIntegralEntity
            cell!.updateCell(entity)
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
// MARK: - 网络请求
extension IntegralRecordViewController{
    /**
     发送积分记录数据网络请求
     
     - parameter currentPage: 第几页
     - parameter isRefresh:   是否刷新true是
     */
    fileprivate func httpIntegralRecord(_ currentPage:Int,isRefresh:Bool){
        var count=0
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.storeQueryMemberIntegralV1(memberId: IS_NIL_MEMBERID()!, currentPage: currentPage, pageSize: 10), successClosure: { (result) -> Void in
            let json=JSON(result)
            print(json)
            if isRefresh{//如果是刷新先删除数据
                self.arr.removeAllObjects()
            }
            for(_,value) in json{
                count+=1
                let entity=Mapper<MemberIntegralEntity>().map(JSONObject:value.object)
                self.arr.add(entity!)
            }
            if count < 10{//判断count是否小于10  如果小于表示没有可以加载了 隐藏加载状态
                self.table?.mj_footer.isHidden=true
            }else{//否则显示
                self.table?.mj_footer.isHidden=false
            }
            if self.arr.count < 1{//表示没有数据加载空
                self.lblNilTitle?.removeFromSuperview()
                self.lblNilTitle=nilTitle("还没有点单币记录")
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
    /**
     查看剩余积分
     */
    func httpQueryMemberIntegral(){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryMemberIntegral(memberId: IS_NIL_MEMBERID()!), successClosure: { (result) -> Void in
            let json=JSON(result)
            let integral=json["success"].intValue
            self.lblIntegral!.text="\(integral)"
            }) { (errorMsg) -> Void in
                SVProgressHUD.showError(withStatus: errorMsg)
        }
    }
}
