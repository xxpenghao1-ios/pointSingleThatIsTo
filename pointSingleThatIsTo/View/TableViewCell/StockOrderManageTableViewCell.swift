//
//  StockOrderManageTableViewCell.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/3/31.
//  Copyright © 2016年 penghao. All rights reserved.
//

import UIKit

/// 进货订单cell
class StockOrderManageTableViewCell: UITableViewCell {
    
    /********约束********/
    /// 上边线高度约束
    @IBOutlet weak var topBorderViewH: NSLayoutConstraint!
    /// 图片上边线约束
    @IBOutlet weak var imgTopBorderViewH: NSLayoutConstraint!
    /// 图片下边线约束
    @IBOutlet weak var imgBottomBorderViewH: NSLayoutConstraint!
    /// 下边线高度约束
    @IBOutlet weak var bottomBorderViewH: NSLayoutConstraint!
    
    /********约束********/
    
    /// 下边线
    @IBOutlet weak var bottomBorderView: UIView!
    /// 图片上边线
    @IBOutlet weak var imgTopBorderView: UIView!
    /// 图片下边线
    @IBOutlet weak var imgbottomBorderView: UIView!
    /// 上边线
    @IBOutlet weak var topBorderView: UIView!
    /// 订单号
    @IBOutlet weak var lblOrderId: UILabel!
    /// 总价
    @IBOutlet weak var lblSumPrice: UILabel!
    /// 经销商名称
    @IBOutlet weak var lblSupplierName: UILabel!
    /// 商品总数
    @IBOutlet weak var lblSumGoods: UILabel!
    /// 图片1
    @IBOutlet weak var goodImg1: UIImageView!
    /// 图片2
    @IBOutlet weak var goodImg2: UIImageView!
    /// 图片3
    @IBOutlet weak var goodImg3: UIImageView!
    /// 间隔背景
    @IBOutlet weak var bacView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        //设置边线约束高度为0.5
        imgTopBorderViewH.constant=0.5
        bottomBorderViewH.constant=0.5
        imgBottomBorderViewH.constant=0.5
        topBorderViewH.constant=0.5
        
        //设置各个背景色
        bacView.backgroundColor=UIColor.goodDetailBorderColor()
        bottomBorderView.backgroundColor=UIColor.borderColor()
        topBorderView.backgroundColor=UIColor.borderColor()
        //设置文字颜色
        lblSupplierName.textColor=UIColor.applicationMainColor()
        
        //设置图片边框
        goodImg1.layer.borderWidth=0.5
        goodImg1.layer.borderColor=UIColor.borderColor().CGColor
        goodImg1.hidden=true
        goodImg2.layer.borderWidth=0.5
        goodImg2.layer.borderColor=UIColor.borderColor().CGColor
        goodImg2.hidden=true
        goodImg3.layer.borderWidth=0.5
        goodImg3.layer.borderColor=UIColor.borderColor().CGColor
        goodImg3.hidden=true
        
        
        
        
    }
    /**
     更新cell
     
     - parameter entity:订单entity
     */
    func updateCell(entity:OrderListEntity){
        //订单号
        lblOrderId.text=entity.orderSN
        //供应商名称
        lblSupplierName.text=entity.supplierName
        //商品总数
        if entity.goods_amount != nil{
            lblSumGoods.text="共计\(entity.goods_amount!)商品"
        }else{
            lblSumGoods.text=""
        }
        //订单总价
        if entity.orderPrice != nil{
            let str="总价:￥\(entity.orderPrice!)"
            let strs:NSMutableAttributedString=NSMutableAttributedString(string:str);
            strs.addAttribute(NSForegroundColorAttributeName, value:UIColor.redColor(), range:NSMakeRange(4,str.characters.count-4));
            lblSumPrice.attributedText=strs
        }else{
            lblSumPrice.text=""
        }
        goodImg1.hidden=true
        goodImg2.hidden=true
        goodImg3.hidden=true
        //判断商品集合是否为空
        if entity.list != nil{
            for(var i=0;i<entity.list!.count;i++){
                    let entity=entity.list![i] as! GoodDetailEntity
                    switch i{
                    case 0:
                        goodImg1.sd_setImageWithURL(NSURL(string:URLIMG+entity.goodPic!), placeholderImage:UIImage(named: "def_nil"))
                        goodImg1.hidden=false
                        break
                    case 1:
                        goodImg2.sd_setImageWithURL(NSURL(string:URLIMG+entity.goodPic!), placeholderImage:UIImage(named: "def_nil"))
                        goodImg2.hidden=false
                        break
                    case 2:
                        goodImg3.sd_setImageWithURL(NSURL(string:URLIMG+entity.goodPic!), placeholderImage:UIImage(named: "def_nil"))
                        goodImg3.hidden=false
                        return
                    default:
                        break
                    }
                }
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
