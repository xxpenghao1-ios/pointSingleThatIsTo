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
import SwiftyJSON
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
    var province=UserDefaults.standard.object(forKey: "province") as! String;
    /// 市
    var city=UserDefaults.standard.object(forKey: "city") as! String;
    /// 区
    var county=UserDefaults.standard.object(forKey: "county") as! String;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if addressFlag == 1{
            self.title="修改收货地址"
        }else{
            self.title="添加收货地址"
        }
        self.view.backgroundColor=UIColor.white
        table=UITableView(frame:CGRect(x: 0,y:navHeight,width:boundsWidth,height: 270), style: UITableViewStyle.plain)
        table!.dataSource=self
        table!.delegate=self
        table!.isScrollEnabled=false
        self.view.addSubview(table!)
        
        //设置cell下边线全屏
        table?.layoutMargins=UIEdgeInsets.zero
        table?.separatorInset=UIEdgeInsets.zero;
        //移除空单元格
        table!.tableFooterView = UIView(frame:CGRect.zero)
        self.automaticallyAdjustsScrollViewInsets = false
        
        let btnSubmit=UIButton(frame:CGRect(x: 30,y: table!.frame.maxY+30,width: boundsWidth-60,height: 40))
        btnSubmit.backgroundColor=UIColor.applicationMainColor()
        btnSubmit.layer.cornerRadius=20
        btnSubmit.setTitle("提交", for: UIControlState())
        btnSubmit.addTarget(self, action:#selector(submit), for: UIControlEvents.touchUpInside)
        btnSubmit.titleLabel!.font=UIFont.systemFont(ofSize: 16)
        btnSubmit.setTitleColor(UIColor.white, for: UIControlState())
        self.view.addSubview(btnSubmit)
        
        //接收地区选择的通知
        NotificationCenter.default.addObserver(self, selector:#selector(updateAddress), name: NSNotification.Name(rawValue: "postUpdateAddress"), object: nil)
        
    }
    /**
     实现地区选择协议
     
     - parameter str: 选中的省市区
     */
    @objc func updateAddress(_ obj:Notification) {
        let myAddress=obj.object as? String
        let addressArr=myAddress!.components(separatedBy: "-")
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
    @objc func submit(_ sender:UIButton){
            let storeId=UserDefaults.standard.object(forKey: "storeId") as! String
            let shippName=txtName!.text
            let detailAddress=txtDetailAddress!.text
            let phoneNumber=txtPhone!.text
            if shippName == nil || shippName!.count == 0{
                SVProgressHUD.showInfo(withStatus: "收货人名称不能为空")
            }else if detailAddress == nil || detailAddress!.count == 0{
                SVProgressHUD.showInfo(withStatus: "详细地址不能为空")
            }else if phoneNumber == nil || phoneNumber!.count == 0{
                SVProgressHUD.showInfo(withStatus: "手机号码不能为空")
            }else{
                if phoneNumber!.count != 11{
                    SVProgressHUD.showInfo(withStatus: "请输入正确的手机号码")
                }else{

                    self.showSVProgressHUD(status:"正在加载...", type: HUD.textClear)
                    if addressFlag == 1{//修改
                        if mySwitch!.isOn{//如果开关按钮打开
                            entity!.defaultFlag=1
                        }else{
                            entity!.defaultFlag=2
                        }
                        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.updateStoreShippAddressforAndroid(flag: entity!.defaultFlag!, storeId: storeId, county: entity!.county!, city: entity!.city!, province: entity!.province!, shippName: shippName!, detailAddress: detailAddress!, phoneNumber: phoneNumber!, IPhonePenghao: 520, shippAddressId: entity!.shippAddressId!), successClosure: { (result) -> Void in
                            let json=JSON(result)
                            let success=json["success"].stringValue
                            SVProgressHUD.dismiss()
                            if success == "success"{
                                SVProgressHUD.showSuccess(withStatus: "修改成功")
                                self.popView()
                            }else{
                                SVProgressHUD.showError(withStatus: "修改失败")
                            }
                            }, failClosure: { (errorMsg) -> Void in
                                SVProgressHUD.showError(withStatus: errorMsg)
                        })
                    }else{//添加收货地址
                        var defaultFlag=2
                        if mySwitch!.isOn{//如果开关按钮打开
                            defaultFlag=1
                        }
                        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.addStoreShippAddressforAndroid(flag: defaultFlag, storeId: storeId, county: county, city: city, province: province, shippName: shippName!, detailAddress: detailAddress!, phoneNumber: phoneNumber!, IPhonePenghao: 520), successClosure: { (result) -> Void in
                            let json=JSON(result)
                            let success=json["success"].stringValue
                            SVProgressHUD.dismiss()
                            if success == "success"{
                                SVProgressHUD.showSuccess(withStatus: "修改成功")
                                self.popView()
                            }else{
                                SVProgressHUD.showError(withStatus: "修改失败")
                            }
                            }, failClosure: { (errorMsg) -> Void in
                                SVProgressHUD.showError(withStatus: errorMsg)
                        })
                    }
                }
            }
    }
    /**
     返回上一页面
     */
    func popView(){
        //发送通知
        NotificationCenter.default.post(name: Notification.Name(rawValue: "updateViewNotification"), object:nil)
        self.navigationController!.popViewController(animated: true)
    }
    //展示每个cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId="cellid"
        var cell=tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil{
            cell=UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:cellId)
        }
        cell!.selectionStyle=UITableViewCellSelectionStyle.none;
        //设置cell下边线全屏
        cell?.layoutMargins=UIEdgeInsets.zero
        cell?.separatorInset=UIEdgeInsets.zero;
        switch indexPath.section{
        case 0:
            switch indexPath.row{
            case 0:
                txtName=UITextField(frame:CGRect(x: 15,y: 5,width: boundsWidth-30,height: 40))
                txtName!.placeholder="请输入收货人姓名"
                txtName!.textColor=UIColor.textColor()
                //不为空，且在编辑状态时（及获得焦点）显示清空按钮
                txtName!.clearButtonMode=UITextFieldViewMode.whileEditing;
                if addressFlag == 1{
                    txtName!.text=entity?.shippName
                }
                cell!.contentView.addSubview(txtName!)
                break
            case 1:
                lblAddress=UILabel(frame:CGRect(x: 15,y: 5,width: boundsWidth-30,height: 40))
                lblAddress!.textColor=UIColor.textColor()
                
                if addressFlag == 1{
                    lblAddress!.text=entity!.province!+entity!.city!+entity!.county!
                }else{
                    lblAddress!.text=province+city+county
                }
                cell!.contentView.addSubview(lblAddress!)
                cell!.accessoryType=UITableViewCellAccessoryType.disclosureIndicator
                break
            case 2:
                txtDetailAddress=UITextField(frame:CGRect(x: 15,y: 5,width: boundsWidth-30,height: 40))
                txtDetailAddress!.placeholder="请输入详细地址"
                txtDetailAddress!.textColor=UIColor.textColor()
                //不为空，且在编辑状态时（及获得焦点）显示清空按钮
                txtDetailAddress!.clearButtonMode=UITextFieldViewMode.whileEditing;
                if addressFlag == 1{
                    txtDetailAddress!.text=entity!.detailAddress
                }
                cell!.contentView.addSubview(txtDetailAddress!)
                break
            case 3:
                txtPhone=UITextField(frame:CGRect(x: 15,y: 5,width: boundsWidth-30,height: 40))
                txtPhone!.placeholder="请输入手机号码"
                txtPhone!.textColor=UIColor.textColor()
                txtPhone!.keyboardType=UIKeyboardType.phonePad
                //不为空，且在编辑状态时（及获得焦点）显示清空按钮
                txtPhone!.clearButtonMode=UITextFieldViewMode.whileEditing;
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
            let lblName=UILabel(frame:CGRect(x: 15,y: 15,width: 200,height: 20))
            lblName.text="是否设为默认地址"
            lblName.textColor=UIColor.textColor()
            lblName.font=UIFont.systemFont(ofSize: 16)
            cell!.contentView.addSubview(lblName)
            
            mySwitch=UISwitch(frame:CGRect(x: boundsWidth-65,y: 12.5,width: 50,height: 25))
            if addressFlag == 1{//如果是修改页面过来的
                if entity!.defaultFlag == 1{//判断是否是默认地址
                    mySwitch!.isOn=true
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
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view=UIView(frame:CGRect.zero)
        view.backgroundColor=UIColor.viewBackgroundColor()
        return view
    }
    //给每个分组的尾部设置10高度
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    //返回tabview的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0{
            return 4
        }else{
            return 1
        }
    }
    //返回tabview的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.section == 0{
            return 50
        }else{
            return 50
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            if indexPath.row == 1{
                let vc=ShowAddressViewController()
                let nav=UINavigationController(rootViewController:vc)
                self.present(nav, animated:true, completion:nil)
            }
        }
    }
    //点击view区域收起键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
