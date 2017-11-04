//
//  StockOrderDetailsViewController.swift
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
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


///进货订单详情
class StockOrderDetailsViewController:BaseViewController,UITableViewDataSource,UITableViewDelegate{

    //用户信息
    var userDefaults=UserDefaults.standard
    //商品列表Table
    var goodsListTable:UITableView?
    
    //接收页面传过来的订单entity
    var orderList:OrderListEntity?
    
    //商品数组
    var goodArr=NSMutableArray()
    
    //底部父容器
    var bottomWarp:UIView!
    
    //总价格
    var sumPriceWarp:UIView!
    var sumPrice:UILabel!
    
    //抢单
    var GrabASingleWarp:UIView!
    var GrabASingleBtn:UIButton!
    
    //电话号码
    var phoneNumber:String=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.white
        //根据订单状态显示相应的按钮文字
        if(orderList!.orderStatus == 1){//未发货
            self.title="未发货"
        }else if(orderList!.orderStatus == 2){//已发货
            self.title="已发货"
        }else{//已经完成的订单
            self.title="已完成"
        }
        creatGoodsListTable()
    }
    
    /**
    创建商品列表
    */
    func creatGoodsListTable(){
        goodsListTable=UITableView(frame: CGRect(x: 0, y: 0, width: boundsWidth, height: boundsHeight-50), style: UITableViewStyle.grouped)
        goodsListTable?.delegate=self
        goodsListTable?.dataSource=self
        goodsListTable?.backgroundColor=UIColor.goodDetailBorderColor()
        self.view.addSubview(goodsListTable!)
        
        //去除15px空白，分割线顶头对齐
        goodsListTable?.layoutMargins=UIEdgeInsets.zero
        goodsListTable?.separatorInset=UIEdgeInsets.zero
        
        //去除没有数据的单元格
        goodsListTable?.tableFooterView=UIView(frame:CGRect.zero)
        //请求订单详情
        if(orderList != nil){//查询进货商品详情
            queryOrderInfo4AndroidByorderId()
            creatBottomView()
        }
        
    }
    //MARK -------------实现Table的一些协议----------------------------
    //返回几组
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    //返回行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0){
            if(indexPath.row == 2){
                return 60
            }else{
                return 50
            }
        }else if(indexPath.section == 1){
            return 100
        }else{
            return 50
        }
    }
    //返回行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(orderList?.list?.count > 0){
            if(section == 0){
                return 3
            }else if(section == 1){//第二组
                return (orderList?.list?.count)!
            }else{//第3组
                if(orderList!.robflag == 2 || orderList!.robflag == 3){//若是已抢订单，则显示卖家留言
                    if orderList!.cashCouponId > 0{//如果有代金券
                        return 10
                    }else{
                        return 9
                    }
                }else{
                    if orderList!.cashCouponId > 0{//如果有代金券
                        return 8
                    }else{
                        return 7
                    }
                }
            }
        }else{
            return 0
        }
    }
    //返回头部视图
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(section == 1){
            //容器
            let headerView=UIView(frame: CGRect(x: 0, y: 0, width: boundsWidth, height: 50))
            headerView.backgroundColor=UIColor.goodDetailBorderColor()
            
            //商品容器
            let goodsLblWarp=UIView(frame: CGRect(x: 0, y: 5, width: boundsWidth, height: 45))
            goodsLblWarp.backgroundColor=UIColor.white
            //商品标题
            let goodsLbl=UILabel(frame: CGRect(x: 10, y: (goodsLblWarp.frame.height-20)/2, width: boundsWidth, height: 20))
            goodsLbl.text="商品信息"
            headerView.addSubview(goodsLblWarp)
            goodsLblWarp.addSubview(goodsLbl)
            return headerView
        }else{
            return nil
        }
    }
    //返回头部高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){
            return 10
        }else if(section == 1){
            return 50
        }else{
            return 5
        }
    }
    //返回底部高度
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if(section == 2){
            return 10
        }else{
            return 5
        }
    }
    
    //返回数据源
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Identifier="StockOrderDetailsTableCell"+"\(indexPath.section)"+"\(indexPath.row)"
        var cell=tableView.dequeueReusableCell(withIdentifier: Identifier) as? StockOrderDetailsCell
        if(cell == nil){
            cell=StockOrderDetailsCell(style: UITableViewCellStyle.default, reuseIdentifier: Identifier)
        }else{
            cell=StockOrderDetailsCell(style: UITableViewCellStyle.default, reuseIdentifier: Identifier)
        }
        if(orderList != nil){
            if(indexPath.section == 0){//第一组数据
                switch indexPath.row {
                case 0:
                    let rightText=UILabel()
                    rightText.font=UIFont.systemFont(ofSize: 16)
                    rightText.numberOfLines=1
                    rightText.textColor=UIColor.applicationMainColor()
                    if(orderList!.orderStatus! == 1){//未发货
                        rightText.text="未发货"
                    }else if(orderList!.orderStatus! == 2){
                        rightText.text="已发货"
                    }else{
                        rightText.text="已完成"
                    }
                    //计算字符串宽高
                    let rightTextSize=rightText.text!.textSizeWithFont(rightText.font, constrainedToSize: CGSize(width: 100, height: 20))
                    rightText.frame=CGRect(x: boundsWidth-10-rightTextSize.width, y: (cell!.contentH-rightTextSize.height)/2, width: rightTextSize.width, height: rightTextSize.height)
                    cell?.contentView.addSubview(rightText)
                    cell?.lblLeftText?.text="订单号: " + orderList!.orderSN!
                case 1:
                    cell?.lblLeftText?.text="联系店铺: " + "\(orderList!.storeName!)(" + "\(orderList!.sellerName!))"
                case 2:
                    cell?.lblLeftText?.font=UIFont.systemFont(ofSize: 14)
                    cell?.lblLeftText?.numberOfLines=0
                    cell?.lblLeftText?.lineBreakMode=NSLineBreakMode.byWordWrapping
                    //店铺地址
                    let storeAddress=orderList?.address! ?? ""
                    let storeAddressSize=storeAddress.textSizeWithFont(cell!.lblLeftText!.font, constrainedToSize: CGSize(width: boundsWidth-20, height: 60))
                    cell?.lblLeftText?.frame=CGRect(x: 10, y: (60-storeAddressSize.height)/2, width: storeAddressSize.width, height: storeAddressSize.height)
                    cell?.lblLeftText?.text="店铺地址: " + storeAddress
                default:break
                }
                cell?.contentView.addSubview(cell!.lblLeftText!)
                
            }else if(indexPath.section == 1){//第二组数据
                cell?.loadHaveGoods(orderList!, i: indexPath.row)
                cell?.lblLeftText?.removeFromSuperview()
            }else if(indexPath.section == 2){//第三组数据
                switch indexPath.row{
                case 0:
                    cell?.lblLeftText?.text="下单时间: "+(orderList?.add_time)!
                case 1:
                    if (orderList?.add_time != nil){
                        let dateFormatter=DateFormatter()
                        dateFormatter.dateFormat="yyyy-MM-dd HH:mm:ss"
                        let orderTime=dateFormatter.date(from: (orderList?.add_time!)!)
                        //把订单时间转换成秒
                        var orderTimeSS=orderTime!.timeIntervalSince(orderTime!)
                        orderTimeSS += 60*60*24
                        let time=Date(timeIntervalSinceNow:orderTimeSS)
                        let date=dateFormatter.string(from: time)
                        cell?.lblLeftText?.text="到货时间: "+(date)
                    }
                case 2:
                    cell?.lblLeftText?.text="送货经销商: "+orderList!.supplierName!
                case 3:
                    let sellering=orderList?.postscript ?? "无卖家附言"
                    cell?.lblLeftText?.text="卖家附言: "+sellering
                case 4:
                    //若附言为空，默认字符串
                    let pay_message=orderList?.pay_message ?? "无买家附言"
                    cell?.lblLeftText?.text="买家附言: "+pay_message
                case 5:
                    cell?.lblLeftText?.text="支付方式: " + "货到付款"
                case 6:
                    cell?.lblLeftText?.text="配送方式: " + "人工送货"
                case 7:
                    if orderList!.cashCouponId > 0{
                        if orderList!.cashCouponAmountOfMoney != nil{
                            cell?.lblLeftText?.text="已使用\(orderList!.cashCouponAmountOfMoney!)元代金券"
                            cell?.lblLeftText?.textColor=UIColor.red
                        }
                    }
                default:break
                }
                cell!.contentView.addSubview(cell!.lblLeftText!)
            }
        }
        //去除15px空白，分割线顶头对齐
        cell?.layoutMargins=UIEdgeInsets.zero
        cell?.separatorInset=UIEdgeInsets.zero
        cell!.selectionStyle=UITableViewCellSelectionStyle.gray
        return cell!
    }
    //Table 点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //取消选中效果颜色
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 2{
            if indexPath.row == 3{
                if orderList?.postscript != nil{
                    UIAlertController.showAlertYes(self, title:"卖家留言", message: orderList?.postscript, okButtonTitle:"确定")
                }
            }else if indexPath.row == 4{
                if orderList?.pay_message != nil{
                    UIAlertController.showAlertYes(self, title:"买家留言", message: orderList?.pay_message, okButtonTitle:"确定")
                }
            }
        }
    }
    
    /**
    查询进货订单商品详情
    */
    func queryOrderInfo4AndroidByorderId(){
        //检查网络
        
            PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryOrderInfo4AndroidByorderId(orderinfoId:orderList!.orderinfoId!), successClosure: { (result) -> Void in
                let jsonResult=JSON(result)
                print(jsonResult)
                //保存商品entity
                let list=jsonResult["listAndroid"]
                for(_,GoodsDetailsValue)in list{//取出商品entity
                    //实例化商品类
                    let goodEntity=GoodDetailEntity()
                    //商品标题
                    goodEntity.goodInfoName=GoodsDetailsValue["goodInfoName"].stringValue
                    //商品价格
                    goodEntity.goodsUprice=GoodsDetailsValue["goodsUprice"].stringValue
                    //商品图片
                    goodEntity.goodPic=GoodsDetailsValue["goodPic"].stringValue
                    //商品数量
                    goodEntity.goodsSumCount=GoodsDetailsValue["goodsSumCount"].stringValue
                    goodEntity.returnGoodsFlag=GoodsDetailsValue["returnGoodsFlag"].intValue
                    self.goodArr.add(goodEntity)
                }
                //将临时的商品数组赋值给订单实体类中的"list"
                self.orderList?.list=self.goodArr
                //刷新Table
                self.goodsListTable?.reloadData()
                }, failClosure: { (errorMsg) -> Void in
                    SVProgressHUD.showError(withStatus: errorMsg)
            })

    }
    
    /**
    创建底部抢单视图
    */
    func creatBottomView(){
        let viewH:CGFloat=50
        //订单父容器
        bottomWarp=UIView(frame: CGRect(x: 0, y: boundsHeight-viewH, width: boundsWidth, height: viewH))
        bottomWarp.backgroundColor=UIColor.orderBottom()
        self.view.addSubview(bottomWarp)
        //左边订单总价父容器
        sumPriceWarp=UIView(frame: CGRect(x: 0, y: 0, width: boundsWidth/3*2, height: viewH))
        bottomWarp.addSubview(sumPriceWarp)
        //总价
        sumPrice=UILabel(frame: CGRect(x: 10, y: (viewH-20)/2, width: sumPriceWarp.frame.width, height: 20))
        sumPrice.textColor=UIColor.white
        let totalPrice=orderList?.orderPrice ?? "0.0"
        sumPrice.text="总价格:"+"￥" + totalPrice
        sumPriceWarp.addSubview(sumPrice)
        //根据订单状态显示相应的按钮文字
        if(orderList!.orderStatus == 2){//已发货
            let btnReceiving=UIButton(frame:CGRect(x: sumPriceWarp.frame.maxX,y: 0,width: boundsWidth/3,height: viewH))
            btnReceiving.setTitle("确认收货", for: UIControlState())
            btnReceiving.setTitleColor(UIColor.white, for: UIControlState())
            btnReceiving.titleLabel!.font=UIFont.boldSystemFont(ofSize: 14)
            btnReceiving.backgroundColor=UIColor.applicationMainColor()
            btnReceiving.addTarget(self, action:Selector("receivingAction:"), for: UIControlEvents.touchUpInside)
            bottomWarp.addSubview(btnReceiving)
        }else if orderList!.orderStatus == 1{//未发货
            let btnCancelOrder=UIButton(frame:CGRect(x: sumPriceWarp.frame.maxX,y: 0,width: boundsWidth/3,height: viewH))
            btnCancelOrder.setTitle("取消订单", for: UIControlState())
            btnCancelOrder.setTitleColor(UIColor.white, for: UIControlState())
            btnCancelOrder.titleLabel!.font=UIFont.boldSystemFont(ofSize: 14)
            btnCancelOrder.backgroundColor=UIColor.applicationMainColor()
            btnCancelOrder.addTarget(self, action:Selector("cancelOrderAction:"), for: UIControlEvents.touchUpInside)
            bottomWarp.addSubview(btnCancelOrder)
        }
    }
    /**
     取消订单
     
     - parameter sender:UIButton
     */
    func cancelOrderAction(_ sender:UIButton){
        UIAlertController.showAlertYesNo(self, title:"点单即到", message:"您要取消订单吗?", cancelButtonTitle:"取消", okButtonTitle:"确定") { (UIAlertAction) -> Void in
            SVProgressHUD.show(withStatus: "正在加载",maskType:.clear)
            PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.storeCancelOrder(orderId: self.orderList!.orderinfoId!), successClosure: { (result) -> Void in
                let json=JSON(result)
                let success=json["success"].stringValue
                if success == "success"{
                    //收货成功返回上一页面 通知页面刷新数据
                    SVProgressHUD.showSuccess(withStatus: "取消订单成功")
                    NotificationCenter.default.post(name:NSNotification.Name(rawValue: "postUpdateOrderList"), object:self, userInfo:nil)
                    self.navigationController!.popViewController(animated: true)
                }else{
                    SVProgressHUD.show(withStatus: "取消订单失败")
                }
                }, failClosure: { (errorMsg) -> Void in
                    SVProgressHUD.showError(withStatus: errorMsg)
            })
        }
    }
    /**
     确认收货
     
     - parameter sender: UIButton
     */
    func receivingAction(_ sender:UIButton){
        UIAlertController.showAlertYesNo(self, title:"点单即到", message:"确认收货?", cancelButtonTitle:"取消", okButtonTitle:"确定") { (UIAlertAction) -> Void in
            SVProgressHUD.show(withStatus: "正在加载",maskType:.clear)
            PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.updataOrderStatus4Store(orderinfoId: self.orderList!.orderinfoId!), successClosure: { (result) -> Void in
                let json=JSON(result)
                let success=json["success"].stringValue
                if success == "success"{
                    //收货成功返回上一页面 通知页面刷新数据
                    SVProgressHUD.showSuccess(withStatus: "收货成功")
                    NotificationCenter.default.post(name:NSNotification.Name(rawValue: "postUpdateOrderList"), object:self, userInfo:nil)
                    self.navigationController!.popViewController(animated: true)
                }else{
                    SVProgressHUD.showError(withStatus: "收货失败")
                }
                }, failClosure: { (errorMsg) -> Void in
                    SVProgressHUD.showError(withStatus: errorMsg)
            })
            
        }
    }
}
