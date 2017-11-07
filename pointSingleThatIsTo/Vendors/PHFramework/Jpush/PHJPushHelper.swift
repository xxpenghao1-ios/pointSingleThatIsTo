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
let APS_FOR_PRODUCTION=true
/// 集成极光推送
class PHJPushHelper:NSObject{
    /**
     在应用启动的时候调用
     
     - parameter launchOptions:需要传入[UIApplicationLaunchOptionsKey:Any]
     */
    
    class func setupWithOptions(launchOptions:[UIApplicationLaunchOptionsKey:Any]?,delegate:JPUSHRegisterDelegate){
        if #available(iOS 10.0, *){
            let entiity = JPUSHRegisterEntity()
            entiity.types = Int(UNAuthorizationOptions.alert.rawValue |
                UNAuthorizationOptions.badge.rawValue |
                UNAuthorizationOptions.sound.rawValue)
            JPUSHService.register(forRemoteNotificationConfig: entiity, delegate:delegate)
        }else if #available(iOS 8.0, *) {
            let types = UIUserNotificationType.badge.rawValue |
                UIUserNotificationType.sound.rawValue |
                UIUserNotificationType.alert.rawValue
            JPUSHService.register(forRemoteNotificationTypes: types, categories: nil)
        }else {
            let type = UIRemoteNotificationType.badge.rawValue |
                UIRemoteNotificationType.sound.rawValue |
                UIRemoteNotificationType.alert.rawValue
            JPUSHService.register(forRemoteNotificationTypes: type, categories: nil)
        }
        JPUSHService.setup(withOption:launchOptions, appKey:"5d41be0ff7738eb9a5d3bff0", channel:"ddjd", apsForProduction:APS_FOR_PRODUCTION)
    }
    
}

