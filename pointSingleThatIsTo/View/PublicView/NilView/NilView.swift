//
//  NilTitle.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/1/19.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
/**
 各个页面为空提示
 
 - parameter str: 传入提示信息
 
 - returns: 返回View
 */
func nilPromptView(str:String) ->UIView{
    let promptView=UIView(frame:CGRectMake(0,0,boundsWidth,80));
    let promptImgView=UIImageView(frame:CGRectMake((promptView.frame.width-50)/2,0,50,50))
    promptImgView.image=UIImage(named:"nildd")
    promptView.addSubview(promptImgView)
    let lblPrompt=UILabel(frame:CGRectMake(0,50+5,promptView.frame.width,20));
    lblPrompt.textAlignment=NSTextAlignment.Center;
    lblPrompt.text=str;
    lblPrompt.font=UIFont.systemFontOfSize(14);
    lblPrompt.textColor=UIColor.textColor();
    promptView.addSubview(lblPrompt);
    return promptView
}
/**
 各个页面为空提示
 
 - parameter str: 传入提示信息
 
 - returns: 返回UILabel
 */
func nilTitle(str:String) ->UILabel{
    let lbl=UILabel(frame:CGRectMake(0,0,boundsWidth,20))
    lbl.text=str
    lbl.textColor=UIColor.textColor()
    lbl.font=UIFont.boldSystemFontOfSize(14)
    lbl.textAlignment = .Center
    return lbl
}
