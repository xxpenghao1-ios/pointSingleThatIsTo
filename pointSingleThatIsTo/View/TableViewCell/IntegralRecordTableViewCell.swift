//
//  IntegralRecordTableViewCell.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/7/19.
//  Copyright © 2016年 penghao. All rights reserved.
//

import UIKit
/// 积分记录cell
class IntegralRecordTableViewCell: UITableViewCell {
    /// 积分
    @IBOutlet weak private var lblIntegral: UILabel!
    /// 标题
    @IBOutlet weak private var lblTitle: UILabel!
    /// 时间
    @IBOutlet weak private var lblTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        lblTime.textColor=UIColor.textColor()
    }
    /**
     更新cell
     
     - parameter entity:MemberIntegralEntity
     */
    func updateCell(entity:MemberIntegralEntity){
        lblTime.text=entity.time
        lblIntegral.text=entity.integral
        switch entity.integralType!{
        case 1:
            lblTitle.text="兑换商品扣除"
            break
        case 2:
            break
        case 3:
            lblTitle.text="购物返还点单币"
            break
        default:
            lblTitle.text="异常数据"
            break
        }
        
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
