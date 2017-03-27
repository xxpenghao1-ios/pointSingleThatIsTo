//
//  categoryListCell.swift
//  pointSingleThatIsTo
//
//  Created by 卢洋 on 16/2/19.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
//自定义cell
class categoryListCell:UICollectionViewCell{
    //cell容器
    var viewWarp:UIView!
    //文字标签
    var textLbl:UILabel?
    
    //品牌图像
    var imageItem:UIImageView?
    
    
    //接收当前cell宽度
    var cellPicW:CGFloat=0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //cell宽度
        cellPicW=frame.size.width
        //父容器
        viewWarp=UIView(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
        self.contentView.addSubview(viewWarp)
        //文字标签
        textLbl=UILabel()
        //品牌
        imageItem=UIImageView()
    }
    /**
    加载品项数据
    
    - parameter entity: GoodsCategoryEntity 商品分类实体类
    */
    func loadItemsData(entity:GoodsCategoryEntity){

        //1.图片
        imageItem=UIImageView(frame: CGRectMake((cellPicW-45)/2, 20, 45, 45))
        self.contentView.addSubview(imageItem!)
        //图片若为空，则给默认图
        let goodsCategoryIco=entity.goodsCategoryIco ?? ""
        imageItem!.sd_setImageWithURL(NSURL(string:URLIMG+goodsCategoryIco), placeholderImage: UIImage(named: "def_nil"))
        
        //2.文字
        textLbl!.textAlignment=NSTextAlignment.Center
        textLbl!.font=UIFont.systemFontOfSize(12)
        textLbl!.textColor=UIColor.blackColor()
        textLbl!.lineBreakMode=NSLineBreakMode.ByWordWrapping
        textLbl!.numberOfLines=2
        //文字若为空，给默认值""
        let text = entity.goodsCategoryName ?? ""
        let textSize = text.textSizeWithFont(textLbl!.font, constrainedToSize: CGSizeMake(cellPicW, 60))
        textLbl!.frame=CGRectMake(0,CGRectGetMaxY(imageItem!.frame)+1, cellPicW, textSize.height)
        textLbl!.text=text
        self.contentView.addSubview(textLbl!)
    }
    /**
    加载品牌三级分类数据
    
    - parameter entity: GoodsCategoryEntity  商品分类实体类
    */
    func loadBrandData(entity:GoodsCategoryEntity){
        //父容器
        viewWarp.layer.borderWidth=CGFloat(0.5)
        viewWarp.layer.borderColor=UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1).CGColor

        //文字
        textLbl!.lineBreakMode=NSLineBreakMode.ByWordWrapping
        textLbl!.numberOfLines=0
        textLbl!.tag=2
        textLbl!.font=UIFont.systemFontOfSize(13);
        textLbl!.textColor=UIColor.blackColor();
        viewWarp.addSubview(textLbl!)
        //文字若为空，给默认值""
        let text = entity.brandname ?? ""
        let textSize = text.textSizeWithFont(textLbl!.font, constrainedToSize: CGSizeMake(cellPicW, 50))
        textLbl!.frame=CGRectMake(0,(cellPicW-textSize.height)/2, cellPicW, textSize.height)
        textLbl!.textAlignment=NSTextAlignment.Center;
        textLbl?.text=text
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}