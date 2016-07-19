//
//  RobbedList.swift
//  pointSingleThatIsTo
//
//  Created by 卢洋 on 16/2/19.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import ObjectMapper
import SVProgressHUD
///已抢订单
class RobbedListViewController:BaseViewController,UITableViewDataSource,UITableViewDelegate {
    //实例化存储用户信息的单例
    var userDefaults=NSUserDefaults.standardUserDefaults()
    
    //已抢单Table
    var robbedListTable:UITableView?
    
    //存放已抢订单entity
    var robbedListEntityArray:[OrderListEntity]=[]
    
    // 没有数据加载该视图
    var nilView:UIView?
    
    /// 默认从第0页开始
    var currentPage=0
    
    //网络连接状态码,true表示有网络
    private var isNetWork:Bool=true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="已抢订单"
        self.view.backgroundColor=UIColor.whiteColor()
        creatRobbedListTable()
        self.nilView=nilPromptView("还木有抢到过订单哦^ - ^")
        self.nilView!.center=self.robbedListTable!.center
        self.view.addSubview(self.nilView!)
//        //添加观察者，监听已抢订单刷新的通知
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateOrderPage:", name: "grabASingleNotification", object: nil)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
//        //若无网络,改变状态码下次进来直接刷新
//        if(!IJReachability.isConnectedToNetwork()){
//            isNetWork=false
//        }
//        //状态码变成false并且有网络则发送已抢订单请求
//        if(!isNetWork){
//            if(IJReachability.isConnectedToNetwork()){
//                self.queryStoreAllRobOrderForList(self.currentPage)
//            }
//        }
    }
    //创建已抢单Table
    func creatRobbedListTable(){
        robbedListTable=UITableView(frame: CGRectMake(0, 0, boundsWidth, boundsHeight-153), style: UITableViewStyle.Plain)
        robbedListTable?.delegate=self
        robbedListTable?.dataSource=self
        robbedListTable?.backgroundColor=UIColor.whiteColor()
        robbedListTable?.separatorStyle=UITableViewCellSeparatorStyle.None
        self.view.addSubview(robbedListTable!)
        
//        robbedListTable!.addHeaderWithCallback({//下拉重新加载数据
//            //从第一页开始
//            self.currentPage=1
//            //清除数据源
//            self.robbedListEntityArray.removeAll()
//            //重新发送已抢单请求
//            self.queryStoreAllRobOrderForList(self.currentPage)
//        })
//        robbedListTable!.addFooterWithCallback({//上拉加载更多
//            //每次页面索引加1
//            self.currentPage+=1
//            self.queryStoreAllRobOrderForList(self.currentPage)
//        })
//        //页面加载默认从第1页开始
//        currentPage=1
//        self.queryStoreAllRobOrderForList(self.currentPage)
    }
    //MARK -------------实现Table的一些协议----------------------------
    //返回几组
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //返回行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 170
    }
    //返回行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return robbedListEntityArray.count
    }
    //返回数据源
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let Identifier="robbedListTableCell"
        var cell=tableView.dequeueReusableCellWithIdentifier(Identifier) as? GrabASingleDetailsCell
        if(cell == nil){
            cell=GrabASingleDetailsCell(style: UITableViewCellStyle.Default, reuseIdentifier: Identifier)
        }else{
            for subview:UIView in cell!.contentView.subviews{
                subview.removeFromSuperview()
                cell=GrabASingleDetailsCell(style: UITableViewCellStyle.Default, reuseIdentifier: Identifier)
            }
        }
        if(robbedListEntityArray.count > 0){
            cell?.loadGrabASingleData(robbedListEntityArray[indexPath.row])
            //添加中间视图交互单击事件
            cell?.viewMiddle.userInteractionEnabled=true
            cell?.viewMiddle.tag=indexPath.row
            let viewMiddleTap=UITapGestureRecognizer(target: self, action: "actionRobbedDetails:")
            cell?.viewMiddle.addGestureRecognizer(viewMiddleTap)
        }
        cell!.selectionStyle=UITableViewCellSelectionStyle.None
        return cell!
    }
    //tableview开始载入的动画
    func tableView(tableView: UITableView, willDisplayCell cell:UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath){
        //设置cell的显示动画为3D缩放
        //xy方向缩放的初始值为0.1
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        //设置动画时间为0.25秒,xy方向缩放的最终值为1
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        })
    }
    /**
    actionGrabASingleDetails   跳转到抢单详情页面
    - parameter sender: 当前点击的视图
    */
    func actionRobbedDetails(sender:UITapGestureRecognizer){
        let GrabASingleDetailsVC=GrabASingleDetailsView()
        GrabASingleDetailsVC.hidesBottomBarWhenPushed=true
        GrabASingleDetailsVC.orderList=robbedListEntityArray[sender.view!.tag]
        self.navigationController?.pushViewController(GrabASingleDetailsVC, animated: true)
    }
    /**
    queryStoreAllRobOrderForList   查询已抢订单
    
    - parameter currentPage: 当前页
    */
    func queryStoreAllRobOrderForList(currentPage:Int){
        let queryStoreAllRobOrderForListURL=URL+"queryStoreAllRobOrderForList.xhtml";
        let storeId=userDefaults.objectForKey("storeId") as! String;
        //判断有无网络
        if(IJReachability.isConnectedToNetwork()){
            //统计订单数，每次发请求先置空
            var count=0
            //加载等待视图
            SVProgressHUD.showWithStatus("数据加载中", maskType: .Clear)
            //开始发送已抢订单查询请求(robflag状态为2)
            request(.GET, queryStoreAllRobOrderForListURL, parameters: ["robflag":"2","sellerId":storeId,"pageSize":10,"currentPage":currentPage])
                .responseJSON{rep in
                    if(rep.result.error != nil){
                        //关闭刷新状态
                        self.robbedListTable?.headerEndRefreshing()
                        //关闭加载状态
                        self.robbedListTable?.footerEndRefreshing()
                        SVProgressHUD.showErrorWithStatus(rep.result.error!.localizedDescription)
                    }
                    if(rep.result.value != nil){
                        let jsonResult=JSON(rep.result.value!)
                        for(_,robbedListValue)in jsonResult{//取出订单entity
                            //关闭等待视图
                            SVProgressHUD.dismiss()
                             //NSLog("已抢订单entity--\(robbedListValue)")
                            // 每次循环加1
                            count++
                            //储存json一键转entity的值
                            let robbedEntity=Mapper<OrderListEntity>().map(robbedListValue.object)
                            //获取"list"的value
                            let list=robbedListValue["list"]
                            //临时储存商品数组
                            let GoodsArray=NSMutableArray()
                            for(_,GoodsDetailsValue)in list{//取出商品entity
                                let GoodsDetailsEntity=Mapper<GoodDetailEntity>().map(GoodsDetailsValue.object)
                                GoodsArray.addObject(GoodsDetailsEntity!)
                            }
                            //将临时的商品数组赋值给订单实体类中的"list"
                            robbedEntity?.list=GoodsArray
                            //添加到订单entity数组中
                            self.robbedListEntityArray.append(robbedEntity!)
                        }
                        if count < 10{//判断count是否小于10  如果小于表示没有可以加载了 隐藏加载状态
                            self.robbedListTable?.setFooterHidden(true)
                        }else{//否则显示
                            self.robbedListTable?.setFooterHidden(false)
                        }
                        if(self.robbedListEntityArray.count < 1){//如果数据为空，显示默认视图
                            self.nilView?.removeFromSuperview()
                            self.nilView=nilPromptView("还木有抢到过订单哦^ - ^")
                            self.nilView!.center=self.robbedListTable!.center
                            self.view.addSubview(self.nilView!)
                        }else{//如果有数据清除
                            self.nilView?.removeFromSuperview()
                        }
                        //关闭下拉刷新状态
                        self.robbedListTable?.headerEndRefreshing()
                        //关闭上拉加载状态
                        self.robbedListTable?.footerEndRefreshing()
                        SVProgressHUD.dismiss()
                        //重新加载Table
                        self.robbedListTable?.reloadData()
                        //改变网络状态
                        self.isNetWork=true
                    }
            }
        }else{
            SVProgressHUD.showErrorWithStatus("无网络连接")
        }
    }
    
    //已抢订单刷新通知的方法
    func updateOrderPage(title:NSNotification){
        let string=title.object as! String
        if(string == "1"){
            //从第一页开始
            self.currentPage=1
            //清除数据源
            self.robbedListEntityArray.removeAll()
            //重新发送已抢单请求
            self.queryStoreAllRobOrderForList(self.currentPage)
        }else if(string == "2"){
            //从第一页开始
            self.currentPage=1
            //清除数据源
            self.robbedListEntityArray.removeAll()
            //重新发送已抢单请求
            self.queryStoreAllRobOrderForList(self.currentPage)
        }
    }
}