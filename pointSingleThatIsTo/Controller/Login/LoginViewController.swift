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
///登录页面
class LoginViewController:BaseViewController{
    
    //账号
    @IBOutlet weak var txtName: UITextField!
    
    //密码
    @IBOutlet weak var txtPassword: UITextField!
    
    //登录按钮
    @IBOutlet weak var btnLogin: UIButton!
    
    //忘记密码
    @IBOutlet weak var lblForgotPassword: UILabel!
    
    //立即注册
    @IBOutlet weak var lblRegister: UILabel!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated:true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.view.backgroundColor=UIColor.applicationMainColor()
        buildView()
    }
    /**
     构建页面
     */
    func buildView(){
        //设置账号输入框
        txtName.textColor=UIColor.whiteColor()
        txtName.layer.borderWidth=1
        txtName.layer.borderColor=UIColor.whiteColor().CGColor
        txtName.layer.cornerRadius=20
        txtName.attributedPlaceholder=NSAttributedString(string:"账号", attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        txtName.adjustsFontSizeToFitWidth=true;
        txtName.tintColor=UIColor.whiteColor()
        txtName.keyboardType=UIKeyboardType.Default;
        //不为空，且在编辑状态时（及获得焦点）显示清空按钮
        txtName!.clearButtonMode=UITextFieldViewMode.WhileEditing;
        //左视图
        let txtNameLeft=UIView(frame:CGRectMake(0,0,20,40));
        txtName.leftView=txtNameLeft
        txtName.leftViewMode=UITextFieldViewMode.Always;
        //获取缓存中的用户名
        let name=userDefaults.objectForKey("memberName") as? String
        if name != nil{
            txtName!.text=name!;
        }

        //设置密码输入框
        txtPassword.textColor=UIColor.whiteColor()
        txtPassword.layer.borderWidth=1
        txtPassword.layer.borderColor=UIColor.whiteColor().CGColor
        txtPassword.layer.cornerRadius=20
        txtPassword.attributedPlaceholder=NSAttributedString(string:"密码", attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        txtPassword.adjustsFontSizeToFitWidth=true;
        txtPassword.tintColor=UIColor.whiteColor()
        txtPassword.keyboardType=UIKeyboardType.Default;
        //不为空，且在编辑状态时（及获得焦点）显示清空按钮
        txtPassword.clearButtonMode=UITextFieldViewMode.WhileEditing;
        //左视图
        let txtPasswordLeft=UIView(frame:CGRectMake(0,0,20,40));
        txtPassword.leftView=txtPasswordLeft
        txtPassword.leftViewMode=UITextFieldViewMode.Always;
        //设置登录按钮
        btnLogin.layer.cornerRadius=20
        
        //设置忘记密码可以有点击事件
        lblForgotPassword.userInteractionEnabled=true
        lblForgotPassword.addGestureRecognizer(UITapGestureRecognizer(target:self, action:"pushForgotPassword"))
        
        //设置立即注册可以有点击事件
        lblRegister.userInteractionEnabled=true
        lblRegister.addGestureRecognizer(UITapGestureRecognizer(target:self, action:"pushRegisterView"))

    }
    //跳转到找回密码页面
    func pushForgotPassword(){
        let vc=RegisterViewController();
        vc.flag=2;
        self.navigationController?.pushViewController(vc, animated:true);
    }
    //跳转到注册页面
    func pushRegisterView(){
        let vc=RegisterViewController();
        vc.flag=1
        self.navigationController?.pushViewController(vc, animated:true);
    }
    /**
     登录
     
     - parameter sender: UIButton
     */
    @IBAction func loginSubmit(sender: UIButton) {
        //拿到输入框的用户名
        let name=txtName.text
        //拿到输入框的密码
        let password=txtPassword.text
        if name == nil || name == ""{
            SVProgressHUD.showInfoWithStatus("请输入用户名")
            txtName.becomeFirstResponder()
            return
        }else if password == nil||password == ""{
            SVProgressHUD.showInfoWithStatus("请输入密码")
            txtPassword.becomeFirstResponder()
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
                    Alamofire.request(.GET,URL+"storeLoginInterface.xhtml", parameters:["memberName":name!,"password":password!,"deviceToken":str!,"deviceName":UIDevice().name,"flag":1], encoding: ParameterEncoding.URL).responseJSON{ response in
                        if response.result.error != nil{
                            SVProgressHUD.showErrorWithStatus(response.result.error!.localizedDescription)
                        }
                        if response.result.value != nil{
                            let json=JSON(response.result.value!)
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
                                //保存店铺号码
                                userDefaults.setObject(entity!.subStationPhoneNumber, forKey:"subStationPhoneNumber")
                                
                                NSLog("店铺唯一标识码--\(entity!.storeFlagCode)")
                                NSLog("店铺ID--\(entity!.storeId)")
                                //写入磁盘
                                userDefaults.synchronize()
                                //登录成功设置应用程序别名
                                JPUSHService.setAlias(entity!.storeFlagCode!, callbackSelector: nil, object:nil)
//                                JPUSHService.setTags([entity!.substationId!], callbackSelector:nil, object:nil)
                                //登录成功跳转到首页
                                let app=UIApplication.sharedApplication().delegate as! AppDelegate
                                
                                app.tab=TabBarViewController()
                                
                                self.txtPassword!.text=""
                                app.window?.rootViewController=app.tab                               //登录成功自动收起键盘
                                self.view.endEditing(true)
                                
                            }else{
                                SVProgressHUD.showErrorWithStatus("登陆失败")
                            }
                        }
                    }
                }
                
            }else{
                SVProgressHUD.showInfoWithStatus("无网络连接")
            }
        }

    }
    //点击view区域收起键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}
