//
//  PHJPushHelper.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/1/15.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
///填写管理Portal上创建应用后自动生成的AppKey值。请确保应用内配置的 AppKey 与第1步在 Portal 上创建应用后生成的 AppKey 一致。
let APP_KEY="5d41be0ff7738eb9a5d3bff0"
/// 指明应用程序包的下载渠道，为方便分渠道统计，具体值由你自行定义，如：App Store。
let CHANNEL="ddjd"
///false(默认值)表示采用的是开发证书，true表示采用生产证书发布应用。
let APS_FOR_PRODUCTION=false
/// 集成极光推送
class PHJPushHelper:NSObject{
    /**
      在应用启动的时候调用
     
     - parameter launchOptions:需要传入NSDictionary
     */
    
    class func setupWithOptions(launchOptions:[NSObject: AnyObject]?){
        // ios8之后可以自定义category
        if (UIDevice.currentDevice().systemVersion as NSString).floatValue >= 8.0{
            JPUSHService.registerForRemoteNotificationTypes(UIUserNotificationType.Badge.rawValue|UIUserNotificationType.Sound.rawValue|UIUserNotificationType.Alert.rawValue,categories: nil)
        }else{//categories 必须为nil
            JPUSHService.registerForRemoteNotificationTypes(UIUserNotificationType.Badge.rawValue|UIUserNotificationType.Sound.rawValue|UIUserNotificationType.Alert.rawValue,categories: nil)
        }
        JPUSHService.setupWithOption(launchOptions, appKey:APP_KEY, channel:CHANNEL, apsForProduction:APS_FOR_PRODUCTION)
    }
    /**
     
     在appdelegate注册设备处调用
     - parameter deviceToken:设备令牌
     */
    class func registerDeviceToken(deviceToken:NSData){
        JPUSHService.registerDeviceToken(deviceToken)
    }
    /**
     // ios7以后，才有completion，否则传nil
     
     - parameter userInfo:   [NSObject: AnyObject]
     - parameter completion: UIBackgroundFetchResult？
     */
    class func handleRemoteNotification(userInfo:[NSObject: AnyObject],completion:((UIBackgroundFetchResult) -> Void)?){
        JPUSHService.handleRemoteNotification(userInfo)
        if (completion != nil){//如果不等于空调用闭包方法
            completion!(UIBackgroundFetchResult.NewData)
        }
    }
    /**
     显示本地通知在最前面
     
     - parameter notification:实现本地通知对象
     */
    class func showLocalNotificationAtFront(notification:UILocalNotification){
        JPUSHService.showLocalNotificationAtFront(notification, identifierKey:nil)
    }
}

