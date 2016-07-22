//
//  File.swift
//  moreEntity
//
//  Created by nevermore on 15/12/22.
//  Copyright © 2015年 hzw. All rights reserved.
//

import Foundation
import ObjectMapper
/// 店铺表
class StoreEntity:Mappable {
    /// 市
    var city:String?
    /// 店铺id
    var storeId:String?
    /// 区
    var county:String?
    /// 区县id
    var countyId:String?
    /// 会员id
    var memberId:String?
    /// 省
    var province:String?
    /// 店铺唯一标识码
    var storeFlagCode:String?
    /// 店铺名称
    var storeName:String?
    /// 分站id
    var substationId:String?
    /// 店铺电话号码
    var subStationPhoneNumber:String?
    /// 店铺二维码图片路径
    var qrcode:String?
    
    
    init(){}
    required init?(_ map: Map) {
        mapping(map)
    }
    func mapping(map: Map) {
        memberId <- map["memberId"]
        storeId <- map["storeId"]
        storeName <- map["storeName"]
        province <- map["province"]
        city <- map["city"]
        countyId <- map["countyId"]
        county <- map["county"]
        storeFlagCode <- map["storeFlagCode"]
        substationId <- map["substationId"]
        subStationPhoneNumber <- map["subStationPhoneNumber"]
        qrcode <- map["qrcode"]
    }
}