//
//  GoodSpecialPriceViewController.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/2/23.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
/// 商品特价
class  GoodSpecialPriceViewController:BaseViewController{
    //1特价 3促销
    var flag:Int?
    /// 销量
    var salesVC=GoodSpecialPriceSalesViewController()
    /// 价格
    var priceVC=GoodSpecialPriceUpriceViewController()
    
    var skScNavC:SKScNavViewController?
    
    /// 遮罩层
    var maskView:UIView?
    
    /// 弹出view
    var alertView:UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        if flag == 1{
            self.title="特价商品"
        }else{
            self.title="促销商品"
        }
        self.view.backgroundColor=UIColor.whiteColor()
        buildView(0)
        
        
    }
    /**
     加载页面
     
     - parameter categoryId: 分类id
     */
    func buildView(categoryId:Int){
        salesVC.title="销量"
        salesVC.flag=flag
        salesVC.categoryId=categoryId
        priceVC.title="价格"
        priceVC.flag=flag
        priceVC.categoryId=categoryId
        skScNavC=nil
        skScNavC=SKScNavViewController(subViewControllers:[salesVC,priceVC])
        skScNavC!.showArrowButton=false
        skScNavC!.addParentController(self)

    }
}