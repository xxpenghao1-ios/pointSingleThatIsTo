//
//  FeedbackOnProblemsViewController.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/9/8.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import SwiftyJSON
class FeedbackOnProblemsViewController:BaseViewController,UITextViewDelegate {
    /// 文本视图容器
    var textViews:UITextView!
    /// 输入的文字
    var textLbl:String=""
    /// 完成按钮
    var confirmBtn:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="问题反馈"
        self.view.backgroundColor=UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false
        creatUI()
    }
    /**
     初始化附言UI
     */
    func creatUI(){
        //文本容器
        textViews=UITextView(frame: CGRect(x: 10, y:navHeight+20, width: boundsWidth-20, height: 100));
        textViews.font=UIFont.systemFont(ofSize: 14)
        textViews.layer.borderWidth=0.5
        textViews.layer.borderColor=UIColor.borderColor().cgColor
        textViews.layer.cornerRadius=5
        textViews.placeholder="感谢您能在百忙之中给我们提供宝贵的意见"
        textViews.text=textLbl
        //textView响应弹出键盘
        textViews.resignFirstResponder();
        textViews.isHidden = false
        textViews.delegate=self
        self.view.addSubview(textViews)
        
        //完成按钮
        confirmBtn=UIButton(frame: CGRect(x: 10, y: textViews.frame.maxY+20, width: boundsWidth-20,height: 40))
        confirmBtn.setTitle("完成", for: UIControlState())
        confirmBtn.setTitleColor(UIColor.white, for: UIControlState())
        confirmBtn.backgroundColor=UIColor.applicationMainColor()
        confirmBtn.layer.cornerRadius=5
        self.view.addSubview(confirmBtn)
        //添加点击事件
        confirmBtn.addTarget(self, action: #selector(actionRemark), for: UIControlEvents.touchUpInside)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        NSLog("DidEndEditing---\(textView.text)")
    }
    //文本框变化事件
    func textViewDidChange(_ textView: UITextView) {
        //接收textView的值
        textLbl=textView.text
        NSLog("DidChange---\(textView.text)")
    }
    /**
     增加附言
     
     - parameter sender: 当前完成按钮
     */
    @objc func actionRemark(_ sender:UIButton){
        let storeId=userDefaults.object(forKey: "storeId") as! String
        if textLbl.count==0{
            SVProgressHUD.showInfo(withStatus: "内容为空")
        }else{
            self.showSVProgressHUD(status:"正在提交", type: HUD.textGradient)
            PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.complaintsAndSuggestions(complaint:textLbl.pregReplace(), storeId:storeId), successClosure: { (result) -> Void in
                let json=JSON(result)
                let success=json["success"].stringValue
                if success == "success"{
                    SVProgressHUD.showSuccess(withStatus: "提交成功")
                    self.navigationController?.popViewController(animated: true)
                }else{
                    SVProgressHUD.showError(withStatus: "提交失败")
                }
                }) { (errorMsg) -> Void in
                    SVProgressHUD.showError(withStatus: errorMsg)
            }
        }
    }
    //点击view隐藏键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
