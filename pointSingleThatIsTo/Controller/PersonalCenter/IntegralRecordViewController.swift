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
/// 积分记录
class IntegralRecordViewController:BaseViewController{
    /// table
    private var table:UITableView?
    /// table头部视图
    private var tableHeaderView:UIView?
    /// 数据源
    private var arr=NSMutableArray()
    /// 空视图提示
    private var lblNilTitle:UILabel?
    /// 积分余额
    private var lblIntegral:UILabel?
    /// 加载页数
    private var currentPage=0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="积分记录"
        self.view.backgroundColor=UIColor.whiteColor()
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
        lblIntegral!.text=userDefaults.objectForKey("balance") as? String
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
            self.httpIntegralRecord(self.currentPage,isRefresh:true)
        }
        table!.addFooterWithCallback{
            self.currentPage+=1
            self.httpIntegralRecord(self.currentPage,isRefresh:false)
        }
        //加载等待视图
        SVProgressHUD.showWithStatus("数据加载中")
        table!.headerBeginRefreshing()
    }
}
// MARK: - 实现table协议
extension IntegralRecordViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell=tableView.dequeueReusableCellWithIdentifier("IntegralRecordId") as? IntegralRecordTableViewCell
        if cell == nil{
            cell=NSBundle.mainBundle().loadNibNamed("IntegralRecordTableViewCell", owner:self, options:nil).last as? IntegralRecordTableViewCell
        }
        cell?.layoutMargins=UIEdgeInsetsZero
        cell?.separatorInset=UIEdgeInsetsZero
        if arr.count > 0{
            let entity=arr[indexPath.row] as! MemberIntegralEntity
            cell!.updateCell(entity)
        }
        return cell!
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
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
    private func httpIntegralRecord(currentPage:Int,isRefresh:Bool){
        var count=0
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.storeQueryMemberIntegralV1(memberId: IS_NIL_MEMBERID()!, currentPage: currentPage, pageSize: 10), successClosure: { (result) -> Void in
            let json=JSON(result)
            if isRefresh{//如果是刷新先删除数据
                self.arr.removeAllObjects()
            }
            for(_,value) in json{
                count++
                let entity=Mapper<MemberIntegralEntity>().map(value.object)
                self.arr.addObject(entity!)
            }
            if count < 10{//判断count是否小于10  如果小于表示没有可以加载了 隐藏加载状态
                self.table?.setFooterHidden(true)
            }else{//否则显示
                self.table?.setFooterHidden(false)
            }
            if self.arr.count < 1{//表示没有数据加载空
                self.lblNilTitle?.removeFromSuperview()
                self.lblNilTitle=nilTitle("还没有积分记录")
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