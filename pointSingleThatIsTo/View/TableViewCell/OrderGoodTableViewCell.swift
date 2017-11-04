//
//  OrderGoodTableViewCell.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/2/25.
//  Copyright © 2016年 penghao. All rights reserved.
//

import UIKit
/// 订单商品cell
class OrderGoodTableViewCell: UITableViewCell {
    /// 商品图片view
    @IBOutlet weak var goodView: UIView!
    
    /// 商品图片
    @IBOutlet weak var goodImgView: UIImageView!
    
    /// 商品名称
    @IBOutlet weak var lblName: UILabel!
    
    /// 商品价格
    @IBOutlet weak var lblPrice: UILabel!
    
    /// 商品数量
    @IBOutlet weak var lblCount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        goodView.layer.borderColor=UIColor.goodDetailBorderColor().cgColor
        goodView.layer.borderWidth=0.5
        
        lblName.textColor=UIColor.textColor()
        
        lblPrice.textColor=UIColor.red
        //去掉选中背景
        self.selectionStyle=UITableViewCellSelectionStyle.none;
        
        // Initialization code
    }
    /**
     更新cell
     
     - parameter entity: 商品entity
     */
    func updateCell(_ entity:GoodDetailEntity){
        entity.goodPic=entity.goodPic ?? ""
        goodImgView.sd_setImage(with: Foundation.URL(string:URLIMG+entity.goodPic!), placeholderImage:UIImage(named: "def_nil"))
        lblName.text=entity.goodInfoName
        if entity.flag == 1{//如果是特价 显示特价价格
            lblPrice.text="￥"+entity.prefertialPrice!
        }else{
            lblPrice.text="￥"+entity.uprice!
        }
        lblCount.text="x\(entity.carNumber!)"
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
