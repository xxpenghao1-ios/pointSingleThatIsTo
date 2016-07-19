//
//  SalePriceCollectionViewCell.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/1/19.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
/// 特价cell
class SalePriceCollectionViewCell:UICollectionViewCell{
    //图片
    var imgView:UIImageView!
    //价格
    var lblUprice:UILabel!
    //原价
    var lblUpriceVlaue:UILabel!
    //优惠
    var lblPreferential:UILabel!
    override init(frame: CGRect) {
        super.init(frame:frame)
        imgView=UIImageView(frame:CGRectMake((frame.size.width-(frame.size.width-40))/2,0,frame.size.width-40,frame.size.width-40))
        self.contentView.addSubview(imgView)
        
        lblPreferential=UILabel(frame:CGRectMake(0,CGRectGetMaxY(imgView.frame)+5,0,20))
        lblPreferential.backgroundColor=UIColor.applicationMainColor()
        lblPreferential.layer.cornerRadius=5
        lblPreferential.layer.masksToBounds=true
        lblPreferential.textColor=UIColor.whiteColor()
        lblPreferential.textAlignment=NSTextAlignment.Center
        lblPreferential.font=UIFont.systemFontOfSize(13)
        self.contentView.addSubview(lblPreferential)
        
        lblUprice=UILabel(frame:CGRectMake(0,CGRectGetMaxY(lblPreferential.frame)+10,frame.size.width,20))
        lblUprice.textColor=UIColor(red: 200/255, green:22/255, blue:35/255, alpha: 1)
        lblUprice.textAlignment=NSTextAlignment.Center
        lblUprice.font=UIFont.systemFontOfSize(14)
        self.contentView.addSubview(lblUprice)
        
    }
    /**
     更新cell
     
     - parameter entity:特价entity
     */
    func updateCell(entity:PreferentialAndGoodsEntity){
        imgView.sd_setImageWithURL(NSURL(string:URLIMG+entity.goodPic!), placeholderImage:UIImage(named:"def_nil"))
        lblUprice.text="￥\(entity.oldPrice!)"
        ///计算优惠价
        let preferential=NSString(string:entity.oldPrice!).floatValue-NSString(string:entity.preferentialPrice!).floatValue
        lblPreferential.text="优惠了￥\(preferential)"
        let  size=lblPreferential.text!.textSizeWithFont(lblPreferential.font, constrainedToSize:CGSizeMake(frame.size.width,20))
        lblPreferential.frame=CGRectMake((frame.size.width-(size.width+10))/2,CGRectGetMaxY(imgView.frame)+10,size.width+10,20)
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}