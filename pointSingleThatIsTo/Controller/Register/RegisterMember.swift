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
import SwiftyJSON
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


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
        
        self.view.backgroundColor=UIColor.white;
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
        viewone.frame=CGRect(x: -1, y: 80, width: boundsWidth+2, height: 50)
        viewone.layer.borderWidth=1
        viewone.layer.borderColor=UIColor.borderColor().cgColor
        viewone.backgroundColor=UIColor.white
        self.view.addSubview(viewone)
        ///显示横线用的viewtwo
        let viewtwo=UIView()
        viewtwo.frame=CGRect(x: -1, y: viewone.frame.maxY-1, width: boundsWidth+2, height: 50)
        viewtwo.layer.borderWidth=1
        viewtwo.layer.borderColor=UIColor.borderColor().cgColor
        viewtwo.backgroundColor=UIColor.white
        self.view.addSubview(viewtwo)
        /// 输入密码
        feildPsW=UITextField()
        feildPsW?.frame=CGRect(x: 10, y: viewone.frame.minY+15, width: boundsWidth-20, height: 20)
        feildPsW?.isSecureTextEntry=true
        feildPsW?.placeholder="密码"
        feildPsW?.font=UIFont.systemFont(ofSize: 16)
        feildPsW?.clearButtonMode=UITextFieldViewMode.always
        self.view.addSubview(feildPsW!)
        /// 再次输入密码
        feildPsWAgian=UITextField()
        feildPsWAgian?.frame=CGRect(x: 10, y: viewtwo.frame.minY+15, width: boundsWidth-20, height: 20)
        feildPsWAgian?.isSecureTextEntry=true
        feildPsWAgian?.placeholder="请再次输入密码"
        feildPsWAgian?.font=UIFont.systemFont(ofSize: 16)
        feildPsWAgian?.clearButtonMode=UITextFieldViewMode.always
        self.view.addSubview(feildPsWAgian!)
        /// 注册按钮
        btnRegist=UIButton()
        btnRegist?.frame=CGRect(x: 30, y: viewtwo.frame.maxY+25, width: boundsWidth-60, height: 40)
        btnRegist?.setTitle("确定", for: UIControlState())
        btnRegist?.backgroundColor=UIColor.red
        btnRegist?.layer.cornerRadius=20
        btnRegist?.tag=2
        btnRegist?.titleLabel?.font=UIFont.systemFont(ofSize: 16)
        btnRegist?.addTarget(self, action:#selector(clickRegist), for: UIControlEvents.touchUpInside)
        self.view.addSubview(btnRegist!)



    }
    
    //注册新账号UI布局
    func uistyle(){
        ///提示标签
        lblremind=UILabel()
        lblremind?.frame=CGRect(x: 0, y: navHeight, width: boundsWidth, height: 60)
        lblremind?.text="亲，用户名是您登录的唯一通行证!"
        lblremind?.font=UIFont.systemFont(ofSize: 16)
        lblremind?.numberOfLines=1
        lblremind?.backgroundColor=UIColor(red: 0.86, green: 0.86, blue: 0.86, alpha: 1)
        lblremind?.textAlignment=NSTextAlignment.center
        self.view.addSubview(lblremind!)
        ///显示横线用的view1
        let viewone=UIView()
        viewone.frame=CGRect(x: -1, y: lblremind!.frame.maxY, width: boundsWidth+2, height: 50)
        viewone.layer.borderWidth=1
        viewone.layer.borderColor=UIColor.borderColor().cgColor
        viewone.backgroundColor=UIColor.white
        self.view.addSubview(viewone)
        ///显示横线用的viewtwo
        let viewtwo=UIView()
        viewtwo.frame=CGRect(x: -1, y: viewone.frame.maxY-1, width: boundsWidth+2, height: 50)
        viewtwo.layer.borderWidth=1
        viewtwo.layer.borderColor=UIColor.borderColor().cgColor
        viewtwo.backgroundColor=UIColor.white
        self.view.addSubview(viewtwo)
        ///显示横线用的viewthree
        let viewthree=UIView()
        viewthree.frame=CGRect(x: -1, y: viewtwo.frame.maxY-1, width: boundsWidth+2, height: 50)
        viewthree.layer.borderWidth=1
        viewthree.layer.borderColor=UIColor.borderColor().cgColor
        viewthree.backgroundColor=UIColor.white
        self.view.addSubview(viewthree)
        ///显示横线用的viewfour
        let viewfour=UIView()
        viewfour.frame=CGRect(x: -1, y: viewthree.frame.maxY-1, width: boundsWidth+2, height: 50)
        viewfour.layer.borderWidth=1
        viewfour.layer.borderColor=UIColor.borderColor().cgColor
        viewfour.backgroundColor=UIColor.white
        self.view.addSubview(viewfour)

        /// 显示手机号码的标签
        lblPhone=UILabel()
        lblPhone?.frame=CGRect(x: 10, y: viewone.frame.minY+15, width: boundsWidth-20, height: 20)
        lblPhone?.text=self.phone
        lblPhone?.backgroundColor=UIColor.white
        lblPhone?.font=UIFont.systemFont(ofSize: 16)
        self.view.addSubview(lblPhone!)
        /// 输入密码
        feildPsW=UITextField()
        feildPsW?.frame=CGRect(x: 10, y: viewtwo.frame.minY+15, width: boundsWidth-20, height: 20)
        feildPsW?.isSecureTextEntry=true
        feildPsW?.placeholder="密码"
        feildPsW?.font=UIFont.systemFont(ofSize: 16)
        feildPsW?.clearButtonMode=UITextFieldViewMode.always
        self.view.addSubview(feildPsW!)
        /// 再次输入密码
        feildPsWAgian=UITextField()
        feildPsWAgian?.frame=CGRect(x: 10, y: viewthree.frame.minY+15, width: boundsWidth-20, height: 20)
        feildPsWAgian?.isSecureTextEntry=true
        feildPsWAgian?.placeholder="请再次输入密码"
        feildPsWAgian?.font=UIFont.systemFont(ofSize: 16)
        feildPsWAgian?.clearButtonMode=UITextFieldViewMode.always
        self.view.addSubview(feildPsWAgian!)
        /// 推荐人填写框
        lblIR=UITextField()
        lblIR?.placeholder="推荐人（可以不扫）"
        lblIR?.isEnabled=false
        lblIR?.frame=CGRect(x: 10, y: viewfour.frame.minY+15, width: boundsWidth-100, height: 20)
        lblIR?.font=UIFont.systemFont(ofSize: 16)
        self.view.addSubview(lblIR!)
        /// 扫一扫按钮
        btnSweep=UIButton()
        btnSweep?.frame=CGRect(x: boundsWidth-90, y: viewfour.frame.minY, width: 90, height: 50)
        btnSweep?.setTitle("扫一扫", for: UIControlState())
        btnSweep?.backgroundColor=UIColor.red
        btnSweep?.titleLabel?.font=UIFont.systemFont(ofSize: 16)
        btnSweep?.addTarget(self, action: #selector(clickSweep), for: UIControlEvents.touchUpInside)
        self.view.addSubview(btnSweep!)
        /// 注册按钮
        btnRegist=UIButton()
        btnRegist?.frame=CGRect(x: 30, y: viewfour.frame.maxY+25, width: boundsWidth-60, height: 40)
        btnRegist?.setTitle("注册", for: UIControlState())
        btnRegist?.backgroundColor=UIColor.red
        btnRegist?.layer.cornerRadius=20
        btnRegist?.tag=1
        btnRegist?.titleLabel?.font=UIFont.systemFont(ofSize: 16)
        btnRegist?.addTarget(self, action: #selector(clickRegist), for: UIControlEvents.touchUpInside)
        self.view.addSubview(btnRegist!)
        
    }
    /// 扫一扫按钮 触发事件@objc
    @objc func clickSweep(_ sender:UIButton){
    }
    /// 注册按钮@objc
    @objc func clickRegist(_ sender:UIButton){
        let charcount=feildPsW?.text?.characters.count
        
        if feildPsW?.text==feildPsWAgian?.text{
            if charcount==0&&feildPsW?.text==" "{
                SVProgressHUD.showInfo(withStatus: "密码不能为空")
            }else if charcount >= 6 || charcount <= 12{
                if sender.tag==1{
                    //注册请求
                    self.httpRegist()
                }else if sender.tag==2{
                    //修改密码请求
                    self.httpPsW()
                }
                
            }else{
                SVProgressHUD.showInfo(withStatus: "请输入6-12位数")
            }
            
        }else{
            SVProgressHUD.showInfo(withStatus: "两次输入的密码不相同")
        }
        
    }
    
    //修改密码请求
    func httpPsW(){
        let phone=self.phone
        let password=self.feildPsW?.text
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.updatePassWord(memberName:phone!, newPassWord:password!), successClosure: { (result) -> Void in
                let json=JSON(result)
                if json["success"].stringValue=="success"{
                    SVProgressHUD.showSuccess(withStatus: "修改成功")
                    self.navigationController?.popToRootViewController(animated: true)
                }else{
                    SVProgressHUD.showError(withStatus: "系统繁忙，请稍后重试")
                }
            }) { (errorMsg) -> Void in
                SVProgressHUD.showError(withStatus: errorMsg)
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
                    self.navigationController?.popToRootViewController(animated: true)
                
                }else {
                    SVProgressHUD.showError(withStatus: "网络异常，请重新注册")
                
                }
            }) { (errorMsg) -> Void in
                SVProgressHUD.showError(withStatus: errorMsg)
        }
        
    }
    
    //注册成功跳转到绑定店铺唯一标示码
    func popToView(_ memberId:Int){
//        var  vc=RegisterValidationStore();
//        vc.memebrId=memberId
//        self.navigationController?.pushViewController(vc, animated:true);
    }

    //点击其他区域关闭键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
    
    

}
