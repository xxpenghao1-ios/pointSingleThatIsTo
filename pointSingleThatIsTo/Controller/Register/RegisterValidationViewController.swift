//
//  RegisterValidationViewController.swift
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

class RegisterValidationViewController:UIViewController{
    /// 手机号码
    var phone:String?
    /// 接收登录页面传过来的值（1为注册，2为修改密码）
    var flag:Int?
    /// 验证码输入框
    var feildCode:UITextField?
    /// 获取验证码标签
    var getCode:UIButton?
    /// 发送请求时用的参数
    var httpflag:String?
    /// 接收请求来的验证码
    var ranCode:String?
    /// 下一步 按钮
    var btnNext:UIButton?
    /// 时间器
    var timer:Timer?;
    /// 时间跳动的数字
    var count=60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置背景色
        self.view.backgroundColor=UIColor.white
        initFunc()
    }
    //方法流程
    func initFunc(){
        initview()
        ifflag()
        
    }
    //ui 布局
    func initview(){
        //画横线用的view
        let lianview=UIView()
        lianview.frame=CGRect(x: -1, y:navHeight+16, width: boundsWidth+2, height: 50)
        lianview.layer.borderWidth=1
        lianview.layer.borderColor=UIColor.borderColor().cgColor
        self.view.addSubview(lianview)
        //验证码 标签
        let lblCode:UILabel=UILabel()
        lblCode.frame=CGRect(x: 0, y: lianview.frame.minY+15, width: boundsWidth*2/7, height: 20)
        lblCode.text="验证码"
        lblCode.font=UIFont.systemFont(ofSize: 16)
        lblCode.textAlignment=NSTextAlignment.center
        
        self.view.addSubview(lblCode)
        /// 验证码输入框
        feildCode=UITextField()
        feildCode?.font=UIFont.systemFont(ofSize: 14)
        feildCode?.placeholder="手机收到的验证码"
        feildCode?.frame=CGRect(x: lblCode.frame.maxX, y: lblCode.frame.minY, width: boundsWidth*3/7, height: 20)
        feildCode?.backgroundColor=UIColor.white
        feildCode?.clearButtonMode=UITextFieldViewMode.always
        feildCode?.keyboardType=UIKeyboardType.numberPad
        self.view.addSubview(feildCode!)
        //隔开线
        let tolian=UIView()
        tolian.frame=CGRect(x: feildCode!.frame.maxX+1, y: lianview.frame.minY+5, width: 1, height: 40)
        tolian.backgroundColor=UIColor.borderColor()
        self.view.addSubview(tolian)
        
        /// 获取验证码按钮
        getCode=UIButton()
        getCode?.frame=CGRect(x: feildCode!.frame.maxX, y: lblCode.frame.minY, width: boundsWidth*2/7, height: 20)
        getCode?.setTitle("获取验证码", for: UIControlState())
        getCode?.setTitleColor(UIColor(red: 0.91, green: 0.40, blue: 0.55, alpha: 1), for: UIControlState())
        getCode?.titleLabel?.font=UIFont.systemFont(ofSize: 16)
        getCode?.addTarget(self, action:#selector(getCodeBtn), for: UIControlEvents.touchUpOutside)
        self.view.addSubview(getCode!)
        /// 下一步按钮
        btnNext=UIButton()
        btnNext?.frame=CGRect(x: 30, y: getCode!.frame.maxY+50, width: boundsWidth-60, height: 40)
        btnNext?.backgroundColor=UIColor.red
        btnNext?.layer.cornerRadius=20
        btnNext?.setTitle("下一步", for: .normal)
        btnNext?.addTarget(self, action:#selector(clickBtn), for: UIControlEvents.touchUpInside)
        self.view.addSubview(btnNext!)
        
        
        
    }
    //点击 下一步按钮  触发
    @objc func clickBtn(_ sender:UIButton){
        let count=feildCode?.text?.characters.count
        if feildCode?.text==nil||count==0{
            SVProgressHUD.showInfo(withStatus:"请输入验证码")
        }else{
            if self.ranCode != nil{
                if feildCode?.text==self.ranCode{
                    let vc=RegisterMember();
                    vc.phone=phone
                    vc.flag=self.flag
                    self.navigationController?.pushViewController(vc, animated:true);
                }else{
                    SVProgressHUD.showError(withStatus: "验证码错误", maskType: .clear)
                }
            }
        }
    }
    //发送请求(获取验证码)
    func httpGetCode(){
        if flag==1{
            self.httpflag="test"
        }else if flag==2{
            self.httpflag="updatePassword"
        }
        let flaghttp=self.httpflag
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.returnRandCode(memberName:self.phone!,flag:flaghttp!), successClosure: { (result) -> Void in
                let json=JSON(result)
                let success=json["success"].stringValue
                if success=="failds"{
                    SVProgressHUD.showError(withStatus: "发送失败")
                }else if success=="error"{
                    SVProgressHUD.showError(withStatus: "服务器异常")
                }else if success=="success"{
                    self.ranCode=json["randCode"].stringValue
                }
            }) { (errorMsg) -> Void in
                SVProgressHUD.showError(withStatus: errorMsg)
        }
    }
    //点击 （获取验证码按钮）触发
    @objc func getCodeBtn(_ sender:UIButton){
        httpGetCode()
        getCode!.isEnabled=false
        getCode?.setTitleColor(UIColor(red: 0.45, green: 0.45, blue: 0.45, alpha: 1), for: UIControlState())
        //创建定时器每隔一秒钟执行一次
        if timer == nil {
            timer=Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true);
        }else{
            self.timer?.invalidate();
            self.timer = nil;
            
        }

    }
    //判断并执行
    func ifflag(){
        if flag==1{//当登录页面传过来是1
            self.title="注册新账号"
        }else if flag==2{//当登录页面传过来是2
            self.title="找回密码"
        }
    }
    
    //定时器方法
    @objc func updateTimer(_ timer:Timer){
        //更改验证按信息
        count-=1;
        getCode?.setTitle("还剩\(count)秒", for: UIControlState())
        getCode!.isEnabled=false
        getCode?.setTitleColor(UIColor(red: 0.91, green: 0.40, blue: 0.55, alpha: 1), for: UIControlState())
        //计时数每次-1；
        
        //等于0的时候关闭计时器
        if count <= 0 {
            self.timer?.invalidate();
            self.timer = nil;
            //重新设置验证lbl
            getCode?.setTitle("重新获取", for: UIControlState())
            count=60;
            getCode!.isEnabled=true
            getCode?.setTitleColor(UIColor(red: 0.45, green: 0.45, blue: 0.45, alpha: 1), for: UIControlState())
            
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //清空计时器
        self.timer?.invalidate();
        self.timer = nil;
        feildCode?.text=nil
        getCode?.setTitle("获取验证码", for: UIControlState())
    }


    //点击view区域收起输入键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
