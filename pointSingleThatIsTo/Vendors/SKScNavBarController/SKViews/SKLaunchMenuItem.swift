//
//  SKLaunchMenuItem.swift
//  SCNavController
//
//  Created by Sukun on 15/9/30.
//  Copyright © 2015年 Sukun. All rights reserved.
//

import UIKit

class SKLaunchMenuItem: UICollectionViewCell {
    
    var titleLabel:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: kScreenWidth / 5, height: 30))
        titleLabel.backgroundColor = UIColor.groupTableViewBackground
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textAlignment = NSTextAlignment.center
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.2
        self.contentView.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
