//
//  UpdateAndAddShippingAddressViewController.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/2/25.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import SVProgressHUD
/// 修改 添加收货地址页面
class UpdateAndAddShippingAddressViewController:BaseViewController,UITableViewDelegate,UITableViewDataSource{
    
    /// 1表示修改收货 2表示添加收货地址
    var addressFlag:Int?
    
    /// 接收传入的地址entity(修改的时候传)
    var entity:AddressEntity?
    
    /// table
    var table:UITableView?
    
    /// 收货人姓名
    var txtName:UITextField?
    
    /// 省市区
    var lblAddress:UILabel?
    
    /// 详细地址
    var txtDetailAddress:UITextField?
    
    /// 电话号码
    var txtPhone:UITextField?
    
    /// 设为默认地址开关按钮
    var mySwitch:UISwitch?
    
    /// 省
    var province=NSUserDefaults.standardUserDefaults().objectForKey("province") as! String;
    /// 市
    var city=NSUserDefaults.standardUserDefaults().objectForKey("city") as! String;
    /// 区
    var county=NSUserDefaults.standardUserDefaults().objectForKey("county") as! String;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if addressFlag == 1{
            self.title="修改收货地址"
        }else{
            self.title="添加收货地址"
        }
        self.view.backgroundColor=UIColor.whiteColor()
        table=UITableView(frame:CGRectMake(0,64,boundsWidth,270), style: UITableViewStyle.Plain)
        table!.dataSource=self
        table!.delegate=self
        table!.scrollEnabled=false
        self.view.addSubview(table!)
        
        //设置cell下边线全屏
        table?.layoutMargins=UIEdgeInsetsZero
        table?.separatorInset=UIEdgeInsetsZero;
        //移除空单元格
        table!.tableFooterView = UIView(frame:CGRectZero)
        self.automaticallyAdjustsScrollViewInsets = false
        
        let btnSubmit=UIButton(frame:CGRectMake(30,CGRectGetMaxY(table!.frame)+30,boundsWidth-60,40))
        btnSubmit.backgroundColor=UIColor.applicationMainColor()
        btnSubmit.layer.cornerRadius=20
        btnSubmit.setTitle("提交", forState: UIControlState.Normal)
        btnSubmit.addTarget(self, action:"submit:", forControlEvents: UIControlEvents.TouchUpInside)
        btnSubmit.titleLabel!.font=UIFont.systemFontOfSize(16)
        btnSubmit.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.view.addSubview(btnSubmit)
        
