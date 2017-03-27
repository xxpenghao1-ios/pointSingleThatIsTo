//
//  CollectionEntity.swift
//  pointSingleThatIsTo
//
//  Created by hao peng on 2017/3/22.
//  Copyright © 2017年 penghao. All rights reserved.
//

import Foundation
import ObjectMapper
/// 收藏entity
class CollectionEntity:Mappable{
    var goodInfoName:String?// 商品名字
    var goodsStock:Int?//库存
    var uprice:String?//商品价格
    var goodPic:String? //商品展示首图（即封面图片）
    var collectionGoodId:Int?//商品ID
    var collectionTime:String?//收藏时间
    var collectionSubSupplierId:Int? //配送商ID
    var goodsBaseCount:Int?//加减基数，就是在购物车添加商品的时候每次添加都会按这个goodsBaseCount得数量添加
    var memberId:Int? //会员ID
    var miniCount:Int?//最低起送量
    var collectionSupplierId:Int?//供应商ID
    var collectionId:Int?
    required init?(_ map: Map) {
        mapping(map)
    }
    func mapping(map: Map) {
        goodInfoName <- map["goodInfoName"]
        goodsStock <- map["goodsStock"]
        uprice <- map["uprice"]
        goodPic <- map["goodPic"]
        collectionGoodId <- map["collectionGoodId"]
        collectionTime <- map["collectionTime"]
        collectionSubSupplierId <- map["collectionSubSupplierId"]
        goodsBaseCount <- map["goodsBaseCount"]
        memberId <- map["memberId"]
        miniCount <- map["miniCount"]
        collectionSupplierId <- map["collectionSupplierId"]
        collectionId <- map["collectionId"]
    }
}