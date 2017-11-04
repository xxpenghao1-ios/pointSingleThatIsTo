//
//  IndexHotGoodEntity.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/1/19.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import ObjectMapper
/// 首页热门商品
class IndexHotGoodEntity:Mappable{
    /// 商品名称
    var goodInfoName:String?
    
    var subSupplier:Int?
    /// 规格
    var ucode:String?
    
    var isDistribution:Int?
    
    var uitemPrice:String?
    
    var goodPic:String?
    
    var uprice:String?
    
    var supplierId:Int?
    
    var ctime:String?
    
    var remark:String?
    
    var goodsbasicinfoId:Int?
    
    var carNumber:Int?
    
    init(){}
    required init?(map: Map) {
        mapping(map: map)
    }
    func mapping(map: Map) {
        goodInfoName <- map["goodInfoName"]
        subSupplier <- map["subSupplier"]
        ucode <- map["ucode"]
        isDistribution <- map["isDistribution"]
        uitemPrice <- map["uitemPrice"]
        goodPic <- map["goodPic"]
        uprice <- map["uprice"]
        supplierId <- map["supplierId"]
        ctime <- map["ctime"]
        remark <- map["remark"]
        goodsbasicinfoId <- map["goodsbasicinfoId"]
        carNumber <- map["carNumber"]
        
    }
}
