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
    @IBOutlet weak fileprivate var lblIntegral: UILabel!
    /// 标题
    @IBOutlet weak fileprivate var lblTitle: UILabel!
    /// 时间
    @IBOutlet weak fileprivate var lblTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        lblTime.textColor=UIColor.textColor()
    }
    /**
     更新cell
     
     - parameter entity:MemberIntegralEntity
     */
    func updateCell(_ entity:MemberIntegralEntity){
        lblTime.text=entity.time
        lblIntegral.text=entity.integral
        switch entity.integralType!{
        case 1:
            lblTitle.text="发货扣除"
            break
        case 2:
            lblTitle.text="充值"
            break
        case 3:
            lblTitle.text="购物获得"
            break
        case 4:
            lblTitle.text="兑换积分商城商品扣除"
        default:
            lblTitle.text="异常数据"
            break
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
