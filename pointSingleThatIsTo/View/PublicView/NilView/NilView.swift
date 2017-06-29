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
public func buildTxt(font:CGFloat,placeholder:String,tintColor:UIColor,keyboardType:UIKeyboardType) -> UITextField{
    let txt=UITextField()
    txt.font=UIFont.systemFontOfSize(font)
    txt.attributedPlaceholder=NSAttributedString(string:placeholder, attributes: [NSForegroundColorAttributeName:UIColor.RGBFromHexColor("#999999")])
    txt.backgroundColor=UIColor.whiteColor()
    txt.clearButtonMode=UITextFieldViewMode.WhileEditing
    txt.tintColor=tintColor
    txt.keyboardType=keyboardType
    return txt
}
/// 文本

public func buildLabel(textColor:UIColor,font:CGFloat,textAlignment:NSTextAlignment) -> UILabel{
    let lbl=UILabel()
    lbl.textColor=textColor
    lbl.font=UIFont.systemFontOfSize(font)
    lbl.textAlignment=textAlignment
    return lbl
}

/// 按钮控件属性
public enum ButtonType {
    case button
    case cornerRadiusButton
}

/// 按钮
public class ButtonControl {
    
    public func button(type:ButtonType,text:String,textColor:UIColor,font:CGFloat,backgroundColor:UIColor,cornerRadius:CGFloat?) -> UIButton{
        switch type {
        case .button:
            return buildButton(text, textColor: textColor, font: font, backgroundColor: backgroundColor)
        case .cornerRadiusButton:
            return buildCornerRadiusButton(text,textColor:textColor,font:font,backgroundColor:backgroundColor,cornerRadius:cornerRadius!)
        }
    }
    
    private func buildCornerRadiusButton(text:String,textColor:UIColor,font:CGFloat,backgroundColor:UIColor,cornerRadius:CGFloat) -> UIButton{
        let btn=UIButton()
        btn.setTitle(text, forState: UIControlState.Normal)
        btn.setTitleColor(textColor,forState: UIControlState.Normal)
        btn.titleLabel!.font=UIFont.systemFontOfSize(font)
        btn.backgroundColor=backgroundColor
        btn.layer.cornerRadius=cornerRadius
        return btn
    }
    private func buildButton(text:String,textColor:UIColor,font:CGFloat,backgroundColor:UIColor) -> UIButton{
        let btn=UIButton()
        btn.setTitle(text, forState: UIControlState.Normal)
        btn.setTitleColor(textColor,forState: UIControlState.Normal)
        btn.titleLabel!.font=UIFont.systemFontOfSize(font)
        btn.backgroundColor=backgroundColor
        return btn
    }
    
    
}
