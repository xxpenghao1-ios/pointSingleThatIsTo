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
        cellview?.backgroundColor=UIColor.white
        cellview?.layer.cornerRadius=5
        
        self.contentView.addSubview(cellview!)
        //初始化产品提供方
        ProductProvider=UILabel()
        
        ProductProvider?.font=UIFont.systemFont(ofSize: 14)
        cellview?.addSubview(ProductProvider!)
        //初始化兑奖人
        Casher=UILabel()
        
        Casher?.font=UIFont.systemFont(ofSize: 12)
        cellview?.addSubview(Casher!)
        //初始化兑奖时间
        awardingTime=UILabel()
        awardingTime?.font=UIFont.systemFont(ofSize: 12)
        awardingTime?.textColor=UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        cellview?.addSubview(awardingTime!)
        //初始化产品图片
        productsImg=UIImageView()
        cellview?.addSubview(productsImg!)
        //初始化产品介绍
        productsLable=UILabel()
        productsLable?.numberOfLines=0
        productsLable?.lineBreakMode=NSLineBreakMode.byWordWrapping
        productsLable?.font=UIFont.systemFont(ofSize: 14)
        cellview?.addSubview(productsLable!)
        //初始化产品数量标签
        productsCount=UILabel()
        productsCount?.font=UIFont.systemFont(ofSize: 12)
        productsCount?.textAlignment=NSTextAlignment.right
        cellview?.addSubview(productsCount!)
        
        
    }
    /**
     cell数据
     */
    func celldate(_ entity:DrawingRecordEntity){
        let supplierName=entity.supplierName ?? ""
        cellview?.frame=CGRect(x: 10, y: 5, width: boundsWidth-20, height: 185)
        //初始化产品提供方
        ProductProvider?.text="产品推荐方：\(supplierName)"
        ProductProvider?.frame=CGRect(x: 5, y: 5, width: self.cellview!.frame.width, height: 20)
        //初始化兑奖人
        let CasherName=entity.memberName ?? ""
        Casher?.text="兑奖人：\(CasherName)"
        Casher?.frame=CGRect(x: ProductProvider!.frame.minX, y: ProductProvider!.frame.maxY+5, width: ProductProvider!.frame.width, height: 20)
        //初始化兑奖时间
        let awardingTimes=entity.awardingTime ?? ""
        awardingTime?.text="兑奖时间：\(awardingTimes)"
        awardingTime?.frame=CGRect(x: ProductProvider!.frame.minX, y: Casher!.frame.maxY+5, width: ProductProvider!.frame.width, height: 20)
        //初始化产品图片
        let productsImgs=entity.goodsPic ?? ""
        productsImg?.sd_setImage(with: Foundation.URL(string: URLIMG+productsImgs),placeholderImage: UIImage(named: "16.jpg"))
        productsImg?.frame=CGRect(x: 10, y: awardingTime!.frame.maxY+5, width: 100, height: 100)

        //初始化产品介绍
        let productsLables=entity.goodsName ?? ""
        productsLable?.text=productsLables
        
        let textsize=productsLable?.text!.textSizeWithFont(productsLable!.font, constrainedToSize: CGSize(width: boundsWidth-150, height: 100))
        
        productsLable?.frame=CGRect(x: productsImg!.frame.maxX+5, y: awardingTime!.frame.maxY+5,width: boundsWidth-150,height: textsize!.height)
       
        //初始化产品数量标签
        
        productsCount?.frame=CGRect(x: self.cellview!.frame.width-100,y: productsImg!.frame.maxY-20, width: 90, height: 20)
        productsCount?.text="*1"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
