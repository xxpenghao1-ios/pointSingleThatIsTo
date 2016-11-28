//
//  CategoryListController.swift
//  pointSingleThatIsTo
//
//  Created by 卢洋 on 16/1/30.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
//分类
class CategoryListController:BaseViewController{
    // 分类
    //var CategoryVC=CategoryViewController()
    // 品牌
    var BrandVC=BrandViewController()
    // 品项
    var ItemsVC=ItemsViewController()
    //一级分类ID
    var pid:Int?;
    //判断页面从首页传过来还是底部工具栏(1-首页，其他从底部传过来)
    var pushState:Int=0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="分类"
        self.view.backgroundColor=UIColor.whiteColor()
        BrandVC.title="按品牌"
        ItemsVC.title="按品项"
        BrandVC.pid=self.pid
        ItemsVC.pid=self.pid
        
        ItemsVC.pushState=pushState
        BrandVC.pushState=pushState
        let SKNac=SKScNavViewController(subViewControllers:[ItemsVC,BrandVC])
        SKNac.showArrowButton=false
        SKNac.addParentController(self)
    }
    
}