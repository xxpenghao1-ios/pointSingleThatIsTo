//
//  BrandCollectionCell.swift
//  pointSingleThatIsTo
//
//  Created by hao peng on 2017/3/23.
//  Copyright © 2017年 penghao. All rights reserved.
//

import Foundation
/// 品牌cell
class BrandCollectionCell:UICollectionViewCell {
    var btn:UIButton!
    override init(frame:CGRect) {
        super.init(frame:frame)
        if frame.width < boundsWidth/3-10{
            btn=UIButton(frame:CGRectMake(10,10,frame.width-20,28))
            btn.titleLabel!.font=UIFont.systemFontOfSize(12)
            btn.layer.cornerRadius=14
        }else{
            btn=UIButton(frame:CGRectMake(10,10,boundsWidth/3-20,32))
            btn.titleLabel!.font=UIFont.systemFontOfSize(14)
            btn.layer.cornerRadius=16
        }
        btn.layer.borderWidth=1
        btn.layer.borderColor=UIColor(red:0, green:214/255, blue:152/255, alpha:1).CGColor
        btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.contentView.addSubview(btn)
        
    }
    /**
     更新cell
     
     - parameter entity:
     */
    func updateCell(entity:GoodsCategoryEntity){
        btn.setTitle(entity.brandname, forState: UIControlState.Normal)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}