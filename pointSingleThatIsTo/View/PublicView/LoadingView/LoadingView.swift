//
//  loadingView.swift
//  kxkg
//
//  Created by hefeiyue on 15/3/23.
//  Copyright (c) 2015年 奈文魔尔. All rights reserved.
//

import Foundation
import UIKit
/**
加载等待视图
*/
class loadingView:UIView{
    //化指示器
    var activityIndicator:UIActivityIndicatorView!
    var activityIndicatorTxt:UILabel!;
    override init(frame: CGRect) {
        super.init(frame:frame);
        //初始化指示器
        activityIndicator=UIActivityIndicatorView(frame:CGRect(x: 20,y: 10,width: 40,height: 40));
        /*
        指定指示器的类型
        一共有三种类型：
        UIActivityIndicatorViewStyleWhiteLarge   //大型白色指示器
        UIActivityIndicatorViewStyleWhite      //标准尺寸白色指示器
        UIActivityIndicatorViewStyleGray    //灰色指示器，用于白色背景
        */
        activityIndicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyle.whiteLarge;
        //停止后是否隐藏(默认为YES)
        activityIndicator.hidesWhenStopped=true;
        
        activityIndicatorTxt=UILabel(frame:CGRect(x: 0,y: 40,width: 80,height: 40));
        activityIndicatorTxt.text="加载中...";
        activityIndicatorTxt.backgroundColor=UIColor.clear;
        activityIndicatorTxt.textColor=UIColor.white;
        activityIndicatorTxt.font=UIFont.systemFont(ofSize: 12);
        activityIndicatorTxt.textAlignment=NSTextAlignment.center;
        self.backgroundColor=UIColor(red:0, green:0, blue: 0, alpha:0.6);
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = true;
        self.addSubview(activityIndicator);
        self.addSubview(activityIndicatorTxt);
    }
    /**
    开始加载
    */
    func start(_ view:UIViewController){
        //禁用视图事件
        view.view.isUserInteractionEnabled = false;
        view.navigationController?.navigationBar.isUserInteractionEnabled = false;
        activityIndicator.startAnimating();
    }
    /**
    停止加载
    */
    func close(_ view:UIViewController){
        //开启视图事件
        view.view.isUserInteractionEnabled = true;
        view.navigationController?.navigationBar.isUserInteractionEnabled = true;
        //删除视图
        self.removeFromSuperview();
    }
    //    /**
    //        设置子View在父View中居中
    //    */
    //    func setCenter(view:UIView!,parentRect:CGRect){
    //        var rect = view.frame;
    //        rect.origin.x = (parentRect.size.width - view.frame.size.width)/2;
    //        rect.origin.y = (parentRect.size.height - view.frame.size.height)/2;
    //        view.frame = rect;
    //    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

