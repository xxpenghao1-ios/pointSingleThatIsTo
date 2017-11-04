//
//  DeliverGoodsedViewController.swift
//  pointSingleThatIsTo
//
//  Created by 卢洋 on 16/2/25.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import SVProgressHUD
import SwiftyJSON
///已经发货
class DeliverGoodsViewController:BaseViewController,UITableViewDataSource,UITableViewDelegate{
    
    var userDefaults=UserDefaults.standard
    
    /// 已发货Table
    var deliverGoodsedTable:UITableView?
    
    /// 存放订单entity
    var stockOrderEntityArray:[OrderListEntity]=[]
    
    /// 没有数据加载该视图
    var nilView:UIView?
    
    /// 默认从第0页开始
    var currentPage=0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="已发货"
        self.view.backgroundColor=UIColor.white
        //监听通知 刷新数据
        NotificationCenter.default.addObserver(self, selector:"updateOrderList:", name:NSNotification.Name(rawValue: "postUpdateOrderList"), object: nil)
        creatDeliverGoodsedTable()
    }
    /**
     更新数据
     
     - parameter obj:NSNotification
     */
    func updateOrderList(_ obj:Notification){
        deliverGoodsedTable?.headerBeginRefreshing()
    }
    /**
    创建已发货Table
    */
    func creatDeliverGoodsedTable(){
        deliverGoodsedTable=UITableView(frame: CGRect(x: 0, y: 0, width: boundsWidth, height: boundsHeight-104), style: UITableViewStyle.plain)
        deliverGoodsedTable?.delegate=self
        deliverGoodsedTable?.dataSource=self
        deliverGoodsedTable?.backgroundColor=UIColor.white
        deliverGoodsedTable?.separatorStyle=UITableViewCellSeparatorStyle.none
        self.view.addSubview(deliverGoodsedTable!)
        
        deliverGoodsedTable!.addHeaderWithCallback({//下拉重新加载数据
            //从第一页开始
            self.currentPage=1
            //重新发送请求
            self.queryOrderInfo4AndroidStoreByOrderStatus(self.currentPage,isRefresh: true)
        })
        deliverGoodsedTable!.addFooterWithCallback({//上拉加载更多
            //每次页面索引加1
            self.currentPage+=1
            self.queryOrderInfo4AndroidStoreByOrderStatus(self.currentPage,isRefresh: false)
        })
        //加载等待视图
        SVProgressHUD.show(withStatus: "数据加载中")
        deliverGoodsedTable!.headerBeginRefreshing()
        
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
        return stockOrderEntityArray.count
    }
    //返回数据源
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Identifier="StockOrderManageTableViewCellId"
        var cell=tableView.dequeueReusableCell(withIdentifier: Identifier) as? StockOrderManageTableViewCell
        if (cell == nil){
            cell=Bundle.main.loadNibNamed("StockOrderManageTableViewCell", owner:self, options: nil)?.last as? StockOrderManageTableViewCell
        }
        if stockOrderEntityArray.count > 0{
            cell!.updateCell(stockOrderEntityArray[indexPath.row])
            let viewMiddle=UIView(frame:CGRect(x: 0,y: 40,width: boundsWidth,height: 80))
            viewMiddle.tag=indexPath.row
            viewMiddle.addGestureRecognizer(UITapGestureRecognizer(target:self, action:Selector(("pushOrderDetail:"))))
            cell!.contentView.addSubview(viewMiddle)
        }
        cell!.selectionStyle=UITableViewCellSelectionStyle.none
        return cell!
    }
    /**
     跳转到详情页面
     
     - parameter sender:UITapGestureRecognizer
     */
    func pushOrderDetail(_ sender:UITapGestureRecognizer){
        let vc=StockOrderDetailsViewController()
        vc.orderList=stockOrderEntityArray[sender.view!.tag]
        self.navigationController!.pushViewController(vc, animated:true)
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
    queryOrderInfo4AndroidStoreByOrderStatus   查询已发货订单
    
    - parameter currentPage: 当前页
    - parameter isRefresh: 是否刷新true是
     
    */
    func queryOrderInfo4AndroidStoreByOrderStatus(_ currentPage:Int,isRefresh:Bool){
        let storeId=userDefaults.object(forKey: "storeId") as! String
            //统计订单数，每次发请求先置空
            var count=0
            //开始发送已发货订单查询请求(orderStatus状态为2)
            PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryOrderInfo4AndroidStoreByOrderStatus(orderStatus:2, storeId:storeId, pageSize: 10, currentPage: currentPage), successClosure: { (result) -> Void in
                let jsonResult=JSON(result)
                print("订单\(jsonResult)")
                if isRefresh{
                    self.stockOrderEntityArray.removeAll()
                }
                for(_,robbedListValue)in jsonResult{//取出订单entity
                    
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
                    self.stockOrderEntityArray.append(robbedEntity!)
                }
                if count < 10{//判断count是否小于10  如果小于表示没有可以加载了 隐藏加载状态
                    self.deliverGoodsedTable?.setFooterHidden(true)
                }else{//否则显示
                    self.deliverGoodsedTable?.setFooterHidden(false)
                }
                if(self.stockOrderEntityArray.count < 1){//如果数据为空，显示默认视图
                    self.nilView?.removeFromSuperview()
                    self.nilView=nilPromptView("暂时木有发货的订单的哦^ - ^")
                    self.nilView!.center=self.deliverGoodsedTable!.center
                    self.view.addSubview(self.nilView!)
                }else{//如果有数据清除
                    self.nilView?.removeFromSuperview()
                }
                //关闭下拉刷新状态
                self.deliverGoodsedTable?.headerEndRefreshing()
                //关闭上拉加载状态
                self.deliverGoodsedTable?.footerEndRefreshing()
                //关闭加载等待视图
                SVProgressHUD.dismiss()
                //重新加载Table
                self.deliverGoodsedTable?.reloadData()
                }, failClosure: { (errorMsg) -> Void in
                    //关闭刷新状态
                    self.deliverGoodsedTable?.headerEndRefreshing()
                    //关闭加载状态
                    self.deliverGoodsedTable?.footerEndRefreshing()
                    SVProgressHUD.showError(withStatus: errorMsg)
            })
    }
    
}
