//
//  SalesmanLoginViewController.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/6/30.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import Alamofire
/// 业务员登录
class SalesmanLoginViewController:BaseViewController{
    /// 用户名
    @IBOutlet weak private var txtName: UITextField!
    /// 密码
    @IBOutlet weak private var txtPassword: UITextField!
    /// 登录按钮
    @IBOutlet weak private var btnLogin: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="业务员登录"
        self.view.backgroundColor=UIColor.whiteColor()
        btnLogin.backgroundColor=UIColor.applicationMainColor()
        btnLogin.titleLabel!.textColor=UIColor.whiteColor()
        btnLogin.layer.cornerRadius=20
        self.navigationController?.setNavigationBarHidden(false, animated:true)
    }
    /**
     业务员登录
     
     - parameter sender:UIButton
     */
    @IBAction func submit(sender: UIButton) {
        let name=txtName.text
        let password=txtPassword.text
        SVProgressHUD.showWithStatus("正在登录", maskType: SVProgressHUDMaskType.Gradient)
        if isStringNil(name) == false{
            SVProgressHUD.showInfoWithStatus("用户名为空")
        }else if isStringNil(password) == false{
            SVProgressHUD.showInfoWithStatus("密码为空")
        }else{
            request(.POST,URL+"nmoreGlobalPosiUploadStoreLogin.xhtml", parameters:["userAccount":name!,"userPassword":password!]).responseJSON{ response in
                if response.result.error != nil{
                    SVProgressHUD.showErrorWithStatus(response.result.error!.localizedDescription)
                }
                if response.result.value != nil{
                    SVProgressHUD.dismiss()
                    let json=JSON(response.result.value!)
                    let success=json["success"].stringValue
                    if success == "success"{
                       let vc=storyboardPushView("SweepersId") as! SweepersViewController
                       vc.userId=json["userId"].stringValue
                       self.navigationController!.pushViewController(vc, animated:true)
                    }else{
                       SVProgressHUD.showErrorWithStatus("登录失败")
                    }
                }
            }
        }
        
    }
}
