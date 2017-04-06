//
//  GoodCategory3ViewController.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/1/27.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
/// 商品3级分类(搜索条件) 3级分类传入flag=2,titleCategoryName,goodsCategoryId,搜索传入flag=1,searchName 促销传入flag=4  5查询1元区商品
class  GoodCategory3ViewController:BaseViewController{
    
    /// 接收传入的状态 1表示搜索 2表示查询3级分类 3表示查询新品推荐 4表示促销
    var flag:Int?
    
    /// 接收传入搜索名称
    var searchName:String?
    
    /// 接收传过来的分类名称
    var titleCategoryName:String?
    
    /// 分类id
    var goodsCategoryId:Int?
    
    /// 销量
    var salesVC=SalesViewController()
    
    /// 价格
    var priceVC=PriceViewController()
    
    /// 按字母排序
    var letterVC=LetterViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if flag == 1{
            self.title=searchName
        }else if flag == 2{
            self.title=titleCategoryName
        }else if flag == 3{
            self.title="新品推荐"
        }else if flag == 4{
            self.title="促销商品"
        }else if flag == 5{
            self.title="1元区"
        }
        self.view.backgroundColor=UIColor.whiteColor()
        /// 获取登录中  保存的县区id 店铺id
        let countyId=NSUserDefaults.standardUserDefaults().objectForKey("countyId") as!String
        let storeId=NSUserDefaults.standardUserDefaults().objectForKey("storeId") as!String
        
        salesVC.title="销量"
        salesVC.countyId=countyId
        salesVC.storeId=storeId
        salesVC.flag=flag
        
        priceVC.title="价格"
        priceVC.countyId=countyId
        priceVC.storeId=storeId
        priceVC.flag=flag
        
        letterVC.title="首字母"
        letterVC.countyId=countyId
        letterVC.storeId=storeId
        letterVC.flag=flag
        
        
        
        var skScNavC:SKScNavViewController?
        if flag == 1{//表示搜索
            salesVC.searchName=searchName
            priceVC.searchName=searchName
            letterVC.searchName=searchName
            skScNavC=SKScNavViewController(subViewControllers:[salesVC,priceVC])
            
        }else if flag == 2{//查询3级分类
            salesVC.goodsCategoryId=goodsCategoryId
            priceVC.goodsCategoryId=goodsCategoryId
            letterVC.goodsCategoryId=goodsCategoryId
            skScNavC=SKScNavViewController(subViewControllers:[letterVC,salesVC,priceVC])
            
        }else if flag == 5{
            salesVC.goodsCategoryId=goodsCategoryId
            priceVC.goodsCategoryId=goodsCategoryId
            letterVC.goodsCategoryId=goodsCategoryId
            skScNavC=SKScNavViewController(subViewControllers:[salesVC,priceVC])
        }else{
            skScNavC=SKScNavViewController(subViewControllers:[salesVC,priceVC])
        }
        skScNavC!.showArrowButton=false
        skScNavC!.addParentController(self)

    }
}