//
//  IRecommendViewControllerAgain.swift
//  pointSingleThatIsTo
//
//  Created by nevermore on 16/2/20.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class IRecommendViewControllerAgain:BaseViewController{
    
    /// 接收请求数据的集合（推荐人）
    var IREntity=IRecommendEntity()
    
    /// 绑定时间
    var bindingRecommendedTime:UILabel?
    
    
    /// bei推荐的人
    var recommendedMemberName:UILabel?
    
    /// 推荐人二维码图片
    var recommendedQrcode:UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置页面标题
        self.title="我推荐的人"
        //设置页面背景色
        self.view.backgroundColor=UIColor.whiteColor()
        
        uiinit()
    }
    //UI布局
    func uiinit(){
        /// bei推荐的人
        recommendedMemberName=UILabel()
        recommendedMemberName?.frame=CGRectMake(0, 120, boundsWidth, 20)
        recommendedMemberName?.textAlignment=NSTextAlignment.Center
        recommendedMemberName?.font=UIFont.systemFontOfSize(14)
        recommendedMemberName?.text="被推荐的人：\(IREntity.recommendedMemberName!)"
        self.view.addSubview(recommendedMemberName!)
        /// 推荐人二维码图片
        recommendedQrcode=UIImageView()
        recommendedQrcode?.sd_setImageWithURL(NSURL(string: URLIMG+IREntity.recommendedQrcode!))
        recommendedQrcode?.frame=CGRectMake(boundsWidth/5, CGRectGetMaxY(recommendedMemberName!.frame)+5, boundsWidth*3/5, boundsWidth*3/5)
        self.view.addSubview(recommendedQrcode!)
        /// 绑定时间
        bindingRecommendedTime=UILabel()
        bindingRecommendedTime?.textAlignment=NSTextAlignment.Center
        bindingRecommendedTime?.frame=CGRectMake(0, CGRectGetMaxY(recommendedQrcode!.frame)+5, boundsWidth, 20)
        bindingRecommendedTime?.text="绑定时间：\(IREntity.bindingRecommendedTime!)"
        bindingRecommendedTime?.font=UIFont.systemFontOfSize(14)
        self.view.addSubview(bindingRecommendedTime!)
    }
    
}
