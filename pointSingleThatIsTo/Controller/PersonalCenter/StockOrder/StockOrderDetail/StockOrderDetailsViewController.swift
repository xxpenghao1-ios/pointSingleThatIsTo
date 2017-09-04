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

///进货订单详情
class StockOrderDetailsViewController:BaseViewController,UITableViewDataSource,UITableViewDelegate{

    //用户信息
    var userDefaults=NSUserDefaults.standardUserDefaults()
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
        self.view.backgroundColor=UIColor.whiteColor()
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
        goodsListTable=UITableView(frame: CGRectMake(0, 0, boundsWidth, boundsHeight-50), style: UITableViewStyle.Grouped)
        goodsListTable?.delegate=self
        goodsListTable?.dataSource=self
        goodsListTable?.backgroundColor=UIColor.goodDetailBorderColor()
        self.view.addSubview(goodsListTable!)
        
        //去除15px空白，分割线顶头对齐
        goodsListTable?.layoutMargins=UIEdgeInsetsZero
        goodsListTable?.separatorInset=UIEdgeInsetsZero
        
        //去除没有数据的单元格
        goodsListTable?.tableFooterView=UIView(frame:CGRectZero)
        //请求订单详情
        if(orderList != nil){//查询进货商品详情
            queryOrderInfo4AndroidByorderId()
            creatBottomView()
        }
        
    }
    //MARK -------------实现Table的一些协议----------------------------
    //返回几组
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    //返回行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
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
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(section == 1){
            //容器
            let headerView=UIView(frame: CGRectMake(0, 0, boundsWidth, 50))
            headerView.backgroundColor=UIColor.goodDetailBorderColor()
            
            //商品容器
            let goodsLblWarp=UIView(frame: CGRectMake(0, 5, boundsWidth, 45))
            goodsLblWarp.backgroundColor=UIColor.whiteColor()
            //商品标题
            let goodsLbl=UILabel(frame: CGRectMake(10, (goodsLblWarp.frame.height-20)/2, boundsWidth, 20))
            goodsLbl.text="商品信息"
            headerView.addSubview(goodsLblWarp)
            goodsLblWarp.addSubview(goodsLbl)
            return headerView
        }else{
            return nil
        }
    }
    //返回头部高度
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){
            return 10
        }else if(section == 1){
            return 50
        }else{
            return 5
        }
    }
    //返回底部高度
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if(section == 2){
            return 10
        }else{
            return 5
        }
    }
    
    //返回数据源
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let Identifier="StockOrderDetailsTableCell"+"\(indexPath.section)"+"\(indexPath.row)"
        var cell=tableView.dequeueReusableCellWithIdentifier(Identifier) as? StockOrderDetailsCell
        if(cell == nil){
            cell=StockOrderDetailsCell(style: UITableViewCellStyle.Default, reuseIdentifier: Identifier)
        }else{
            cell=StockOrderDetailsCell(style: UITableViewCellStyle.Default, reuseIdentifier: Identifier)
        }
        if(orderList != nil){
            if(indexPath.section == 0){//第一组数据
                switch indexPath.row {
                case 0:
                    let rightText=UILabel()
                    rightText.font=UIFont.systemFontOfSize(16)
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
                    let rightTextSize=rightText.text!.textSizeWithFont(rightText.font, constrainedToSize: CGSizeMake(100, 20))
                    rightText.frame=CGRectMake(boundsWidth-10-rightTextSize.width, (cell!.contentH-rightTextSize.height)/2, rightTextSize.width, rightTextSize.height)
                    cell?.contentView.addSubview(rightText)
                    cell?.lblLeftText?.text="订单号: " + orderList!.orderSN!
                case 1:
                    cell?.lblLeftText?.text="联系店铺: " + "\(orderList!.storeName!)(" + "\(orderList!.sellerName!))"
                case 2:
                    cell?.lblLeftText?.font=UIFont.systemFontOfSize(14)
                    cell?.lblLeftText?.numberOfLines=0
                    cell?.lblLeftText?.lineBreakMode=NSLineBreakMode.ByWordWrapping
                    //店铺地址
                    let storeAddress=orderList?.address! ?? ""
                    let storeAddressSize=storeAddress.textSizeWithFont(cell!.lblLeftText!.font, constrainedToSize: CGSizeMake(boundsWidth-20, 60))
                    cell?.lblLeftText?.frame=CGRectMake(10, (60-storeAddressSize.height)/2, storeAddressSize.width, storeAddressSize.height)
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
                        let dateFormatter=NSDateFormatter()
                        dateFormatter.dateFormat="yyyy-MM-dd HH:mm:ss"
                        let orderTime=dateFormatter.dateFromString((orderList?.add_time!)!)
                        //把订单时间转换成秒
                        var orderTimeSS=orderTime!.timeIntervalSinceDate(orderTime!)
                        orderTimeSS += 60*60*24
                        let time=NSDate(timeIntervalSinceNow:orderTimeSS)
                        let date=dateFormatter.stringFromDate(time)
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
                            cell?.lblLeftText?.textColor=UIColor.redColor()
                        }
                    }
                default:break
                }
                cell!.contentView.addSubview(cell!.lblLeftText!)
            }
        }
        //去除15px空白，分割线顶头对齐
        cell?.layoutMargins=UIEdgeInsetsZero
        cell?.separatorInset=UIEdgeInsetsZero
        cell!.selectionStyle=UITableViewCellSelectionStyle.Gray
        return cell!
    }
    //Table 点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //取消选中效果颜色
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
        if(IJReachability.isConnectedToNetwork()){
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
                    self.goodArr.addObject(goodEntity)
                }
                //将临时的商品数组赋值给订单实体类中的"list"
                self.orderList?.list=self.goodArr
                //刷新Table
                self.goodsListTable?.reloadData()
                }, failClosure: { (errorMsg) -> Void in
                    SVProgressHUD.showErrorWithStatus(errorMsg)
            })
        }else{
            SVProgressHUD.showErrorWithStatus("无网络连接")
        }
    }
    
    /**
    创建底部抢单视图
    */
    func creatBottomView(){
        let viewH:CGFloat=50
        //订单父容器
        bottomWarp=UIView(frame: CGRectMake(0, boundsHeight-viewH, boundsWidth, viewH))
        bottomWarp.backgroundColor=UIColor.orderBottom()
        self.view.addSubview(bottomWarp)
        //左边订单总价父容器
        sumPriceWarp=UIView(frame: CGRectMake(0, 0, boundsWidth/3*2, viewH))
        bottomWarp.addSubview(sumPriceWarp)
        //总价
        sumPrice=UILabel(frame: CGRectMake(10, (viewH-20)/2, sumPriceWarp.frame.width, 20))
        sumPrice.textColor=UIColor.whiteColor()
        let totalPrice=orderList?.orderPrice ?? "0.0"
        sumPrice.text="总价格:"+"￥" + totalPrice
        sumPriceWarp.addSubview(sumPrice)
        //根据订单状态显示相应的按钮文字
        if(orderList!.orderStatus == 2){//已发货
            let btnReceiving=UIButton(frame:CGRectMake(CGRectGetMaxX(sumPriceWarp.frame),0,boundsWidth/3,viewH))
            btnReceiving.setTitle("确认收货", forState: UIControlState.Normal)
            btnReceiving.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            btnReceiving.titleLabel!.font=UIFont.boldSystemFontOfSize(14)
            btnReceiving.backgroundColor=UIColor.applicationMainColor()
            btnReceiving.addTarget(self, action:"receivingAction:", forControlEvents: UIControlEvents.TouchUpInside)
            bottomWarp.addSubview(btnReceiving)
        }else if orderList!.orderStatus == 1{//未发货
            let btnCancelOrder=UIButton(frame:CGRectMake(CGRectGetMaxX(sumPriceWarp.frame),0,boundsWidth/3,viewH))
            btnCancelOrder.setTitle("取消订单", forState: UIControlState.Normal)
            btnCancelOrder.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            btnCancelOrder.titleLabel!.font=UIFont.boldSystemFontOfSize(14)
            btnCancelOrder.backgroundColor=UIColor.applicationMainColor()
            btnCancelOrder.addTarget(self, action:"cancelOrderAction:", forControlEvents: UIControlEvents.TouchUpInside)
            bottomWarp.addSubview(btnCancelOrder)
        }
    }
    /**
     取消订单
     
     - parameter sender:UIButton
     */
    func cancelOrderAction(sender:UIButton){
        UIAlertController.showAlertYesNo(self, title:"点单即到", message:"您要取消订单吗?", cancelButtonTitle:"取消", okButtonTitle:"确定") { (UIAlertAction) -> Void in
            SVProgressHUD.showWithStatus("正在加载",maskType:.Clear)
            PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.storeCancelOrder(orderId: self.orderList!.orderinfoId!), successClosure: { (result) -> Void in
                let json=JSON(result)
                let success=json["success"].stringValue
                if success == "success"{
                    //收货成功返回上一页面 通知页面刷新数据
                    SVProgressHUD.showSuccessWithStatus("取消订单成功")
                    NSNotificationCenter.defaultCenter().postNotificationName("postUpdateOrderList", object:self, userInfo:nil)
                    self.navigationController!.popViewControllerAnimated(true)
                }else{
                    SVProgressHUD.showWithStatus("取消订单失败")
                }
                }, failClosure: { (errorMsg) -> Void in
                    SVProgressHUD.showErrorWithStatus(errorMsg)
            })
        }
    }
    /**
     确认收货
     
     - parameter sender: UIButton
     */
    func receivingAction(sender:UIButton){
        UIAlertController.showAlertYesNo(self, title:"点单即到", message:"确认收货?", cancelButtonTitle:"取消", okButtonTitle:"确定") { (UIAlertAction) -> Void in
            SVProgressHUD.showWithStatus("正在加载",maskType:.Clear)
            PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.updataOrderStatus4Store(orderinfoId: self.orderList!.orderinfoId!), successClosure: { (result) -> Void in
                let json=JSON(result)
                let success=json["success"].stringValue
                if success == "success"{
                    //收货成功返回上一页面 通知页面刷新数据
                    SVProgressHUD.showSuccessWithStatus("收货成功")
                    NSNotificationCenter.defaultCenter().postNotificationName("postUpdateOrderList", object:self, userInfo:nil)
                    self.navigationController!.popViewControllerAnimated(true)
                }else{
                    SVProgressHUD.showErrorWithStatus("收货失败")
                }
                }, failClosure: { (errorMsg) -> Void in
                    SVProgressHUD.showErrorWithStatus(errorMsg)
            })
            
        }
    }
}