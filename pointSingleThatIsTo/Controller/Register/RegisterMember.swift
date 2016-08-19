//
//  RegisterMember.swift
//  pointSingleThatIsTo
//
//  Created by nevermore on 16/2/24.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

//注册用户页面
class RegisterMember:UIViewController{
    //接收手机号码
    var phone:String?;
    ///接收登录页面传过来的值（1为注册，2为修改密码）
    var flag:Int?
    /// 显示手机号码的标签
    var lblPhone:UILabel?
    /// 输入密码
    var feildPsW:UITextField?
    /// 再次输入密码
    var feildPsWAgian:UITextField?
    /// 推荐人标签
    var lblIR:UITextField?
    /// 扫一扫按钮
    var btnSweep:UIButton?
    /// 注册按钮
    var btnRegist:UIButton?
    ///提示标签
    var lblremind:UILabel?
    /// 会员ID
    var memberId:String?
    
    //页面加载，执行一次
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.view.backgroundColor=UIColor.whiteColor();
        initFunc()
    }
    //方法流程
    func initFunc(){
        
        //判断flag并执行
        ifflag()
        
    }

    //判断flag并执行
    func ifflag(){
        
        if flag==1{//当登录页面传过来是1
            self.title="注册新账号"
            //注册新账号UI布局
            uistyle()
            
            
        }else if flag==2{//当登录页面传过来是2
            self.title="修改密码"
           // 修改密码UI布局
            viewstyle()
        }
    }
    //修改密码UI布局
    func viewstyle(){
        ///显示横线用的view1
        let viewone=UIView()
        viewone.frame=CGRectMake(-1, 80, boundsWidth+2, 50)
        viewone.layer.borderWidth=1
        viewone.layer.borderColor=UIColor.borderColor().CGColor
        viewone.backgroundColor=UIColor.whiteColor()
        self.view.addSubview(viewone)
        ///显示横线用的viewtwo
        let viewtwo=UIView()
        viewtwo.frame=CGRectMake(-1, CGRectGetMaxY(viewone.frame)-1, boundsWidth+2, 50)
        viewtwo.layer.borderWidth=1
        viewtwo.layer.borderColor=UIColor.borderColor().CGColor
        viewtwo.backgroundColor=UIColor.whiteColor()
        self.view.addSubview(viewtwo)
        /// 输入密码
        feildPsW=UITextField()
        feildPsW?.frame=CGRectMake(10, CGRectGetMinY(viewone.frame)+15, boundsWidth-20, 20)
        feildPsW?.secureTextEntry=true
        feildPsW?.placeholder="密码"
        feildPsW?.font=UIFont.systemFontOfSize(16)
        feildPsW?.clearButtonMode=UITextFieldViewMode.Always
        self.view.addSubview(feildPsW!)
        /// 再次输入密码
        feildPsWAgian=UITextField()
        feildPsWAgian?.frame=CGRectMake(10, CGRectGetMinY(viewtwo.frame)+15, boundsWidth-20, 20)
        feildPsWAgian?.secureTextEntry=true
        feildPsWAgian?.placeholder="请再次输入密码"
        feildPsWAgian?.font=UIFont.systemFontOfSize(16)
        feildPsWAgian?.clearButtonMode=UITextFieldViewMode.Always
        self.view.addSubview(feildPsWAgian!)
        /// 注册按钮
        btnRegist=UIButton()
        btnRegist?.frame=CGRectMake(30, CGRectGetMaxY(viewtwo.frame)+25, boundsWidth-60, 40)
        btnRegist?.setTitle("确定", forState: UIControlState.Normal)
        btnRegist?.backgroundColor=UIColor.redColor()
        btnRegist?.layer.cornerRadius=20
        btnRegist?.tag=2
        btnRegist?.titleLabel?.font=UIFont.systemFontOfSize(16)
        btnRegist?.addTarget(self, action: "clickRegist:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btnRegist!)



    }
    
    //注册新账号UI布局
    func uistyle(){
        ///提示标签
        lblremind=UILabel()
        lblremind?.frame=CGRectMake(0, 64, boundsWidth, 60)
        lblremind?.text="亲，用户名是您登录的唯一通行证!"
        lblremind?.font=UIFont.systemFontOfSize(16)
        lblremind?.numberOfLines=1
        lblremind?.backgroundColor=UIColor(red: 0.86, green: 0.86, blue: 0.86, alpha: 1)
        lblremind?.textAlignment=NSTextAlignment.Center
        self.view.addSubview(lblremind!)
        ///显示横线用的view1
        let viewone=UIView()
        viewone.frame=CGRectMake(-1, CGRectGetMaxY(lblremind!.frame), boundsWidth+2, 50)
        viewone.layer.borderWidth=1
        viewone.layer.borderColor=UIColor.borderColor().CGColor
        viewone.backgroundColor=UIColor.whiteColor()
        self.view.addSubview(viewone)
        ///显示横线用的viewtwo
        let viewtwo=UIView()
        viewtwo.frame=CGRectMake(-1, CGRectGetMaxY(viewone.frame)-1, boundsWidth+2, 50)
        viewtwo.layer.borderWidth=1
        viewtwo.layer.borderColor=UIColor.borderColor().CGColor
        viewtwo.backgroundColor=UIColor.whiteColor()
        self.view.addSubview(viewtwo)
        ///显示横线用的viewthree
        let viewthree=UIView()
        viewthree.frame=CGRectMake(-1, CGRectGetMaxY(viewtwo.frame)-1, boundsWidth+2, 50)
        viewthree.layer.borderWidth=1
        viewthree.layer.borderColor=UIColor.borderColor().CGColor
        viewthree.backgroundColor=UIColor.whiteColor()
        self.view.addSubview(viewthree)
        ///显示横线用的viewfour
        let viewfour=UIView()
        viewfour.frame=CGRectMake(-1, CGRectGetMaxY(viewthree.frame)-1, boundsWidth+2, 50)
        viewfour.layer.borderWidth=1
        viewfour.layer.borderColor=UIColor.borderColor().CGColor
        viewfour.backgroundColor=UIColor.whiteColor()
        self.view.addSubview(viewfour)

        /// 显示手机号码的标签
        lblPhone=UILabel()
        lblPhone?.frame=CGRectMake(10, CGRectGetMinY(viewone.frame)+15, boundsWidth-20, 20)
        lblPhone?.text=self.phone
        lblPhone?.backgroundColor=UIColor.whiteColor()
        lblPhone?.font=UIFont.systemFontOfSize(16)
        self.view.addSubview(lblPhone!)
        /// 输入密码
        feildPsW=UITextField()
        feildPsW?.frame=CGRectMake(10, CGRectGetMinY(viewtwo.frame)+15, boundsWidth-20, 20)
        feildPsW?.secureTextEntry=true
        feildPsW?.placeholder="密码"
        feildPsW?.font=UIFont.systemFontOfSize(16)
        feildPsW?.clearButtonMode=UITextFieldViewMode.Always
        self.view.addSubview(feildPsW!)
        /// 再次输入密码
        feildPsWAgian=UITextField()
        feildPsWAgian?.frame=CGRectMake(10, CGRectGetMinY(viewthree.frame)+15, boundsWidth-20, 20)
        feildPsWAgian?.secureTextEntry=true
        feildPsWAgian?.placeholder="请再次输入密码"
        feildPsWAgian?.font=UIFont.systemFontOfSize(16)
        feildPsWAgian?.clearButtonMode=UITextFieldViewMode.Always
        self.view.addSubview(feildPsWAgian!)
        /// 推荐人填写框
        lblIR=UITextField()
        lblIR?.placeholder="推荐人（可以不扫）"
        lblIR?.enabled=false
        lblIR?.frame=CGRectMake(10, CGRectGetMinY(viewfour.frame)+15, boundsWidth-100, 20)
        lblIR?.font=UIFont.systemFontOfSize(16)
        self.view.addSubview(lblIR!)
        /// 扫一扫按钮
        btnSweep=UIButton()
        btnSweep?.frame=CGRectMake(boundsWidth-90, CGRectGetMinY(viewfour.frame), 90, 50)
        btnSweep?.setTitle("扫一扫", forState: UIControlState.Normal)
        btnSweep?.backgroundColor=UIColor.redColor()
        btnSweep?.titleLabel?.font=UIFont.systemFontOfSize(16)
        btnSweep?.addTarget(self, action: "clickSweep:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btnSweep!)
        /// 注册按钮
        btnRegist=UIButton()
        btnRegist?.frame=CGRectMake(30, CGRectGetMaxY(viewfour.frame)+25, boundsWidth-60, 40)
        btnRegist?.setTitle("注册", forState: UIControlState.Normal)
        btnRegist?.backgroundColor=UIColor.redColor()
        btnRegist?.layer.cornerRadius=20
        btnRegist?.tag=1
        btnRegist?.titleLabel?.font=UIFont.systemFontOfSize(16)
        btnRegist?.addTarget(self, action: "clickRegist:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btnRegist!)
        
    }
    /// 扫一扫按钮 触发事件
    func clickSweep(sender:UIButton){
    }
    /// 注册按钮
    func clickRegist(sender:UIButton){
        let charcount=feildPsW?.text?.characters.count
        
        if feildPsW?.text==feildPsWAgian?.text{
            if charcount==0&&feildPsW?.text==" "{
                SVProgressHUD.showInfoWithStatus("密码不能为空")
            }else if charcount >= 6 || charcount <= 12{
                if sender.tag==1{
                    //注册请求
                    self.httpRegist()
                }else if sender.tag==2{
                    //修改密码请求
                    self.httpPsW()
                }
                
            }else{
                SVProgressHUD.showInfoWithStatus("请输入6-12位数")
            }
            
        }else{
            SVProgressHUD.showInfoWithStatus("两次输入的密码不相同")
        }
        
    }
    
    //修改密码请求
    func httpPsW(){
        let phone=self.phone
        let password=self.feildPsW?.text
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.updatePassWord(memberName:phone!, newPassWord:password!), successClosure: { (result) -> Void in
                let json=JSON(result)
                if json["success"].stringValue=="success"{
                    SVProgressHUD.showSuccessWithStatus("修改成功")
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }else{
                    SVProgressHUD.showErrorWithStatus("系统繁忙，请稍后重试")
                }
            }) { (errorMsg) -> Void in
                SVProgressHUD.showErrorWithStatus(errorMsg)
        }
    }
    
    //发送注册的请求
    func httpRegist(){
        let phone=self.phone
        let password=self.feildPsW?.text
        let referralName=self.lblIR?.text
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.doRegest(memberName:phone!, password: password!, phone_mob: phone!, referralName: referralName!), successClosure: { (result) -> Void in
                let json=JSON(result)
                if json["success"].stringValue=="success"{
                    self.memberId=json["memberId"].stringValue
                    self.navigationController?.popToRootViewControllerAnimated(true)
                
                }else {
                    SVProgressHUD.showErrorWithStatus("网络异常，请重新注册")
                
                }
            }) { (errorMsg) -> Void in
                SVProgressHUD.showErrorWithStatus(errorMsg)
        }
        
    }
    
    //注册成功跳转到绑定店铺唯一标示码
    func popToView(memberId:Int){
//        var  vc=RegisterValidationStore();
//        vc.memebrId=memberId
//        self.navigationController?.pushViewController(vc, animated:true);
    }

    //点击其他区域关闭键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

    
    
    

}