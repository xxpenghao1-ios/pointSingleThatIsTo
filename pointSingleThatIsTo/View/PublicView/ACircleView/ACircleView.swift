//
//  ACircleView.swift
//  kxkg
//
//  Created by hefeiyue on 15/3/25.
//  Copyright (c) 2015年 奈文魔尔. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
/**
 圆形视图
*/
class ACircleView:UIView{
    //声明加载view的动画路径
    var pacmanOpenPath:UIBezierPath!;
    var arcCenter:CGPoint!;
    //生成color数组
    var colors=NSMutableArray();
    //CAGradientLayer 通过指定颜色，一个开始的点，一个结束的点和梯度类型使你能够简单的在层上绘制一个梯度，效果就是颜色渐变
    var gradientLayer:CAGradientLayer!;
    //CAShapeLayer 通过创建一个核心图像路径，并且分配给CAShaperLayer的path属性，从而为需要的形状指定路径。 可以指定填充路径之外的颜色，路径内的颜色，绘制路径，线宽，是否圆角等等
    var shapeLayer:CAShapeLayer!;
    var spinAnimation:CABasicAnimation!;
    var lblHaveToPush:UILabel!;
    var lblCount:UILabel!;
    var lblStore:UILabel!;
    override init(frame: CGRect) {
        super.init(frame:frame);
        
        lblHaveToPush=UILabel(frame:CGRect(x: 0,y: 50,width: frame.width,height: 20));
        lblHaveToPush.text="已推送给";
        lblHaveToPush.font=UIFont.boldSystemFont(ofSize: 20);
        lblHaveToPush.textColor=UIColor.white;
        lblHaveToPush.textAlignment=NSTextAlignment.center;
        self.addSubview(lblHaveToPush);
        
        lblCount=UILabel(frame:CGRect(x: 0,y: lblHaveToPush.frame.height+lblHaveToPush.frame.origin.y+10,width: frame.width,height: 40));
        lblCount.textColor=UIColor.white;
        lblCount.textAlignment=NSTextAlignment.center;
        lblCount.font=UIFont.boldSystemFont(ofSize: 40);
        self.addSubview(lblCount);
        
        lblStore=UILabel(frame:CGRect(x: 0,y: lblCount.frame.height+lblCount.frame.origin.y+10,width: frame.width,height: 20));
        lblStore.text="家店铺";
        lblStore.font=UIFont.boldSystemFont(ofSize: 20);
        lblStore.textColor=UIColor.white;
        lblStore.textAlignment=NSTextAlignment.center;
        self.addSubview(lblStore);
        
        let radius:CGFloat=(frame.width-20)/2;
        arcCenter=CGPoint(x: radius,y: radius);
        pacmanOpenPath=UIBezierPath();
        pacmanOpenPath.addArc(withCenter: arcCenter, radius:radius, startAngle:0, endAngle:CGFloat(M_PI * 2) , clockwise: true);
        colors.add(UIColor.blue.cgColor);
        colors.add(UIColor.white.cgColor);
        //在指定的color中绘制渐变层
        gradientLayer=CAGradientLayer();
        gradientLayer.colors=colors as [AnyObject];
        gradientLayer.frame=CGRect(x: 0,y: 0,width: frame.width,height: frame.height);
        self.layer.addSublayer(gradientLayer);
        
        shapeLayer=CAShapeLayer();
        shapeLayer.fillColor=UIColor.clear.cgColor;
        shapeLayer.fillMode=kCAFillRuleEvenOdd;
        shapeLayer.path=pacmanOpenPath.cgPath;
        shapeLayer.strokeColor=UIColor.yellow.cgColor;
        shapeLayer.lineWidth=10.0;
        shapeLayer.lineJoin=kCALineJoinRound;
        shapeLayer.lineCap=kCALineCapRound;
        shapeLayer.frame=CGRect(x: 10, y: 10,width: frame.width-20,height: frame.height-20);
        //所有继承于CALayer的核心动画层都有一个属性叫做mask.这个属性能够使你给层的所有内容做遮罩，除了层面罩中已经有的部分，它允许仅仅形状层绘制的部分显示那部分的图像。  我们将shapeLayer作为这个遮罩，显示出来的效果就是一个有着渐变填充色的圆弧
        gradientLayer.mask = shapeLayer;
        //最重要的显示内容已经有了，接下来就是让图层动起来，所以加一个旋转动画
        spinAnimation=CABasicAnimation(keyPath:"transform.rotation");
        spinAnimation.timingFunction=CAMediaTimingFunction(name:kCAMediaTimingFunctionLinear);
        spinAnimation.fromValue=NSNumber(value: 0 as Int32);
        spinAnimation.toValue=NSNumber(value: 2 * M_PI as Double);
        spinAnimation.duration=2;
        spinAnimation.repeatCount=HUGE;
        shapeLayer.add(spinAnimation, forKey:"shapeRotateAnimation");
        //现在圆弧就能够旋转了，但是我们发现渐变色是固定的位置，感觉就像是固定的背景色，为了达到一种动态的渐变，所以给gradientLayer也加上旋转动画效果，这样就是一段旋转的有着渐变效果的圆弧
        gradientLayer.add(spinAnimation, forKey:"GradientRotateAniamtion");
        
        
        
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
