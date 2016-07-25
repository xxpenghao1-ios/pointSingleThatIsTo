//
//  IntegralGoodExchangeEntity.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/7/25.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import ObjectMapper
/// 积分商品兑换
class IntegralGoodExchangeEntity:Mappable{
    //商城商品主键ID
    var integralMallId:Int?;
    ///所属分站Id
    var subStationId:Int?;
    ///商品名称
    var goodsName:String?;
    ///商品描述
    var goodsDescribe:String?;
    ///商品图片
    var goodsPic:String?;
    ///添加时间
    var addTime:String?;
    ///兑换所需积分
    var exchangeIntegral:Int?;
    ///剩余的商品数量
    var goodsSurplusCount:Int?;
    ///商品状态； 1可以兑换，2已下架
    var goodsStatu:Int?;
    required init?(_ map: Map) {
        mapping(map)
    }
    func mapping(map: Map) {
        integralMallId <- map["integralMallId"]
        subStationId <- map["subStationId"]
        goodsName <- map["goodsName"]
        goodsDescribe <- map["goodsDescribe"]
        goodsPic <- map["goodsPic"]
        addTime <- map["addTime"]
        exchangeIntegral <- map["exchangeIntegral"]
        goodsSurplusCount <- map["goodsSurplusCount"]
        goodsStatu <- map["goodsStatu"]
    }
}