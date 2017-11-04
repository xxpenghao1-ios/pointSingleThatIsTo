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
        hotView=UIView(frame:CGRect(x: 0,y: 0,width: frame.size.width,height: frame.size.height))
        hotView.layer.cornerRadius=10;
        hotView.layer.borderColor=UIColor(red:215/255, green:215/255, blue: 215/255, alpha: 1).cgColor
        hotView.layer.borderWidth=1
        self.contentView.addSubview(hotView)
        //商品图片
        goodImgView=UIImageView(frame:CGRect(x: (frame.size.width-100)/2,y: 20,width: 100, height: 100))
        self.contentView.addSubview(goodImgView)
        //商品名称
        goodName=UILabel(frame:CGRect(x: 10,y: goodImgView.frame.maxY+20,width: frame.size.width-20,height: 40))
        goodName.font=UIFont.systemFont(ofSize: 13)
        goodName.lineBreakMode=NSLineBreakMode.byWordWrapping
        goodName.numberOfLines=2
        self.contentView.addSubview(goodName)
        //边线
        let border=UIView(frame:CGRect(x: 10,y: goodName.frame.maxY+5,width: frame.size.width-20,height: 0.5))
        border.backgroundColor=UIColor.borderColor()
        self.contentView.addSubview(border)
        //价格
        goodUpice=UILabel(frame:CGRect(x: 0,y: border.frame.maxY+5
            ,width: frame.size.width,height: 20))
        goodUpice.textAlignment=NSTextAlignment.center
        goodUpice.textColor=UIColor(red:255/255, green:0/255, blue:0/255, alpha:1)
        self.contentView.addSubview(goodUpice)
        
        
    }

    /**
     更新cell
     
     - parameter entity:热门商品entity
     */
    func updateCell(_ entity:GoodDetailEntity){
       entity.goodPic=entity.goodPic ?? ""
        goodImgView.sd_setImage(with:Foundation.URL(string:URLIMG+entity.goodPic!), placeholderImage:UIImage(named:"def_nil"))
        goodName.text=entity.goodInfoName!
        goodUpice.text="￥\(entity.uprice!)"
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
