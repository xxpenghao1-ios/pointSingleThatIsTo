//
//  BlacklistViewController.swift
//  pointSingleThatIsTo
//
//  Created by nevermore on 16/1/27.
//  Copyright © 2016年 penghao. All rights reserved.
//

//
//  BlacklistViewController.swift
//  kxkg
//
//  Created by hefeiyue on 15/4/17.
//  Copyright (c) 2015年 奈文魔尔. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
/**黑名单列表*/
class BlacklistViewController:UIViewController {
    var nilView:UIView?
    override func viewDidLoad() {
        super.viewDidLoad();
        self.title="黑名单";
        self.view.backgroundColor=UIColor.whiteColor()
        
        arrNilAddView()
    }
    
    //如果没有数据加载改方法
    func arrNilAddView(){
        nilView=nilPromptView("您还木有拉黑供应商的记录")
        nilView!.center=self.view.center
        self.view.addSubview(nilView!)
    }
    
}