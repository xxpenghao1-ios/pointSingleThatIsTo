//
//  EZAlertController.swift
//  pointSingleThatIsTo
//
//  Created by 卢洋 on 16/3/1.
//  Copyright © 2016年 penghao. All rights reserved.
//

import UIKit
public class EZAlertController {

    class var instance : EZAlertController {
        struct Static {
            static let inst : EZAlertController = EZAlertController ()
        }
        return Static.inst
    }
    
    private func topMostController() -> UIViewController? {
        
        var presentedVC = UIApplication.sharedApplication().keyWindow?.rootViewController
        while let pVC = presentedVC?.presentedViewController
        {
            presentedVC = pVC
        }
        
        if presentedVC == nil {
            print("EZAlertController Error: You don't have any views set. You may be calling in viewdidload. Try viewdidappear.")
        }
        return presentedVC
    }
    /**
    标题
    - parameter title: 标题
    - returns: UIAlertController
    */
    public class func alert(title: String) -> UIAlertController {
        return alert(title, message: "")
    }
    /**
    带标题和内容
    
    - parameter title:   标题
    - parameter message: 内容
    
    - returns: UIAlertController
    */
    public class func alert(title: String, message: String) -> UIAlertController {
        return alert(title, message: message, acceptMessage: "OK") { () -> () in
            // Do nothing
        }
    }
    /**
    带标题、内容、和单按钮（回调函数）
    
    - parameter title:         标题
    - parameter message:       内容
    - parameter acceptMessage: 按钮
    - parameter acceptBlock:   回调函数
    
    - returns: UIAlertController
    */
    public class func alert(title: String, message: String, acceptMessage: String, acceptBlock: () -> ()) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let acceptButton = UIAlertAction(title: acceptMessage, style: .Default, handler: { (action: UIAlertAction) in
            acceptBlock()
        })
        alert.addAction(acceptButton)
        
        instance.topMostController()?.presentViewController(alert, animated: true, completion: nil)
        return alert
    }
    /**
    标题、内容、按钮数组、回调函数
    
    - parameter title:    标题
    - parameter message:  内容
    - parameter buttons:  按钮数组
    - parameter tapBlock: 回调函数
    
    - returns: UIAlertController
    */
    public class func alert(title: String, message: String, buttons:[String], tapBlock:((UIAlertAction,Int) -> Void)?) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert, buttons: buttons, tapBlock: tapBlock)
        instance.topMostController()?.presentViewController(alert, animated: true, completion: nil)
        return alert
    }
    /**
    自定义弹出UIView
    
    - parameter title:      标题
    - parameter message:    内容
    - parameter sourceView: UIView
    - parameter actions:    【UIAlertController】
    
    - returns: UIAlertController
    */
    public class func actionSheet(title: String, message: String, sourceView: UIView, actions: [UIAlertAction]) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.ActionSheet)
        for action in actions {
            alert.addAction(action)
        }
        alert.popoverPresentationController?.sourceView = sourceView
        alert.popoverPresentationController?.sourceRect = sourceView.bounds
        instance.topMostController()?.presentViewController(alert, animated: true, completion: nil)
        return alert
    }
    
    public class func actionSheet(title: String, message: String, sourceView: UIView, buttons:[String], tapBlock:((UIAlertAction,Int) -> Void)?) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet, buttons: buttons, tapBlock: tapBlock)
        alert.popoverPresentationController?.sourceView = sourceView
        alert.popoverPresentationController?.sourceRect = sourceView.bounds
        instance.topMostController()?.presentViewController(alert, animated: true, completion: nil)
        return alert
    }
    
}


private extension UIAlertController {
    convenience init(title: String?, message: String?, preferredStyle: UIAlertControllerStyle, buttons:[String], tapBlock:((UIAlertAction,Int) -> Void)?) {
        self.init(title: title, message: message, preferredStyle:preferredStyle)
        var buttonIndex = 0
        for buttonTitle in buttons {
            let action = UIAlertAction(title: buttonTitle, preferredStyle: .Default, buttonIndex: buttonIndex, tapBlock: tapBlock)
            buttonIndex++
            self.addAction(action)
        }
    }
}

private extension UIAlertAction {
    convenience init(title: String?, preferredStyle: UIAlertActionStyle, buttonIndex:Int, tapBlock:((UIAlertAction,Int) -> Void)?) {
        self.init(title: title, style: style) {
            (action:UIAlertAction) in
            if let block = tapBlock {
                block(action,buttonIndex)
            }
        }
    }
}
