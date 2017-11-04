////
////  SalesmanLoginViewController.swift
////  pointSingleThatIsTo
////
////  Created by penghao on 16/6/30.
////  Copyright © 2016年 penghao. All rights reserved.
////
//
//import Foundation
//import UIKit
//import SVProgressHUD
//import SwiftyJSON
///// 业务员登录
//class SalesmanLoginViewController:BaseViewController{
//    /// 用户名
//    @IBOutlet weak fileprivate var txtName: UITextField!
//    /// 密码
//    @IBOutlet weak fileprivate var txtPassword: UITextField!
//    /// 登录按钮
//    @IBOutlet weak fileprivate var btnLogin: UIButton!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.title="业务员登录"
//        self.view.backgroundColor=UIColor.white
//        btnLogin.backgroundColor=UIColor.applicationMainColor()
//        btnLogin.titleLabel!.textColor=UIColor.white
//        btnLogin.layer.cornerRadius=20
//        self.navigationController?.setNavigationBarHidden(false, animated:true)
//    }
//    /**
//     业务员登录
//
//     - parameter sender:UIButton
//     */
//    @IBAction func submit(_ sender: UIButton) {
//        let name=txtName.text
//        let password=txtPassword.text
//        SVProgressHUD.show(withStatus: "正在登录", maskType: SVProgressHUDMaskType.gradient)
//        if isStringNil(name) == false{
//            SVProgressHUD.showInfo(withStatus: "用户名为空")
//        }else if isStringNil(password) == false{
//            SVProgressHUD.showInfo(withStatus: "密码为空")
//        }else{
//            PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.nmoreGlobalPosiUploadStoreLogin(userAccount: name!, userPassword: password!), successClosure: { (result) -> Void in
//                SVProgressHUD.dismiss()
//                let json=JSON(result)
//                let success=json["success"].stringValue
//                if success == "success"{
//                    let vc=storyboardPushView("SweepersId") as! SweepersViewController
//                    vc.userId=json["userId"].stringValue
//                    self.navigationController!.pushViewController(vc, animated:true)
//                }else{
//                    SVProgressHUD.showError(withStatus: "登录失败")
//                }
//                }, failClosure: { (errorMsg) -> Void in
//                    SVProgressHUD.showError(withStatus: errorMsg)
//            })
//        }
//
//    }
//}

