//
//  SignListTableCell.swift
//  pointSingleThatIsTo
//
//  Created by hao peng on 2017/8/29.
//  Copyright © 2017年 penghao. All rights reserved.
//

import Foundation
import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

/// 签到记录cell
class SignListTableCell:UITableViewCell {
    fileprivate var timeImg:UIImageView!
    fileprivate var lblTime:UILabel!
    fileprivate var lblDDBCount:UILabel!
    fileprivate var lblExtraDDB:UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style:style, reuseIdentifier:reuseIdentifier)
        timeImg=UIImageView(frame:CGRect(x: 15,y: 7.5,width: 25,height: 25))
        timeImg.image=UIImage(named: "sign_time")
        self.contentView.addSubview(timeImg)
        
        
        lblTime=buildLabel(UIColor.textColor(), font:14, textAlignment: NSTextAlignment.left)
        lblTime.frame=CGRect(x: 50,y: 10,width: 100,height: 20)
        self.contentView.addSubview(lblTime)
        
        lblDDBCount=buildLabel(UIColor.applicationMainColor(), font:13, textAlignment: NSTextAlignment.right)
        lblDDBCount.frame=CGRect(x: boundsWidth-60,y: 10,width: 50,height: 20)
        self.contentView.addSubview(lblDDBCount)
        
        lblExtraDDB=buildLabel(UIColor.applicationMainColor(), font:13, textAlignment: NSTextAlignment.right)
        lblExtraDDB.text="连续签到额外获得"
        lblExtraDDB.isHidden=true
        lblExtraDDB.frame=CGRect(x: lblTime.frame.maxX,y: 10,width: boundsWidth-lblTime.frame.maxX-60,height: 20)
        self.contentView.addSubview(lblExtraDDB)
        self.selectionStyle = .none
        
    }
    /**
     更新cell
     */
    func updateCell(_ entity:SignEntity){
        lblTime.text=entity.storeSignDate
        if entity.storeSignContinuityGetBalance > 0{
            lblExtraDDB.isHidden=false
            lblDDBCount.text="+\(entity.storeSignGetBalance!+entity.storeSignContinuityGetBalance!)"
        }else{
            lblDDBCount.text="+\(entity.storeSignGetBalance!)"
            lblExtraDDB.isHidden=true
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
