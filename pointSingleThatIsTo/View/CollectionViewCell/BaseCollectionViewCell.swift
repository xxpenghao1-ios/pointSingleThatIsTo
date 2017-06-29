//
//  BaseCollectionViewCell.swift
//  CXHSalesman
//
//  Created by hao peng on 2017/4/10.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
struct LWLineSeparatorOptions: OptionSetType {
    let rawValue: Int
    init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    static let top = LWLineSeparatorOptions.init(rawValue: 1)
    static let bottom = LWLineSeparatorOptions.init(rawValue: 2)
    static let left = LWLineSeparatorOptions.init(rawValue: 4)
    static let right = LWLineSeparatorOptions.init(rawValue: 8)
}

class LWLineSeparatorCollectionViewCell: UICollectionViewCell {
    
    var linwSeparatorOptions: LWLineSeparatorOptions = [.top, .bottom, .left, .right] {
        didSet {
            let _ = contentView.layer.sublayers!.map {
                if $0.isKindOfClass(CAShapeLayer.self) {
                    $0.removeFromSuperlayer()
                }
            }
            setNeedsDisplay()
        }
    }
    var lineColor = UIColor.init(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 0.7)
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        if linwSeparatorOptions.contains(.top) {
            let layer = CAShapeLayer()
            layer.lineWidth = 1
            layer.borderWidth = 1
            layer.strokeColor = lineColor.CGColor
            
            let path = UIBezierPath.init()
            path.moveToPoint(CGPointMake(0, 0))
            path.addLineToPoint(CGPointMake(rect.size.width, 0))
            
            layer.path = path.CGPath
            contentView.layer.addSublayer(layer)
        }
        
        if linwSeparatorOptions.contains(.bottom) {
            let layer = CAShapeLayer()
            layer.lineWidth = 1
            layer.borderWidth = 1
            layer.strokeColor = lineColor.CGColor
            
            let path = UIBezierPath.init()
            path.moveToPoint(CGPointMake(0, rect.size.height))
            path.addLineToPoint(CGPointMake(rect.size.width, rect.size.height))
            
            layer.path = path.CGPath
            contentView.layer.addSublayer(layer)
        }
        
        if linwSeparatorOptions.contains(.left) {
            let layer = CAShapeLayer()
            layer.lineWidth = 1
            layer.borderWidth = 1
            layer.strokeColor = lineColor.CGColor
            
            let path = UIBezierPath.init()
            path.moveToPoint(CGPointMake(0, 0))
            path.addLineToPoint(CGPointMake(0, rect.size.height))
            
            layer.path = path.CGPath
            contentView.layer.addSublayer(layer)
        }
        
        if linwSeparatorOptions.contains(.right) {
            let layer = CAShapeLayer()
            layer.lineWidth = 1
            layer.borderWidth = 1
            layer.strokeColor = lineColor.CGColor
            
            let path = UIBezierPath.init()
            path.moveToPoint(CGPointMake(rect.size.width, 0))
            path.addLineToPoint(CGPointMake(rect.size.width, rect.size.height))
            
            layer.path = path.CGPath
            contentView.layer.addSublayer(layer)
        }
    }  
}