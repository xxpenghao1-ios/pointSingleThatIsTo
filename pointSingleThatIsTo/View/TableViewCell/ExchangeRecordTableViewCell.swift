//
//  ExchangeRecordTableViewCell.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/7/29.
//  Copyright © 2016年 penghao. All rights reserved.
//

import UIKit
/// 兑换记录cell
class ExchangeRecordTableViewCell: UITableViewCell {
    /// 图片
    @IBOutlet weak var imgGood: UIImageView!
    /// 商品名称
    @IBOutlet weak var lblGoodName: UILabel!
    /// 兑换数量
    @IBOutlet weak var lblCount: UILabel!
    /// 兑换状态
    @IBOutlet weak var lblStatu: UILabel!
    /// 兑换时间
    @IBOutlet weak var lblTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        lblCount.textColor=UIColor.textColor()
        lblStatu.textColor=UIColor.textColor()
        lblTime.textColor=UIColor.textColor()
    }
    /**
     更新cell
     
     - parameter entity:ExchangeRecordEntity
     */
    func updateCell(entity:ExchangeRecordEntity){
        imgGood.sd_setImageWithURL(NSURL(string:URLIMG+entity.goodsPic!), placeholderImage:UIImage(named: "def_nil"))
        lblGoodName.text=entity.goodsName
        if entity.exchangeStatu == 1{
            lblStatu.text="已提交"
        }else if entity.exchangeStatu == 2{
            lblStatu.text="已成功"
        }
        if entity.exchangeCount != nil{
            lblCount.text="兑换数量\(entity.exchangeCount!)"
        }
        lblTime.text=entity.addTime
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
