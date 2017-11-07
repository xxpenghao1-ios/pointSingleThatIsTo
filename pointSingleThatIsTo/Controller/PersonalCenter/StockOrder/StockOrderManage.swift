//
//  StockOrderManage.swift
//  pointSingleThatIsTo
//
//  Created by 卢洋 on 16/2/25.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
///进货订单管理
class StockOrderManage:BaseViewController{
    
    /// 1表示导航栏push过来的  2表示推送 直接present过来的
    var flag:Int?
    
    /// 未发货
    var UnDeliverGoodsVC=UnDeliverGoodsViewController()
    /// 已发货
    var DeliverGoodsVC=DeliverGoodsViewController()
    /// 已完成
    var CompletedStockOrderVC=CompletedStockOrderViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.white
        self.title="进货订单"
        UnDeliverGoodsVC.title="未发货"
        DeliverGoodsVC.title="已发货"
        CompletedStockOrderVC.title="已完成"
        let SKScNav=SKScNavViewController(subViewControllers: [UnDeliverGoodsVC,DeliverGoodsVC,CompletedStockOrderVC])
        SKScNav.showArrowButton=false
        SKScNav.addParentController(self)
        if flag == 2{
            self.navigationItem.rightBarButtonItem=UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target:self, action:#selector(cancel))
        }
        
    }
    /**
     关闭页面
     */
    @objc func cancel(){
        self.dismiss(animated: true, completion:nil)
    }

}
