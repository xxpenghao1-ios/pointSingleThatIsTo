//
//  IRecommendViewControllerCell.swift
//  pointSingleThatIsTo
//
//  Created by nevermore on 16/2/20.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
/// 推荐的人
class IRecommendViewControllerCell:UITableViewCell {
    /// 推荐的人 名称
    var recommendedMemberName:UILabel?
    /// 查看二维码标签
    var seeIR:UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        uibuju()
    }
    /**
     ui布局
     */
    func uibuju(){
        /// 推荐的人 名称
        recommendedMemberName=UILabel()
        recommendedMemberName?.font=UIFont.systemFontOfSize(14)
        self.contentView.addSubview(recommendedMemberName!)
        /// 查看二维码标签
        seeIR=UILabel()
        seeIR?.font=UIFont.systemFontOfSize(14)
        seeIR?.text="查看二维码"
        seeIR?.frame=CGRectMake(boundsWidth-111, 20, 90, 20)
        self.contentView.addSubview(seeIR!)
        
        
    }
    //插入数据
    func dateshow(enetity:IRecommendEntity){
        /// 推荐的人 名称
        recommendedMemberName?.frame=CGRectMake(15, 20, boundsWidth-130, 20)
        recommendedMemberName?.text=enetity.recommendedMemberName!
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
