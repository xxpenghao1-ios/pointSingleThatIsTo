//
//  UIAlertController.swift
//  kxkg
//
//  Created by hefeiyue on 15/1/12.
//  Copyright (c) 2015年 奈文魔尔. All rights reserved.
//

import Foundation
import UIKit


//extension UIAlertController {
//    class func showAlertYes(
//        presentController: UIViewController!,
//        title: String!,
//        message: String!,
//        okButtonTitle: String?) {
//            let alert = UIAlertController(title: title!, message: message!, preferredStyle: UIAlertControllerStyle.Alert)
//            if (okButtonTitle != nil) {
//                alert.addAction(UIAlertAction(title: okButtonTitle!, style: UIAlertActionStyle.Default, handler: nil))
//            }
//            
//            presentController!.presentViewController(alert, animated: true, completion: nil)
//    }
//    
//    class func showAlertYes(
//        presentController: UIViewController!,
//        title: String!,
//        message: String!,
//        okButtonTitle: String? ,
//        okHandler: ((UIAlertAction!) -> Void)!) {
//            let alert = UIAlertController(title: title!, message: message!, preferredStyle: UIAlertControllerStyle.Alert)
//            if (okButtonTitle != nil) {
//                alert.addAction(UIAlertAction(title: okButtonTitle!, style: UIAlertActionStyle.Default, handler: okHandler))
//            }
//            
//            presentController!.presentViewController(alert, animated: true, completion: nil)
//    }
//    class func showAlertYesNo(
//        presentController: UIViewController!,
//        title: String!,
//        message: String!,
//        cancelButtonTitle: String?,
//        okButtonTitle: String?) {
//            let alert = UIAlertController(title: title!, message: message!, preferredStyle: UIAlertControllerStyle.Alert)
//            if (cancelButtonTitle != nil) {
//                alert.addAction(UIAlertAction(title: cancelButtonTitle!, style: UIAlertActionStyle.Default, handler: nil))
//            }
//            if (okButtonTitle != nil) {
//                alert.addAction(UIAlertAction(title: okButtonTitle!, style: UIAlertActionStyle.Default, handler: nil))
//            }
//            
//            presentController!.presentViewController(alert, animated: true, completion: nil)
//    }
//    
//    class func showAlertYesNo(
//        presentController: UIViewController!,
//        title: String!,
//        message: String!,
//        cancelButtonTitle: String? ,
//        okButtonTitle: String? ,
//        okHandler: ((UIAlertAction!) -> Void)!) {
//            let alert = UIAlertController(title: title!, message: message!, preferredStyle: UIAlertControllerStyle.Alert)
//            if (cancelButtonTitle != nil) {
//                alert.addAction(UIAlertAction(title: cancelButtonTitle!, style: UIAlertActionStyle.Default, handler: nil))            }
//            if (okButtonTitle != nil) {
//                alert.addAction(UIAlertAction(title: okButtonTitle!, style: UIAlertActionStyle.Default, handler: okHandler))            }
//            
//            presentController!.presentViewController(alert, animated: true, completion: nil)
//    }
//}
