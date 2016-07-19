//
//  networkAnomaliesView.swift
//  kxkg
//
//  Created by hefeiyue on 15/3/23.
//  Copyright (c) 2015年 奈文魔尔. All rights reserved.
//

import Foundation
import UIKit
/**
   返回一个网络异常提示view
*/
func networkAnomaliesView() ->UIView{
    let view=UIView(frame:CGRectMake(0,0,260,253));
    let imgView=UIImageView(frame:CGRectMake(0,0,260,253));
    imgView.image=UIImage(named:"network.png")
    view.addSubview(imgView);
    return view;
}