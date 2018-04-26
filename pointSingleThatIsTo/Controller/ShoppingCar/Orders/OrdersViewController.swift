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
import Alamofire
import SwiftyJSON
/// 下单页面(传入Dictionary<String,GoodDetailEntity>,totalPirce)
class OrdersViewController:BaseViewController,UITableViewDataSource,UITableViewDelegate{
    /// 接收购物车传过来选中的商品
    var arr=NSMutableArray();
    /// 接收购物车传入的总价
    var totalPirce:Double?
    /// 接收传入商品总数
    var sumCount:Int?
    /// 保存地址数组
    fileprivate var addressArr=NSMutableArray()
    /// table
    fileprivate var table:UITableView?
    /// 接收买家附言
    fileprivate var buyerRemark:String?
    
    fileprivate var updateViewFlag=false
    
    /// 展示总价lbl
    fileprivate var lblTotalPrice:UILabel?
    
    /// 下单按钮
    fileprivate var btnOrdering:UIButton?
    
    /// 保存收获地址
    fileprivate var addressEntity:AddressEntity?
    
    //保存代金券使用下限
    fileprivate var cashcouponLowerLimitOfUse=0
    //保存是否开启可以使用代金券 默认2关闭,1开启
    fileprivate var cashcouponStatu=2
    //保存代金券信息
    fileprivate var vouchersEntity:VouchersEntity?
    
    fileprivate let storeId=UserDefaults.standard.object(forKey: "storeId") as! String
    
