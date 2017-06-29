//
//  AddShoppingCartAnimation.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/4/7.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
/// 加入购物车效果
class AddShoppingCartAnimation:BaseViewController{
    /// 接收tableView
    var tableView:UITableView?
    //  接收button
    var button:UIButton?
    
    private var _layer:CALayer?
    private var path:UIBezierPath?
    /**
     加入购物车特效
     
     - parameter rect:CGRect当前图片位置
     - parameter imageView:当前位置图片
     - parameter isGoodDetail:是否的商品详情1是否则商品列表
     */
    func startAnimationWithRect(rect:CGRect, imageView:UIImageView,isGoodDetail:Int){
        if _layer==nil{
            _layer=CALayer()
            _layer!.contents = imageView.layer.contents;
            
            _layer!.contentsGravity = kCAGravityResizeAspectFill;
            _layer!.bounds = rect;
            _layer!.cornerRadius=CGRectGetHeight(_layer!.bounds)/2
            _layer!.masksToBounds=true;
            if isGoodDetail == 1{//如果是商品详情
                _layer!.position=CGPointMake(imageView.center.x, CGRectGetMidY(rect)+120)
                self.view.layer.addSublayer(_layer!)
                path=UIBezierPath()
                path!.moveToPoint(_layer!.position)
                path!.addQuadCurveToPoint(CGPointMake(boundsWidth-40, UIScreen.mainScreen().bounds.height-90), controlPoint:CGPointMake(boundsWidth/2,rect.origin.y-80))
            }else{
                _layer!.position=CGPointMake(imageView.center.x, CGRectGetMidY(rect)+120)
                self.view.layer.addSublayer(_layer!)
                path=UIBezierPath()
                path!.moveToPoint(_layer!.position)
                path!.addQuadCurveToPoint(CGPointMake(boundsWidth-40, UIScreen.mainScreen().bounds.height-90), controlPoint:CGPointMake(boundsWidth/2,rect.origin.y-80))
            }
        }
        self.groupAnimation()
    }
    /**
     启动动画组
     */
    func groupAnimation(){
        tableView?.userInteractionEnabled=false
        let  animation=CAKeyframeAnimation(keyPath:"position")
        animation.path = path!.CGPath;
        animation.rotationMode = kCAAnimationRotateAuto;
        let expandAnimation = CABasicAnimation(keyPath:"transform.scale")
        expandAnimation.duration = 0.5;
        expandAnimation.fromValue = NSNumber(float:1)
        expandAnimation.toValue = NSNumber(float:2)
        expandAnimation.timingFunction=CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn)
        let narrowAnimation=CABasicAnimation(keyPath:"transform.scale")
        narrowAnimation.beginTime = 0.5;
        narrowAnimation.fromValue = NSNumber(float:2.0)
        narrowAnimation.duration = 0.5;
        narrowAnimation.toValue = NSNumber(float:0.3)
        
        narrowAnimation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let groups = CAAnimationGroup()
        groups.animations = [animation,expandAnimation,narrowAnimation];
        groups.duration = 1.0;
        groups.removedOnCompletion=false;
        groups.fillMode=kCAFillModeForwards;
        groups.delegate = self;
        _layer!.addAnimation(groups, forKey:"group")
        
        
    }
    
    /**
     删除对应的动画效果
     
     - parameter anim: CAAnimation
     - parameter flag: Bool
     */
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if (anim == _layer!.animationForKey("group")) {
            tableView?.userInteractionEnabled=true
            _layer?.removeFromSuperlayer()
            _layer=nil
            let shakeAnimation = CABasicAnimation(keyPath:"transform.translation.y")
            shakeAnimation.duration = 0.25;
            shakeAnimation.fromValue =  NSNumber(float:-5)
            shakeAnimation.toValue =  NSNumber(float:5)
            shakeAnimation.autoreverses = true
            UIView.animateWithDuration(10, animations: { () -> Void in
                let shoppingCarImg2=UIImage(named: "char2");
                self.button!.setBackgroundImage(shoppingCarImg2, forState: UIControlState.Normal)
                self.button!.layer.addAnimation(shakeAnimation, forKey:nil)
                
                }, completion: { (b) -> Void in
                    let delayInSeconds:Int64 = 1000000000 * 1
                    let c=delayInSeconds/4
                    let popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,c)
                    dispatch_after(popTime, dispatch_get_main_queue(), {
                        let shoppingCarImg1=UIImage(named: "char1");
                        self.button!.setBackgroundImage(shoppingCarImg1, forState: UIControlState.Normal)
                    })
            })
            
        }
    }

}
