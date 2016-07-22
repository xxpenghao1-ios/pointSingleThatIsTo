//
//  SubstationEntity.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/7/20.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import ObjectMapper
/// 分站entity
class SubstationEntity:Mappable {
    /// 分站名称
    var substationName:String?
    /// 分站开通日期
    var ctime:String?
    /// 分站店铺积分获取是否开启； 1开启，2关闭；   （配送商发货后，店铺是否获取积分；根据订单金额获取积分，1元=1积分）
    var subStationBalanceStatu:Int?
    ///分站设置的全场打折，折扣比例；
    var subStationDiscountProportion:String?
    ///分站店铺摇是否开启；1开启，2关闭；
    var subStationPhoneNumber:String?
    ///分站店铺全场打折是否开启； 1开启，2关闭；   （开启后，店铺下单每笔订单（根据配送商）获得相应的折扣）
    var subStationDiscountStatu:Int?
    /// 分站id
    var substationId:Int?
    var stateType:Int?
    required init?(_ map: Map) {
        mapping(map)
    }
    func mapping(map: Map) {
        substationName <- map["substationName"]
        ctime <- map["ctime"]
        subStationBalanceStatu <- map["subStationBalanceStatu"]
        subStationDiscountProportion <- map["subStationDiscountProportion"]
        subStationPhoneNumber <- map["subStationPhoneNumber"]
        subStationDiscountStatu <- map["subStationDiscountStatu"]
        substationId <- map["substationId"]
        stateType <- map["stateType"]
        
    }
}