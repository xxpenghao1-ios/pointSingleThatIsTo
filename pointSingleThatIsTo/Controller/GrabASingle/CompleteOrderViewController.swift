//
//  CompleteOrderViewController.swift
//  pointSingleThatIsTo
//
//  Created by 卢洋 on 16/2/19.
//  Copyright © 2016年 penghao. All rights reserved.
//CompleteOrderViewController

import Foundation
import UIKit
import ObjectMapper
import SVProgressHUD
import SwiftyJSON
///已发货
class CompleteOrderViewController:BaseViewController,UITableViewDataSource,UITableViewDelegate {
    //实例化存储用户信息的单例
    var userDefaults=UserDefaults.standard
    
    //已完成订单Table
    var completeListTable:UITableView?
    
    //存放已完成订单entity
    var completeListEntityArray:[OrderListEntity]=[]
    
    // 没有数据加载该视图
    var nilView:UIView?
    
    /// 默认从第0页开始
    var currentPage=0
    
    //网络连接状态码,true表示有网络
    fileprivate var isNetWork:Bool=true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="完成订单"
        self.view.backgroundColor=UIColor.white
        creatCompleteListTable()
        self.nilView=nilPromptView("还木有抢到过订单哦^ - ^")
        self.nilView!.center=self.completeListTable!.center
        self.view.addSubview(self.nilView!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    /**
    创建已完成订单
    */
    func creatCompleteListTable(){
        completeListTable=UITableView(frame: CGRect(x: 0, y: 0, width: boundsWidth, height: boundsHeight-153), style: UITableViewStyle.plain)
        completeListTable?.delegate=self
        completeListTable?.dataSource=self
        completeListTable?.backgroundColor=UIColor.white
        completeListTable?.separatorStyle=UITableViewCellSeparatorStyle.none
        self.view.addSubview(completeListTable!)
        
//        completeListTable!.addHeaderWithCallback({//下拉重新加载数据
//            //从第一页开始
//            self.currentPage=1
//            //清除数据源
//            self.completeListEntityArray.removeAll()
//            //重新发送已抢单请求
//            self.queryStoreAllRobOrderForList(self.currentPage)
//        })
//        completeListTable!.addFooterWithCallback({//上拉加载更多
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //返回行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    //返回行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completeListEntityArray.count
    }
    //返回数据源
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Identifier="completeListTableCell"
        var cell=tableView.dequeueReusableCell(withIdentifier: Identifier) as? GrabASingleDetailsCell
        if(cell == nil){
            cell=GrabASingleDetailsCell(style: UITableViewCellStyle.default, reuseIdentifier: Identifier)
        }else{
            for subview:UIView in cell!.contentView.subviews{
                subview.removeFromSuperview()
                cell=GrabASingleDetailsCell(style: UITableViewCellStyle.default, reuseIdentifier: Identifier)
            }
        }
        if(completeListEntityArray.count > 0){
            cell?.loadGrabASingleData(completeListEntityArray[indexPath.row])
            //添加中间视图交互单击事件
            cell?.viewMiddle.isUserInteractionEnabled=true
            cell?.viewMiddle.tag=indexPath.row
            let viewMiddleTap=UITapGestureRecognizer(target: self, action: Selector("actionCompleteDetails:"))
            cell?.viewMiddle.addGestureRecognizer(viewMiddleTap)
        }
        cell!.selectionStyle=UITableViewCellSelectionStyle.none
        return cell!
    }
    //tableview开始载入的动画
    func tableView(_ tableView: UITableView, willDisplay cell:UITableViewCell, forRowAt indexPath: IndexPath){
        //设置cell的显示动画为3D缩放
        //xy方向缩放的初始值为0.1
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        //设置动画时间为0.25秒,xy方向缩放的最终值为1
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        })
    }
    /**
    actionGrabASingleDetails   跳转到抢单详情页面
    - parameter sender: 当前点击的视图
    */
    func actionCompleteDetails(_ sender:UITapGestureRecognizer){
//        let GrabASingleDetailsVC=GrabASingleDetailsView()
//        GrabASingleDetailsVC.hidesBottomBarWhenPushed=true
//        GrabASingleDetailsVC.orderList=completeListEntityArray[sender.view!.tag]
//        self.navigationController?.pushViewController(GrabASingleDetailsVC, animated: true)
    }
    /**
    queryStoreAllRobOrderForList   查询已完成订单
    
    - parameter currentPage: 当前页
    */
    func queryStoreAllRobOrderForList(_ currentPage:Int){
        let storeId=userDefaults.object(forKey: "storeId") as! String;
            //加载等待视图
        SVProgressHUD.show(withStatus: "数据加载中", maskType: .clear)
            //统计订单数，每次发请求先置空
            var count=0
            //开始发送已抢订单查询请求(robflag状态为4)
            PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryStoreAllRobOrderForList(robflag:4, sellerId:storeId, pageSize:10, currentPage:currentPage), successClosure: { (result) -> Void in
                    let jsonResult=JSON(result)
                    for(_,robbedListValue)in jsonResult{//取出订单entity
                        //释放菊花图
                        SVProgressHUD.dismiss()
                        // 每次循环加1
                        count+=1
                        //储存json一键转entity的值
                        let robbedEntity=Mapper<OrderListEntity>().map(JSONObject: robbedListValue.object)
                        //获取"list"的value
                        let list=robbedListValue["list"]
                        //临时储存商品数组
                        let GoodsArray=NSMutableArray()
                        for(_,GoodsDetailsValue)in list{//取出商品entity
                            let GoodsDetailsEntity=Mapper<GoodDetailEntity>().map(JSONObject:GoodsDetailsValue.object)
                            GoodsArray.add(GoodsDetailsEntity!)
                        }
                        //将临时的商品数组赋值给订单实体类中的"list"
                        robbedEntity?.list=GoodsArray
                        //添加到订单entity数组中
                        self.completeListEntityArray.append(robbedEntity!)
                    }
                    if count < 10{//判断count是否小于10  如果小于表示没有可以加载了 隐藏加载状态
                        self.completeListTable?.setFooterHidden(true)
                    }else{//否则显示
                        self.completeListTable?.setFooterHidden(false)
                    }
                    if(self.completeListEntityArray.count < 1){//如果数据为空，显示默认视图
                        self.nilView?.removeFromSuperview()
                        self.nilView=nilPromptView("还木有抢到过订单哦^ - ^")
                        self.nilView!.center=self.completeListTable!.center
                        self.view.addSubview(self.nilView!)
                    }else{//如果有数据清除
                        self.nilView?.removeFromSuperview()
                    }
                    //关闭下拉刷新状态
                    self.completeListTable?.headerEndRefreshing()
                    //关闭上拉加载状态
                    self.completeListTable?.footerEndRefreshing()
                    //关闭加载等待视图
                    SVProgressHUD.dismiss()
                    //重新加载Table
                    self.completeListTable?.reloadData()
                    //改变网络状态
                    self.isNetWork=true
                }, failClosure: { (errorMsg) -> Void in
                    //关闭刷新状态
                    self.completeListTable?.headerEndRefreshing()
                    //关闭加载状态
                    self.completeListTable?.footerEndRefreshing()
                    SVProgressHUD.showError(withStatus: errorMsg)
            })
    }
}
