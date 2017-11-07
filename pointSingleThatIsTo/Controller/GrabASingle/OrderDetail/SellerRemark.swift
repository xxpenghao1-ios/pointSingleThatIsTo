//
//  SellerRemark.swift
//  pointSingleThatIsTo
//
//  Created by 卢洋 on 16/2/24.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit

/// 卖家附言
class SellerRemark:BaseViewController,UITextViewDelegate{
    /// 文本视图容器
    var textViews:UITextView!
    /// 输入的文字
    var textLbl:String=""
    /// 完成按钮
    var confirmBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.title="卖家附言"
        self.view.backgroundColor=UIColor(red: 0.97, green: 0.97, blue: 0.98, alpha: 1)
        self.automaticallyAdjustsScrollViewInsets = false
        creatUI()
    }
    /**
    初始化附言UI
    */
    func creatUI(){
        //文本容器
        textViews=UITextView(frame: CGRect(x: 10, y: 84, width: boundsWidth-20, height: 100));
        textViews.font=UIFont.systemFont(ofSize: 14)
        textViews.layer.borderWidth=0.5
        textViews.layer.borderColor=UIColor.borderColor().cgColor
        textViews.placeholder="输入你想说的话..."
        textViews.text=textLbl
        //textView响应弹出键盘
        textViews.resignFirstResponder();
        textViews.isHidden = false
        textViews.delegate=self
        self.view.addSubview(textViews)
        
        //完成按钮
        confirmBtn=UIButton(frame: CGRect(x: 10, y: textViews.frame.maxY+10, width: boundsWidth-20, height: 45))
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
        //发送通知
        NotificationCenter.default.post(name: Notification.Name(rawValue: "remarkNotification"), object: textLbl)
        self.navigationController?.popViewController(animated: true)
        
    }
    //点击view隐藏键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
