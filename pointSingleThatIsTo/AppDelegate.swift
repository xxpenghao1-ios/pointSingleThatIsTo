//
//  AppDelegate.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/1/14.
//  Copyright © 2016年 penghao. All rights reserved.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift
import SVProgressHUD
import SwiftyJSON
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    var window: UIWindow?
    /// 登录页面
    var navLogin:UINavigationController?
    /// 主页面
    var tab:UITabBarController?
    //程序入口
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        BaiduMobStat.default().start(withAppId:"ec2fbe36a3")
        BaiduMobStat.default().enableDebugOn=true
        JPUSHService.setDebugMode()
        //监听极光推送自定义消息(只有在前端运行的时候才能收到自定义消息的推送。)
        NotificationCenter.default.addObserver(self, selector:#selector(networkDidReceiveMessage), name:NSNotification.Name.jpfNetworkDidReceiveMessage, object:nil)
        //开启键盘框架
        IQKeyboardManager.sharedManager().enable = true
        //设置导航栏的各种状态
        setUpNav()
        //开启极光推送
        PHJPushHelper.setupWithOptions(launchOptions:launchOptions,delegate:self)
        //关闭极光推送打印
        JPUSHService.setLogOFF()
        //初始化登录页面
        navLogin=UINavigationController(rootViewController:LoginViewController())
        
        if IS_NIL_MEMBERID() == nil{//判断会员id是否为空 如果为空进入程序 需要登录
            self.window?.rootViewController=navLogin
        }else{
            //初始化主页面
            tab=TabBarViewController()
            self.window?.rootViewController=tab
            login()
        }
        //设置菊花图默认前景色和背景色
        SVProgressHUD.setForegroundColor(UIColor(white: 1, alpha: 1))
        SVProgressHUD.setBackgroundColor(UIColor(white: 0.15, alpha: 0.85))
        
        //self.window?.rootViewController=navLogin
        return true
    }
//    /**
//     版本更新
//     */
//    func setupSiren() {
//        
//        
//        
//        // Required
//        siren.appID="1078070211" // For this example, we're using the iTunes Connect App (https://itunes.apple.com/us/app/itunes-connect/id1078070211?mt=8)
//        // Optional
//        siren.debugEnabled = false
//        
//        siren.appName="点单即到店铺版"
//        
//        // Optional - Defaults to .Option
//        //        siren.alertType = .Option // or .Force, .Skip, .None
//        
//        // Optional - Can set differentiated Alerts for Major, Minor, Patch, and Revision Updates (Must be called AFTER siren.alertType, if you are using siren.alertType)
//        siren.majorUpdateAlertType = .Option
//        siren.minorUpdateAlertType = .Option
//        siren.patchUpdateAlertType = .Option
//        siren.revisionUpdateAlertType = .Option
//        
//        // Optional - Sets all messages to appear in Spanish. Siren supports many other languages, not just English and Spanish.
//        //        siren.forceLanguageLocalization = .Spanish
//        
//        // Required
//        siren.checkVersion(.Immediately)
//    }
    


    /**
     设置导航栏的各种状态
     */
    func setUpNav(){
        //导航栏背景色
        UINavigationBar.appearance().barTintColor=UIColor.applicationMainColor();
        //导航栏文字颜色
        UINavigationBar.appearance().titleTextAttributes=NSDictionary(object:UIColor.white, forKey:NSAttributedStringKey.foregroundColor as NSCopying) as? [NSAttributedStringKey : Any];
        UINavigationBar.appearance().tintColor=UIColor.white
//        //将返回按钮的文字position设置不在屏幕上显示
//        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(CGFloat(NSInteger.min),CGFloat(NSInteger.min)), for:UIBarMetrics.default)
        //改变状态栏的颜色
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent;
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //设备标识是NSdata通过截取字符串去掉空格获得字符串保存进缓存 登录发给服务器 用于控制用户只能在一台设备登录
        let characterSet: CharacterSet = CharacterSet(charactersIn: "<>")
        let deviceTokenString: String = (deviceToken.description as NSString)
            .trimmingCharacters(in: characterSet)
            .replacingOccurrences(of: " ", with: "") as String
        //把截取的设备令牌保存进缓存
        UserDefaults.standard.set(deviceTokenString, forKey:"deviceToken")
        //写入磁盘
        UserDefaults.standard.synchronize()
        //在appdelegate注册设备处调用
        JPUSHService.registerDeviceToken(deviceToken)
        
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        //处理收到的 APNs 消息
         JPUSHService.handleRemoteNotification(userInfo)
    }
    //接收通知消息
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //处理收到的 APNs 消息
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(.newData)
        //转换为json
        let jsonObject=JSON(userInfo);
        //取出推送内容
        var aps=jsonObject["aps"]
        let pushReason=jsonObject["pushReason"].intValue;
        let alert=aps["alert"].stringValue;
        if(application.applicationState == UIApplicationState.active){//如果程序活动在前台
            if pushReason != 0{
                systemMessage(alert)
            }
        }else{//如果程序运行在后台
            if pushReason != 0{//进来直接跳转到订单页面
                NotificationCenter.default.post(name: Notification.Name(rawValue: "postPersonalCenter"), object:5, userInfo:nil)
            }
        }
        /**
        发送通知 在UITabBarController更新个人中心的角标
        */
        NotificationCenter.default.post(name: Notification.Name(rawValue: "postPersonalCenter"), object:1, userInfo:nil)
    }
    /**
     系统消息
     
     - parameter alert:内容
     */
    func systemMessage(_ alert:String){
        let alert=UIAlertController(title:"点单即到",message:alert, preferredStyle: UIAlertControllerStyle.alert)
        let cancel=UIAlertAction(title:"取消", style: UIAlertActionStyle.cancel, handler:nil)
        let ok=UIAlertAction(title:"前往个人中心查看", style: UIAlertActionStyle.default, handler:{ Void in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "postPersonalCenter"), object:5, userInfo:nil)
        })
        alert.addAction(cancel)
        alert.addAction(ok)
        self.window?.rootViewController!.present(alert, animated:true, completion:nil)
    }
    //当一个运行着的应用程序收到一个远程的通知 发送到委托去...
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        let memberId=IS_NIL_MEMBERID()
        if memberId != nil{
            isUser(memberId!)
        }
