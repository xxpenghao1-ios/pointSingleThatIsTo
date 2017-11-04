////
////  GrabASingleDetailsViewController.swift
////  pointSingleThatIsTo
////
////  Created by 卢洋 on 16/2/19.
////  Copyright © 2016年 penghao. All rights reserved.
////快速抢单
//
//import Foundation
//import UIKit
//import ObjectMapper
//import SVProgressHUD
//
/////快速抢单
//class GrabASingleDetailsViewController:BaseViewController,UITableViewDataSource,UITableViewDelegate{
//    var userDefaults=UserDefaults.standard
//
//    //抢单Table
//    var GrabASingleTable:UITableView?
//
//    //存放订单entity
//    var GrabASingleEntityArray:[OrderListEntity]=[]
//
//    // 没有数据加载该视图
//    var nilView:UIView?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.title="快速抢单"
//        self.view.backgroundColor=UIColor.white
//        CreatGrabASingleTable()
//        self.nilView=nilPromptView("还木有订单可抢^ - ^")
//        self.nilView!.center=self.GrabASingleTable!.center
//        self.view.addSubview(self.nilView!)
////        //添加观察者，监听我要抢单刷新的通知
////        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateOrderPage:", name: "grabASingleNotification", object: nil)
//
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
////        queryRobFor1OrderForList()
//    }
//
//    //创建快速抢单Table
//    func CreatGrabASingleTable(){
//        GrabASingleTable=UITableView(frame: CGRect(x: 0, y: 0, width: boundsWidth, height: boundsHeight-153), style: UITableViewStyle.plain)
//        GrabASingleTable?.delegate=self
//        GrabASingleTable?.dataSource=self
//        GrabASingleTable?.backgroundColor=UIColor.white
//        GrabASingleTable?.separatorStyle=UITableViewCellSeparatorStyle.none
//        self.view.addSubview(GrabASingleTable!)
//    }
//    //MARK -------------实现Table的一些协议----------------------------
//    //返回几组
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    //返回行高
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 170
//    }
//    //返回行数
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return GrabASingleEntityArray.count
//    }
//    //返回数据源
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let Identifier="GrabASingleTableCell"
//        var cell=tableView.dequeueReusableCell(withIdentifier: Identifier) as? GrabASingleDetailsCell
//        if(cell == nil){
//            cell=GrabASingleDetailsCell(style: UITableViewCellStyle.default, reuseIdentifier: Identifier)
//        }else{
//            for subview:UIView in cell!.contentView.subviews{
//                subview.removeFromSuperview()
//                cell=GrabASingleDetailsCell(style: UITableViewCellStyle.default, reuseIdentifier: Identifier)
//            }
//        }
//        if(GrabASingleEntityArray.count > 0){
//            cell?.loadGrabASingleData(GrabASingleEntityArray[indexPath.row])
//            //添加中间视图交互单击事件
//            cell?.viewMiddle.isUserInteractionEnabled=true
//            cell?.viewMiddle.tag=indexPath.row
//            let viewMiddleTap=UITapGestureRecognizer(target: self, action: "actionGrabASingleDetails:")
//            cell?.viewMiddle.addGestureRecognizer(viewMiddleTap)
//        }
//        cell!.selectionStyle=UITableViewCellSelectionStyle.none
//        return cell!
//    }
//    //tableview开始载入的动画
//    func tableView(_ tableView: UITableView, willDisplay cell:UITableViewCell, forRowAt indexPath: IndexPath){
//        //设置cell的显示动画为3D缩放
//        //xy方向缩放的初始值为0.1
//        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
//        //设置动画时间为0.25秒,xy方向缩放的最终值为1
//        UIView.animate(withDuration: 0.25, animations: { () -> Void in
//            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
//        })
//    }
//    /**
//    actionGrabASingleDetails   跳转到抢单详情页面
//    - parameter sender: 当前点击的视图
//    */
//    func actionGrabASingleDetails(_ sender:UITapGestureRecognizer){
//        let GrabASingleDetailsVC=GrabASingleDetailsView()
//        GrabASingleDetailsVC.hidesBottomBarWhenPushed=true
//        GrabASingleDetailsVC.orderList=GrabASingleEntityArray[sender.view!.tag]
//        self.navigationController?.pushViewController(GrabASingleDetailsVC, animated: true)
//    }
//    /**
//    queryRobFor1OrderForList  发送快速抢单请求
//
//    - parameter :
//    */
//    func queryRobFor1OrderForList(){
//        let storeFlagCode=userDefaults.object(forKey: "storeFlagCode") as! String
//        //判断有无网络
//        if(IJReachability.isConnectedToNetwork()){
//            //清空数据源
//            GrabASingleEntityArray.removeAll()
//            //LoadingWaitView()
//            //加载等待视图
//            SVProgressHUD.showWithStatus("数据加载中", maskType: .Clear)
//            PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryRobFor1OrderForList(storeFlagCode:storeFlagCode), successClosure: { (result) -> Void in
//                let jsonResult=JSON(result)
//                for(_,OrderListValue)in jsonResult{//取出订单entity
//                    //储存json一键转entity的值
//                    let OrderEntity=Mapper<OrderListEntity>().map(OrderListValue.object)
//                    //获取"list"的value
//                    let list=OrderListValue["list"]
//                    //临时储存商品数组
//                    let GoodsArray=NSMutableArray()
//                    for(_,GoodsDetailsValue)in list{//取出商品entity
//                        let GoodsDetailsEntity=Mapper<GoodDetailEntity>().map(GoodsDetailsValue.object)
//                        GoodsArray.addObject(GoodsDetailsEntity!)
//                    }
//                    //将临时的商品数组赋值给订单实体类中的"list"
//                    OrderEntity?.list=GoodsArray
//                    //添加到订单entity数组中
//                    self.GrabASingleEntityArray.append(OrderEntity!)
//                }
//                if(self.GrabASingleEntityArray.count < 1){//如果数据为空，显示默认视图
//                    self.nilView?.removeFromSuperview()
//                    self.nilView=nilPromptView("还木有订单可抢^ - ^")
//                    self.nilView!.center=self.GrabASingleTable!.center
//                    self.view.addSubview(self.nilView!)
//                }else{//如果有数据清除
//                    self.nilView?.removeFromSuperview()
//                }
//                //关闭加载等待视图
//                SVProgressHUD.dismiss()
//                //重新加载Table
//                self.GrabASingleTable?.reloadData()
//                }, failClosure: { (errorMsg) -> Void in
//                    SVProgressHUD.showErrorWithStatus(errorMsg)
//            })
//        }else{
//            SVProgressHUD.showErrorWithStatus("无网络连接")
//        }
//
//    }
//
//    //抢单刷新通知的方法
//    func updateOrderPage(_ title:Notification){
//        let string=title.object as! String
//        if(string == "1"){
//            queryRobFor1OrderForList()
//        }
//    }
//}

