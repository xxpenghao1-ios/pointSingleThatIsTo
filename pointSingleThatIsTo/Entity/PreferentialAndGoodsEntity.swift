//
//  File.swift
//  moreEntity
//
//  Created by nevermore on 15/12/22.
//  Copyright © 2015年 hzw. All rights reserved.
//

import Foundation
import ObjectMapper
/// 特价商品信息
class PreferentialAndGoodsEntity:Mappable {
    ///主键ID
    var preferentialId:Int?
    ///商品ID
    var goodsId:Int?
    ///商品名称
    var goodInfoName:String?
    ///商品图片
    var goodPic:String?
    ///供应商ID
    var supplierId:Int?
    ///特价价格
    var preferentialPrice:String?
    ///提供的特价商品总数
    var goodsCount:Int?
    ///开始时间
    var startTime:String?
    ///结束时间
    var endTime:String?
    ///分销商ID
    var subsupplierId:Int?
    ///每家店铺的限购数量
    var eachCount:Int?
    ///活动开启状态，1开启，2停止
    var stataType:Int?
    ///原价
    var oldPrice:String?
    ///规格
    var ucode:String?
    ///商品条形码
    var goodInfoCode:String?
    ///分站Id
    var substationId:Int?
    ///移动端特价分销商
    var subSupplier:Int?
  
    
    init(){}
    required init?(_ map: Map) {
        mapping(map)
    }
    func mapping(map: Map) {
        preferentialId <- map["preferentialId"]
        goodsId <- map["goodsId"]
        goodInfoName <- map["goodInfoName"]
        goodPic <- map["goodPic"]
        supplierId <- map["supplierId"]
        preferentialPrice <- map["preferentialPrice"]
        goodsCount <- map["goodsCount"]
        startTime <- map["startTime"]
        endTime <- map["endTime"]
        subsupplierId <- map["subsupplierId"]
        eachCount <- map["eachCount"]
        stataType <- map["stataType"]
        oldPrice <- map["oldPrice"]
        ucode <- map["ucode"]
        goodInfoCode <- map["goodInfoCode"]
        substationId <- map["substationId"]
        subSupplier <- map["subSupplier"]
       
        
    }
}