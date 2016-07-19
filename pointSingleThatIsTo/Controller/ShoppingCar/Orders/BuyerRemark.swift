//
//  BuyerRemark.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/2/25.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
/// 买家留言
class BuyerRemark:UIViewController,UITextViewDelegate {
    /// 文本视图容器
    var textViews:UITextView!
    /// 输入的文字
    var textLbl:String?
    /// 完成按钮
    var confirmBtn:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="买家附言"
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
        textViews.layer.cornerRadius=5
        textViews.layer.borderColor=UIColor.borderColor().CGColor
        textViews.placeholder="输入你想说的话..."
        textViews.text=textLbl
        //textView响应弹出键盘
        textViews.resignFirstResponder();
        textViews.hidden = false
        textViews.delegate=self
        self.view.addSubview(textViews)
        
        //完成按钮
        confirmBtn=UIButton(frame: CGRectMake(10, CGRectGetMaxY(textViews.frame)+10, boundsWidth-20, 45))
        confirmBtn.setTitle("完成", forState: UIControlState.Normal)
        confirmBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        confirmBtn.backgroundColor=UIColor.applicationMainColor()
        confirmBtn.layer.cornerRadius=5
        self.view.addSubview(confirmBtn)
        //添加点击事件
        confirmBtn.addTarget(self, action: "actionRemark:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    //文本框变化事件
    func textViewDidChange(textView: UITextView) {
        //接收textView的值
        textLbl=textView.text
    }
    /**
     增加附言
     
     - parameter sender: 当前完成按钮
     */
    func actionRemark(sender:UIButton){
        //发送通知
        NSNotificationCenter.defaultCenter().postNotificationName("remarkNotification", object: textLbl)
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    //点击view隐藏键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}