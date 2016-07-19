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
    /// 商品单位
    @IBOutlet weak private var lblUnit: UILabel!
    /// 剩余兑换数
    @IBOutlet weak private var lblRemainingExchangeNumber: UILabel!
    /// 消耗积分
    @IBOutlet weak private var lblConsumptionIntegral: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        lblUnit.textColor=UIColor.textColor()
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
     
     - parameter entity:消费记录entity
     */
    func updateCell(){
        ImgGood.sd_setImageWithURL(NSURL(string:URLIMG+""), placeholderImage:UIImage(named: "def_nil"))
        
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