//        JPUSHService.resetBadge();
        application.applicationIconBadgeNumber=0;
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }


    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    /**
     判断用户是否已经被别人登录
     
     - parameter memberId:会员Id
     */
    func isUser(_ memberId:String){
        Alamofire.request(URL+"MemberDeviceVerification.xhtml",method:.get, parameters:["memberId":memberId])
            .responseJSON { response in
                if response.result.error != nil{
                }
                if response.result.value != nil{
                    let json=JSON(response.result.value!)
                    //设备令牌
                    let deviceToken=json["deviceToken"].stringValue;
                    //登录时间
                    let loginTime=json["loginTime"].stringValue;
                    //设备名称
                    let deviceName=json["deviceName"].stringValue;
                    
                    if deviceToken != "penghao"{//如果用户在打开app没有选择接收通知 直接在登录界面 给服务器传入了默认值(penghao) 不等于表示 用户开启了消息通知
                        if deviceToken != userDefaults.object(forKey:"deviceToken") as? String{//判断服务器返回的设备标识与当前本机的缓存中的设备标识是否相等  如果不等于表示该账号在另一台设备在登录
                            //直接跳转到登录页面
                            self.window?.rootViewController=self.navLogin
                            userDefaults.removeObject(forKey: "memberId")
                            let alert=UIAlertController(title:"重新登录", message:"您的账号于\(loginTime)在另一台设备\(deviceName)上登录。如非本人操作,则密码可能已泄露,建议您重新设置密码,以确保数据安全。", preferredStyle: UIAlertControllerStyle.alert)
                            let ok=UIAlertAction(title:"确定", style: UIAlertActionStyle.default, handler:{ Void
                                in//点击确定 清除推送别名
                                JPUSHService.deleteAlias(nil, seq:11)
                                JPUSHService.setTags([],completion: nil,seq:22)
                                
                            })
                            alert.addAction(ok)
                            self.window?.rootViewController?.present(alert, animated:true, completion:nil)
                            
                        }
                    }
            }
        }
    }
    /**
     登录(后台要求这么做)
     */
    func login(){
        let memberName=userDefaults.object(forKey: "memberName") as! String
        let password=userDefaults.object(forKey: "password") as! String
        /// 获取缓存中的唯一表示
        var str=UserDefaults.standard.object(forKey: "deviceToken") as? String
        if str == nil{//如果为空 直接付默认值
            str="penghao"
        }
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.login(memberName: memberName, password: password, deviceToken:str!, deviceName:UIDevice().name, flag: 1), successClosure: { (result) -> Void in
            print(result)
            }) { (errorMsg) -> Void in
                
        }
    }
    deinit{
        NotificationCenter.default.removeObserver(self)
    }

}
// MARK: - 实现极光推送协议
extension AppDelegate:JPUSHRegisterDelegate{
    ///用户点击通知栏进入app执行
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userInfo=response.notification.request.content.userInfo
        if (response.notification.request.trigger?.isKind(of:UNPushNotificationTrigger.classForCoder()))!{
            JPUSHService.handleRemoteNotification(userInfo)
            //转换为json
            let jsonObject=JSON(userInfo);
            let pushReason=jsonObject["pushReason"].intValue;
            if pushReason != 0{//进来直接跳转到订单页面
                NotificationCenter.default.post(name: Notification.Name(rawValue: "postPersonalCenter"), object:5, userInfo:nil)
            }
            /**
             发送通知 在UITabBarController更新个人中心的角标
             */
            NotificationCenter.default.post(name: Notification.Name(rawValue: "postPersonalCenter"), object:1, userInfo:nil)
        }
        completionHandler()
    }
    ///用户在前台接收到推送消息执行
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo=notification.request.content.userInfo
        if (notification.request.trigger?.isKind(of:UNPushNotificationTrigger.classForCoder()))!{
            JPUSHService.handleRemoteNotification(userInfo)
            //转换为json
            let jsonObject=JSON(userInfo);
            //取出推送内容
            var aps=jsonObject["aps"]
            let pushReason=jsonObject["pushReason"].intValue;
            let alert=aps["alert"].stringValue;
            if pushReason != 0{
                systemMessage(alert)
            }
            /**
             发送通知 在UITabBarController更新个人中心的角标
             */
            NotificationCenter.default.post(name: Notification.Name(rawValue: "postPersonalCenter"), object:1, userInfo:nil)
        }
    }
    
}
// MARK: - 极光推送自定义消息监听
extension AppDelegate{
    @objc func networkDidReceiveMessage(_ notification:Notification){
        let userInfo=notification.userInfo
        if userInfo != nil{
            let json=JSON(userInfo!)
            let nmoreMessage=json["extras"]["nmoreMessage"].intValue
            if nmoreMessage == 3{//如果为3 表示该账号在其他设备登录
                let memberId=IS_NIL_MEMBERID()
                if memberId != nil{
                    isUser(memberId!)
                }else{
                    
                }
            }
            else{
                
            }
        }
    }
}

