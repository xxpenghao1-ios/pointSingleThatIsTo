//
//  DrawingRecordEntity.swift
//  pointSingleThatIsTo
//
//  Created by nevermore on 16/1/28.
//  Copyright © 2016年 penghao. All rights reserved.
//
import ObjectMapper
import Foundation
/// 兑奖信息
class DrawingRecordEntity:Mappable {
   
    /**商品名称*/
    var  goodsName:String?;
    /**商品Id*/
    var  goodsId:Int?;
    /// 供应商ID
    var supplierId:Int?
    /// 店铺名称
    var storeName:String?
    /// 摇一摇 ID
    var shakeMemberInfoId:Int?
    /// 接收时间
    var receiveTime:String?;
    /**图片路径*/
    var  goodsPic:String?;
    /**供应商名称*/
    var  supplierName:String?;
    /**供应商摇一摇商品id*/
    var  supplierShakeGoodsId:Int?;
    
    /**奖品数量*/
    var  surplusCount:Int?;
    /**兑奖时间*/
    var  awardingTime:String?;
    /**中奖时间*/
    var winningTime:String?;
    /// 商品条形码
    var goodInfoCode:String?;
    
    /**flag用来判断是否已兑奖*/
    var shakeFlag:Int?;
    /**兑奖人名称*/
    var memberName:String?
    
    init(){}
    required init?(_ map: Map) {
        mapping(map)
    }
    func mapping(map: Map) {
        goodsName <- map["goodsName"]
        goodsId <- map["goodsId"]
        goodsPic <- map["goodsPic"]
        supplierName <- map["supplierName"]
        supplierShakeGoodsId <- map["supplierShakeGoodsId"]
        supplierId <- map["supplierId"]
        surplusCount <- map["surplusCount"]
        awardingTime <- map["awardingTime"]
        winningTime <- map["winningTime"]
        goodInfoCode <- map["goodInfoCode"]
        shakeMemberInfoId <- map["shakeMemberInfoId"]
        shakeFlag <- map["shakeFlag"]
        memberName <- map["memberName"]
        receiveTime <- map["receiveTime"]
        storeName <- map["storeName"]
               
    }
}