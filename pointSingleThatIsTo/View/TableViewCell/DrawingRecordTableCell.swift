//
//  DrawingRecordTableCell.swift
//  pointSingleThatIsTo
//
//  Created by nevermore on 16/1/28.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
/// 已兑奖产品
class DrawingRecordTableCell: UITableViewCell {
    /// cell容器
    var cellview:UIView?
    /// 产品推荐人
    var ProductProvider:UILabel?
    /// 兑奖人
    var Casher:UILabel?
    /// 兑奖时间
    var awardingTime:UILabel?
    /// 兑奖产品图片
    var productsImg:UIImageView?
    /// 产品介绍
    var productsLable:UILabel?
    /// 产品数量label
    var productsCount:UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        celllayout();
       
    }
    /**
     cell布局
     */
    func celllayout(){
        self.contentView.backgroundColor=UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1)
        //初始化cell容器
        cellview=UIView()
        cellview?.backgroundColor=UIColor.whiteColor()
        cellview?.layer.cornerRadius=5
        
        self.contentView.addSubview(cellview!)
        //初始化产品提供方
        ProductProvider=UILabel()
        
        ProductProvider?.font=UIFont.systemFontOfSize(14)
        cellview?.addSubview(ProductProvider!)
        //初始化兑奖人
        Casher=UILabel()
        
        Casher?.font=UIFont.systemFontOfSize(12)
        cellview?.addSubview(Casher!)
        //初始化兑奖时间
        awardingTime=UILabel()
        awardingTime?.font=UIFont.systemFontOfSize(12)
        awardingTime?.textColor=UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        cellview?.addSubview(awardingTime!)
        //初始化产品图片
        productsImg=UIImageView()
        cellview?.addSubview(productsImg!)
        //初始化产品介绍
        productsLable=UILabel()
        productsLable?.numberOfLines=0
        productsLable?.lineBreakMode=NSLineBreakMode.ByWordWrapping
        productsLable?.font=UIFont.systemFontOfSize(14)
        cellview?.addSubview(productsLable!)
        //初始化产品数量标签
        productsCount=UILabel()
        productsCount?.font=UIFont.systemFontOfSize(12)
        productsCount?.textAlignment=NSTextAlignment.Right
        cellview?.addSubview(productsCount!)
        
        
    }
    /**
     cell数据
     */
    func celldate(entity:DrawingRecordEntity){
        let supplierName=entity.supplierName ?? ""
        cellview?.frame=CGRectMake(10, 5, boundsWidth-20, 185)
        //初始化产品提供方
        ProductProvider?.text="产品推荐方：\(supplierName)"
        ProductProvider?.frame=CGRectMake(5, 5, self.cellview!.frame.width, 20)
        //初始化兑奖人
        let CasherName=entity.memberName ?? ""
        Casher?.text="兑奖人：\(CasherName)"
        Casher?.frame=CGRectMake(CGRectGetMinX(ProductProvider!.frame), CGRectGetMaxY(ProductProvider!.frame)+5, CGRectGetWidth(ProductProvider!.frame), 20)
        //初始化兑奖时间
        let awardingTimes=entity.awardingTime ?? ""
        awardingTime?.text="兑奖时间：\(awardingTimes)"
        awardingTime?.frame=CGRectMake(CGRectGetMinX(ProductProvider!.frame), CGRectGetMaxY(Casher!.frame)+5, CGRectGetWidth(ProductProvider!.frame), 20)
        //初始化产品图片
        let productsImgs=entity.goodsPic ?? ""
        productsImg?.sd_setImageWithURL(NSURL(string: URLIMG+productsImgs),placeholderImage: UIImage(named: "16.jpg"))
        productsImg?.frame=CGRectMake(10, CGRectGetMaxY(awardingTime!.frame)+5, 100, 100)

        //初始化产品介绍
        let productsLables=entity.goodsName ?? ""
        productsLable?.text=productsLables
        
        let textsize=productsLable?.text!.textSizeWithFont(productsLable!.font, constrainedToSize: CGSizeMake(boundsWidth-150, 100))
        
        productsLable?.frame=CGRectMake(CGRectGetMaxX(productsImg!.frame)+5, CGRectGetMaxY(awardingTime!.frame)+5,boundsWidth-150,textsize!.height)
       
        //初始化产品数量标签
        
        productsCount?.frame=CGRectMake(self.cellview!.frame.width-100,CGRectGetMaxY(productsImg!.frame)-20, 90, 20)
        productsCount?.text="*1"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}