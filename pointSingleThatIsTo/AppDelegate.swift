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
import Siren
import XCGLogger
import RealReachability

/// 设置全局log打印对象
let log: XCGLogger = {
    let log = XCGLogger.defaultInstance()
    log.setup(.Debug, showThreadName: true, showLogLevel: true, showFileNames: true, showLineNumbers: true, writeToFile:nil)
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd hh:mma"
    dateFormatter.locale = NSLocale.currentLocale()
    log.dateFormatter = dateFormatter
    
    //使用XCGLogger记录日志 begin
    log.xcodeColorsEnabled = true // Or set the XcodeColors environment variable in your scheme to YES
    log.xcodeColors = [
        .Verbose: .lightGrey,
        .Debug: .darkGrey,
        .Info: .darkGreen,
        .Warning: .orange,
        .Error: XCGLogger.XcodeColor(fg: UIColor.redColor(), bg: UIColor.whiteColor()), // Optionally use a UIColor
        .Severe: XCGLogger.XcodeColor(fg: (255, 255, 255), bg: (255, 0, 0)) // Optionally use RGB values directly
    ]
    //使用XCGLogger记录日志 end
    
    return log
}()
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,BMKGeneralDelegate{
    var window: UIWindow?
    /// 登录页面
    var navLogin:UINavigationController?
    /// 主页面
    var tab:UITabBarController?
    /// 百度地图
    var mapManager: BMKMapManager?
    //程序入口
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        mapManager = BMKMapManager()
        // 如果要关注网络及授权验证事件，请设定generalDelegate参数
        let ret = mapManager?.start("zUKLMiVbDlWfOj7o5vcY3m4XG2E9u3XN", generalDelegate:self)
        if ret == true {
            log.info("连接百度地图成功")
        }
//        JPUSHService.setDebugMode()
        //监听极光推送自定义消息(只有在前端运行的时候才能收到自定义消息的推送。)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"networkDidReceiveMessage:", name:kJPFNetworkDidReceiveMessageNotification, object:nil)
        //开启网络状况的监听
        RealReachability.sharedInstance().startNotifier()
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"reachabilityChanged:", name:kRealReachabilityChangedNotification, object:nil)
        //检查版本更新
        setupSiren()
        //开启键盘框架
        IQKeyboardManager.sharedManager().enable = true
        //设置导航栏的各种状态
        setUpNav()
        //启动极光推送
        PHJPushHelper.setupWithOptions(launchOptions)
        
        //初始化登录页面
        navLogin=UINavigationController(rootViewController:storyboardPushView("LoginId") as! LoginViewController)
        // 得到当前应用的版本号
        let infoDictionary = NSBundle.mainBundle().infoDictionary
        let currentAppVersion = infoDictionary!["CFBundleShortVersionString"] as! String
        // 取出之前保存的版本号
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let appVersion = userDefaults.stringForKey("appVersion")
        
        // 如果 appVersion 为 nil 说明是第一次启动；如果 appVersion 不等于 currentAppVersion 说明是更新了
        if appVersion == nil || appVersion != currentAppVersion {
            // 保存最新的版本号
            userDefaults.setValue(currentAppVersion, forKey: "appVersion")
            let helpNav=UINavigationController(rootViewController: ViewController())
            //设置根视图
            self.window!.rootViewController=helpNav
        }else{
            if IS_NIL_MEMBERID() == nil{//判断会员id是否为空 如果为空进入程序 需要登录
                self.window?.rootViewController=navLogin
            }else{
                //初始化主页面
                tab=TabBarViewController()
                self.window?.rootViewController=tab
                }
        }
        //设置菊花图默认前景色和背景色
        SVProgressHUD.setForegroundColor(UIColor(white: 1, alpha: 1))
        SVProgressHUD.setBackgroundColor(UIColor(white: 0.15, alpha: 0.85))
        
        //self.window?.rootViewController=navLogin
        return true
    }
    /**
     版本更新
     */
    func setupSiren() {
        let siren = Siren.sharedInstance
        
        // Required
        siren.appID="1078070211" // For this example, we're using the iTunes Connect App (https://itunes.apple.com/us/app/itunes-connect/id1078070211?mt=8)
        // Optional
        siren.delegate = self
        
        // Optional
        siren.debugEnabled = false
        
        siren.appName="点单即到"
        
        // Optional - Defaults to .Option
        //        siren.alertType = .Option // or .Force, .Skip, .None
        
        // Optional - Can set differentiated Alerts for Major, Minor, Patch, and Revision Updates (Must be called AFTER siren.alertType, if you are using siren.alertType)
        siren.majorUpdateAlertType = .Option
        siren.minorUpdateAlertType = .Option
        siren.patchUpdateAlertType = .Option
        siren.revisionUpdateAlertType = .Option
        
        // Optional - Sets all messages to appear in Spanish. Siren supports many other languages, not just English and Spanish.
        //        siren.forceLanguageLocalization = .Spanish
        
        // Required
        siren.checkVersion(.Immediately)
    }
    


    /**
     设置导航栏的各种状态
     */
    func setUpNav(){
        //导航栏背景色
        UINavigationBar.appearance().barTintColor=UIColor.applicationMainColor();
        //导航栏文字颜色
        UINavigationBar.appearance().titleTextAttributes=NSDictionary(object:UIColor.whiteColor(), forKey:NSForegroundColorAttributeName) as? [String : AnyObject];
        UINavigationBar.appearance().tintColor=UIColor.whiteColor()
        //将返回按钮的文字position设置不在屏幕上显示
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(CGFloat(NSInteger.min),CGFloat(NSInteger.min)), forBarMetrics:UIBarMetrics.Default)
        //改变状态栏的颜色
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent;
    }
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        //设备标识是NSdata通过截取字符串去掉空格获得字符串保存进缓存 登录发给服务器 用于控制用户只能在一台设备登录
        let characterSet: NSCharacterSet = NSCharacterSet(charactersInString: "<>")
        let deviceTokenString: String = (deviceToken.description as NSString)
            .stringByTrimmingCharactersInSet(characterSet)
            .stringByReplacingOccurrencesOfString(" ", withString: "") as String
        //把截取的设备令牌保存进缓存
        NSUserDefaults.standardUserDefaults().setObject(deviceTokenString, forKey:"deviceToken")
        //写入磁盘
        NSUserDefaults.standardUserDefaults().synchronize()
        //在appdelegate注册设备处调用
        PHJPushHelper.registerDeviceToken(deviceToken)
        
    }
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        //处理收到的 APNs 消息
        PHJPushHelper.handleRemoteNotification(userInfo,completion: nil)
    }
    //接收通知消息
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        //转换为json
        let jsonObject=JSON(userInfo);
        //取出推送内容
        var aps=jsonObject["aps"]
        let pushReason=jsonObject["pushReason"].intValue;
        let alert=aps["alert"].stringValue;
        //处理收到的 APNs 消息
        PHJPushHelper.handleRemoteNotification(userInfo, completion:completionHandler)
        if(application.applicationState == UIApplicationState.Active){//如果程序活动在前台
            if pushReason != 0{
                systemMessage(alert)
            }
             
        }else{//如果程序运行在后台
            if pushReason != 0{//进来直接跳转到订单页面
                tab?.selectedIndex=4
            }
        }
        /**
        发送通知 在UITabBarController更新个人中心的角标
        */
        NSNotificationCenter.defaultCenter().postNotificationName("postPersonalCenter", object:1, userInfo:nil)
    }
    /**
     系统消息
     
     - parameter alert:内容
     */
    func systemMessage(alert:String){
        let alert=UIAlertController(title:"点单即到",message:alert, preferredStyle: UIAlertControllerStyle.Alert)
        let cancel=UIAlertAction(title:"取消", style: UIAlertActionStyle.Cancel, handler:nil)
        let ok=UIAlertAction(title:"前往个人中心查看", style: UIAlertActionStyle.Default, handler:{ Void in
            self.tab?.selectedIndex=4
        })
        alert.addAction(cancel)
        alert.addAction(ok)
        self.window?.rootViewController!.presentViewController(alert, animated:true, completion:nil)
    }
    //当一个运行着的应用程序收到一个远程的通知 发送到委托去...
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        //显示本地通知在最前面
        PHJPushHelper.showLocalNotificationAtFront(notification)
    }


    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        /**
            版本检查每次启动应用程序执行Immediately
            版本检查每天执行一次 Daily
            版本检查每周执行一次Weekly
        */
        Siren.sharedInstance.checkVersion(.Immediately)
    }

    func applicationDidBecomeActive(application: UIApplication) {
        let memberId=IS_NIL_MEMBERID()
        if memberId != nil{
            isUser(memberId!)
        }
        JPUSHService.resetBadge();
        application.applicationIconBadgeNumber=0;
        /**
        版本检查每次启动应用程序执行Immediately
        版本检查每天执行一次 Daily
        版本检查每周执行一次Weekly
        */
        Siren.sharedInstance.checkVersion(.Daily)
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }


    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    /**
     判断用户是否已经被别人登录
     
     - parameter memberId:会员Id
     */
    func isUser(memberId:String){
        Alamofire.request(.GET,URL+"MemberDeviceVerification.xhtml", parameters:["memberId":memberId])
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
                        if deviceToken != NSUserDefaults.standardUserDefaults().objectForKey("deviceToken") as! String{//判断服务器返回的设备标识与当前本机的缓存中的设备标识是否相等  如果不等于表示该账号在另一台设备在登录
                            //直接跳转到登录页面
                            self.window?.rootViewController=self.navLogin
                            userDefaults.removeObjectForKey("memberId")
                            let alert=UIAlertController(title:"重新登录", message:"您的账号于\(loginTime)在另一台设备\(deviceName)上登录。如非本人操作,则密码可能已泄露,建议您重新设置密码,以确保数据安全。", preferredStyle: UIAlertControllerStyle.Alert)
                            let ok=UIAlertAction(title:"确定", style: UIAlertActionStyle.Default, handler:{ Void
                                in//点击确定 清除推送别名
                                JPUSHService.setAlias("",callbackSelector:nil, object:nil)
                                JPUSHService.setTags([], callbackSelector:nil, object:nil)
                                
                            })
                            alert.addAction(ok)
                            self.window?.rootViewController?.presentViewController(alert, animated:true, completion:nil)
                            
                        }
                    }
            }
        }
    }
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}
/// MARK: - 版本更新
extension AppDelegate: SirenDelegate
{
    func sirenDidShowUpdateDialog() {
        print("sirenDidShowUpdateDialog")
    }
    
