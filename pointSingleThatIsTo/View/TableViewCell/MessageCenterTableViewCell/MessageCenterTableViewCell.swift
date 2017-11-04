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
    fileprivate var messageTitle:UILabel!
    /// 消息内容
    fileprivate var messageContent:UILabel!
    /// 消息添加时间
    fileprivate var messageAddTimer:UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style:style, reuseIdentifier:reuseIdentifier)
        messageTitle=UILabel(frame:CGRect(x: 15,y: 10,width: boundsWidth-30,height: 20))
        messageTitle!.font=UIFont.boldSystemFont(ofSize: 14)
        self.contentView.addSubview(messageTitle!)
        messageAddTimer=UILabel()
        messageAddTimer!.textColor=UIColor.darkText
        messageAddTimer!.textAlignment = .right
        messageAddTimer!.font=UIFont.systemFont(ofSize: 12)
        self.contentView.addSubview(messageAddTimer!)
        messageContent=UILabel()
        messageContent!.textColor=UIColor.textColor()
        messageContent!.font=UIFont.systemFont(ofSize: 13)
        messageContent!.numberOfLines=0
        messageContent!.lineBreakMode=NSLineBreakMode.byWordWrapping
        self.contentView.addSubview(messageContent!)
        self.selectionStyle=UITableViewCellSelectionStyle.none;
    }
    /**
     更新cell
     
     - parameter entity: AdMessgInfoEntity
     */
    func updateCell(_ entity:AdMessgInfoEntity){
        messageTitle.text=entity.messTitle
        messageContent.text=entity.messContent
        messageAddTimer.text=entity.messAddTime
        let size=messageContent.text!.textSizeWithFont(messageContent.font, constrainedToSize:CGSize(width: boundsWidth-30,height: 5000))
        messageContent.frame=CGRect(x: 15,y: messageTitle.frame.maxY+10,width: boundsWidth-30,height: size.height)
        messageAddTimer.frame=CGRect(x: boundsWidth-215,y: messageContent.frame.maxY+10,width: 200,height: 20)
        self.frame.size.height=messageAddTimer.frame.maxY+10
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
