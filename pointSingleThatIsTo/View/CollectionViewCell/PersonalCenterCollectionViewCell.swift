//
//  PersonalCenterCollectionViewCell.swift
//  pointSingleThatIsTo
//
//  Created by hao peng on 2017/6/10.
//  Copyright © 2017年 penghao. All rights reserved.
//

import Foundation
import UIKit
class PersonalCenterCollectionViewCell:LWLineSeparatorCollectionViewCell{
    fileprivate var img:UIImageView!
    fileprivate var lblName:UILabel!
    fileprivate var view:UIView!
    override init(frame: CGRect) {
        super.init(frame:frame)
        view=UIView(frame:CGRect(x:0,y:0,width:90,height:90))
        view.center=self.contentView.center
        self.contentView.addSubview(view)
        img=UIImageView(frame:CGRect(x:20,y:0,width:50,height:50))
        view.addSubview(img)
        lblName=buildLabel(UIColor.textColor(), font:16, textAlignment: NSTextAlignment.center)
        lblName.frame=CGRect(x:0,y:img.frame.maxY,width:90,height:20)
        view.addSubview(lblName)
        self.contentView.backgroundColor=UIColor.white
        
    }
    
    /// 更新数据
    ///
    /// - Parameters:
    ///   - imgStr: 图片
    ///   - str: 名称
    func updateCell(_ imgStr:String,str:String){
        img.image=UIImage(named:imgStr)
        lblName.text=str
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
