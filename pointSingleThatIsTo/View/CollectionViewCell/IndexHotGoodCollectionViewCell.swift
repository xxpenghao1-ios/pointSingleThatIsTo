//
//  IndexHotGoodCollectionViewCell.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/1/20.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
/// 首页热门商品cell
class IndexHotGoodCollectionViewCell:UICollectionViewCell {
    /// 热门商品view
    var hotView:UIView!
    /// 图片
    var goodImgView:UIImageView!
    /// 名称
    var goodName:UILabel!
    /// 价格
    var goodUpice:UILabel!
    override init(frame: CGRect) {
        super.init(frame:frame)
        hotView=UIView(frame:CGRectMake(0,0,frame.size.width,frame.size.height))
        hotView.layer.cornerRadius=10;
        hotView.layer.borderColor=UIColor(red:215/255, green:215/255, blue: 215/255, alpha: 1).CGColor
        hotView.layer.borderWidth=1
        self.contentView.addSubview(hotView)
        //商品图片
        goodImgView=UIImageView(frame:CGRectMake((frame.size.width-100)/2,20,100, 100))
        self.contentView.addSubview(goodImgView)
        //商品名称
        goodName=UILabel(frame:CGRectMake(10,CGRectGetMaxY(goodImgView.frame)+20,frame.size.width-20,40))
        goodName.font=UIFont.systemFontOfSize(13)
        goodName.lineBreakMode=NSLineBreakMode.ByWordWrapping
        goodName.numberOfLines=2
        self.contentView.addSubview(goodName)
        //边线
        let border=UIView(frame:CGRectMake(10,CGRectGetMaxY(goodName.frame)+5,frame.size.width-20,0.5))
        border.backgroundColor=UIColor.borderColor()
        self.contentView.addSubview(border)
        //价格
        goodUpice=UILabel(frame:CGRectMake(0,CGRectGetMaxY(border.frame)+5
            ,frame.size.width,20))
        goodUpice.textAlignment=NSTextAlignment.Center
        goodUpice.textColor=UIColor(red:255/255, green:0/255, blue:0/255, alpha:1)
        self.contentView.addSubview(goodUpice)
        
        
    }

    /**
     更新cell
     
     - parameter entity:热门商品entity
     */
    func updateCell(entity:GoodDetailEntity){
        goodImgView.sd_setImageWithURL(NSURL(string:URLIMG+entity.goodPic!), placeholderImage:UIImage(named:"def_nil"))
        goodName.text=entity.goodInfoName!
        goodUpice.text="￥\(entity.uprice!)"
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}