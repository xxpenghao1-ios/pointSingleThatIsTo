//
//  CanBeTicketViewControllerEntity.swift
//  pointSingleThatIsTo
//
//  Created by nevermore on 16/2/18.
//  Copyright © 2016年 penghao. All rights reserved.
//

import ObjectMapper
import Foundation


class CanBeTicketViewControllerEntity:Mappable {
    /// 商品图片
    var goodPic:String?
    /// 商品名称介绍
    var goodsName:String?
    /// 总数量
    var goodsSum:Int?
    /// 中奖时间
    var storeAddTime:String?
    /// 剩余数量
    var storeSurplusGoodsSum:Int?
    /// 供应商
    var supplierName:String?
    /// 中奖商品ID
    var supplierShakeGoodsId:Int?
    
    init(){}
    required init?(_ map: Map) {
        mapping(map)
    }
    func mapping(map: Map) {
        goodPic <- map["goodPic"]
        goodsName <- map["goodsName"]
        goodsSum <- map["goodsSum"]
        storeAddTime <- map["storeAddTime"]
        storeSurplusGoodsSum <- map["storeSurplusGoodsSum"]
        supplierName <- map["supplierName"]
        supplierShakeGoodsId <- map["supplierShakeGoodsId"]
        
    }
    
    
}
