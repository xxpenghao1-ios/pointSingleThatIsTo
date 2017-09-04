//
//  SignListTableCell.swift
//  pointSingleThatIsTo
//
//  Created by hao peng on 2017/8/29.
//  Copyright © 2017年 penghao. All rights reserved.
//

import Foundation
import UIKit
/// 签到记录cell
class SignListTableCell:UITableViewCell {
    private var timeImg:UIImageView!
    private var lblTime:UILabel!
    private var lblDDBCount:UILabel!
    private var lblExtraDDB:UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style:style, reuseIdentifier:reuseIdentifier)
        timeImg=UIImageView(frame:CGRectMake(15,7.5,25,25))
        timeImg.image=UIImage(named: "sign_time")
        self.contentView.addSubview(timeImg)
        
        
        lblTime=buildLabel(UIColor.textColor(), font:14, textAlignment: NSTextAlignment.Left)
        lblTime.frame=CGRectMake(50,10,100,20)
        self.contentView.addSubview(lblTime)
        
        lblDDBCount=buildLabel(UIColor.applicationMainColor(), font:13, textAlignment: NSTextAlignment.Right)
        lblDDBCount.frame=CGRectMake(boundsWidth-60,10,50,20)
        self.contentView.addSubview(lblDDBCount)
        
        lblExtraDDB=buildLabel(UIColor.applicationMainColor(), font:13, textAlignment: NSTextAlignment.Right)
        lblExtraDDB.text="连续签到额外获得"
        lblExtraDDB.hidden=true
        lblExtraDDB.frame=CGRectMake(CGRectGetMaxX(lblTime.frame),10,boundsWidth-CGRectGetMaxX(lblTime.frame)-60,20)
        self.contentView.addSubview(lblExtraDDB)
        self.selectionStyle = .None
        
    }
    /**
     更新cell
     */
    func updateCell(entity:SignEntity){
        lblTime.text=entity.storeSignDate
        if entity.storeSignContinuityGetBalance > 0{
            lblExtraDDB.hidden=false
            lblDDBCount.text="+\(entity.storeSignGetBalance!+entity.storeSignContinuityGetBalance!)"
        }else{
            lblDDBCount.text="+\(entity.storeSignGetBalance!)"
            lblExtraDDB.hidden=true
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}