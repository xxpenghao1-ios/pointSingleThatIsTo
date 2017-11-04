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
    func httpExchangeInfo(_ entity:IntegralGoodExchangeEntity,index:IndexPath)
}
/// 购物积分兑换商品cell
class PresentExpTableViewCell: UITableViewCell {
    internal var delegate:PresentExpTableViewCellDelegate?
    /// 兑换按钮
    @IBOutlet weak fileprivate var btnExchange: UIButton!
    /// 商品图片
    @IBOutlet weak fileprivate var ImgGood: UIImageView!
    /// 商品名称
    @IBOutlet weak fileprivate var lblGoodName: UILabel!
    /// 剩余兑换数
    @IBOutlet weak fileprivate var lblRemainingExchangeNumber: UILabel!
    /// 消耗积分
    @IBOutlet weak fileprivate var lblConsumptionIntegral: UILabel!
    //供应商名称
    @IBOutlet weak var lblSubSupplierName: UILabel!
    
    /// 用于保存传入的实体对象
    fileprivate var cellEntity:IntegralGoodExchangeEntity?
    /// 记录行索引
    internal var index:IndexPath?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblRemainingExchangeNumber.textColor=UIColor.textColor()
        lblConsumptionIntegral.textColor=UIColor.textColor()
        btnExchange.backgroundColor=UIColor.applicationMainColor()
        btnExchange.titleLabel!.textColor=UIColor.white
        btnExchange.layer.cornerRadius=15
        btnExchange.addTarget(self, action:Selector("submitExchangeInfo:"), for: UIControlEvents.touchUpInside)
        //去掉选中背景
        self.selectionStyle=UITableViewCellSelectionStyle.none;
        // Initialization code
    }
    /**
     更新cell
     
     - parameter entity:IntegralGoodExchangeEntity
     */
    func updateCell(_ entity:IntegralGoodExchangeEntity){
        cellEntity=entity
        entity.goodsPic=entity.goodsPic ?? ""
        ImgGood.sd_setImage(with: Foundation.URL(string:URLIMG+entity.goodsPic!), placeholderImage:UIImage(named: "def_nil"))
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
        if entity.subSupplierName != nil{
            lblSubSupplierName.text="商品所属:"+entity.subSupplierName!
        }else{
            lblSubSupplierName.text="商品所属:无"
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
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
    func submitExchangeInfo(_ sender:UIButton){
        delegate?.httpExchangeInfo(cellEntity!,index:index!)
    }
}
