//
//  DrawingRecordViewController.swift
//  pointSingleThatIsTo
//
//  Created by nevermore on 16/1/27.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

/// 已对奖品
class DrawingRecordViewController:UIViewController{
//    /// 兑奖table
//    var DrawingRecordTable:UITableView?
//    /// 创建DrawingRecordEntity类型的空集合
//    var DrawingEntity=NSMutableArray()
//    /// memberId
//    var storeId:String?
//    var Page:Int?
//    var tablefootCount:Int?
    var nilView:UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置页面标题
        self.title="已兑奖品"
        self.view.backgroundColor=UIColor.whiteColor()
        nilView=nilPromptView("没有该信息记录")
        nilView!.center=self.view.center
        self.view.addSubview(nilView!)
        
    }
    
    
}
