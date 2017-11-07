////
////  GrabASingleDetailsView.swift
////  pointSingleThatIsTo
////
////  Created by 卢洋 on 16/2/22.
////  Copyright © 2016年 penghao. All rights reserved.
////
//
//import Foundation
//import UIKit
//// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
//// Consider refactoring the code to use the non-optional operators.
//fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
//  switch (lhs, rhs) {
//  case let (l?, r?):
//    return l < r
//  case (nil, _?):
//    return true
//  default:
//    return false
//  }
//}
//
//// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
//// Consider refactoring the code to use the non-optional operators.
//fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
//  switch (lhs, rhs) {
//  case let (l?, r?):
//    return l > r
//  default:
//    return rhs < lhs
//  }
//}
//
//import ObjectMapper
//import SVProgressHUD
////快速抢单详情
//class GrabASingleDetailsView:BaseViewController,UITableViewDataSource,UITableViewDelegate{
//    //用户信息
//    var userDefaults=UserDefaults.standard
//    //商品列表Table
//    var goodsListTable:UITableView?
//
//    //接收页面传过来的订单entity
//    var orderList:OrderListEntity?
//
//    //商品数组
//    var goodArr=NSMutableArray()
//
//    //底部父容器
//    var bottomWarp:UIView!
//
//    //总价格
//    var sumPriceWarp:UIView!
//    var sumPrice:UILabel!
//
//    //抢单
//    var GrabASingleWarp:UIView!
//    var GrabASingleBtn:UIButton!
//
//    //电话号码
//    var phoneNumber:String=""
//
//    /// 接收卖家附言
//    var sellerRemark=""
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.backgroundColor=UIColor.white
//        creatGoodsListTable()
//        creatBottomView()
//        //添加观察者，监听卖家附言的通知
//        NotificationCenter.default.addObserver(self, #selector: #selector(("updateRemark:")), name: NSNotification.Name(rawValue: "remarkNotification"), object: nil)
//    }
//    /**
//    创建我要抢单商品列表
//    */
//    func creatGoodsListTable(){
//        goodsListTable=UITableView(frame: CGRect(x: 0, y: 0, width: boundsWidth, height: boundsHeight-50), style: UITableViewStyle.grouped)
//        goodsListTable?.delegate=self
//        goodsListTable?.dataSource=self
//        goodsListTable?.backgroundColor=UIColor.goodDetailBorderColor()
//        self.view.addSubview(goodsListTable!)
//
//        //去除15px空白，分割线顶头对齐
//        goodsListTable?.layoutMargins=UIEdgeInsets.zero
//        goodsListTable?.separatorInset=UIEdgeInsets.zero
//
//        //去除没有数据的单元格
//        goodsListTable?.tableFooterView=UIView(frame:CGRect.zero)
//        //请求订单详情
//        if(orderList != nil){
//            queryOrderInfo4AndroidByorderId()
//        }
//
//    }
//    //MARK -------------实现Table的一些协议----------------------------
//    //返回几组
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//    //返回行高
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if(indexPath.section == 0){
//            return 100
//        }else{
//            if(indexPath.row == 2){
//                return 60
//            }else{
//                return 50
//            }
//        }
//    }
//    //返回行数
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if(orderList?.list?.count > 0){
//            if(section == 0){
//               return (orderList?.list?.count)!
//            }else{//第二组
//                if(orderList!.robflag == 2 || orderList!.robflag == 3){//若是已抢订单，则显示卖家留言
//                    return 6
//                }else{
//                    return 5
//                }
//            }
//        }else{
//            return 0
//        }
//    }
//    //返回头部视图
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if(section == 0){
//            //容器
//            let headerView=UIView(frame: CGRect(x: 0, y: 0, width: boundsWidth, height: 50))
//            headerView.backgroundColor=UIColor.goodDetailBorderColor()
//
//            //商品容器
//            let goodsLblWarp=UIView(frame: CGRect(x: 0, y: 10, width: boundsWidth, height: 40))
//            goodsLblWarp.backgroundColor=UIColor.white
//            //商品标题
//            let goodsLbl=UILabel(frame: CGRect(x: 10, y: (goodsLblWarp.frame.height-20)/2, width: boundsWidth, height: 20))
//            goodsLbl.text="商品信息"
//            headerView.addSubview(goodsLblWarp)
//            goodsLblWarp.addSubview(goodsLbl)
//            return headerView
//        }else{
//            return nil
//        }
//    }
//    //返回头部高度
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if(section == 0){
//            return 50
//        }else{
//            return 5
//        }
//    }
//    //返回底部高度
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 5
//    }
//    //返回数据源
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let Identifier="GrabASingleDetailsTableCell"+"\(indexPath.section)"+"\(indexPath.row)"
//        var cell=tableView.dequeueReusableCell(withIdentifier: Identifier) as? GrabASingleDetailsViewCell
//        if(cell == nil){
//            cell=GrabASingleDetailsViewCell(style: UITableViewCellStyle.default, reuseIdentifier: Identifier)
//        }else{
//            cell=GrabASingleDetailsViewCell(style: UITableViewCellStyle.default, reuseIdentifier: Identifier)
//        }
//        if(orderList != nil){
//            if(indexPath.section == 0){//第一组
//                cell?.loadHaveGoods(orderList!, i: indexPath.row)
//                cell?.add_time?.removeFromSuperview()
//            }
//            if(indexPath.section == 1){//第二组
//                //接收收货地址字符串
//                let address=orderList!.address!
//                //截取收货地址字符串中的手机号码
//                let addressString=address.components(separatedBy: ")")
//                //取得电话号码
//                phoneNumber=addressString[1]
//                //取得收货地址
//                let addresss=addressString[0]+")"
//                if(phoneNumber.contains(" ")){//若包含空格，则过滤
//                    phoneNumber = phoneNumber.trimmingCharacters(in: CharacterSet.whitespaces);
//                }
//                if(orderList!.robflag == 1){//若是我要抢单，则隐藏电话号码
//                    let s=(phoneNumber.startIndex ..< phoneNumber.characters.index(phoneNumber.startIndex, offsetBy: phoneNumber.characters.count-8))
//                    phoneNumber=phoneNumber.substring(with: s)+"******"
//                }
//                switch indexPath.row{
//                case 0:
//                    cell?.add_time?.text="下单时间: "+(orderList?.add_time)!
//                case 1:
//                    if(orderList!.robflag == 2 || orderList!.robflag == 3 || orderList!.robflag == 4){//如果是已抢订单，则显示拨打电话图片
//                        cell?.phonePic=UIImageView(frame: CGRect(x: boundsWidth-30, y: (cell!.contentView.frame.height-15)/2, width: 20, height: 20))
//                        cell?.phonePic.image=UIImage(named: "tell_ico")
//                        cell?.contentView.addSubview(cell!.phonePic)
//                    }
//                    cell?.add_time?.text="联系方式: "+phoneNumber
//
//                case 2:
//                    cell?.add_time?.text="送货地址: "+addresss
//                    let textSize=cell?.add_time?.text?.textSizeWithFont((cell?.add_time?.font)!, constrainedToSize: CGSize(width: boundsWidth-20, height: 60))
//                    cell?.add_time?.frame=CGRect(x: 10, y: (60-textSize!.height)/2, width: textSize!.width, height: textSize!.height)
//                case 3:
//                   //若附言为空，默认字符串
//                        let pay_message=orderList?.pay_message ?? "无买家附言"
//                        cell?.add_time?.text="买家附言: "+pay_message
//                case 4:cell?.add_time?.text="支付方式: "+"货到付款"
//                case 5:
//                    if(orderList!.robflag == 2){//已抢订单
//                        if(sellerRemark == ""){
//                            cell?.add_time?.text="卖家附言: "+"点击添加附言"
//                        }else{
//                            cell?.add_time?.text="卖家附言: "+sellerRemark
//                        }
//                    }else if(orderList!.robflag == 3){//已发货订单
//                        let sellering=orderList?.postscript ?? "无卖家附言"
//                        cell?.add_time?.text="卖家附言: "+sellering
//                    }
//
//
//                default:break
//                }
//                cell!.contentView.addSubview(cell!.add_time!)
//            }
//
//        }
//        //去除15px空白，分割线顶头对齐
//        cell?.layoutMargins=UIEdgeInsets.zero
//        cell?.separatorInset=UIEdgeInsets.zero
//        cell!.selectionStyle=UITableViewCellSelectionStyle.gray
//        return cell!
//    }
//    //表格点击事件
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //取消选中的样式
//        tableView.deselectRow(at: indexPath, animated: true);
//        if(indexPath.section == 1){//第二组
//            if(orderList!.robflag == 2){//已经抢到的订单详情
//                if(indexPath.row == 1){//拨打电话
//                    let alertController = UIAlertController(title: "点单即到",
//                    message: "是否拨打电话:\(phoneNumber)", preferredStyle: UIAlertControllerStyle.alert)
//                let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default,
//                    handler: {
//                        action in
//                        let app=UIApplication.shared;
//                        app.openURL(Foundation.URL(string:"tel://\(self.phoneNumber)")!)
//                })
//                let cancelAction=UIAlertAction(title: "取消", style: UIAlertActionStyle.default, handler: nil)
//                alertController.addAction(okAction)
//                alertController.addAction(cancelAction)
//                self.present(alertController, animated: true, completion: nil)
//
//                }else if(indexPath.row == 5){//卖家附言cell的索引
//                    //跳转到卖家附言界面
//                    let sellerVC=SellerRemark()
//                    if(sellerRemark.characters.count > 0){
//                        sellerVC.textLbl=sellerRemark
//                    }
//                    self.navigationController?.pushViewController(sellerVC, animated: true)
//                }
//
//            }else if(orderList!.robflag == 3 || orderList!.robflag == 4){
//                if(indexPath.row == 1){//拨打电话
//                    let alertController = UIAlertController(title: "点单即到",
//                        message: "是否拨打电话:\(phoneNumber)", preferredStyle: UIAlertControllerStyle.alert)
//                    let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default,
//                        handler: {
//                            action in
//                            let app=UIApplication.shared;
//                            app.openURL(Foundation.URL(string:"tel://\(self.phoneNumber)")!)
//                    })
//                    let cancelAction=UIAlertAction(title: "取消", style: UIAlertActionStyle.default, handler: nil)
//                    alertController.addAction(okAction)
//                    alertController.addAction(cancelAction)
//                    self.present(alertController, animated: true, completion: nil)
//                }
//            }
//        }
//    }
//
//    /**
//    查询订单是否被抢
//    */
//    func queryOrderInfo4AndroidByorderId(){
//
//            PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryOrderInfo4AndroidByorderId(orderinfoId:orderList!.orderinfoId!), successClosure: { (result) -> Void in
//                let jsonResult=JSON(result)
//                //保存商品entity
//                let list=jsonResult["listAndroid"]
////                NSLog("list----\(list)")
//                //判断订单是否被抢
//                if(jsonResult["robflag"] == "10"){//10表示订单被抢
//                    //订单被抢，则发送快速抢单页面刷新的通知
//                    NotificationCenter.defaultCenter().postNotificationName("grabASingleNotification", object: "1")
//
//                    let alertController = UIAlertController(title: "点单即到",
//                                                            message: "订单已经被抢，下次下手快点哦", preferredStyle: UIAlertControllerStyle.alert)
//                    let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default,
//                        handler: {
//                            action in
//                            self.navigationController?.popViewController(animated: true)
//                    })
//                    alertController.addAction(okAction)
//                    self.presentViewController(alertController, animated: true, completion: nil)
//                }else{//订单还没被抢
//                    for(_,GoodsDetailsValue)in list{//取出商品entity
//                        //实例化商品类
//                        let goodEntity=GoodDetailEntity()
//                        //商品标题
//                        goodEntity.goodInfoName=GoodsDetailsValue["goodInfoName"].stringValue
//                        //商品价格
//                        goodEntity.goodsUprice=GoodsDetailsValue["goodsUprice"].stringValue
//                        //商品图片
//                        goodEntity.goodPic=GoodsDetailsValue["goodPic"].stringValue
//                        //商品数量
//                        goodEntity.goodsSumCount=GoodsDetailsValue["goodsSumCount"].stringValue
//                        self.goodArr.addObject(goodEntity)
//                    }
//                    //将临时的商品数组赋值给订单实体类中的"list"
//                    self.orderList?.list=self.goodArr
//                    //刷新Table
//                    self.goodsListTable?.reloadData()
//                    self.bottomWarp.isHidden=false
//                }
//
//                }, failClosure: { (errorMsg) -> Void in
//                    SVProgressHUD.showError(withStatus: errorMsg)
//            })
//    }
//    /**
//    创建底部抢单视图
//    */
//    func creatBottomView(){
//        let viewH:CGFloat=50
//        //订单父容器
//        bottomWarp=UIView(frame: CGRect(x: 0, y: boundsHeight-viewH, width: boundsWidth, height: viewH))
//        bottomWarp.backgroundColor=UIColor.orderBottom()
//        self.view.addSubview(bottomWarp)
//        //先隐藏
//        bottomWarp.isHidden=true
//        //左边订单总价父容器
//        sumPriceWarp=UIView(frame: CGRect(x: 0, y: 0, width: boundsWidth/3*2, height: viewH))
//        bottomWarp.addSubview(sumPriceWarp)
//        //总价
//        sumPrice=UILabel(frame: CGRect(x: 10, y: (viewH-20)/2, width: sumPriceWarp.frame.width, height: 20))
//        sumPrice.textColor=UIColor.white
//        let totalPrice=orderList?.orderPrice ?? ""
//        sumPrice.text="总价格:"+"￥" + totalPrice
//        sumPriceWarp.addSubview(sumPrice)
//
//        //右边抢订单容器
//        GrabASingleWarp=UIView(frame: CGRect(x: sumPriceWarp.frame.width, y: 0, width: boundsWidth/3, height: viewH))
//        GrabASingleWarp.backgroundColor=UIColor.applicationMainColor()
//        bottomWarp.addSubview(GrabASingleWarp)
//
//        //右边抢订单按钮
//        GrabASingleBtn=UIButton(frame: CGRect(x: 0, y: 0, width: GrabASingleWarp.frame.width, height: viewH))
//        GrabASingleBtn.tintColor=UIColor.white
//        GrabASingleWarp.addSubview(GrabASingleBtn)
//
//        //根据订单状态显示相应的按钮文字
//        if(orderList!.robflag == 1){//可以抢单
//            self.title="我要抢单"
//            GrabASingleBtn.setTitle("抢单", for: UIControlState())
//            GrabASingleBtn.addTarget(self, action: "actionGrabASingle:", for: UIControlEvents.touchUpInside)
//        }else if(orderList!.robflag == 2){//已经抢到的订单，准备发货
//            self.title="已抢订单"
//            GrabASingleBtn.setTitle("发货", for: UIControlState())
//            GrabASingleBtn.addTarget(self, action: "actionDeliverGoods:", for: UIControlEvents.touchUpInside)
//        }else if(orderList!.robflag == 3){//已经发货的订单
//            self.title="已发货订单"
//            GrabASingleWarp.isHidden=true
//        }else{//已经完成的订单
//            self.title="已完成订单"
//            GrabASingleWarp.isHidden=true
//        }
//
//    }
//    /**
//    我要抢单请求
//
//    - parameter btn:
//    */
//    func actionGrabASingle(_ btn:UIButton){
//        //店铺号
//        let storeId=userDefaults.object(forKey: "storeId") as! String
//        //检测网络
//        if(IJReachability.isConnectedToNetwork()){
//            //加载菊花图
//            SVProgressHUD.showWithStatus("正在加载中",maskType: SVProgressHUDMaskType.gradient)
//            PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.robOrderByStore4Android(orderId:orderList!.orderinfoId!, storeId:storeId), successClosure: { (result) -> Void in
//                SVProgressHUD.dismiss()
//                let jsonResult=JSON(result)
//                if(jsonResult["success"].stringValue == "success"){//抢单成功后，发送快速抢单页面、和已抢订单页面刷新的通知
//                    //订单被抢，则发送快速抢单页面刷新的通知 1-表示订单被抢
//                    NotificationCenter.defaultCenter().postNotificationName("grabASingleNotification", object: "1")
//                    let alertController = UIAlertController(title: "点单即到",
//                                                            message: "抢单成功!", preferredStyle: UIAlertControllerStyle.alert)
//                    let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default,
//                        handler: {
//                            action in
//                            self.navigationController?.popViewControllerAnimated(true)
//                    })
//                    alertController.addAction(okAction)
//                    self.presentViewController(alertController, animated: true, completion: nil)
//                }else if(jsonResult["success"].stringValue == "isrob"){
//                    let alertController = UIAlertController(title: "点单即到",
//                        message: "该笔订单已经被抢,下次记得手要快哦!", preferredStyle: UIAlertControllerStyle.Alert)
//                    let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default,
//                        handler: {
//                            action in
//                            self.navigationController?.popViewControllerAnimated(true)
//                    })
//                    alertController.addAction(okAction)
//                    self.presentViewController(alertController, animated: true, completion: nil)
//                }else{
//                    SVProgressHUD.showErrorWithStatus("抢单失败，请重新抢单")
//                }
//
//                }, failClosure: { (errorMsg) -> Void in
//                    SVProgressHUD.showErrorWithStatus(errorMsg)
//            })
//        }else{
//            SVProgressHUD.showErrorWithStatus("无网络连接")
//        }
//    }
//    /**
//    发货请求
//
//    - parameter btn:
//    */
//    func actionDeliverGoods(_ btn:UIButton){
//            //弹窗
//            let alertController = UIAlertController(title: "点单即到",
//                message: "确定发货吗?", preferredStyle: UIAlertControllerStyle.alert)
//            let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default,
//                handler: {
//                    action in
//                    //首先判断卖家有没有添加附言
//                    if(self.sellerRemark == ""){
//                        self.sellerRemark="卖家无附言"
//                    }
//                    //加载菊花图
//                    SVProgressHUD.showWithStatus("正在加载中")
//                    SVProgressHUD
//                    PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.storeConfirmDelivergoods(orderinfoId:self.orderList!.orderinfoId!, postscript:self.sellerRemark), successClosure: { (result) -> Void in
//                        SVProgressHUD.dismiss()
//                        let jsonResult=JSON(result)
//                        if(jsonResult["success"].stringValue == "success"){//发货成功后，已抢订单、已发货页面需要刷新，2-表示已发货
//                            NSNotificationCenter.defaultCenter().postNotificationName("grabASingleNotification", object: "2")
//                            let alertController = UIAlertController(title: "点单即到",
//                                message: "发货成功,请等待买家收货!", preferredStyle: UIAlertControllerStyle.Alert)
//                            let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default,
//                                handler: {
//                                    action in
//                                    //返回上一页面
//                                    self.navigationController?.popViewControllerAnimated(true)
//                            })
//                            alertController.addAction(okAction)
//                            self.presentViewController(alertController, animated: true, completion: nil)
//                        }else{
//                            SVProgressHUD.showErrorWithStatus("发货失败，请重新发货")
//                        }
//
//                        }, failClosure: { (errorMsg) -> Void in
//                            SVProgressHUD.showErrorWithStatus(errorMsg)
//                    })
//            })
//            let cancelAction=UIAlertAction(title: "取消", style: UIAlertActionStyle.default, handler: nil)
//            alertController.addAction(okAction)
//            alertController.addAction(cancelAction)
//            self.present(alertController, animated: true, completion: nil)
//    }
//    /**
//    监听到卖家附言的通知调用的方法
//
//    - parameter sender: 当前附言
//    */
//    func updateRemark(_ sender:Notification){
//        let string = sender.object as! String;
//        NSLog("卖家附言--\(string)")
//        self.sellerRemark = string
//        self.goodsListTable?.reloadData()
//    }
//
//}

