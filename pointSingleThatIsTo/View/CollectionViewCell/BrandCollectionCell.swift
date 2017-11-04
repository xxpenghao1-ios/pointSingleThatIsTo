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
            btn=UIButton(frame:CGRect(x: 10,y: 10,width: frame.width-20,height: 28))
            btn.titleLabel!.font=UIFont.systemFont(ofSize: 12)
            btn.layer.cornerRadius=14
        }else{
            btn=UIButton(frame:CGRect(x: 10,y: 10,width: boundsWidth/3-20,height: 32))
            btn.titleLabel!.font=UIFont.systemFont(ofSize: 14)
            btn.layer.cornerRadius=16
        }
        btn.layer.borderWidth=1
        btn.layer.borderColor=UIColor(red:0, green:214/255, blue:152/255, alpha:1).cgColor
        btn.setTitleColor(UIColor.black, for: UIControlState())
        self.contentView.addSubview(btn)
        
    }
    /**
     更新cell
     
     - parameter entity:
     */
    func updateCell(_ entity:GoodsCategoryEntity){
        btn.setTitle(entity.brandname, for: UIControlState())
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
