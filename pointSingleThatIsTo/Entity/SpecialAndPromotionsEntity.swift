//
//  SpecialAndPromotionsEntity.swift
//  pointSingleThatIsTo
//
//  Created by hao peng on 2017/3/20.
//  Copyright © 2017年 penghao. All rights reserved.
//

import Foundation
import ObjectMapper
/// 特价与促销图片
class SpecialAndPromotionsEntity:Mappable{
    ///标识是特价还是促销(3特价2,促销)
    var mobileOrPc:Int?
    //图片路径
    var advertisingURL:String?
    required init?(map: Map) {
        mapping(map: map)
    }
    func mapping(map: Map) {
        mobileOrPc <- map["mobileOrPc"]
        advertisingURL <- map["advertisingURL"]
    }
}
