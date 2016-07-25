//
//  PresentExpTableViewCell.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/7/18.
//  Copyright © 2016年 penghao. All rights reserved.
//

import UIKit
/// 购物积分cell
class PresentExpTableViewCell: UITableViewCell {
    /// 兑换按钮
    @IBOutlet weak private var btnExchange: UIButton!
    /// 商品图片
    @IBOutlet weak private var ImgGood: UIImageView!
    /// 商品名称
    @IBOutlet weak private var lblGoodName: UILabel!
    /// 剩余兑换数
    @IBOutlet weak private var lblRemainingExchangeNumber: UILabel!
    /// 消耗积分
    @IBOutlet weak private var lblConsumptionIntegral: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        lblRemainingExchangeNumber.textColor=UIColor.textColor()
        lblConsumptionIntegral.textColor=UIColor.textColor()
        btnExchange.backgroundColor=UIColor.applicationMainColor()
        btnExchange.titleLabel!.textColor=UIColor.whiteColor()
        btnExchange.layer.cornerRadius=15
        //去掉选中背景
        self.selectionStyle=UITableViewCellSelectionStyle.None;
        // Initialization code
    }
    /**
     更新cell
     
     - parameter entity:IntegralGoodExchangeEntity
     */
    func updateCell(entity:IntegralGoodExchangeEntity){
        
        ImgGood.sd_setImageWithURL(NSURL(string:URLIMG+entity.goodsPic!), placeholderImage:UIImage(named: "def_nil"))
        if entity.goodsSurplusCount != nil{
            lblRemainingExchangeNumber.text="剩余兑换:\(entity.goodsSurplusCount!)"
        }else{
            entity.goodsSurplusCount=0
            lblRemainingExchangeNumber.text="剩余兑换:\(entity.goodsSurplusCount!)"
        }
        lblGoodName.text=entity.goodsName
        if entity.exchangeIntegral != nil{
            lblConsumptionIntegral.text="消耗积分:\(entity.exchangeIntegral!)"
        }else{
            lblConsumptionIntegral.text="消耗积分:0"
        }
        
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
