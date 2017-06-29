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
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated:true)
    }
    override func viewDidLoad() {
        super.viewDidLoad();
        self.view.backgroundColor=UIColor.whiteColor()
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
        txtName!.textColor=UIColor.whiteColor()
        txtName!.layer.borderWidth=1
        txtName!.layer.borderColor=UIColor.whiteColor().CGColor
        txtName!.layer.cornerRadius=5
        txtName!.attributedPlaceholder=NSAttributedString(string:"请输入账号", attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        txtName!.adjustsFontSizeToFitWidth=true;
        txtName!.tintColor=UIColor.whiteColor()
        txtName!.keyboardType=UIKeyboardType.Default;
        txtName!.font=UIFont.systemFontOfSize(14)
        //不为空，且在编辑状态时（及获得焦点）显示清空按钮
        txtName!.clearButtonMode=UITextFieldViewMode.WhileEditing;
        //左视图
        let txtNameLeft=UIView(frame:CGRectMake(0,0,40,40))
        let txtNameLeftImg=UIImageView(frame:CGRectMake(10,7.5,25,25))
        txtNameLeftImg.image=UIImage(named: "memberName")
        txtNameLeft.addSubview(txtNameLeftImg)
        txtName!.leftView=txtNameLeft
        txtName!.leftViewMode=UITextFieldViewMode.Always;
        //获取缓存中的用户名
        let name=userDefaults.objectForKey("memberName") as? String
        if name != nil{
            txtName!.text=name!;
        }

        //设置密码输入框
        txtPassword!.textColor=UIColor.whiteColor()
        txtPassword!.layer.borderWidth=1
        txtPassword!.layer.borderColor=UIColor.whiteColor().CGColor
        txtPassword!.layer.cornerRadius=5
        txtPassword!.font=UIFont.systemFontOfSize(14)
        txtPassword!.attributedPlaceholder=NSAttributedString(string:"请输入密码", attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        txtPassword!.adjustsFontSizeToFitWidth=true;
        txtPassword!.tintColor=UIColor.whiteColor()
        txtPassword!.secureTextEntry=true
        txtPassword!.keyboardType=UIKeyboardType.Default;
        txtPassword!.delegate=self
        //不为空，且在编辑状态时（及获得焦点）显示清空按钮
        txtPassword!.clearButtonMode=UITextFieldViewMode.WhileEditing;
        //左视图
        let txtPasswordLeft=UIView(frame:CGRectMake(0,0,40,40))
        let txtPasswordLeftImg=UIImageView(frame:CGRectMake(10,7.5,25,25))
        txtPasswordLeftImg.image=UIImage(named: "password")
        txtPasswordLeft.addSubview(txtPasswordLeftImg)
        txtPassword!.leftView=txtPasswordLeft
        txtPassword!.leftViewMode=UITextFieldViewMode.Always;
        txtPassword!.addTarget(self, action:"textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        //设置登录按钮
        btnLogin!.layer.cornerRadius=5
        btnLogin!.layer.borderWidth=1
        btnLogin!.disable()
        btnLogin!.layer.borderColor=UIColor.whiteColor().CGColor
        btnLogin!.setTitle("登录", forState: UIControlState.Normal)
        btnLogin!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btnLogin!.titleLabel!.font=UIFont.systemFontOfSize(16)
        btnLogin!.addTarget(self, action:"loginSubmit:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        //设置忘记密码可以有点击事件
        lblForgotPassword!.text="忘记密码?"
        lblForgotPassword!.textColor=UIColor.whiteColor()
        lblForgotPassword!.font=UIFont.systemFontOfSize(14)
        lblForgotPassword!.textAlignment = .Right
        lblForgotPassword!.userInteractionEnabled=true
        lblForgotPassword!.addGestureRecognizer(UITapGestureRecognizer(target:self, action:"pushForgotPassword"))
        
        //设置立即注册可以有点击事件
        lblRegister!.text="立即注册"
        lblRegister!.textColor=UIColor.whiteColor()
        lblRegister!.font=UIFont.systemFontOfSize(14)
        lblRegister!.textAlignment = .Left
        lblRegister!.userInteractionEnabled=true
        lblRegister!.addGestureRecognizer(UITapGestureRecognizer(target:self, action:"pushRegisterView"))

    }
    //跳转到找回密码页面
    func pushForgotPassword(){
        let vc=RegisterViewController();
        vc.flag=2;
        self.navigationController?.pushViewController(vc, animated:true);
    }
    //跳转到注册页面
    func pushRegisterView(){
        SVProgressHUD.showInfoWithStatus("请去平台官网http://www.hnzltx.com联系客服注册")
    }
    /**
     登录
     
     - parameter sender: UIButton
     */
    func loginSubmit(sender: UIButton) {
        //拿到输入框的用户名
        let name=txtName!.text
        //拿到输入框的密码
        let password=txtPassword!.text
        if name == nil || name == ""{
            SVProgressHUD.showInfoWithStatus("请输入用户名")
            txtName!.becomeFirstResponder()
            sender.enable()
            return
        }else if password == nil||password == ""{
            SVProgressHUD.showInfoWithStatus("请输入密码")
            txtPassword!.becomeFirstResponder()
            sender.enable()
            return
        }else{
            /// 获取缓存中的唯一表示
            var str=NSUserDefaults.standardUserDefaults().objectForKey("deviceToken") as? String
            if str == nil{//如果为空 直接付默认值
                str="penghao"
            }
            if IJReachability.isConnectedToNetwork(){//判断有无网络
                if name == "ddjd" && password == "ddjd888888"{//跳转到业务员登录
                    let vc=storyboardPushView("SalesmanLoginId") as! SalesmanLoginViewController
                    self.navigationController!.pushViewController(vc, animated: true)
                }else{
                    SVProgressHUD.showWithStatus("正在登陆",maskType: SVProgressHUDMaskType.Gradient)
                    NSLog("开始验证发送网络请求验证用户信息")
                    PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.login(memberName:name!, password:password!, deviceToken:str!, deviceName:UIDevice().name,flag:1), successClosure: { (result) -> Void in
                        let json=JSON(result)
                        let success=json["success"].stringValue
                        if success == "failds"{
                            SVProgressHUD.showErrorWithStatus("店铺信息不存在")
                        }else if success == "loginNull"{
                            SVProgressHUD.showErrorWithStatus("该账号不是店铺")
                        }else if success == "isexist"{
                            SVProgressHUD.showErrorWithStatus("账号或密码错误")
                        }else if success == "success"{//返回成功 保存登录信息
                            SVProgressHUD.showSuccessWithStatus("登陆成功")
                            let entity=Mapper<StoreEntity>().map(json.object)
                            //保存店铺id
                            userDefaults.setObject(entity!.storeId, forKey:"storeId")
                            //保存会员id
                            userDefaults.setObject(entity!.memberId, forKey:"memberId")
                            //保存县区id
                            userDefaults.setObject(entity!.countyId, forKey:"countyId")
                            //保存省市区
                            userDefaults.setObject(entity!.province!+entity!.city!+entity!.county!, forKey:"address")
                            //保存省
                            userDefaults.setObject(entity!.province!, forKey:"province")
                            //保存市
                            userDefaults.setObject(entity!.city!, forKey:"city")
                            //保存区
                            userDefaults.setObject(entity!.county!, forKey:"county")
                            //保存分站id
                            userDefaults.setObject(entity!.substationId, forKey:"substationId")
                            //保存用户名
                            userDefaults.setObject(name, forKey:"memberName")
                            //保存店铺唯一标识码
                            userDefaults.setObject(entity!.storeFlagCode, forKey:"storeFlagCode")
                            //保存店铺名称
                            userDefaults.setObject(entity!.storeName, forKey:"storeName")
                            //保存分站客服号码
                            userDefaults.setObject(entity!.subStationPhoneNumber, forKey:"subStationPhoneNumber")
                            //保存店铺二维码
                            userDefaults.setObject(entity!.qrcode, forKey:"qrcode")
                            NSLog("店铺唯一标识码--\(entity!.storeFlagCode)")
                            NSLog("店铺ID--\(entity!.storeId)")
                            NSLog("分站ID--\(entity!.substationId)")
                            //写入磁盘
                            userDefaults.synchronize()
                            //登录成功设置应用程序别名
                            JPUSHService.setAlias(entity!.storeFlagCode!, callbackSelector: nil, object:nil)
                            JPUSHService.setTags([entity!.substationId!], callbackSelector:nil, object:nil)
                            //登录成功跳转到首页
                            let app=UIApplication.sharedApplication().delegate as! AppDelegate
                            
                            app.tab=TabBarViewController()
                            
                            self.txtPassword!.text=""
                            app.window?.rootViewController=app.tab                               //登录成功自动收起键盘
                            self.view.endEditing(true)
                            
                        }else{
                            SVProgressHUD.showErrorWithStatus("登陆失败")
                        }
                        
                        }, failClosure: { (errorMsg) -> Void in
                            SVProgressHUD.showErrorWithStatus(errorMsg)
                    })
                    
                }
                
            }else{
                SVProgressHUD.showInfoWithStatus("无网络连接")
            }
        }
        sender.enable()
        
    }
    //点击view区域收起键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}
extension LoginViewController:UITextFieldDelegate{
    //监听密码框输入
    func textFieldDidChange(textField:UITextField){
        if textField.text != nil && textField.text != ""{
            btnLogin!.enable()
        }else{
            btnLogin!.disable()
        }
    }
}
