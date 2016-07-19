//
//  AddressEntity.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/2/22.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import ObjectMapper
/// 地址entity
class AddressEntity:Mappable {
    /// 区
    var county:String?
    /// 市
    var city:String?
    /// 省
    var province:String?
    /// 地址id
    var shippAddressId:Int?
    /// 收货人名称
    var shippName:String?
    /// 是否是默认地址
    var defaultFlag:Int?
    /// 详细地址
    var detailAddress:String?
    /// 会员id
    var memberId:Int?
    /// 电话号码
    var phoneNumber:String?
    init(){}
    required init?(_ map: Map) {
        mapping(map)
    }
    func mapping(map: Map) {
        county <- map["county"]
        city <- map["city"]
        province <- map["province"]
        shippAddressId <- map["shippAddressId"]
        shippName <- map["shippName"]
        defaultFlag <- map["defaultFlag"]
        detailAddress <- map["detailAddress"]
        memberId <- map["memberId"]
        phoneNumber <- map["phoneNumber"]
    }
 
}