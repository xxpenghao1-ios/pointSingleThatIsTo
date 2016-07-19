//
//  MemberIntegralEntity.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/7/18.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import ObjectMapper
/// 消费积分记录
class MemberIntegralEntity:Mappable{
    ///会员ID
    var memberId:Int?;
    ///状态1 兑换商品扣除。2，充值。3，购物获得
    var integralType:Int?;
    ///积分扣除或者充值记录 ； 存储如-5或+5
    var integral:String?;
    ///生成时间
    var time:String?;
    required init?(_ map: Map) {
        mapping(map)
    }
    func mapping(map: Map) {
        memberId <- map["memberId"]
        integralType <- map["integralType"]
        integral <- map["integral"]
        time <- map["time"]
    }
}