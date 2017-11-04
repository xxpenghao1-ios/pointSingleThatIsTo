//
//  IRecommendEntity.swift
//  pointSingleThatIsTo
//
//  Created by nevermore on 16/2/20.
//  Copyright © 2016年 penghao. All rights reserved.
//

import ObjectMapper
import Foundation


class IRecommendEntity:Mappable {
    
    /// 绑定时间
    var bindingRecommendedTime:String?
    
    /// 推荐人ID
    var recommendedMemberId:Int?
    /// bei推荐的人
    var recommendedMemberName:String?
    
    /// 推荐人二维码图片
    var recommendedQrcode:String?
    
    init(){}
    required init?(map: Map) {
        mapping(map: map)
    }
    func mapping(map: Map) {
        bindingRecommendedTime <- map["bindingRecommendedTime"]
        recommendedMemberId <- map["recommendedMemberId"]
        recommendedMemberName <- map["recommendedMemberName"]
        recommendedQrcode <- map["recommendedQrcode"]
        
    }
    
    
}
