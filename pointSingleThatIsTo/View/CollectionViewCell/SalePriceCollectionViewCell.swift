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
        imgView=UIImageView(frame:CGRect(x: (frame.size.width-(frame.size.width-40))/2,y: 0,width: frame.size.width-40,height: frame.size.width-40))
        self.contentView.addSubview(imgView)
        
        lblPreferential=UILabel(frame:CGRect(x: 0,y: imgView.frame.maxY+5,width: 0,height: 20))
        lblPreferential.backgroundColor=UIColor.applicationMainColor()
        lblPreferential.layer.cornerRadius=5
        lblPreferential.layer.masksToBounds=true
        lblPreferential.textColor=UIColor.white
        lblPreferential.textAlignment=NSTextAlignment.center
        lblPreferential.font=UIFont.systemFont(ofSize: 13)
        self.contentView.addSubview(lblPreferential)
        
        lblUprice=UILabel(frame:CGRect(x: 0,y: lblPreferential.frame.maxY+10,width: frame.size.width,height: 20))
        lblUprice.textColor=UIColor(red: 200/255, green:22/255, blue:35/255, alpha: 1)
        lblUprice.textAlignment=NSTextAlignment.center
        lblUprice.font=UIFont.systemFont(ofSize: 14)
        self.contentView.addSubview(lblUprice)
        
    }
    /**
     更新cell
     
     - parameter entity:特价entity
     */
    func updateCell(_ entity:PreferentialAndGoodsEntity){
        imgView.sd_setImage(with: Foundation.URL(string:URLIMG+entity.goodPic!), placeholderImage:UIImage(named:"def_nil"))
        lblUprice.text="￥\(entity.oldPrice!)"
        ///计算优惠价
        let preferential=NSString(string:entity.oldPrice!).floatValue-NSString(string:entity.preferentialPrice!).floatValue
        lblPreferential.text="优惠了￥\(preferential)"
        let  size=lblPreferential.text!.textSizeWithFont(lblPreferential.font, constrainedToSize:CGSize(width: frame.size.width,height: 20))
        lblPreferential.frame=CGRect(x: (frame.size.width-(size.width+10))/2,y: imgView.frame.maxY+10,width: size.width+10,height: 20)
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
