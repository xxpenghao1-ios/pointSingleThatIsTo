//
//  RegisterViewController.swift
//  pointSingleThatIsTo
//
//  Created by nevermore on 16/2/23.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import SVProgressHUD
import SwiftyJSON
///登录跳转后的页面（1为注册，2为修改密码）
class RegisterViewController:UIViewController{
    ///接收登录页面传过来的值（1为注册，2为修改密码）
    var flag:Int?
    ///提示标签
    var lblremind:UILabel?
    ///手机号码输入框
    var feildPhone:UITextField?
    /// 下一步按钮
    var btnNext:UIButton?

    
    //页面加载（一次）
    override func viewDidLoad() {
        super.viewDidLoad();
        //显示导航栏
        self.navigationController?.setNavigationBarHidden(false, animated:true)
        //设置背景色
        self.view.backgroundColor=UIColor.white
        
        initFunc()
    }
    //方法流程
    func initFunc(){
        uiView()
        ifflag()
        
    }
    //判断并执行
    func ifflag(){
        
        if flag==1{//当登录页面传过来是1
            self.title="注册新账号"
            lblremind?.text="亲，请输入手机号码，快速注册账号"
        }else if flag==2{//当登录页面传过来是2
            self.title="找回密码"
            lblremind?.text="亲，请输入手机号码，快速找回密码"

        }
    }
    //UI布局
    func uiView(){
        ///提示标签
        lblremind=UILabel()
        lblremind?.frame=CGRect(x: 0, y: navHeight, width: boundsWidth, height: 60)
        lblremind?.textAlignment=NSTextAlignment.center
        lblremind?.backgroundColor=UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        lblremind?.font=UIFont.systemFont(ofSize: 14)
        self.view.addSubview(lblremind!)
        //加边框线的uiview
        let lian=UIView()
        lian.frame=CGRect(x: -1, y: lblremind!.frame.maxY, width: boundsWidth+2, height: 50)
        lian.layer.borderWidth=1
        lian.backgroundColor=UIColor.white
        lian.layer.borderColor=UIColor.borderColor().cgColor
        self.view.addSubview(lian)
        ///手机号码输入框
        feildPhone=UITextField()
        feildPhone?.frame=CGRect(x: 5, y: lblremind!.frame.maxY+15, width: boundsWidth-10, height: 20)
        feildPhone?.placeholder="请输入手机号码"
        feildPhone?.font=UIFont.systemFont(ofSize: 16)
        feildPhone?.keyboardType=UIKeyboardType.numberPad
        feildPhone?.clearButtonMode=UITextFieldViewMode.always
        feildPhone?.backgroundColor=UIColor.white
        self.view.addSubview(feildPhone!)
        /// 下一步按钮
        btnNext=UIButton()
        btnNext?.frame=CGRect(x: 30, y: feildPhone!.frame.maxY+50, width: boundsWidth-60, height: 40)
        btnNext?.backgroundColor=UIColor.red
        btnNext?.layer.cornerRadius=20
        btnNext?.setTitle("下一步", for: UIControlState())
        btnNext?.addTarget(self, action: #selector(clickBtn), for: UIControlEvents.touchUpInside)
        self.view.addSubview(btnNext!)
        
        
    }
    
    //点击下一步触发
    @objc func clickBtn(_ sender:UIButton){
        //要求手机号为11位数
        if feildPhone?.text?.characters.count==11{
            //发送请求（手机验证）
            httpPhone()
        }else if feildPhone?.text?.characters.count==0&&feildPhone?.text==nil{
            SVProgressHUD.showInfo(withStatus: "手机号不能为空", maskType: .clear)
        }else{
            SVProgressHUD.showInfo(withStatus: "请输入正确的手机号", maskType: .clear)
        }
    }
    
    //发送请求（手机验证）
    func httpPhone(){
        let phone=feildPhone?.text
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.doMemberTheOnly(memberName:phone!), successClosure: { (result) -> Void in
            //解析json
            let JSONres=JSON(result)
            if JSONres["success"].stringValue == "failds"{
                if self.flag==1{//1则账号没有被注册 跳转页面
                    let vc=RegisterValidationViewController();
                    vc.phone=phone
                    vc.flag=self.flag
                    self.navigationController?.pushViewController(vc, animated:true);
                    self.view.endEditing(true)
                    
                }else if self.flag==2{//2为 没有被注册就不存在修改密码
                    SVProgressHUD.showError(withStatus: "账号不存在")
                }
                
            }else if JSONres["success"].stringValue == "success"{
                if self.flag==1{//账号已经被注册
                    SVProgressHUD.showInfo(withStatus: "该账号已经被注册", maskType: .clear)
                }else if self.flag==2{// 已经被注册就可以修改密码
                    let vc=RegisterValidationViewController();
                    vc.phone=phone
                    vc.flag=self.flag
                    self.navigationController?.pushViewController(vc, animated:true);
                    self.view.endEditing(true)
                }
            }
            }) { (errorMsg) -> Void in
                SVProgressHUD.showError(withStatus: errorMsg)
        }
    }
    //点其他区域关闭键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }



}
