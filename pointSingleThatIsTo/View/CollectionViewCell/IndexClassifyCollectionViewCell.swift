//
//  IndexClassifyCollectionViewCell.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/1/19.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
///首页分类CollectionViewCell
class IndexClassifyCollectionViewCell:UICollectionViewCell {
    //分类图片
    var imgView:UIImageView!;
    //分类名称
    var name:UILabel!;
    //索引
    var index:Int?;
    override init(frame: CGRect){
        super.init(frame:frame);
        imgView=UIImageView(frame:CGRectMake(10,0,frame.size.width-20,frame.size.height-20));
        self.contentView.addSubview(imgView);
        
        name=UILabel(frame:CGRectMake(0,frame.height-20,frame.width,20));
        name.font=UIFont.systemFontOfSize(13);
        name.textAlignment=NSTextAlignment.Center;
        self.contentView.addSubview(name);
    }
    //传入数据
    func updaeCell(entity:GoodsCategoryEntity){
        name.text=entity.goodsCategoryName!;
        imgView.sd_setImageWithURL(NSURL(string:URLIMG+entity.goodsCategoryIco!), placeholderImage:UIImage(named:"def_fl"));
        
    }
    /**
     根据传入的内容 展示特定的分类
     
     - parameter str: 名称
     - parameter pic: 图片
     */
    func updateCell1(str:String,pic:String){
        name.text=str
        imgView.image=UIImage(named:pic)
        
    }
    required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }

}