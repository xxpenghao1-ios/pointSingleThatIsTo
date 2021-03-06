//
//  loginViewController.swift
//  kxkg
//
//  Created by hefeiyue on 15/3/18.
//  Copyright (c) 2015年 奈文魔尔. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import ObjectMapper
import SVProgressHUD
import SnapKit
import SwiftyJSON
///登录页面
class LoginViewController:BaseViewController{
    
    //图片log
    var imgLog:UIImageView?
    
    //账号
    var txtName: UITextField?
    
    //密码
    var txtPassword: UITextField?
    
    //登录按钮
    var btnLogin: UIButton?
    
    //忘记密码
    var lblForgotPassword: UILabel?
    
    //立即注册
    var lblRegister: UILabel?
    
    //背景图片
    var bacImgView:UIImageView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated:true)
    }
    override func viewDidLoad() {
        super.viewDidLoad();
        self.view.backgroundColor=UIColor.white
        buildView()
    }
    /**
     构建页面
     */
    func buildView(){
        bacImgView=UIImageView()
        bacImgView!.image=UIImage(named: "log_bac")
        self.view.addSubview(bacImgView!)
        imgLog=UIImageView()
        imgLog!.image=UIImage(named: "new_logo")
        self.view.addSubview(imgLog!)
        txtName=UITextField()
        self.view.addSubview(txtName!)
        txtPassword=UITextField()
        self.view.addSubview(txtPassword!)
        btnLogin=UIButton()
        self.view.addSubview(btnLogin!)
        lblForgotPassword=UILabel()
        self.view.addSubview(lblForgotPassword!)
        lblRegister=UILabel()
        self.view.addSubview(lblRegister!)
        bacImgView!.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
        imgLog!.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(202)
            make.height.equalTo(47)
            make.left.equalTo((boundsWidth-202)/2)
            make.top.equalTo(100)
        }
        txtName!.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(250)
            make.height.equalTo(40)
            make.left.equalTo(((boundsWidth-250)/2))
            make.top.equalTo(imgLog!.snp_bottom).offset(40)
        }
        txtPassword!.snp_makeConstraints { (make) -> Void in
            make.width.height.left.equalTo(txtName!)
            make.top.equalTo(txtName!.snp_bottom).offset(15)
            
        }
        btnLogin!.snp_makeConstraints { (make) -> Void in
            make.width.height.left.equalTo(txtName!)
            make.top.equalTo(txtPassword!.snp_bottom).offset(30)
        }
        lblRegister!.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(125)
            make.height.equalTo(20)
            make.left.equalTo(btnLogin!.snp_left)
            make.top.equalTo(btnLogin!.snp_bottom).offset(10)
        }
        lblForgotPassword!.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(125)
            make.height.equalTo(20)
            make.left.equalTo(lblRegister!.snp_right)
            make.top.equalTo(btnLogin!.snp_bottom).offset(10)
        }

        //设置账号输入框
        txtName!.textColor=UIColor.white
        txtName!.layer.borderWidth=1
        txtName!.layer.borderColor=UIColor.white.cgColor
        txtName!.layer.cornerRadius=5
        txtName!.attributedPlaceholder=NSAttributedString(string:"请输入账号", attributes: [NSAttributedStringKey.foregroundColor:UIColor.white])
        txtName!.adjustsFontSizeToFitWidth=true;
        txtName!.tintColor=UIColor.white
        txtName!.keyboardType=UIKeyboardType.default;
        txtName!.font=UIFont.systemFont(ofSize: 14)
        //不为空，且在编辑状态时（及获得焦点）显示清空按钮
        txtName!.clearButtonMode=UITextFieldViewMode.whileEditing;
        //左视图
        let txtNameLeft=UIView(frame:CGRect(x: 0,y: 0,width: 40,height: 40))
        let txtNameLeftImg=UIImageView(frame:CGRect(x: 10,y: 7.5,width: 25,height: 25))
        txtNameLeftImg.image=UIImage(named: "memberName")
        txtNameLeft.addSubview(txtNameLeftImg)
        txtName!.leftView=txtNameLeft
        txtName!.leftViewMode=UITextFieldViewMode.always;
        //获取缓存中的用户名
        let name=userDefaults.object(forKey: "memberName") as? String
        if name != nil{
            txtName!.text=name!;
        }

        //设置密码输入框
        txtPassword!.textColor=UIColor.white
        txtPassword!.layer.borderWidth=1
        txtPassword!.layer.borderColor=UIColor.white.cgColor
        txtPassword!.layer.cornerRadius=5
        txtPassword!.font=UIFont.systemFont(ofSize: 14)
        txtPassword!.attributedPlaceholder=NSAttributedString(string:"请输入密码", attributes:[NSAttributedStringKey.foregroundColor:UIColor.white])
        txtPassword!.adjustsFontSizeToFitWidth=true;
        txtPassword!.tintColor=UIColor.white
        txtPassword!.isSecureTextEntry=true
        txtPassword!.keyboardType=UIKeyboardType.default;
        txtPassword!.delegate=self
        //不为空，且在编辑状态时（及获得焦点）显示清空按钮
        txtPassword!.clearButtonMode=UITextFieldViewMode.whileEditing;
        //左视图
        let txtPasswordLeft=UIView(frame:CGRect(x: 0,y: 0,width: 40,height: 40))
        let txtPasswordLeftImg=UIImageView(frame:CGRect(x: 10,y: 7.5,width: 25,height: 25))
        txtPasswordLeftImg.image=UIImage(named: "password")
        txtPasswordLeft.addSubview(txtPasswordLeftImg)
        txtPassword!.leftView=txtPasswordLeft
        txtPassword!.leftViewMode=UITextFieldViewMode.always;
        txtPassword!.addTarget(self, action:#selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        //设置登录按钮
        btnLogin!.layer.cornerRadius=5
        btnLogin!.layer.borderWidth=1
        btnLogin!.disable()
        btnLogin!.layer.borderColor=UIColor.white.cgColor
        btnLogin!.setTitle("登录", for: UIControlState())
        btnLogin!.setTitleColor(UIColor.white, for: UIControlState())
        btnLogin!.titleLabel!.font=UIFont.systemFont(ofSize: 16)
        btnLogin!.addTarget(self, action:#selector(loginSubmit), for: UIControlEvents.touchUpInside)
        
        
        //设置忘记密码可以有点击事件
        lblForgotPassword!.text="忘记密码?"
        lblForgotPassword!.textColor=UIColor.white
        lblForgotPassword!.font=UIFont.systemFont(ofSize: 14)
        lblForgotPassword!.textAlignment = .right
        lblForgotPassword!.isUserInteractionEnabled=true
        lblForgotPassword!.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(pushForgotPassword)))
        
        //设置立即注册可以有点击事件
        lblRegister!.text="立即注册"
        lblRegister!.textColor=UIColor.white
        lblRegister!.font=UIFont.systemFont(ofSize: 14)
        lblRegister!.textAlignment = .left
        lblRegister!.isUserInteractionEnabled=true
        lblRegister!.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(pushRegisterView)))

    }
    //跳转到找回密码页面
    @objc func pushForgotPassword(){
        let vc=RegisterViewController();
        vc.flag=2;
        self.navigationController?.pushViewController(vc, animated:true);
    }
    //跳转到注册页面
    @objc func pushRegisterView(){
        SVProgressHUD.showInfo(withStatus: "请去平台官网http://www.hnzltx.com联系客服注册")
    }
    /**
     登录
     
     - parameter sender: UIButton
     */
    @objc func loginSubmit(_ sender: UIButton) {
        //拿到输入框的用户名
        let name=txtName!.text
        //拿到输入框的密码
        let password=txtPassword!.text
        if name == nil || name == ""{
            SVProgressHUD.showInfo(withStatus: "请输入用户名")
            txtName!.becomeFirstResponder()
            sender.enable()
            return
        }else if password == nil||password == ""{
            SVProgressHUD.showInfo(withStatus: "请输入密码")
            txtPassword!.becomeFirstResponder()
            sender.enable()
            return
        }else{
            /// 获取缓存中的唯一表示
            var str=UserDefaults.standard.object(forKey: "deviceToken") as? String
            if str == nil{//如果为空 直接付默认值
                str="penghao"
            }
                if name == "ddjd" && password == "ddjd888888"{//跳转到业务员登录
                    SVProgressHUD.show(withStatus:"业务员扫街苹果版已经关闭")
                }else{
                    self.showSVProgressHUD(status:"正在登陆", type: HUD.textGradient)
                    NSLog("开始验证发送网络请求验证用户信息")
                    PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.login(memberName:name!, password:password!, deviceToken:str!, deviceName:UIDevice().name,flag:1), successClosure: { (result) -> Void in
                        let json=JSON(result)
                        print(json)
                        let success=json["success"].stringValue
                        if success == "failds"{
                            SVProgressHUD.showError(withStatus: "店铺信息不存在")
                        }else if success == "loginNull"{
                            SVProgressHUD.showError(withStatus: "该账号不是店铺")
                        }else if success == "isexist"{
                            SVProgressHUD.showError(withStatus: "账号或密码错误")
                        }else if success == "success"{//返回成功 保存登录信息
                            SVProgressHUD.showSuccess(withStatus: "登陆成功")
                            let entity=Mapper<StoreEntity>().map(JSONObject:json.object)
                            //保存店铺id
                            userDefaults.set(entity!.storeId, forKey:"storeId")
                            //保存会员id
                            userDefaults.set(entity!.memberId, forKey:"memberId")
                            //保存县区id
                            userDefaults.set(entity!.countyId, forKey:"countyId")
                            //保存省市区
                            userDefaults.set(entity!.province!+entity!.city!+entity!.county!, forKey:"address")
                            //保存省
                            userDefaults.set(entity!.province!, forKey:"province")
                            //保存市
                            userDefaults.set(entity!.city!, forKey:"city")
                            //保存区
                            userDefaults.set(entity!.county!, forKey:"county")
                            //保存分站id
                            userDefaults.set(entity!.substationId, forKey:"substationId")
                            //保存用户名
                            userDefaults.set(name, forKey:"memberName")
                            //保存密码
                            userDefaults.set(password,forKey:"password")
                            //保存店铺唯一标识码
                            userDefaults.set(entity!.storeFlagCode, forKey:"storeFlagCode")
                            //保存店铺名称
                            userDefaults.set(entity!.storeName, forKey:"storeName")
                            //保存分站客服号码
                            userDefaults.set(entity!.subStationPhoneNumber, forKey:"subStationPhoneNumber")
                            //保存店铺二维码
                            userDefaults.set(entity!.qrcode, forKey:"qrcode")
                            NSLog("店铺唯一标识码--\(entity!.storeFlagCode)")
                            NSLog("店铺ID--\(entity!.storeId)")
                            NSLog("分站ID--\(entity!.substationId)")
                            //写入磁盘
                            userDefaults.synchronize()
                            //登录成功设置应用程序别名
                            JPUSHService.setAlias(entity!.storeFlagCode!, completion: nil, seq: 11)
                            JPUSHService.setTags([entity!.substationId!],completion: nil,seq:22)
                            //登录成功跳转到首页
                            let app=UIApplication.shared.delegate as! AppDelegate
                            
                            app.tab=TabBarViewController()
                            
                            self.txtPassword!.text=""
                            app.window?.rootViewController=app.tab                               //登录成功自动收起键盘
                            self.view.endEditing(true)
                            
                        }else{
                            SVProgressHUD.showError(withStatus: "登陆失败")
                        }
                        
                        }, failClosure: { (errorMsg) -> Void in
                            SVProgressHUD.showError(withStatus: errorMsg)
                    })
                    
                }
        }
        sender.enable()
        
    }
    //点击view区域收起键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
extension LoginViewController:UITextFieldDelegate{
    //监听密码框输入
    @objc func textFieldDidChange(_ textField:UITextField){
        if textField.text != nil && textField.text != ""{
            btnLogin!.enable()
        }else{
            btnLogin!.disable()
        }
    }
}
