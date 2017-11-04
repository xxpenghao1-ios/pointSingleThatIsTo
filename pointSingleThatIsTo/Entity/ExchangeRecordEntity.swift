//
//  ExchangeRecordEntity.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/7/29.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import ObjectMapper
/// 兑换记录entity
class ExchangeRecordEntity:Mappable{
    /// 商品名称
    var goodsName:String?
    /// 商品状态
    var exchangeStatu:Int?
    /// 图片路径
    var goodsPic:String?
    /// 时间
    var addTime:String?
    /// 兑换数量
    var exchangeCount:Int?
    required init?(map: Map) {
        mapping(map:map)
    }
    func mapping(map: Map) {
        goodsName <- map["goodsName"]
        exchangeStatu <- map["exchangeStatu"]
        goodsPic <- map["goodsPic"]
        addTime <- map["addTime"]
        exchangeCount <- map["exchangeCount"]
    }
}
