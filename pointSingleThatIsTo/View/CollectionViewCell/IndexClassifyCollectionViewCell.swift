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
        imgView=UIImageView(frame:CGRect(x: 10,y: 0,width: frame.size.width-20,height: frame.size.height-20));
        self.contentView.addSubview(imgView);
        
        name=UILabel(frame:CGRect(x: 0,y: frame.height-20,width: frame.width,height: 20));
        name.font=UIFont.systemFont(ofSize: 13);
        name.textAlignment=NSTextAlignment.center;
        self.contentView.addSubview(name);
    }
    //传入数据
    func updaeCell(_ entity:GoodsCategoryEntity){
        name.text=entity.goodsCategoryName!;
        entity.goodsCategoryIco=entity.goodsCategoryIco ?? ""
        imgView.sd_setImage(with: Foundation.URL(string:URLIMG+entity.goodsCategoryIco!), placeholderImage:UIImage(named:"def_fl"));
        
    }
    /**
     根据传入的内容 展示特定的分类
     
     - parameter str: 名称
     - parameter pic: 图片
     */
    func updateCell1(_ str:String,pic:String){
        name.text=str
        imgView.image=UIImage(named:pic)
        
    }
    required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }

}
