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
func nilPromptView(_ str:String) ->UIView{
    let promptView=UIView(frame:CGRect(x: 0,y: 0,width: boundsWidth,height: 80));
    let promptImgView=UIImageView(frame:CGRect(x: (promptView.frame.width-50)/2,y: 0,width: 50,height: 50))
    promptImgView.image=UIImage(named:"nildd")
    promptView.addSubview(promptImgView)
    let lblPrompt=UILabel(frame:CGRect(x: 0,y: 50+5,width: promptView.frame.width,height: 20));
    lblPrompt.textAlignment=NSTextAlignment.center;
    lblPrompt.text=str;
    lblPrompt.font=UIFont.systemFont(ofSize: 14);
    lblPrompt.textColor=UIColor.textColor();
    promptView.addSubview(lblPrompt);
    return promptView
}
/**
 各个页面为空提示
 
 - parameter str: 传入提示信息
 
 - returns: 返回UILabel
 */
func nilTitle(_ str:String) ->UILabel{
    let lbl=UILabel(frame:CGRect(x: 0,y: 0,width: boundsWidth,height: 20))
    lbl.text=str
    lbl.textColor=UIColor.textColor()
    lbl.font=UIFont.boldSystemFont(ofSize: 14)
    lbl.textAlignment = .center
    return lbl
}
public func buildTxt(_ font:CGFloat,placeholder:String,tintColor:UIColor,keyboardType:UIKeyboardType) -> UITextField{
    let txt=UITextField()
    txt.font=UIFont.systemFont(ofSize: font)
    txt.attributedPlaceholder=NSAttributedString(string:placeholder, attributes: [NSAttributedStringKey.foregroundColor:UIColor.RGBFromHexColor("#999999")])
    txt.backgroundColor=UIColor.white
    txt.clearButtonMode=UITextFieldViewMode.whileEditing
    txt.tintColor=tintColor
    txt.keyboardType=keyboardType
    return txt
}
/// 文本

public func buildLabel(_ textColor:UIColor,font:CGFloat,textAlignment:NSTextAlignment) -> UILabel{
    let lbl=UILabel()
    lbl.textColor=textColor
    lbl.font=UIFont.systemFont(ofSize: font)
    lbl.textAlignment=textAlignment
    return lbl
}

/// 按钮控件属性
public enum ButtonType {
    case button
    case cornerRadiusButton
}

/// 按钮
open class ButtonControl {
    
    open func button(_ type:ButtonType,text:String,textColor:UIColor,font:CGFloat,backgroundColor:UIColor,cornerRadius:CGFloat?) -> UIButton{
        switch type {
        case .button:
            return buildButton(text, textColor: textColor, font: font, backgroundColor: backgroundColor)
        case .cornerRadiusButton:
            return buildCornerRadiusButton(text,textColor:textColor,font:font,backgroundColor:backgroundColor,cornerRadius:cornerRadius!)
        }
    }
    
    fileprivate func buildCornerRadiusButton(_ text:String,textColor:UIColor,font:CGFloat,backgroundColor:UIColor,cornerRadius:CGFloat) -> UIButton{
        let btn=UIButton()
        btn.setTitle(text, for: UIControlState())
        btn.setTitleColor(textColor,for: UIControlState())
        btn.titleLabel!.font=UIFont.systemFont(ofSize: font)
        btn.backgroundColor=backgroundColor
        btn.layer.cornerRadius=cornerRadius
        return btn
    }
    fileprivate func buildButton(_ text:String,textColor:UIColor,font:CGFloat,backgroundColor:UIColor) -> UIButton{
        let btn=UIButton()
        btn.setTitle(text, for: UIControlState())
        btn.setTitleColor(textColor,for: UIControlState())
        btn.titleLabel!.font=UIFont.systemFont(ofSize: font)
        btn.backgroundColor=backgroundColor
        return btn
    }
    
    
}
