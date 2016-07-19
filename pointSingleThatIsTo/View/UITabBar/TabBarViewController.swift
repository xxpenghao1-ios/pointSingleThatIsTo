//
//  TabBarViewController.swift
//
//
//  Created by hefeiyue on 15/6/5.
//  Copyright (c) 2015年 奈文魔尔. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class TabBarViewController:UITabBarController {
    
    let shoppingCarView=ShoppingCarViewContorller()
    let personalCenterView=PersonalCenterViewContorller()
    //获取会员id
    let memberId=IS_NIL_MEMBERID()
    /// 保存角标数量
    var count=0
    
    override func viewDidLoad() {
        super.viewDidLoad();
        //首页
        addChildViewController(IndexViewController(), title: "首页", imageName: "1")
        //我要抢单
        addChildViewController(GrabASingleViewController(), title: "我要抢单", imageName: "2")
        //分类
        addChildViewController(CategoryListController(), title: "分类", imageName: "3")
        //购物车
        addChildViewController(shoppingCarView, title: "购物车", imageName: "4")
        //个人中心
        addChildViewController(personalCenterView, title: "个人中心", imageName: "5")
        self.tabBar.backgroundColor=UIColor.clearColor()
        let viewImg=UIView(frame:CGRectMake(0,0,UIScreen.mainScreen().bounds.width, 49))
        viewImg.backgroundColor=UIColor.blackColor()
        self.tabBar.insertSubview(viewImg, atIndex:0)
        self.tabBar.opaque=true
        self.tabBar.tintColor=UIColor.applicationMainColor()
        
        //设置购物车角标
        setBadgeValue()
        //接收通知 更新购物车角标
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"updateBadgeValue:", name:"postBadgeValue", object:nil)
        //更新个人中心角标
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"updatePersonalCenter:", name:"postPersonalCenter", object: nil)
        
     }
    /// 个人中心角标总数
    var sumCount=0
    /**
     收到通知更新角标
     
     - parameter notification:NSNotification
     */
    func updatePersonalCenter(notification:NSNotification){
        let obj=notification.object as! Int
        if obj == 1{//表示角标数值累加
            sumCount+=obj
            self.personalCenterView.tabBarItem.badgeValue="\(sumCount)"
        }else{//清空角标数值
            self.personalCenterView.tabBarItem.badgeValue=nil
            sumCount=0
        }
        /**
        发送通知  通知个人中心小红点是否显示
        */
        NSNotificationCenter.defaultCenter().postNotificationName("postIsHiddenMessageBadgeView", object:sumCount, userInfo:nil)
    }
    /**
     收到通知更新角标
     
     - parameter notification:NSNotification
     */
    func updateBadgeValue(notification:NSNotification){
        if notification.object != nil{
            let obj=notification.object as! Int
            if obj == 1{//读取服务器购物车总数量
                setBadgeValue()
            }else if obj == 2{
                if notification.userInfo != nil{
                    let userInfo=JSON(notification.userInfo!)
                    count+=userInfo["carCount"].intValue
                    self.shoppingCarView.tabBarItem.badgeValue="\(count)"
                }
            }else if obj == 3{
                if notification.userInfo != nil{
                    let userInfo=JSON(notification.userInfo!)
                    count-=userInfo["carCount"].intValue
                    if count == 0{
                       self.shoppingCarView.tabBarItem.badgeValue=nil
                    }else{
                       self.shoppingCarView.tabBarItem.badgeValue="\(count)"
                    }
                    
                }
            }
        }
        
    }
    /**
     设置购物车角标
     */
    func setBadgeValue(){
        request(.GET,URL+"memberShoppingCarCountForMobile.xhtml",parameters:["memberId":memberId!]).responseJSON{ response in
            if response.result.value != nil{
                let json=JSON(response.result.value!)
                let shoppingCount=json["shoppingCount"].intValue
                if shoppingCount == 0{
                    self.shoppingCarView.tabBarItem.badgeValue=nil
                }else{
                    self.shoppingCarView.tabBarItem.badgeValue="\(shoppingCount)"
                }
                self.count=shoppingCount
            }
        }
    }
    /**
    初始化子控制器
    
    - parameter childController: 需要初始化的子控制器
    - parameter title:           子控制器的标题
    - parameter imageName:       子控制器的图片
    */
    private func addChildViewController(childController: UIViewController, title:String?, imageName:String) {
        
        // 1.设置子控制器对应的数据
        childController.tabBarItem.image = UIImage(named:imageName)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        childController.tabBarItem.selectedImage = UIImage(named:"selected"+imageName)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        
        // 2.设置底部工具栏标题
        childController.tabBarItem.title=title
        
        // 3.给子控制器包装一个导航控制器
        let nav = UINavigationController()
        nav.addChildViewController(childController)
        
        // 4.将子控制器添加到当前控制器上
        addChildViewController(nav)
    }
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
