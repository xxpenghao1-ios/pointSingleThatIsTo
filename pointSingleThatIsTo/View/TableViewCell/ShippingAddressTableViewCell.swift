//
//  ShippingAddressTableViewCell.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/2/25.
//  Copyright © 2016年 penghao. All rights reserved.
//

import UIKit
/// 收货地址cell
class ShippingAddressTableViewCell: UITableViewCell {
    /// 姓名 电话
    @IBOutlet weak var lblNameAndPhone: UILabel!
    
    /// 省市区
    @IBOutlet weak var lblAddress: UILabel!
    
    /// 详细地址
    @IBOutlet weak var lblDetailAddress: UILabel!
    
    /// 默认地址
    @IBOutlet weak var lblDefaultAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblNameAndPhone.textColor=UIColor.textColor()
        lblAddress.textColor=UIColor.textColor()
        lblDetailAddress.textColor=UIColor.textColor()
        lblDefaultAddress.textColor=UIColor.textColor()
        lblDefaultAddress.hidden=true
    }
    /**
     更新cell
     
     - parameter entity: 地址entity
     */
    func updateCell(entity:AddressEntity){
        lblNameAndPhone.text=entity.shippName!+"  "+entity.phoneNumber!
        lblAddress.text=entity.province!+entity.city!+entity.county!
        lblDetailAddress.text=entity.detailAddress
        if entity.defaultFlag == 1{
            lblDefaultAddress.hidden=false
        }
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
