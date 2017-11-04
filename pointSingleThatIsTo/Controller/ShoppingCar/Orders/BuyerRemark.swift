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
        self.view.backgroundColor=UIColor.white
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
        textViews.layer.cornerRadius=5
        textViews.layer.borderColor=UIColor.borderColor().cgColor
        textViews.placeholder="重要提示! 不能输入表情,有可能导致订单提交失败"
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
        confirmBtn.addTarget(self, action: "actionRemark:", for: UIControlEvents.touchUpInside)
    }
    //文本框变化事件
    func textViewDidChange(_ textView: UITextView) {
        //接收textView的值
        textLbl=textView.text
    }
    /**
     增加附言
     
     - parameter sender: 当前完成按钮
     */
    func actionRemark(_ sender:UIButton){
        if textLbl != nil{
            //发送通知
        NotificationCenter.default.post(name: Notification.Name(rawValue: "remarkNotification"), object:textLbl!.pregReplace())
        }
        self.navigationController?.popViewController(animated: true)
        
    }
    //点击view隐藏键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension String {
    //返回字数
    var count: Int {
        let string_NS = self as NSString
        return string_NS.length
    }
    
    //使用正则表达式替换
    func pregReplace(_ options: NSRegularExpression.Options = []) -> String {
            let regex = try! NSRegularExpression(pattern:"[\\ud83c\\udc00-\\ud83c\\udfff]|[\\ud83d\\udc00-\\ud83d\\udfff]|[\\u2600-\\u27ff]", options: options)
            return regex.stringByReplacingMatches(in: self, options:[],range:NSMakeRange(0, self.count), withTemplate:"")
    }
}
extension String{
    func check() -> String {
        
        let  result = NSMutableString()
        // 使用正则表达式一定要加try语句
        
        do {
            
            // - 1、创建规则
            
            let pattern = "[a-zA-Z_0-9_一-龥]"
            
            // - 2、创建正则表达式对象
            
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            
            // - 3、开始匹配
            
            let res = regex.matches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count))
            
            // 输出结果
            
            for checkingRes in res {
                
                let nn = (self as NSString).substring(with: checkingRes.range) as NSString
                
                result.append(nn as String)
                
            }
            
        }
            
        catch {
            
            print(error)
            
        }
        
        return result as String
        
    }
}
