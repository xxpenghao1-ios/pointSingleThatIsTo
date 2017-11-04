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
    //接收分类名称
    var categoryName:String?
    // 分类
    //var CategoryVC=CategoryViewController()
    // 品牌
    fileprivate var BrandVC=BrandViewController()
    // 品项
    fileprivate var ItemsVC=ItemsViewController()
    //一级分类ID
    var pid:Int?;
    //判断页面从首页传过来还是底部工具栏(1-首页，其他从底部传过来)
    var pushState:Int=0
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryName=categoryName ?? "分类"
        self.title=categoryName
        self.view.backgroundColor=UIColor.white
        BrandVC.title="按品牌"
        ItemsVC.title="按品项"
        BrandVC.pid=self.pid
        ItemsVC.pid=self.pid
        ItemsVC.pushState=pushState
        ItemsVC.itemsTitle=categoryName
        BrandVC.pushState=pushState
        let SKNac=SKScNavViewController(subViewControllers:[ItemsVC,BrandVC])
        SKNac.showArrowButton=false
        SKNac.addParentController(self)
        if categoryName == "休闲零食"{
            self.navigationItem.rightBarButtonItem=UIBarButtonItem(title:"1元区", style: UIBarButtonItemStyle.done, target:self, action:"push1yuanqu")
        }
    }
    

    //跳转1元区
    func push1yuanqu(){
        /// 获取对应分类entity
        let GoodCategory3VC=GoodCategory3ViewController()
        GoodCategory3VC.flag=5
        GoodCategory3VC.goodsCategoryId=pid ?? 1
        self.navigationController!.pushViewController(GoodCategory3VC, animated:true)
    }

}