    func sirenUserDidCancel() {
        print("sirenUserDidCancel")
    }
    func sirenUserDidSkipVersion() {
        print("sirenUserDidSkipVersion")
    }
    
    func sirenUserDidLaunchAppStore() {
        print("sirenUserDidLaunchAppStore")
    }
    
    /**
     This delegate method is only hit when alertType is initialized to .None
     */
    func sirenDidDetectNewVersionWithoutAlert(message: String) {
        print("\(message)")
    }
}
// MARK: - 网络实时监控
extension AppDelegate{
    func reachabilityChanged(notification:NSNotification){
        let reachability=notification.object as! RealReachability
        let status=reachability.currentReachabilityStatus()
        log.info("网络:\(status)")
    }
}
// MARK: - 极光推送自定义消息监听
extension AppDelegate{
    func networkDidReceiveMessage(notification:NSNotification){
        let userInfo=notification.userInfo
        if userInfo != nil{
            let json=JSON(userInfo!)
            let nmoreMessage=json["extras"]["nmoreMessage"].intValue
            if nmoreMessage == 3{//如果为3 表示该账号在其他设备登录
                let memberId=IS_NIL_MEMBERID()
                if memberId != nil{
                    isUser(memberId!)
                }else{
                    log.warning("会员id为空")
                }
            }
            else{
                log.warning("极光推送消息userInfo为空\(userInfo)")
            }
        }
    }
}

