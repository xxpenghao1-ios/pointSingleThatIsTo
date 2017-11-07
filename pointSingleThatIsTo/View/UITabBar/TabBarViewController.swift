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
import SwiftyJSON
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
//        //我要抢单
//        addChildViewController(GrabASingleViewController(), title: "我要抢单", imageName: "2")
        //分类
        addChildViewController(CategoryListController(), title: "分类", imageName: "2")
        //购物车
        addChildViewController(shoppingCarView, title: "购物车", imageName: "3")
        //个人中心
        addChildViewController(personalCenterView, title: "个人中心", imageName: "4")
        self.tabBar.backgroundColor=UIColor.clear
        let viewImg=UIView(frame:CGRect(x: 0,y: 0,width: UIScreen.main.bounds.width, height: 49))
        viewImg.backgroundColor=UIColor.black
        self.tabBar.insertSubview(viewImg, at:0)
        self.tabBar.isOpaque=true
        self.tabBar.tintColor=UIColor.applicationMainColor()
        
        //设置购物车角标
        setBadgeValue()
        //接收通知 更新购物车角标
        NotificationCenter.default.addObserver(self, selector:#selector(updateBadgeValue), name:NSNotification.Name(rawValue: "postBadgeValue"), object:nil)
        //更新个人中心角标
        NotificationCenter.default.addObserver(self, selector:#selector(updatePersonalCenter), name:NSNotification.Name(rawValue: "postPersonalCenter"), object: nil)
        
     }
    /// 个人中心角标总数
    var sumCount=0
    /**
     收到通知更新角标
     
     - parameter notification:NSNotification
     */
    @objc func updatePersonalCenter(_ notification:Notification){
        let obj=notification.object as! Int
        if obj == 1{//表示角标数值累加
            sumCount+=obj
            self.personalCenterView.tabBarItem.badgeValue="\(sumCount)"
        }else if obj == 5{//切换到个人中心
            self.selectedIndex=3
        }else{//清空角标数值
            self.personalCenterView.tabBarItem.badgeValue=nil
            sumCount=0
        }
    }
    /**
     收到通知更新角标
     
     - parameter notification:NSNotification
     */
    @objc func updateBadgeValue(_ notification:Notification){
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
        request(URL+"memberShoppingCarCountForMobile.xhtml",method:.get ,parameters:["memberId":memberId!]).responseJSON{ response in
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
    fileprivate func addChildViewController(_ childController: UIViewController, title:String?, imageName:String) {
        
        // 1.设置子控制器对应的数据
        childController.tabBarItem.image = UIImage(named:imageName)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        childController.tabBarItem.selectedImage = UIImage(named:"selected"+imageName)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        
        // 2.设置底部工具栏标题
        childController.tabBarItem.title=title
        
        // 3.给子控制器包装一个导航控制器
        let nav = UINavigationController()
        nav.addChildViewController(childController)
        
        // 4.将子控制器添加到当前控制器上
        addChildViewController(nav)
    }
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
}
