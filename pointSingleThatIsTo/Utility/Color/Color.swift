//
//  Color.swift
//  pointSingleThatIsTo
//
//  Created by hefeiyue on 15/3/7.
//  Copyright (c) 2015年 奈文魔尔. All rights reserved.
//

import Foundation
import UIKit
extension UIColor{
    ///主题色
    class func applicationMainColor() -> UIColor {
        return UIColor(red: 227/255, green: 1/255, blue: 81/255, alpha:1)
    }
    //商品详情边框颜色
    class func goodDetailBorderColor() ->UIColor {
        return UIColor(red:236/255, green:236/255, blue:236/255, alpha: 1)
    }
    //页面背景颜色
    class func viewBackgroundColor() ->UIColor{
        return UIColor(red:233/255, green:233/255, blue:233/255, alpha:1);
    }
    //文字颜色
    class func textColor() ->UIColor {
        return UIColor(red: 104/255, green:104/255, blue:104/255, alpha: 1.0);
    }
    //商品价格颜色
    class func goodPriceColor() ->UIColor {
        return UIColor(red:225/255, green:45/255, blue:45/255, alpha:1)
    }
    //边框颜色
    class func borderColor() ->UIColor {
        return UIColor(red:143/255, green:143/255, blue:143/255, alpha: 1.0);
    }
    //底部抢单视图颜色
    class func orderBottom() -> UIColor{
        return UIColor(red:32/255, green:32/255, blue:32/255, alpha: 1.0);
    }
}
extension UIColor{
    class func RGBFromHexColor(_ hexColorString : String)->UIColor{
        var cString: String = hexColorString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if cString.count < 6 {
            return UIColor.black
        }
        if cString.hasPrefix("0X") {
            cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 2))
        }
        if cString.hasPrefix("#") {
            cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 1))
        }
        if cString.count != 6 {
            return UIColor.black
        }
        
        var range: NSRange = NSMakeRange(0, 2)
        let rString = (cString as NSString).substring(with: range)
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
        Scanner.init(string: rString).scanHexInt32(&r)
        Scanner.init(string: gString).scanHexInt32(&g)
        Scanner.init(string: bString).scanHexInt32(&b)
        
        
        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: 1)
        
        
    }
}
