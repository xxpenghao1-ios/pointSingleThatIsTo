//
//  AdMessgInfoEntity.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/2/22.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import ObjectMapper
/// 公告栏entity
class AdMessgInfoEntity:Mappable{
    var adMessgInfo:Int?
    /// 分站id
    var substationId:Int?
    /// 消息标题
    var messTitle:String?
    /// 消息内容
    var messContent:String?
    /// 会员id
    var memberId:Int?
    /// 消息添加时间
    var messAddTime:String?
    /// 状态1为不显示，2为显示
    var flag:Int?
    var memberName:String?		//会员名
    var pushFlag:Int?		//消息类别；1为在首页显示；2为推送消息；
    var pushStatu:Int?;		//推送状态；1等待审核；2已推送；
    var pushReason:Int?;		//推送原因； 1促销活动；2特价活动；3新品推荐；4系统消息
    init(){}
    required init?(map: Map) {
        mapping(map: map)
    }
    func mapping(map: Map) {
        adMessgInfo <- map["adMessgInfo"]
        substationId <- map["substationId"]
        messTitle <- map["messTitle"]
        messContent <- map["messContent"]
        memberId <- map["memberId"]
        messAddTime <- map["messAddTime"]
        flag <- map["flag"]
        memberName <- map["memberName"]
        pushFlag <- map["pushFlag"]
        pushStatu <- map["pushStatu"]
        pushReason <- map["pushReason"]
        
    }
}
