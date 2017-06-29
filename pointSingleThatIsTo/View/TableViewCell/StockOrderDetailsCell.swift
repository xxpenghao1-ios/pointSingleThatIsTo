//
//  StockOrderDetailsCell.swift
//  pointSingleThatIsTo
//
//  Created by 卢洋 on 16/2/25.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
///进货订单详情Cell
class StockOrderDetailsCell:UITableViewCell{
    
    /// 左边文字
    var lblLeftText:UILabel?
    
    //contentView的高度
    var contentH:CGFloat=0
    
    //cell的父容器
    var cellWarp:UIView!
    
    //商品图片
    var goodsPic:UIImageView?
    
    //商品标题
    var goodsTitle:UILabel?
    
    //商品价格
    var goodsPrice:UILabel?
    
    //商品数量
    var goodsCount:UILabel?
    
    var lblReturnGoodsFlag:UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //当前cell的高度
        contentH=50
        //初始化父容器
        cellWarp=UIView()
        
        //初始化商品图片
        goodsPic=UIImageView()
        
        //初始化商品标题
        goodsTitle=UILabel()
        
        //初始化商品价格
        goodsPrice=UILabel()
        
        //初始化商品数量
        goodsCount=UILabel()
        
        lblReturnGoodsFlag=UILabel()
        
        //初始化左边文字
        lblLeftText=UILabel()
        lblLeftText!.frame = CGRectMake(10, (contentH-20)/2, boundsWidth-20, 20)
        lblLeftText?.font=UIFont.systemFontOfSize(14)
        
    }
    /**
    加载商品不为空的情况下的数据
    
    - parameter entity:订单entity
    - parameter i:传当前行索引
    */
    func loadHaveGoods(entity:OrderListEntity,i:Int){
        //定义常量边距
        let margin:CGFloat=10
        //保存商品entity的数组
        let goodsList=entity.list!
        if(goodsList.count > 0){
            let goodsEntity=goodsList[i] as! GoodDetailEntity
            //商品图片
            goodsPic!.frame=CGRectMake(margin, margin, 80, 80)
            goodsPic!.layer.borderWidth=0.5
            goodsPic!.layer.borderColor=UIColor.borderColor().CGColor
            self.contentView.addSubview(goodsPic!)
            //商品图片若为空，则给默认图,防止程序crash
            var saveGoodsPic=""
            if(goodsEntity.goodPic != nil){
                saveGoodsPic=URLIMG + goodsEntity.goodPic!
            }
            goodsPic!.sd_setImageWithURL(NSURL(string: saveGoodsPic),placeholderImage:UIImage(named: "def_nil"))
            //实例化商品标题frame
            goodsTitle?.frame=CGRectMake(CGRectGetMaxX(goodsPic!.frame)+5, margin, boundsWidth-CGRectGetMaxX(goodsPic!.frame), 20)
            //商品标题
            goodsTitle?.text=goodsEntity.goodInfoName
            goodsTitle?.font=UIFont.systemFontOfSize(14)
            goodsTitle?.numberOfLines=1
            self.contentView.addSubview(goodsTitle!)
            
            //商品可不可退
            lblReturnGoodsFlag?.frame=CGRectMake(CGRectGetMaxX(goodsPic!.frame)+5, CGRectGetMaxY(goodsPic!.frame)-40, 200, 20)
            lblReturnGoodsFlag?.font=UIFont.systemFontOfSize(13)
            lblReturnGoodsFlag?.textColor=UIColor.textColor()
            if goodsEntity.returnGoodsFlag != nil{
                if goodsEntity.returnGoodsFlag == 1{
                    lblReturnGoodsFlag?.text="该商品可以退换"
                }else if goodsEntity.returnGoodsFlag == 2{
                    lblReturnGoodsFlag?.text="该商品不可退换"
                }
                self.contentView.addSubview(lblReturnGoodsFlag!)
            }

            
            //实例化商品价格frame
            goodsPrice?.frame=CGRectMake(CGRectGetMaxX(goodsPic!.frame)+5, CGRectGetMaxY(goodsPic!.frame)-20, 200, 20)
            //接收单价
            var singlePrice="0.0"
            if(goodsEntity.goodsUprice != nil && goodsEntity.goodsUprice != ""){//是否为空
                singlePrice=goodsEntity.goodsUprice!
            }
            goodsPrice?.text="￥"+singlePrice
            goodsPrice?.textColor=UIColor.applicationMainColor()
            self.contentView.addSubview(goodsPrice!)
            
            //实例化商品数量frame
            var kGoodsCount="x1"
            if(goodsEntity.goodsSumCount != nil && goodsEntity.goodsSumCount != ""){//是否为空
                kGoodsCount="x"+goodsEntity.goodsSumCount!
            }
            goodsCount?.font=UIFont.systemFontOfSize(14)
            goodsCount?.numberOfLines=1
            goodsCount?.lineBreakMode=NSLineBreakMode.ByWordWrapping
            let goodsCountSize=kGoodsCount.textSizeWithFont(goodsCount!.font, constrainedToSize: CGSizeMake(100, 20))
            goodsCount?.frame=CGRectMake(boundsWidth-20-goodsCountSize.width, CGRectGetMaxY(goodsPic!.frame)-20, goodsCountSize.width, goodsCountSize.height)
            goodsCount?.text=kGoodsCount
            self.contentView.addSubview(goodsCount!)
        }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}