        //接收地区选择的通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateAddress:", name: "postUpdateAddress", object: nil)
        

        
    }
    /**
     实现地区选择协议
     
     - parameter str: 选中的省市区
     */
    func updateAddress(obj:NSNotification) {
        let myAddress=obj.object as? String
        let addressArr=myAddress!.componentsSeparatedByString("-")
        province=addressArr[0]
        city=addressArr[1]
        county=addressArr[2]
        if addressFlag == 1{
            entity?.province=province
            entity?.city=city
            entity?.county=county
        }
        lblAddress!.text=province+city+county
    }
    /**
     提交
     
     - parameter sender: UIButton
     */
    func submit(sender:UIButton){
        if IJReachability.isConnectedToNetwork(){
            let storeId=NSUserDefaults.standardUserDefaults().objectForKey("storeId") as! String
            let shippName=txtName!.text
            let detailAddress=txtDetailAddress!.text
            let phoneNumber=txtPhone!.text
            if shippName == nil || shippName!.characters.count == 0{
                SVProgressHUD.showInfoWithStatus("收货人名称不能为空")
            }else if detailAddress == nil || detailAddress!.characters.count == 0{
               SVProgressHUD.showInfoWithStatus("详细地址不能为空")
            }else if phoneNumber == nil || phoneNumber!.characters.count == 0{
                SVProgressHUD.showInfoWithStatus("手机号码不能为空")
            }else{
                if phoneNumber!.characters.count != 11{
                    SVProgressHUD.showInfoWithStatus("请输入正确的手机号码")
                }else{
                    SVProgressHUD.showWithStatus("数据加载中", maskType: .Clear)
                    if addressFlag == 1{//修改
                        if mySwitch!.on{//如果开关按钮打开
                            entity!.defaultFlag=1
                        }else{
                            entity!.defaultFlag=2
                        }
                        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.updateStoreShippAddressforAndroid(flag: entity!.defaultFlag!, storeId: storeId, county: entity!.county!, city: entity!.city!, province: entity!.province!, shippName: shippName!, detailAddress: detailAddress!, phoneNumber: phoneNumber!, IPhonePenghao: 520, shippAddressId: entity!.shippAddressId!), successClosure: { (result) -> Void in
                            let json=JSON(result)
                            let success=json["success"].stringValue
                            SVProgressHUD.dismiss()
                            if success == "success"{
                                SVProgressHUD.showSuccessWithStatus("修改成功")
                                self.popView()
                            }else{
                                SVProgressHUD.showErrorWithStatus("修改失败")
                            }
                            }, failClosure: { (errorMsg) -> Void in
                                SVProgressHUD.showErrorWithStatus(errorMsg)
                        })
                    }else{//添加收货地址
                        var defaultFlag=2
                        if mySwitch!.on{//如果开关按钮打开
                            defaultFlag=1
                        }
                        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.addStoreShippAddressforAndroid(flag: defaultFlag, storeId: storeId, county: county, city: city, province: province, shippName: shippName!, detailAddress: detailAddress!, phoneNumber: phoneNumber!, IPhonePenghao: 520), successClosure: { (result) -> Void in
                            let json=JSON(result)
                            let success=json["success"].stringValue
                            SVProgressHUD.dismiss()
                            if success == "success"{
                                SVProgressHUD.showSuccessWithStatus("修改成功")
                                self.popView()
                            }else{
                                SVProgressHUD.showErrorWithStatus("修改失败")
                            }
                            }, failClosure: { (errorMsg) -> Void in
                                SVProgressHUD.showErrorWithStatus(errorMsg)
                        })
                    }
                }
            }
        }else{
            SVProgressHUD.showErrorWithStatus("无网络连接")
        }
    }
    /**
     返回上一页面
     */
    func popView(){
        //发送通知
        NSNotificationCenter.defaultCenter().postNotificationName("updateViewNotification", object:nil)
        self.navigationController!.popViewControllerAnimated(true)
    }
    //展示每个cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId="cellid"
        var cell=tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil{
            cell=UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier:cellId)
        }
        cell!.selectionStyle=UITableViewCellSelectionStyle.None;
        //设置cell下边线全屏
        cell?.layoutMargins=UIEdgeInsetsZero
        cell?.separatorInset=UIEdgeInsetsZero;
        switch indexPath.section{
        case 0:
            switch indexPath.row{
            case 0:
                txtName=UITextField(frame:CGRectMake(15,5,boundsWidth-30,40))
                txtName!.placeholder="请输入收货人姓名"
                txtName!.textColor=UIColor.textColor()
                //不为空，且在编辑状态时（及获得焦点）显示清空按钮
                txtName!.clearButtonMode=UITextFieldViewMode.WhileEditing;
                if addressFlag == 1{
                    txtName!.text=entity?.shippName
                }
                cell!.contentView.addSubview(txtName!)
                break
            case 1:
                lblAddress=UILabel(frame:CGRectMake(15,5,boundsWidth-30,40))
                lblAddress!.textColor=UIColor.textColor()
                
                if addressFlag == 1{
                    lblAddress!.text=entity!.province!+entity!.city!+entity!.county!
                }else{
                    lblAddress!.text=province+city+county
                }
                cell!.contentView.addSubview(lblAddress!)
                cell!.accessoryType=UITableViewCellAccessoryType.DisclosureIndicator
                break
            case 2:
                txtDetailAddress=UITextField(frame:CGRectMake(15,5,boundsWidth-30,40))
                txtDetailAddress!.placeholder="请输入详细地址"
                txtDetailAddress!.textColor=UIColor.textColor()
                //不为空，且在编辑状态时（及获得焦点）显示清空按钮
                txtDetailAddress!.clearButtonMode=UITextFieldViewMode.WhileEditing;
                if addressFlag == 1{
                    txtDetailAddress!.text=entity!.detailAddress
                }
                cell!.contentView.addSubview(txtDetailAddress!)
                break
            case 3:
                txtPhone=UITextField(frame:CGRectMake(15,5,boundsWidth-30,40))
                txtPhone!.placeholder="请输入手机号码"
                txtPhone!.textColor=UIColor.textColor()
                txtPhone!.keyboardType=UIKeyboardType.PhonePad
                //不为空，且在编辑状态时（及获得焦点）显示清空按钮
                txtPhone!.clearButtonMode=UITextFieldViewMode.WhileEditing;
                if addressFlag == 1{
                    txtPhone!.text=entity!.phoneNumber
                }
                cell!.contentView.addSubview(txtPhone!)
                break
            default:
                break
            }
            break
        case 1:
            let lblName=UILabel(frame:CGRectMake(15,15,200,20))
            lblName.text="是否设为默认地址"
            lblName.textColor=UIColor.textColor()
            lblName.font=UIFont.systemFontOfSize(16)
            cell!.contentView.addSubview(lblName)
            
            mySwitch=UISwitch(frame:CGRectMake(boundsWidth-65,12.5,50,25))
            if addressFlag == 1{//如果是修改页面过来的
                if entity!.defaultFlag == 1{//判断是否是默认地址
                    mySwitch!.on=true
                }
            }
            cell!.contentView.addSubview(mySwitch!)
            break
        default:
            break
            
        }
        return cell!
    }
    
    //给每个组的尾部添加视图
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view=UIView(frame:CGRectZero)
        view.backgroundColor=UIColor.viewBackgroundColor()
        return view
    }
    //给每个分组的尾部设置10高度
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    //返回tabview的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0{
            return 4
        }else{
            return 1
        }
    }
    //返回tabview的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if indexPath.section == 0{
            return 50
        }else{
            return 50
        }
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0{
            if indexPath.row == 1{
                let vc=ShowAddressViewController()
                let nav=UINavigationController(rootViewController:vc)
                self.presentViewController(nav, animated:true, completion:nil)
            }
        }
    }
    //点击view区域收起键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}