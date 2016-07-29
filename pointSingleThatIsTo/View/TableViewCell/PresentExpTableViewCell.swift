//
//  PresentExpTableViewCell.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/7/18.
//  Copyright © 2016年 penghao. All rights reserved.
//

import UIKit
/**
 *购物积分兑换商品cell协议
 */
protocol PresentExpTableViewCellDelegate:NSObjectProtocol{
    /**
     发送网络请求提交兑换商品信息
     
     - parameter entity:IntegralGoodExchangeEntity
     */
    func httpExchangeInfo(entity:IntegralGoodExchangeEntity,index:NSIndexPath)
}
/// 购物积分兑换商品cell
class PresentExpTableViewCell: UITableViewCell {
    internal var delegate:PresentExpTableViewCellDelegate?
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
    /// 用于保存传入的实体对象
    private var cellEntity:IntegralGoodExchangeEntity?
    /// 记录行索引
    internal var index:NSIndexPath?
    override func awakeFromNib() {
        super.awakeFromNib()
        lblRemainingExchangeNumber.textColor=UIColor.textColor()
        lblConsumptionIntegral.textColor=UIColor.textColor()
        btnExchange.backgroundColor=UIColor.applicationMainColor()
        btnExchange.titleLabel!.textColor=UIColor.whiteColor()
        btnExchange.layer.cornerRadius=15
        btnExchange.addTarget(self, action:"submitExchangeInfo:", forControlEvents: UIControlEvents.TouchUpInside)
        //去掉选中背景
        self.selectionStyle=UITableViewCellSelectionStyle.None;
        // Initialization code
    }
    /**
     更新cell
     
     - parameter entity:IntegralGoodExchangeEntity
     */
    func updateCell(entity:IntegralGoodExchangeEntity){
        cellEntity=entity
        
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
// MARK: - 点击事件
extension PresentExpTableViewCell{
    /**
     提交兑换信息
     
     - parameter sender: UIButton
     */
    func submitExchangeInfo(sender:UIButton){
        delegate?.httpExchangeInfo(cellEntity!,index:index!)
    }
}
