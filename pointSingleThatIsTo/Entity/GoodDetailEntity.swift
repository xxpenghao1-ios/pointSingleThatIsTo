//
//  GoodDetailEntity.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/1/21.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import ObjectMapper
/// 商品详情entity
class GoodDetailEntity:Mappable {
    /// 分类名称
    var tcategoryName:String?
    /// 规格
    var ucode:String?
    /// 图片路径
    var goodPic:String?
    /// 商品条码
    var goodInfoCode:String?
    /// 该商品是否被重新分配给了分销商或物流配送商1-未分配  2-分配了
    var isDistribution:Int?
    /// 商品名称
    var goodInfoName:String?
    /// 商品备注
    var goodsDes:String?
    var traffic:Int?
    var scategoryName:String?
    /// 特价价格(特价区)
    var preferentialPrice:String?
    /// 商品原价
    var oldPrice:String?
    var fcategoryName:String?
    /// 商品现在价格
    var uprice:String?
    /// 单个商品批发价格
    var uitemPrice:String?
    var remark:String?
    var ctime:String?
    var supplierId:Int?
    /// 特价库存(查询购物车)
    var stock:Int?
    var goodsbasicinfoId:Int?
    var commission:String?
    /// 特价商品限定数量
    var eachCount:Int?
    var carNumber:Int?
    /// 是否是特价 1表示是特价 2不是 3促销
    var flag:Int?
    /// 会员id
    var memberId:String?
    /// 库存
    var goodsStock:Int?
    var subSupplier:Int?
    /// 商品价格 ly增加
    var goodsUprice:String?
    /// 商品数量
    var goodsSumCount:String?
    /// 供应商名称
    var supplierName:String?
    /// 商品单位
    var goodUnit:String?
    /// 商品售后服务
    var goodService:String?
    /// 商品产地
    var goodSource:String?
    /// 商品配料
    var goodMixed:String?
    /// 商品保质期
    var goodLife:String?
    /// 购物记录日期
    var purchaseRecordsDate:String?
    /// 是否有促销活动 1(表示有) 其他没有
    var isPromotionFlag:Int?
    /// 是否是新品 1是
    var isNewGoodFlag:Int?
    /// 商品加减数量
    var goodsBaseCount:Int?
    /// 最低配送量
    var miniCount:Int?
    /// 特价价格(购物车)
    var prefertialPrice:String?
    /// 商品总价
    var goodsSumMoney:String?
    /// 特价id
    var preferentialId:Int?
    /// 商品销量
    var salesCount:Int?
    /// 特价结束时间
    var endTime:String?
    /// 是否选中(1选中2未选中)
    var isSelected:Int?
    ///默认为null；如果=1，此商品被用户收藏
    var goodsCollectionStatu:Int?
    ///商品是否可退；1可退；2不可退
    var returnGoodsFlag:Int?
    ///促销活动结束时间
    var promotionEndTime:String?
    ///促销商品单店的限购量
    var storeBuyCount:Int?
    ///促销商品所有的限购量
    var sumBuyCount:Int?
    ///促销商品还可以购买的数量
    var promotionEachCount:Int?
    ///促销商品店铺还可以购买的数量
    var promotionStoreEachCount:Int?
    ///促销期号
    var promotionNumber:Int?
    /// 促销的达标数量
    var promotionStandardCount:Int?
    
    init(){}
    required init?(map: Map) {
        mapping(map: map)
    }
    func mapping(map: Map) {
        tcategoryName <- map["tcategoryName"]
        ucode <- map["ucode"]
        goodPic <- map["goodPic"]
        goodInfoCode <- map["goodInfoCode"]
        isDistribution <- map["isDistribution"]
        goodInfoName <- map["goodInfoName"]
        goodsDes <- map["goodsDes"]
        traffic <- map["traffic"]
        scategoryName <- map["scategoryName"]
        preferentialPrice <- map["preferentialPrice"]
        oldPrice <- map["oldPrice"]
        fcategoryName <- map["fcategoryName"]
        uprice <- map["uprice"]
        uitemPrice <- map["uitemPrice"]
        remark <- map["remark"]
        ctime <- map["ctime"]
        supplierId <- map["supplierId"]
        stock <- map["stock"]
        goodsbasicinfoId <- map["goodsbasicinfoId"]
        commission <- map["commission"]
        eachCount <- map["eachCount"]
        carNumber <- map["carNumber"]
        flag <- map["flag"]
        memberId <- map["memberId"]
        goodsStock <- map["goodsStock"]
        subSupplier <- map["subSupplier"]
        goodsUprice <- map["goodsUprice"]
        goodsSumCount <- map["goodsSumCount"]
        supplierName <- map["supplierName"]
        goodUnit <- map["goodUnit"]
        goodService <- map["goodService"]
        goodSource <- map["goodSource"]
        goodMixed <- map["goodMixed"]
        goodLife <- map["goodLife"]
        purchaseRecordsDate <- map["purchaseRecordsDate"]
        isPromotionFlag <- map["isPromotionFlag"]
        goodsBaseCount <- map["goodsBaseCount"]
        miniCount <- map["miniCount"]
        prefertialPrice <- map["prefertialPrice"]
        goodsSumMoney <- map["goodsSumMoney"]
        preferentialId <- map["preferentialId"]
        salesCount <- map["salesCount"]
        endTime <- map["endTime"]
        goodsCollectionStatu <- map["goodsCollectionStatu"]
        returnGoodsFlag <- map["returnGoodsFlag"]
        promotionEndTime <- map["promotionEndTime"]
        storeBuyCount <- map["storeBuyCount"]
        sumBuyCount <- map["sumBuyCount"]
        promotionEachCount <- map["promotionEachCount"]
        promotionStoreEachCount <- map["promotionStoreEachCount"]
        promotionNumber <- map["promotionNumber"]
        promotionStandardCount <- map["promotionStandardCount"]
    }
}
