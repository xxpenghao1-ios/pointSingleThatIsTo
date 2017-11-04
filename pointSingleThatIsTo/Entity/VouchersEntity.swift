//
//  VouchersEntity.swift
//  pointSingleThatIsTo
//
//  Created by hao peng on 2017/8/10.
//  Copyright © 2017年 penghao. All rights reserved.
//

import Foundation
import ObjectMapper
/// 代金券entity
class VouchersEntity:Mappable {
    var cashCouponAmountOfMoney:Int?
    var cashCouponExpirationDate:String?
    var cashCouponExpirationDateInt:Int?
    var cashCouponId:Int?
    init(){}
    required init?(map: Map) {
        mapping(map: map)
    }
    func mapping(map: Map) {
        cashCouponAmountOfMoney <- map["cashCouponAmountOfMoney"]
        cashCouponExpirationDate <- map["cashCouponExpirationDate"]
        cashCouponExpirationDateInt <- map["cashCouponExpirationDateInt"]
        cashCouponId <- map["cashCouponId"]
        
    }
}
