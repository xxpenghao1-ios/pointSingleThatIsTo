//
//  BaseCollectionViewCell.swift
//  CXHSalesman
//
//  Created by hao peng on 2017/4/10.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
struct LWLineSeparatorOptions: OptionSet {
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
                if $0.isKind(of: CAShapeLayer.self) {
                    $0.removeFromSuperlayer()
                }
            }
            setNeedsDisplay()
        }
    }
    var lineColor = UIColor.init(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 0.7)
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if linwSeparatorOptions.contains(.top) {
            let layer = CAShapeLayer()
            layer.lineWidth = 1
            layer.borderWidth = 1
            layer.strokeColor = lineColor.cgColor
            
            let path = UIBezierPath.init()
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.size.width, y: 0))
            
            layer.path = path.cgPath
            contentView.layer.addSublayer(layer)
        }
        
        if linwSeparatorOptions.contains(.bottom) {
            let layer = CAShapeLayer()
            layer.lineWidth = 1
            layer.borderWidth = 1
            layer.strokeColor = lineColor.cgColor
            
            let path = UIBezierPath.init()
            path.move(to: CGPoint(x: 0, y: rect.size.height))
            path.addLine(to: CGPoint(x: rect.size.width, y: rect.size.height))
            
            layer.path = path.cgPath
            contentView.layer.addSublayer(layer)
        }
        
        if linwSeparatorOptions.contains(.left) {
            let layer = CAShapeLayer()
            layer.lineWidth = 1
            layer.borderWidth = 1
            layer.strokeColor = lineColor.cgColor
            
            let path = UIBezierPath.init()
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: rect.size.height))
            
            layer.path = path.cgPath
            contentView.layer.addSublayer(layer)
        }
        
        if linwSeparatorOptions.contains(.right) {
            let layer = CAShapeLayer()
            layer.lineWidth = 1
            layer.borderWidth = 1
            layer.strokeColor = lineColor.cgColor
            
            let path = UIBezierPath.init()
            path.move(to: CGPoint(x: rect.size.width, y: 0))
            path.addLine(to: CGPoint(x: rect.size.width, y: rect.size.height))
            
            layer.path = path.cgPath
            contentView.layer.addSublayer(layer)
        }
    }  
}
