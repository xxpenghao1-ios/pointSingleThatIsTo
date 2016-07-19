//
//  MessageCenterTableViewCell.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/6/20.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
/// 消息中心cell
class MessageCenterTableViewCell:UITableViewCell {
    /// 消息标题
    private var messageTitle:UILabel!
    /// 消息内容
    private var messageContent:UILabel!
    /// 消息添加时间
    private var messageAddTimer:UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style:style, reuseIdentifier:reuseIdentifier)
        messageTitle=UILabel(frame:CGRectMake(15,10,boundsWidth-30,20))
        messageTitle!.font=UIFont.boldSystemFontOfSize(14)
        self.contentView.addSubview(messageTitle!)
        messageAddTimer=UILabel()
        messageAddTimer!.textColor=UIColor.darkTextColor()
        messageAddTimer!.textAlignment = .Right
        messageAddTimer!.font=UIFont.systemFontOfSize(12)
        self.contentView.addSubview(messageAddTimer!)
        messageContent=UILabel()
        messageContent!.textColor=UIColor.textColor()
        messageContent!.font=UIFont.systemFontOfSize(13)
        messageContent!.numberOfLines=0
        messageContent!.lineBreakMode=NSLineBreakMode.ByWordWrapping
        self.contentView.addSubview(messageContent!)
        self.selectionStyle=UITableViewCellSelectionStyle.None;
    }
    /**
     更新cell
     
     - parameter entity: AdMessgInfoEntity
     */
    func updateCell(entity:AdMessgInfoEntity){
        messageTitle.text=entity.messTitle
        messageContent.text=entity.messContent
        messageAddTimer.text=entity.messAddTime
        let size=messageContent.text!.textSizeWithFont(messageContent.font, constrainedToSize:CGSizeMake(boundsWidth-30,5000))
        messageContent.frame=CGRectMake(15,CGRectGetMaxY(messageTitle.frame)+10,boundsWidth-30,size.height)
        messageAddTimer.frame=CGRectMake(boundsWidth-215,CGRectGetMaxY(messageContent.frame)+10,200,20)
        self.frame.size.height=CGRectGetMaxY(messageAddTimer.frame)+10
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}