//
//  GoodSpecialPriceViewController.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/2/23.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
/// 商品特价
class  GoodSpecialPriceViewController:BaseViewController{
    
    /// 接收传入的分类集合
    var arr:NSMutableArray?
    
    /// 销量
    var salesVC=GoodSpecialPriceSalesViewController()
    /// 价格
    var priceVC=GoodSpecialPriceUpriceViewController()
    
    var skScNavC:SKScNavViewController?
    
    /// 遮罩层
    var maskView:UIView?
    
    /// 弹出view
    var alertView:UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="特价商品"
        self.view.backgroundColor=UIColor.whiteColor()
        
        let categoryItem=UIBarButtonItem(title:"分类查询", style: UIBarButtonItemStyle.Plain, target:self, action:"categorySelect:");
        self.navigationItem.rightBarButtonItem=categoryItem
        //默认给0
        buildView(0)
        
        
    }
    /**
     加载页面
     
     - parameter categoryId: 分类id
     */
    func buildView(categoryId:Int){
        salesVC.title="销量"
        salesVC.categoryId=categoryId
        priceVC.title="价格"
        priceVC.categoryId=categoryId
        skScNavC=nil
        skScNavC=SKScNavViewController(subViewControllers:[salesVC,priceVC])
        skScNavC!.showArrowButton=false
        skScNavC!.addParentController(self)

    }
    /**
     切换分类
     
     - parameter sender:UIBarButtonItem
     */
    func categorySelect(sender:UIBarButtonItem){
        alertViewStyle(arr)
    }
    //弹出窗体
    func alertViewStyle(categoryArr:NSMutableArray?){
        if UIApplication.sharedApplication().applicationSupportsShakeToEdit.boolValue == true{
            UIApplication.sharedApplication().applicationSupportsShakeToEdit=false;
        }
        //遮罩层
        maskView=UIView(frame:CGRectMake(0,-40,boundsWidth,boundsHeight-20));
        maskView!.backgroundColor=UIColor(red: 0, green:0, blue:0, alpha:0.5);
        //窗体内容
        alertView=UIView(frame:CGRectMake((maskView!.frame.width-300)/2,(maskView!.frame.height-400)/2,300,400));
        alertView!.backgroundColor=UIColor.whiteColor();
        alertView!.layer.cornerRadius = 5;
        alertView!.layer.masksToBounds = true;
        maskView!.addSubview(alertView!);
        //分类名称view
        var btnViewY:CGFloat=0;
        if categoryArr != nil{
            for(var i=0;i<categoryArr!.count;i++){
                let entity=categoryArr![i] as! GoodsCategoryEntity;
                let btnView=UIButton(frame:CGRectMake(0,btnViewY,200, 39.5));
                btnView.tag=entity.goodsCategoryId!;
                btnView.setTitle(entity.goodsCategoryName!, forState:.Normal)
                btnView.setTitleColor(UIColor.textColor(), forState:.Normal)
                btnView.titleLabel!.font=UIFont.boldSystemFontOfSize(16);
                btnView.addTarget(self, action:"selectGoodListById:", forControlEvents: UIControlEvents.TouchUpInside);
                alertView!.addSubview(btnView);
                let border=UIView(frame:CGRectMake(0,btnView.frame.height+btnView.frame.origin.y,btnView.frame.width,0.5));
                border.backgroundColor=UIColor.goodDetailBorderColor()
                alertView!.addSubview(border)
                btnViewY+=40;
            }
        }
        alertView!.frame=CGRectMake((maskView!.frame.width-200)/2,(maskView!.frame.height-btnViewY)/2,200,btnViewY);
        self.view.addSubview(maskView!)
        
    }
    func selectGoodListById(sender:UIButton){
        self.title="特价商品/\(sender.titleLabel!.text!)"
        //发送通知 刷新页面
        NSNotificationCenter.defaultCenter().postNotificationName("selectedCategory", object:sender.tag)
        
        closeMakeAlert();//关闭弹出窗
    }
    //关闭遮罩层和弹出窗
    func closeMakeAlert(){
        self.maskView?.removeFromSuperview();
    }
}