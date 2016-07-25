//
//  RememberViewController.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/7/13.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
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
    private var integral:Int?{
        didSet{
           lblIntegral!.text="\(oldValue)"
        }
    }
    private var lblIntegral:UILabel?
    override func viewDidLoad(){
        super.viewDidLoad()
        httpQueryMemberIntegral()
        self.title="积分兑换商品"
        self.view.backgroundColor=UIColor.whiteColor()
        tableHeaderView=UIView(frame:CGRectMake(0,64,boundsWidth,120))
        self.view.addSubview(tableHeaderView!)
        
        let imgView=UIImageView(frame:tableHeaderView!.bounds)
        imgView.image=UIImage(named: "jf_bj")
        tableHeaderView!.addSubview(imgView)
        
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
extension PresentExpViewController:UITableViewDelegate,UITableViewDataSource{
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
            cell!.updateCell(entity)
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
    /**
     查看剩余积分
     */
    func httpQueryMemberIntegral(){
        request(.GET,URL+"queryMemberIntegral.xhtml", parameters:["memberId":IS_NIL_MEMBERID()!]).responseJSON{ response in
            if response.result.error != nil{
                SVProgressHUD.showErrorWithStatus(response.result.error!.localizedDescription)
            }
            if response.result.value != nil{
                let json=JSON(response.result.value!)
                self.integral=json["success"].intValue
            }
        }
    }
    /**
     
     发送积分商品请求
     - parameter currentPage: 第几页
     - parameter isRefresh:   是否刷新true是
     */
    func httpQueryIntegralMallForSubStation(currentPage:Int,isRefresh:Bool){
        var count=0
        let subStationId=userDefaults.objectForKey("subStationId") as! String
        request(.GET,URL+"queryIntegralMallForSubStation.xhtml", parameters:["subStationId":subStationId,"currentPage":currentPage,"pageSize":10]).responseJSON{ response in
            if response.result.error != nil{
                //关闭刷新状态
                self.table?.headerEndRefreshing()
                //关闭加载状态
                self.table?.footerEndRefreshing()
                SVProgressHUD.showErrorWithStatus(response.result.error!.localizedDescription)
            }
            if response.result.value != nil{
                let json=JSON(response.result.value!)
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
            }
        }
    }
}