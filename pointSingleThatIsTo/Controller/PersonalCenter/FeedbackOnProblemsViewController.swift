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
class FeedbackOnProblemsViewController:UIViewController,UITextViewDelegate {
    /// 文本视图容器
    var textViews:UITextView!
    /// 输入的文字
    var textLbl:String=""
    /// 完成按钮
    var confirmBtn:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="问题反馈"
        self.view.backgroundColor=UIColor.whiteColor()
        self.automaticallyAdjustsScrollViewInsets = false
        creatUI()
    }
    /**
     初始化附言UI
     */
    func creatUI(){
        //文本容器
        textViews=UITextView(frame: CGRectMake(10, 84, boundsWidth-20, 100));
        textViews.font=UIFont.systemFontOfSize(14)
        textViews.layer.borderWidth=0.5
        textViews.layer.borderColor=UIColor.borderColor().CGColor
        textViews.layer.cornerRadius=5
        textViews.placeholder="感谢您能在百忙之中给我们提供宝贵的意见"
        textViews.text=textLbl
        //textView响应弹出键盘
        textViews.resignFirstResponder();
        textViews.hidden = false
        textViews.delegate=self
        self.view.addSubview(textViews)
        
        //完成按钮
        confirmBtn=UIButton(frame: CGRectMake(10, CGRectGetMaxY(textViews.frame)+20, boundsWidth-20,40))
        confirmBtn.setTitle("完成", forState: UIControlState.Normal)
        confirmBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        confirmBtn.backgroundColor=UIColor.applicationMainColor()
        confirmBtn.layer.cornerRadius=5
        self.view.addSubview(confirmBtn)
        //添加点击事件
        confirmBtn.addTarget(self, action: "actionRemark:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    func textViewDidEndEditing(textView: UITextView) {
        NSLog("DidEndEditing---\(textView.text)")
    }
    //文本框变化事件
    func textViewDidChange(textView: UITextView) {
        //接收textView的值
        textLbl=textView.text
        NSLog("DidChange---\(textView.text)")
    }
    /**
     增加附言
     
     - parameter sender: 当前完成按钮
     */
    func actionRemark(sender:UIButton){
        let storeId=userDefaults.objectForKey("storeId") as! String
        if textLbl.characters.count==0{
            SVProgressHUD.showInfoWithStatus("内容为空")
        }else{
            SVProgressHUD.showWithStatus("正在提交",maskType: SVProgressHUDMaskType.Gradient)
            PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.complaintsAndSuggestions(complaint:textLbl.check(), storeId:storeId), successClosure: { (result) -> Void in
                let json=JSON(result)
                let success=json["success"].stringValue
                if success == "success"{
                    SVProgressHUD.showSuccessWithStatus("提交成功")
                    self.navigationController?.popViewControllerAnimated(true)
                }else{
                    SVProgressHUD.showErrorWithStatus("提交失败")
                }
                }) { (errorMsg) -> Void in
                    SVProgressHUD.showErrorWithStatus(errorMsg)
            }
        }
    }
    //点击view隐藏键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

}