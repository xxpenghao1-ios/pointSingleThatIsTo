//
//  CanBeTicketViewControllerCell.swift
//  pointSingleThatIsTo
//
//  Created by nevermore on 16/2/18.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit

/// 未兑奖产品
class CanBeTicketViewControllerCell:UITableViewCell {
    /// 兑奖产品图片
    var productsImg:UIImageView?
    /// 产品介绍
    var productsLable:UILabel?
    /// 产品总数量label
    var productsCount:UILabel?
    /// 剩余数量
    var pCount:UILabel?

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        ui();
    }
    //ui布局
    func ui(){
        /// 兑奖产品图片
        productsImg=UIImageView()
        productsImg?.layer.borderColor=UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1).cgColor
        productsImg?.layer.borderWidth=0.5
        self.contentView.addSubview(productsImg!)
        /// 产品介绍
        productsLable=UILabel()
        productsLable?.font=UIFont.systemFont(ofSize: 14)
        productsLable?.numberOfLines=0
        productsLable?.lineBreakMode=NSLineBreakMode.byCharWrapping
        self.contentView.addSubview(productsLable!)
        /// 产品总数量label
        productsCount=UILabel()
        productsCount?.font=UIFont.systemFont(ofSize: 14)
        self.contentView.addSubview(productsCount!)
        /// 剩余数量
        pCount=UILabel()
        pCount?.font=UIFont.systemFont(ofSize: 14)
        self.contentView.addSubview(pCount!)

        
    }
    //数据显示
    func dateShow(_ entitys:CanBeTicketViewControllerEntity){
        
        /// 兑奖产品图片
        productsImg?.frame=CGRect(x: 10, y: 10, width: 100, height: 100)
        entitys.goodPic=entitys.goodPic ?? ""
        productsImg?.sd_setImage(with: Foundation.URL(string: URLIMG+entitys.goodPic!),placeholderImage: UIImage(named: "def_fl"))
        
        /// 产品介绍
        productsLable?.text=entitys.goodsName!
        let textsize=productsLable?.text?.textSizeWithFont(productsLable!.font, constrainedToSize: CGSize(width: boundsWidth-130, height: 100))
        productsLable?.frame=CGRect(x: productsImg!.frame.maxX+10, y: 10, width: boundsWidth-130, height: textsize!.height)
        
        /// 产品总数量label
        productsCount?.frame=CGRect(x: productsImg!.frame.maxX+10, y: 90, width: 120, height: 20)
        let str:NSMutableAttributedString=NSMutableAttributedString(string:"总数量：\(entitys.goodsSum!)");
        let count = "\(entitys.goodsSum!)".characters.count
        str.addAttribute(NSAttributedStringKey.foregroundColor, value:UIColor(red: 0.85, green: 0.38, blue: 0.17, alpha: 1), range:NSMakeRange(4,count));
        productsCount?.attributedText=str
        
        /// 剩余数量
        pCount?.frame=CGRect(x: boundsWidth-110, y: productsCount!.frame.minY, width: 120, height: 20)
        pCount?.text="剩余数量：\(entitys.storeSurplusGoodsSum!)"
        let str1:NSMutableAttributedString=NSMutableAttributedString(string:"剩余数量：\(entitys.storeSurplusGoodsSum!)");
        let counts = "\(entitys.storeSurplusGoodsSum!)".characters.count
        str1.addAttribute(NSAttributedStringKey.foregroundColor, value:UIColor(red: 0.85, green: 0.38, blue: 0.17, alpha: 1), range:NSMakeRange(5,counts));
        pCount?.attributedText=str1
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
