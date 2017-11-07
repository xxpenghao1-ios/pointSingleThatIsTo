//
//  GoodDetailPromotionsDetailView.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/2/20.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
/// 促销活动详情
class GoodDetailPromotionsDetailView:BaseViewController{
    /// 接收传入的活动详情
    var str:String?
    override func viewDidLoad(){
        super.viewDidLoad()
        self.title="促销活动详情"
        self.view.backgroundColor=UIColor.white
        let lblStr=UILabel()
        lblStr.text=str
        lblStr.font=UIFont.systemFont(ofSize: 15)
        lblStr.textColor=UIColor.applicationMainColor()
        lblStr.numberOfLines=0
        lblStr.lineBreakMode=NSLineBreakMode.byWordWrapping
        let size=lblStr.text!.textSizeWithFont(lblStr.font, constrainedToSize:CGSize(width: boundsWidth-30,height: 300))
        lblStr.frame=CGRect(x: 15,y:navHeight+20,width: boundsWidth-30,height: size.height)
        self.view.addSubview(lblStr)
        
        
    }
}
