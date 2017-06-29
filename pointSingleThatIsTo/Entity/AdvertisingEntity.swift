//
//  AdvertisingEntity.swift
//  moreEntity
//
//  Created by nevermore on 15/12/21.
//  Copyright © 2015年 hzw. All rights reserved.
//


import Foundation
import ObjectMapper
/// 广告
class AdvertisingEntity:Mappable {
    ///广告ID
    var advertisingId:Int?;
    ///广告名
    var advertisingName:String?
    ///广告描述
    var advertisingDescription:String?;
    ///广告路径
    var advertisingURL:String?;
    ///广告上传时间
    var advertisingUploadTime:String?;
    ///广告的链接路径
    var advertisingLinkURL:Int?;
    ///是否禁用此广告  ，默认1开启。2禁用
    var advertisingDisable:Int?;
    ///默认状态为1，在首页显示。如果将状态改为2，在登录界面显示
    var advertisingFlag:Int?;
    ///mobileOrPc,默认状态为1，在PC显示。如果将状态改为2，在移动端显示,3店铺版首页特价图片，4，消费者版下单转动图片
    var mobileOrPc:Int?
    ///分站Id
    var substationId:Int?
    var isPromotion:Int?
    var searchStatu:Int?
    init(){}
    required init?(_ map: Map) {
        mapping(map)
    }
    func mapping(map: Map) {
        advertisingId <- map["advertisingId"]
        advertisingName <- map["advertisingName"]
        advertisingDescription <- map["advertisingDescription"]
        advertisingURL <- map["advertisingURL"]
        advertisingUploadTime <- map["advertisingUploadTime"]
        advertisingLinkURL <- map["advertisingLinkURL"]
        advertisingDisable <- map["advertisingDisable"]
        advertisingFlag <- map["advertisingFlag"]
        mobileOrPc <- map["mobileOrPc"]
        substationId <- map["substationId"]
        isPromotion <- map["isPromotion"]
        searchStatu <- map["searchStatu"]
    }
}