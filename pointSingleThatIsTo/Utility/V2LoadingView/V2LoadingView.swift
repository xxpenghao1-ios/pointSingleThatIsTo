//
//  V2LoadingView.swift
//  V2ex-Swift
//
//  Created by huangfeng on 1/28/16.
//  Copyright © 2016 Fin. All rights reserved.
//

import UIKit
//import SnapKit
//let noticeString = [
//    "正在拼命加载",
//    "年轻人,不要着急",
//    "让我飞一会儿",
//]
//
//class V2LoadingView: UIView {
//    var activityIndicatorView:UIActivityIndicatorView?
//    init (){
//        super.init(frame:CGRect.zero)
//        self.activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
//        self.addSubview(self.activityIndicatorView!)
//        self.activityIndicatorView!.snp_makeConstraints{ (make) -> Void in
//            make.centerX.equalTo(self)
//            make.centerY.equalTo(self).offset(-32)
//        }
//        
//        let noticeLabel = UILabel()
//        //修复BUG。做个小笔记给阅读代码的兄弟们提个醒
//        //(Int)(arc4random())
//        //上面这种写法有问题，arc4random()会返回 一个Uint32的随机数值。
//        //在32位机器上,如果随机的数大于Int.max ,转换就会crash。
//        noticeLabel.text = noticeString[random() % noticeString.count]
//        noticeLabel.font = UIFont.systemFont(ofSize: 10)
//        noticeLabel.textColor = UIColor(red: 173/255, green: 173/255, blue: 173/255, alpha: 1)
//        self.addSubview(noticeLabel)
//        noticeLabel.snp_makeConstraints{ (make) -> Void in
//            make.top.equalTo(self.activityIndicatorView!.snp_bottom).offset(10)
//            make.centerX.equalTo(self.activityIndicatorView!)
//        }
//    }
//
//    override func willMove(toSuperview newSuperview: UIView?) {
//        self.activityIndicatorView?.startAnimating()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    //隐藏
//    func hide(){
//        self.superview?.bringSubview(toFront: self)
//        UIView.animate(withDuration: 0.2,
//            animations: { () -> Void in
//            self.alpha = 0
//        }, completion: { (finished) -> Void in
//            if finished {
//                self.removeFromSuperview()
//            }
//        })
//        
//    }
//}

