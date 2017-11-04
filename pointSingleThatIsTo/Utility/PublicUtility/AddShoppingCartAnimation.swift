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
class AddShoppingCartAnimation:BaseViewController,CAAnimationDelegate{
    /// 接收tableView
    var tableView:UITableView?
    //  接收button
    var button:UIButton?
    
    fileprivate var _layer:CALayer?
    fileprivate var path:UIBezierPath?
    /**
     加入购物车特效
     
     - parameter rect:CGRect当前图片位置
     - parameter imageView:当前位置图片
     - parameter isGoodDetail:是否的商品详情1是否则商品列表
     */
    func startAnimationWithRect(_ rect:CGRect, imageView:UIImageView,isGoodDetail:Int){
        if _layer==nil{
            _layer=CALayer()
            _layer!.contents = imageView.layer.contents;
            
            _layer!.contentsGravity = kCAGravityResizeAspectFill;
            _layer!.bounds = rect;
            _layer!.cornerRadius=_layer!.bounds.height/2
            _layer!.masksToBounds=true;
            if isGoodDetail == 1{//如果是商品详情
                _layer!.position=CGPoint(x: imageView.center.x, y: rect.midY+120)
                self.view.layer.addSublayer(_layer!)
                path=UIBezierPath()
                path!.move(to: _layer!.position)
                path!.addQuadCurve(to: CGPoint(x: boundsWidth-40, y: UIScreen.main.bounds.height-90), controlPoint:CGPoint(x: boundsWidth/2,y: rect.origin.y-80))
            }else{
                _layer!.position=CGPoint(x: imageView.center.x, y: rect.midY+120)
                self.view.layer.addSublayer(_layer!)
                path=UIBezierPath()
                path!.move(to: _layer!.position)
                path!.addQuadCurve(to: CGPoint(x: boundsWidth-40, y: UIScreen.main.bounds.height-90), controlPoint:CGPoint(x: boundsWidth/2,y: rect.origin.y-80))
            }
        }
        self.groupAnimation()
    }
    /**
     启动动画组
     */
    func groupAnimation(){
        tableView?.isUserInteractionEnabled=false
        let  animation=CAKeyframeAnimation(keyPath:"position")
        animation.path = path!.cgPath;
        animation.rotationMode = kCAAnimationRotateAuto;
        let expandAnimation = CABasicAnimation(keyPath:"transform.scale")
        expandAnimation.duration = 0.5;
        expandAnimation.fromValue = NSNumber(value: 1 as Float)
        expandAnimation.toValue = NSNumber(value: 2 as Float)
        expandAnimation.timingFunction=CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn)
        let narrowAnimation=CABasicAnimation(keyPath:"transform.scale")
        narrowAnimation.beginTime = 0.5;
        narrowAnimation.fromValue = NSNumber(value: 2.0 as Float)
        narrowAnimation.duration = 0.5;
        narrowAnimation.toValue = NSNumber(value: 0.3 as Float)
        
        narrowAnimation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let groups = CAAnimationGroup()
        groups.animations = [animation,expandAnimation,narrowAnimation];
        groups.duration = 1.0;
        groups.isRemovedOnCompletion=false;
        groups.fillMode=kCAFillModeForwards;
        groups.delegate=self
        _layer!.add(groups, forKey:"group")
        
        
    }
    
    /**
     删除对应的动画效果
     
     - parameter anim: CAAnimation
     - parameter flag: Bool
     */
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if (anim == _layer!.animation(forKey: "group")) {
            tableView?.isUserInteractionEnabled=true
            _layer?.removeFromSuperlayer()
            _layer=nil
            let shakeAnimation = CABasicAnimation(keyPath:"transform.translation.y")
            shakeAnimation.duration = 0.25;
            shakeAnimation.fromValue =  NSNumber(value: -5 as Float)
            shakeAnimation.toValue =  NSNumber(value: 5 as Float)
            shakeAnimation.autoreverses = true
            UIView.animate(withDuration: 10, animations: { () -> Void in
                let shoppingCarImg2=UIImage(named: "char2");
                self.button!.setBackgroundImage(shoppingCarImg2, for: UIControlState())
                self.button!.layer.add(shakeAnimation, forKey:nil)

                }, completion: { (b) -> Void in
                    let delayInSeconds:Int64 = 1000000000 * 1
                    let c=delayInSeconds/4
                    let popTime:DispatchTime = DispatchTime.now() + Double(c) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: popTime, execute: {
                        let shoppingCarImg1=UIImage(named: "char1");
                        self.button!.setBackgroundImage(shoppingCarImg1, for: UIControlState())
                    })
            })

        }
    }

}
