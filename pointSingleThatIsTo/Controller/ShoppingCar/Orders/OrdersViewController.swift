//
//  OrdersViewController.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/2/22.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import SVProgressHUD

/// 下单页面(传入Dictionary<String,GoodDetailEntity>,totalPirce)
class OrdersViewController:BaseViewController,UITableViewDataSource,UITableViewDelegate{
    /// 接收购物车传过来选中的商品
    var arr=NSMutableArray();
    /// 接收购物车传入的总价
    var totalPirce:Double?
    /// 接收传入商品总数
    var sumCount:Int?
    /// 保存地址数组
    private var addressArr=NSMutableArray()
    /// table
    private var table:UITableView?
    /// 接收买家附言
    private var buyerRemark:String?
    
    private var updateViewFlag=false
    
    /// 展示总价lbl
    private var lblTotalPrice:UILabel?
    
    /// 下单按钮
    private var btnOrdering:UIButton?
    
    /// 保存收获地址
    private var addressEntity:AddressEntity?
    
    private let storeId=NSUserDefaults.standardUserDefaults().objectForKey("storeId") as! String
    
    private let memberId=NSUserDefaults.standardUserDefaults().objectForKey("memberId") as! String
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //每次进入页面刷新页面
        if updateViewFlag{
            self.addressArr.removeAllObjects()
            httpAddress()
        }
        updateViewFlag=true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="确认订单"
        self.view.backgroundColor=UIColor.whiteColor()
        if IJReachability.isConnectedToNetwork(){
            table=UITableView(frame:CGRectMake(0,0,boundsWidth,boundsHeight-50), style: UITableViewStyle.Plain)
            table!.dataSource=self
            table!.delegate=self
            self.view.addSubview(table!)
            //移除空单元格
            table!.tableFooterView = UIView(frame:CGRectZero)
            //设置cell下边线全屏
            if(table!.respondsToSelector("setLayoutMargins:")){
                table?.layoutMargins=UIEdgeInsetsZero
            }
            if(table!.respondsToSelector("setSeparatorInset:")){
                table?.separatorInset=UIEdgeInsetsZero;
            }
            
            buildOrderingView()
            //请求地址信息
            httpAddress()
            //监听附言通知
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateRemark:", name: "remarkNotification", object: nil)
        }else{
            SVProgressHUD.showErrorWithStatus("无网络连接")
        }
    }
    /**
     构建下单view
     */
    func buildOrderingView(){
        /// 订单视图
        let orderingView=UIView(frame:CGRectMake(0,boundsHeight-50,boundsWidth,50))
        orderingView.backgroundColor=UIColor(red:32/255, green: 32/255, blue: 32/255, alpha: 1)
        lblTotalPrice=UILabel(frame:CGRectMake(15,15,boundsWidth/2,20))
        lblTotalPrice!.text="总价 : ￥\(totalPirce!)"
        lblTotalPrice!.textColor=UIColor.whiteColor()
        lblTotalPrice!.font=UIFont.systemFontOfSize(14)
        orderingView.addSubview(lblTotalPrice!)
        
        //下单按钮
        btnOrdering=UIButton(frame:CGRectMake(orderingView.frame.width/3*2,0,orderingView.frame.width/3,50))
        btnOrdering!.backgroundColor=UIColor.applicationMainColor()
        btnOrdering!.setTitle("提交订单", forState: UIControlState.Normal)
        btnOrdering!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btnOrdering!.titleLabel!.font=UIFont.systemFontOfSize(15)
        btnOrdering!.addTarget(self, action:"submitOrder:", forControlEvents: UIControlEvents.TouchUpInside);
        orderingView.addSubview(btnOrdering!)
        
        
        self.view.addSubview(orderingView)
    }
    /**
     下单
     
     - parameter sender:UIButton
     */
    func submitOrder(sender:UIButton){
        if IJReachability.isConnectedToNetwork(){
            if self.addressArr.count > 0{//查看用户是否有收获地址信息
                self.buyerRemark=self.buyerRemark ?? ""
                //详细地址
                let detailAddress=addressEntity!.province!+addressEntity!.city!+addressEntity!.county!+addressEntity!.detailAddress!;
                /// 把字典中的entity转换成json格式的字符串
                let goodsList=toJSONString(arr)
                SVProgressHUD.showWithStatus("数据加载中", maskType: .Clear)
                PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.storeOrderForAndroid(goodsList: goodsList, detailAddress: detailAddress, phoneNumber: addressEntity!.phoneNumber!, shippName: addressEntity!.shippName!, storeId: storeId, pay_message: self.buyerRemark!, tag: 2), successClosure: { (result) -> Void in
                    let json=JSON(result)
                    let success=json["success"].stringValue
                    if success == "success"{
                        var badgeCount=0
                        for(var i=0;i<self.arr.count;i++){
                            
                            let entity=self.arr[i] as! GoodDetailEntity
                            badgeCount+=entity.carNumber!
                        }
                        //发送通知更新角标
                        NSNotificationCenter.defaultCenter().postNotificationName("postBadgeValue",object:3, userInfo:["carCount":badgeCount])
                        
                        let alert=UIAlertController(title:"点单即到", message:"下单成功,查看订单状态吗?", preferredStyle: UIAlertControllerStyle.Alert)
                        let ok=UIAlertAction(title:"确定", style: UIAlertActionStyle.Default, handler:{ Void in
                            //弹出订单页面
                            let vc=StockOrderManage()
                            vc.flag=2
                            let nav=UINavigationController(rootViewController:vc)
                            self.presentViewController(nav, animated:true, completion:nil)
                            self.navigationController!.popToRootViewControllerAnimated(true);
                        })
                        let cancel=UIAlertAction(title:"取消", style: UIAlertActionStyle.Cancel, handler:{ Void in
                            self.navigationController!.popToRootViewControllerAnimated(true);
                        })
                        alert.addAction(cancel)
                        alert.addAction(ok)
                        self.presentViewController(alert, animated:true, completion:nil)
                    }else if success == "info"{
                        let info=json["info"].stringValue
                        UIAlertController.showAlertYes(self, title:"点单即到", message:info, okButtonTitle:"确定", okHandler: { (UIAlertAction) -> Void in
                            self.navigationController!.popToRootViewControllerAnimated(true);
                        })
                    }else{
                        SVProgressHUD.showErrorWithStatus("提交订单失败")
                        if self.buyerRemark == "无附言"{
                            self.buyerRemark=nil
                        }
                    }
                    SVProgressHUD.dismiss()

                    }, failClosure: { (errorMsg) -> Void in
                        SVProgressHUD.showErrorWithStatus(errorMsg)
                })
            }else{
                SVProgressHUD.showInfoWithStatus("请先添加收货地址")
            }
        }else{
            SVProgressHUD.showErrorWithStatus("无网络连接")
        }
    }
    /**
     请求地址信息
     */
    func httpAddress(){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryStoreShippAddressforAndroid(storeId: storeId), successClosure: { (result) -> Void in
            let json=JSON(result)
            for(_,value) in json{
                let entity=Mapper<AddressEntity>().map(value.object)
                self.addressArr.addObject(entity!)
            }
            self.table?.reloadData()
            }) { (errorMsg) -> Void in
                SVProgressHUD.showErrorWithStatus(errorMsg)
        }
    }
    //给每个组的尾部添加视图
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view=UIView(frame:CGRectZero)
        view.backgroundColor=UIColor.viewBackgroundColor()
        return view
    }
    //给每个分组的尾部设置10高度
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId="cell id"
        var cell=tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil{
            cell=UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellId)
        }else{
            cell=UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellId)
        }
        //设置cell下边线全屏
        if(cell!.respondsToSelector("setLayoutMargins:")){
            cell!.layoutMargins=UIEdgeInsetsZero
        }
        if(cell!.respondsToSelector("setSeparatorInset:")){
            cell!.separatorInset=UIEdgeInsetsZero;
        }
        switch indexPath.section{
        case 0:
            switch indexPath.row{
            case 0:
                /// 商品viewX
                var goodViewX:CGFloat=15
                /// 计算数组加载了几次
                var count=0
                for(var i=0;i<arr.count;i++){//循环集合
                    let entity=arr[i] as! GoodDetailEntity
                    count++
                    ///创建商品图片view
                    let goodView=UIView(frame:CGRectMake(goodViewX,10,60,60))
                    goodView.layer.borderWidth=1
                    goodView.layer.borderColor=UIColor.viewBackgroundColor().CGColor
                    /// 创建商品图片
                    let goodImgView=UIImageView(frame:CGRectMake(0,0,60,60))
                    goodImgView.sd_setImageWithURL(NSURL(string:URLIMG+entity.goodPic!), placeholderImage:UIImage(named: "def_nil"))
                    goodView.addSubview(goodImgView)
                    cell!.contentView.addSubview(goodView)
                    goodViewX+=70
                    if count == 3{
                        break
                    }
                }
                cell!.detailTextLabel!.text="共计\(sumCount!)件商品"
                cell!.detailTextLabel!.font=UIFont.systemFontOfSize(14)
                cell!.accessoryType=UITableViewCellAccessoryType.DisclosureIndicator
                break
            default:
                break
            }
            break
        case 1:
            if self.addressArr.count > 0{
                cell!.textLabel!.text=nil
                /// 姓名手机号码
                let lblNameAndPhone=UILabel(frame:CGRectMake(15,10,boundsWidth-30,20))
                lblNameAndPhone.textColor=UIColor.textColor()
                lblNameAndPhone.font=UIFont.systemFontOfSize(14)
                cell!.contentView.addSubview(lblNameAndPhone)
                /// 省市区
                let lblAddress=UILabel(frame:CGRectMake(15,CGRectGetMaxY(lblNameAndPhone.frame)+10,boundsWidth-60,20))
                lblAddress.textColor=UIColor.textColor()
                lblAddress.font=UIFont.systemFontOfSize(14)
                cell!.contentView.addSubview(lblAddress)
                /// 详细地址
                let lblDetailAddress=UILabel(frame:CGRectMake(15,CGRectGetMaxY(lblAddress.frame)+10,boundsWidth-30,20))
                lblDetailAddress.textColor=UIColor.textColor()
                lblDetailAddress.font=UIFont.systemFontOfSize(14)
                cell!.contentView.addSubview(lblDetailAddress)
                for(var i=0;i<self.addressArr.count;i++){//循环所有地址信息
                    let entity=self.addressArr[i] as! AddressEntity
                    if entity.defaultFlag == 1{//如果有默认地址的加载默认地址
                        addressEntity=entity
                        break
                    }else{//如果循环完一直没有默认地址 直接取第1个收货地址
                        addressEntity=self.addressArr[0] as? AddressEntity
                    }
                }
                //给各个控件赋值
                lblNameAndPhone.text=addressEntity!.shippName!+"  "+addressEntity!.phoneNumber!
                lblAddress.text=addressEntity!.province!+addressEntity!.city!+addressEntity!.county!
                lblDetailAddress.text=addressEntity!.detailAddress
            }else{
                cell!.textLabel!.text="+添加收货地址"
                cell!.textLabel!.font=UIFont.systemFontOfSize(15)
                cell!.textLabel!.textColor=UIColor.redColor()
            }
            cell!.accessoryType=UITableViewCellAccessoryType.DisclosureIndicator
            break
        case 2:
            let name=UILabel(frame:CGRectMake(15,15,70,20))
            name.textColor=UIColor.textColor()
            name.font=UIFont.systemFontOfSize(14)
            cell!.contentView.addSubview(name)
            let nameValue=UILabel(frame:CGRectMake(CGRectGetMaxX(name.frame),15,100,20))
            nameValue.font=UIFont.systemFontOfSize(14)
            nameValue.textColor=UIColor.redColor()
            cell!.contentView.addSubview(nameValue)
            switch indexPath.row{
            case 0:
                name.text="支付方式 : "
                nameValue.text="货到付款"
                break
            case 1:
                name.text="配送方式 : "
                nameValue.text="人工送货"
                break
            case 2:
                name.text="买家附言 : "
                if self.buyerRemark == nil{
                    nameValue.text="+点击添加附言"
                }else{
                    nameValue.text=self.buyerRemark
                    nameValue.textColor=UIColor.textColor()
                }
                cell!.accessoryType=UITableViewCellAccessoryType.DisclosureIndicator
                break
            default:
                break
            }
            break
        default:
            break
        }
        return cell!
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    //返回tabview的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        switch section{
            case 0:
                return 1
            case 1:
                return 1
            case 2:
                return 3
            default:
                break
        }
        return 0
    }
    //返回tabview的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        switch indexPath.section{
        case 0:
            return 80
        case 1:
            if self.addressArr.count > 0{
                return 100
            }else{
                return 50
            }
        case 2:
            return 50
        default:
            break
        }
        return 0;
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //取消选中的样式
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
        switch indexPath.section{
        case 0://跳转到购物清单
            let vc=OrderGoodViewController()
            vc.arr=arr
            self.navigationController!.pushViewController(vc, animated:true)
            break
        case 1://跳转到收货地址管理
            if self.addressArr.count > 0{//如果有数据自己跳转收货地址列表页面
                let vc=ShippingAddressViewController()
                self.navigationController!.pushViewController(vc, animated: true)
            }else{//没有跳转到添加收货地址
                let vc=UpdateAndAddShippingAddressViewController()
                vc.addressFlag=2
                self.navigationController!.pushViewController(vc, animated:true)
            }
            break
        case 2:
            switch indexPath.row{
            case 2://跳转到买家附言
                let vc=BuyerRemark()
                vc.textLbl=self.buyerRemark
                self.navigationController!.pushViewController(vc,animated:true)
                break
            default:
                break
            }
            break
        default:
            break
        }
    }
    /**
     接收通知
     
     - parameter obj: 传入的参数
     */
    func updateRemark(obj:NSNotification){
        var str=obj.object as? String
        if str == nil || str == ""{
            str=nil
        }
        self.buyerRemark=str
        self.table?.reloadData()
    }
}