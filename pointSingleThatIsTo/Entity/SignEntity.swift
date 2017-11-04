//
//  SignEntity.swift
//  pointSingleThatIsTo
//
//  Created by hao peng on 2017/9/1.
//  Copyright © 2017年 penghao. All rights reserved.
//

import Foundation
import ObjectMapper
/// 签到entity
class SignEntity:Mappable {
    var storeSignId:Int?
    var storeSignStoreId:Int?
    var storeSignGetBalance:Int?
    var storeSignContinuityGetBalance:Int?
    var storeSignDate:String?
    var storeSignTime:String?
    init(){}
    required init?(map: Map) {
        mapping(map: map)
    }
    func mapping(map: Map) {
        storeSignId <- map["storeSignId"]
        storeSignStoreId <- map["storeSignStoreId"]
        storeSignGetBalance <- map["storeSignGetBalance"]
        storeSignContinuityGetBalance <- map["storeSignContinuityGetBalance"]
        storeSignDate <- map["storeSignDate"]
        storeSignTime <- map["storeSignTime"]
    }
}