    fileprivate let memberId=UserDefaults.standard.object(forKey: "memberId") as! String
    fileprivate let substationId=userDefaults.object(forKey: "substationId") as! String
    
    
    override func viewDidAppear(_ animated: Bool) {
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
        self.view.backgroundColor=UIColor.white
            table=UITableView(frame:CGRect(x: 0,y: 0,width: boundsWidth,height: boundsHeight-50-bottomSafetyDistanceHeight), style: UITableViewStyle.plain)
            table!.dataSource=self
            table!.delegate=self
            self.view.addSubview(table!)
            //移除空单元格
            table!.tableFooterView = UIView(frame:CGRect.zero)
            //设置cell下边线全屏
        if(table!.responds(to: #selector(setter: UIView.layoutMargins))){
                table?.layoutMargins=UIEdgeInsets.zero
            }
        if(table!.responds(to: #selector(setter: UITableViewCell.separatorInset))){
                table?.separatorInset=UIEdgeInsets.zero;
            }
            buildOrderingView()
            //请求地址信息
            httpAddress()
            //请求代金券是否可以使用
            requestSubStationCC()
            //监听附言通知
        NotificationCenter.default.addObserver(self, selector: #selector(updateRemark), name: NSNotification.Name(rawValue: "remarkNotification"), object: nil)
    }
    
    /**
     请代金券是否可以使用
     */
    func requestSubStationCC(){
        request(URLIMG+"/cc/querySubStationCC",method:.get,parameters:["substationId":substationId]).responseJSON{ response in
            if response.result.error != nil{
                SVProgressHUD.showError(withStatus: response.result.error!.localizedDescription)
            }
            if response.result.value != nil{
                let json=JSON(response.result.value!)
                self.cashcouponLowerLimitOfUse=json["cashcouponLowerLimitOfUse"].intValue
                self.cashcouponStatu=json["cashcouponStatu"].intValue
                self.table?.reloadData()
            }
        }
    }
    /**
     构建下单view
     */
    func buildOrderingView(){
        /// 订单视图
        let orderingView=UIView(frame:CGRect(x: 0,y: boundsHeight-50-bottomSafetyDistanceHeight,width: boundsWidth,height: 50))
        orderingView.backgroundColor=UIColor(red:32/255, green: 32/255, blue: 32/255, alpha: 1)
        lblTotalPrice=UILabel(frame:CGRect(x: 15,y: 15,width: boundsWidth/2,height: 20))
        lblTotalPrice!.text="总价 : ￥\(totalPirce!)"
        lblTotalPrice!.textColor=UIColor.white
        lblTotalPrice!.font=UIFont.systemFont(ofSize: 14)
        orderingView.addSubview(lblTotalPrice!)
        
        //下单按钮
        btnOrdering=UIButton(frame:CGRect(x: orderingView.frame.width/3*2,y: 0,width: orderingView.frame.width/3,height: 50))
        btnOrdering!.backgroundColor=UIColor.applicationMainColor()
        btnOrdering!.setTitle("提交订单", for: UIControlState())
        btnOrdering!.setTitleColor(UIColor.white, for: UIControlState())
        btnOrdering!.titleLabel!.font=UIFont.systemFont(ofSize: 15)
        btnOrdering!.addTarget(self, action:#selector(submitOrder), for: UIControlEvents.touchUpInside);
        orderingView.addSubview(btnOrdering!)
        
        
        self.view.addSubview(orderingView)
    }
    /**
     下单
     
     - parameter sender:UIButton
     */
    @objc func submitOrder(_ sender:UIButton){
        
            if self.addressArr.count > 0{//查看用户是否有收获地址信息
                self.buyerRemark=self.buyerRemark ?? ""
                //详细地址
                let detailAddress=addressEntity!.province!+addressEntity!.city!+addressEntity!.county!+addressEntity!.detailAddress!;
                /// 把字典中的entity转换成json格式的字符串
                let goodsList=toJSONString(arr)
                 self.showSVProgressHUD(status:"数据加载中", type: HUD.textClear)
                var cashCouponId:Int?
                if self.vouchersEntity != nil{
                   cashCouponId=self.vouchersEntity!.cashCouponId
                }
                PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.storeOrderForAndroid(goodsList: goodsList, detailAddress: detailAddress, phoneNumber: addressEntity!.phoneNumber!, shippName: addressEntity!.shippName!, storeId: storeId, pay_message: self.buyerRemark!, tag: 2,cashCouponId:cashCouponId), successClosure: { (result) -> Void in
                    let json=JSON(result)
                    let success=json["success"].stringValue
                    if success == "success"{
                        var badgeCount=0
                        for i in 0..<self.arr.count{
                            
                            let entity=self.arr[i] as! GoodDetailEntity
                            badgeCount+=entity.carNumber!
                        }
                        //发送通知更新角标
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "postBadgeValue"),object:3, userInfo:["carCount":badgeCount])
                        
                        let alert=UIAlertController(title:"点单即到", message:"下单成功,您的货物会在24小时内送货上门,请注意查收。", preferredStyle: UIAlertControllerStyle.alert)
                        let ok=UIAlertAction(title:"查看订单", style: UIAlertActionStyle.default, handler:{ Void in
                            //弹出订单页面
                            let vc=StockOrderManage()
                            vc.flag=2
                            let nav=UINavigationController(rootViewController:vc)
                            self.present(nav, animated:true, completion:nil)
                            self.navigationController!.popToRootViewController(animated: true);
                        })
                        let cancel=UIAlertAction(title:"取消", style: UIAlertActionStyle.cancel, handler:{ Void in
                            self.navigationController!.popToRootViewController(animated: true);
                        })
                        alert.addAction(cancel)
                        alert.addAction(ok)
                        self.present(alert, animated:true, completion:nil)
                    }else if success == "info"{
                        let info=json["info"].stringValue
                        UIAlertController.showAlertYes(self, title:"点单即到", message:info, okButtonTitle:"确定", okHandler: { (UIAlertAction) -> Void in
                            self.navigationController!.popToRootViewController(animated: true);
                        })
                    }else{
                        SVProgressHUD.showError(withStatus: "提交订单失败")
                        if self.buyerRemark == "无附言"{
                            self.buyerRemark=nil
                        }
                    }
                    SVProgressHUD.dismiss()

                    }, failClosure: { (errorMsg) -> Void in
                        SVProgressHUD.showError(withStatus: errorMsg)
                })
            }else{
                SVProgressHUD.showInfo(withStatus: "请先添加收货地址")
            }
    }
    /**
     请求地址信息
     */
    func httpAddress(){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryStoreShippAddressforAndroid(storeId: storeId), successClosure: { (result) -> Void in
            let json=JSON(result)
            for(_,value) in json{
                let entity=Mapper<AddressEntity>().map(JSONObject:value.object)
                entity?.detailAddress=entity?.detailAddress ?? ""
                entity?.phoneNumber=entity?.phoneNumber ?? ""
                entity?.shippName=entity?.shippName ?? ""
                self.addressArr.add(entity!)
            }
            self.table?.reloadData()
            }) { (errorMsg) -> Void in
                SVProgressHUD.showError(withStatus: errorMsg)
        }
    }
    //给每个组的尾部添加视图
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view=UIView(frame:CGRect.zero)
        view.backgroundColor=UIColor.viewBackgroundColor()
        return view
    }
    //给每个分组的尾部设置10高度
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId="cell id"
        var cell=tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil{
            cell=UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: cellId)
        }else{
            cell=UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: cellId)
        }
        //设置cell下边线全屏
        if(cell!.responds(to: #selector(setter: UIView.layoutMargins))){
            cell!.layoutMargins=UIEdgeInsets.zero
        }
        if(cell!.responds(to: #selector(setter: UITableViewCell.separatorInset))){
            cell!.separatorInset=UIEdgeInsets.zero;
        }
        switch indexPath.section{
        case 0:
            switch indexPath.row{
            case 0:
                /// 商品viewX
                var goodViewX:CGFloat=15
                /// 计算数组加载了几次
                var count=0
                for i in 0..<arr.count{
                    let entity=arr[i] as! GoodDetailEntity
                    count+=1
                    ///创建商品图片view
                    let goodView=UIView(frame:CGRect(x: goodViewX,y: 10,width: 60,height: 60))
                    goodView.layer.borderWidth=1
                    goodView.layer.borderColor=UIColor.viewBackgroundColor().cgColor
                    /// 创建商品图片
                    let goodImgView=UIImageView(frame:CGRect(x: 0,y: 0,width: 60,height: 60))
                    entity.goodPic=entity.goodPic ?? ""
                    goodImgView.sd_setImage(with: Foundation.URL(string:URLIMG+entity.goodPic!), placeholderImage:UIImage(named: "def_nil"))
                    goodView.addSubview(goodImgView)
                    cell!.contentView.addSubview(goodView)
                    goodViewX+=70
                    if count == 3{
                        break
                    }
                }
                cell!.detailTextLabel!.text="共计\(sumCount!)件商品"
                cell!.detailTextLabel!.font=UIFont.systemFont(ofSize: 14)
                cell!.accessoryType=UITableViewCellAccessoryType.disclosureIndicator
                break
            default:
                break
            }
            break
        case 1:
            if self.addressArr.count > 0{
                cell!.textLabel!.text=nil
                /// 姓名手机号码
                let lblNameAndPhone=UILabel(frame:CGRect(x: 15,y: 10,width: boundsWidth-30,height: 20))
                lblNameAndPhone.textColor=UIColor.textColor()
                lblNameAndPhone.font=UIFont.systemFont(ofSize: 14)
                cell!.contentView.addSubview(lblNameAndPhone)
                /// 省市区
                let lblAddress=UILabel(frame:CGRect(x: 15,y: lblNameAndPhone.frame.maxY+10,width: boundsWidth-60,height: 20))
                lblAddress.textColor=UIColor.textColor()
                lblAddress.font=UIFont.systemFont(ofSize: 14)
                cell!.contentView.addSubview(lblAddress)
                /// 详细地址
                let lblDetailAddress=UILabel(frame:CGRect(x: 15,y: lblAddress.frame.maxY+10,width: boundsWidth-30,height: 20))
                lblDetailAddress.textColor=UIColor.textColor()
                lblDetailAddress.font=UIFont.systemFont(ofSize: 14)
                cell!.contentView.addSubview(lblDetailAddress)
                for i in 0..<self.addressArr.count{//循环所有地址信息
                    let entity=self.addressArr[i] as! AddressEntity
                    if entity.defaultFlag == 1{//如果有默认地址的加载默认地址
                        addressEntity=entity
                        break
                    }else{//如果循环完一直没有默认地址 直接取第1个收货地址
                        addressEntity=self.addressArr[0] as? AddressEntity
                    }
                }
                //给各个控件赋值
                if addressEntity!.phoneNumber != nil{
                    lblNameAndPhone.text=addressEntity!.shippName!+"  "+addressEntity!.phoneNumber!
                }
                lblAddress.text=addressEntity!.province!+addressEntity!.city!+addressEntity!.county!
                lblDetailAddress.text=addressEntity!.detailAddress
            }else{
                cell!.textLabel!.text="+添加收货地址"
                cell!.textLabel!.font=UIFont.systemFont(ofSize: 15)
                cell!.textLabel!.textColor=UIColor.red
            }
            cell!.accessoryType=UITableViewCellAccessoryType.disclosureIndicator
            break
        case 2:
            let name=UILabel(frame:CGRect(x: 15,y: 15,width: 70,height: 20))
            name.textColor=UIColor.textColor()
            name.font=UIFont.systemFont(ofSize: 14)
            cell!.contentView.addSubview(name)
            let nameValue=UILabel(frame:CGRect(x: name.frame.maxX,y: 15,width: 100,height: 20))
            nameValue.font=UIFont.systemFont(ofSize: 14)
            nameValue.textColor=UIColor.red
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
                    cell!.detailTextLabel!.font=UIFont.systemFont(ofSize: 14)
                    cell!.detailTextLabel!.text=self.buyerRemark
                }
                cell!.accessoryType=UITableViewCellAccessoryType.disclosureIndicator
                break
            case 3:
                name.text="代金券:"
                cell!.detailTextLabel!.font=UIFont.systemFont(ofSize: 14)
                cell!.accessoryType=UITableViewCellAccessoryType.disclosureIndicator
                if vouchersEntity == nil{
                    cell!.detailTextLabel!.text="满\(cashcouponLowerLimitOfUse)元可以使用代金券"
                }else{
                    cell!.detailTextLabel!.text="满\(cashcouponLowerLimitOfUse)立减\(vouchersEntity!.cashCouponAmountOfMoney!)元"
                }
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    //返回tabview的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        switch section{
            case 0:
                return 1
            case 1:
                return 1
            case 2:
                if cashcouponStatu == 1{
                    return 4
                }else{
                    return 3
                }
            default:
                break
        }
        return 0
    }
    //返回tabview的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //取消选中的样式
        tableView.deselectRow(at: indexPath, animated: true);
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
            case 3:
                if self.totalPirce! >= Double(cashcouponLowerLimitOfUse){
                    let vc=VouchersViewController()
                    vc.flag=1
                    vc.vouchersEntity={ (entity) in
                        self.vouchersEntity=entity
                        let price=self.totalPirce!-Double(entity.cashCouponAmountOfMoney!)
                        self.lblTotalPrice!.text="总价 : ￥\(price)(立省\(entity.cashCouponAmountOfMoney!)元)"
                    }
                    self.navigationController?.pushViewController(vc, animated:true)
                }else{
                    SVProgressHUD.showInfo(withStatus: "订单金额要满\(cashcouponLowerLimitOfUse)元才能使用代金券")
                }
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
    @objc func updateRemark(_ obj:Notification){
        var str=obj.object as? String
        if str == nil || str == ""{
            str=nil
        }
        self.buyerRemark=str
        self.table?.reloadData()
    }
}
