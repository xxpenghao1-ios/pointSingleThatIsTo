//
//  OrderListEntity.swift
//  pointSingleThatIsTo
//
//  Created by 卢洋 on 16/2/20.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import ObjectMapper
/**订单信息*/
class OrderListEntity:Mappable{
    /** 出货编号 **/
    var out_trade_sn:String?;
    /**当前登录者的Id **/
    var buyerId:Int?;
    /** 卖家Id**/
    var sellerId:Int?;
    /**订单总价**/
    var orderPrice:String?;
    /**订单号 **/
    var orderinfoId:Int?;
    /** 买家电话**/
    var phone_tel:String?;
    /**1-可以抢单，2已经被抢单，3开始送货  4已完成**/
    var robflag:Int?;
    /** 收货地址**/
    var address:String?;
    /** 订单编号**/
    var orderSN:String?;
    /** 1-未发货，2已发货，3-已经完成**/
    var orderStatus:Int?;
    /** 订单类型1-店铺对供应商 2-用户对店铺 **/
    var orderType:Int?;
    /**评价状态 1-未评价2-已评价 **/
    var evaluation_status:Int?;
    /**买家用户名 **/
    var buyName:String?;
    /**商品集合**/
    var list:NSMutableArray?;
    /** 下单时间 **/
    var add_time:String?;
    /**店铺名称**/
    var sellerName:String?;
    var storeName:String?;
    /** 商品数量 **/
    var goods_amount:String?;
    /**支付消息 **/
    var pay_message:String?;
    /**用户加价价钱*/
    var additionalMoney:String?;
    /**供应商名称*/
    var supplierName:String?;
    /**完成时间*/
    var finished_time:String?;
    /**卖家附言*/
    var postscript:String?;
    var returnGoodsFlag:Int?
    
    init(){}
    required init?(_ map: Map) {
        mapping(map)
    }
    func mapping(map:Map){
        out_trade_sn <- map["out_trade_sn"]
        buyerId <- map["buyerId"]
        sellerId <- map["sellerId"]
        orderPrice <- map["orderPrice"]
        orderinfoId <- map["orderinfoId"]
        phone_tel <- map["phone_tel"]
        robflag <- map["robflag"]
        address <- map["address"]
        orderSN <- map["orderSN"]
        orderStatus <- map["orderStatus"]
        orderType <- map["orderType"]
        evaluation_status <- map["evaluation_status"]
        buyName <- map["buyName"]
        list <- map["list"]
        add_time <- map["add_time"]
        sellerName <- map["sellerName"]
        storeName <- map["storeName"]
        goods_amount <- map["goods_amount"]
        pay_message <- map["pay_message"]
        additionalMoney <- map["additionalMoney"]
        supplierName <- map["supplierName"]
        finished_time <- map["finished_time"]
        postscript <- map["postscript"]
        returnGoodsFlag <- map["returnGoodsFlag"]
        
    }
}