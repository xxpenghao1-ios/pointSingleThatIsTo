//
//  GoodsCategoryEntity.swift
//  moreEntity
//
//  Created by nevermore on 15/12/22.
//  Copyright © 2015年 hzw. All rights reserved.
//

import Foundation
import ObjectMapper
/// 商品分类的实体
class GoodsCategoryEntity:Mappable {
    ///商品分类ID
    var goodsCategoryId:Int?
    ///商品分类名称
    var goodsCategoryName:String?
    ///商品上级分类ID
    var goodsCategoryPid:Int?
    ///商品分类图标(原图)
    var goodsCategoryIco:String?
    ///分类描述
    var goodsCategoryIdRemark:String?
    ///分类类型
    var categoryType:Int?
    
    /// 分站品牌名字
    var brandname:String?
    
    /// 分站品牌ID
    var brandId:String?
    
    /// 分站分类ID
    var goodscategoryId:Int?
    
    /// 分站ID
    var substationId:String?
    
    init(){}
    required init?(_ map: Map) {
        mapping(map)
    }
    func mapping(map: Map) {
        goodsCategoryId <- map["goodsCategoryId"]
        goodsCategoryName <- map["goodsCategoryName"]
        goodsCategoryPid <- map["goodsCategoryPid"]
        goodsCategoryIco <- map["goodsCategoryIco"]
        goodsCategoryIdRemark <- map["goodsCategoryIdRemark"]
        brandname <- map["brandname"]
        brandId <- map["brandId"]
        goodscategoryId <- map["goodscategoryId"]
        categoryType <- map["categoryType"]
        substationId <- map["substationId"]
    }
}