//
//  ShoppingCarVo.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/8/9.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import ObjectMapper
/// 购物车Vo
class ShoppingCarVo:Mappable{
    /// 最低起送额
    var lowestMoney:String?
    /// 配送商Id
    var supplierId:Int?
    /// 配送商名称
    var supplierName:String?
    /// 商品集合
    var listGoods:NSMutableArray?
    /// 是否选中(1选中2未选中)
    var isSelected:Int?
    required init?(_ map: Map) {
        mapping(map)
    }
    func mapping(map: Map) {
        lowestMoney <- map["lowestMoney"]
        supplierId <- map["supplierId"]
        supplierName <- map["supplierName"]
    }
}