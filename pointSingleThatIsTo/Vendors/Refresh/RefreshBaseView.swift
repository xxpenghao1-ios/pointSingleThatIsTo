//
//  RefreshBaseView.swift
//  RefreshExample
//
//  Created by SunSet on 14-6-23.
//  Copyright (c) 2014 zhaokaiyuan. All rights reserved.
//
import UIKit

//控件的刷新状态
enum RefreshState {
    case  pulling               // 松开就可以进行刷新的状态
    case  normal                // 普通状态
    case  refreshing            // 正在刷新中的状态
    case  willRefreshing
}

//控件的类型
enum RefreshViewType {
    case  typeHeader             // 头部控件
    case  typeFooter             // 尾部控件
}
let RefreshLabelTextColor:UIColor = UIColor(red: 150.0/255, green: 150.0/255.0, blue: 150.0/255.0, alpha: 1)


class RefreshBaseView: UIView {
    
 
    //  父控件
    var scrollView:UIScrollView!
    var scrollViewOriginalInset:UIEdgeInsets!
    
    // 内部的控件
    var statusLabel:UILabel!
    var arrowImage:UIImageView!
    var activityView:UIActivityIndicatorView!
    
    //回调
    var beginRefreshingCallback:(()->Void)?
    
    // 交给子类去实现 和 调用
    var  oldState:RefreshState?
    
    var State:RefreshState = RefreshState.normal{
    willSet{
    }
    didSet{
        
    }
    
    }
    
    func setState(_ newValue:RefreshState){
        
        
        if self.State != RefreshState.refreshing {
            
            scrollViewOriginalInset = self.scrollView.contentInset;
        }
        if self.State == newValue {
            return
        }
        switch newValue {
        case .normal:
            self.arrowImage.isHidden = false
            self.activityView.stopAnimating()
            break
        case .pulling:
            break
        case .refreshing:
            self.arrowImage.isHidden = true
            activityView.startAnimating()
            beginRefreshingCallback!()
            break
        default:
            break
            
        }


    }
    
    
    //控件初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        
        //状态标签
        statusLabel = UILabel()
        statusLabel.autoresizingMask = UIViewAutoresizing.flexibleWidth
        statusLabel.font = UIFont.boldSystemFont(ofSize: 13)
        statusLabel.textColor = RefreshLabelTextColor
        statusLabel.backgroundColor =  UIColor.clear
        statusLabel.textAlignment = NSTextAlignment.center
        self.addSubview(statusLabel)
        //箭头图片
        arrowImage = UIImageView(image: UIImage(named: "arrow.png"))
        arrowImage.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleRightMargin]
        self.addSubview(arrowImage)
        //状态标签
        activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityView.bounds = self.arrowImage.bounds
        activityView.autoresizingMask = self.arrowImage.autoresizingMask
        self.addSubview(activityView)
         //自己的属性
        self.autoresizingMask = UIViewAutoresizing.flexibleWidth
        self.backgroundColor = UIColor.clear
        //设置默认状态
        self.State = RefreshState.normal;
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

   
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
         //箭头
        let arrowX:CGFloat = self.frame.size.width * 0.5 - 100
        self.arrowImage.center = CGPoint(x: arrowX, y: self.frame.size.height * 0.5)
        //指示器
        self.activityView.center = self.arrowImage.center
    }
    
    
    override func willMove(toSuperview newSuperview: UIView!) {
        super.willMove(toSuperview: newSuperview)
        // 旧的父控件
         
        if (self.superview != nil) {
            self.superview?.removeObserver(self, forKeyPath: RefreshContentSize as String, context: nil)
            
            }
        // 新的父控件
        if (newSuperview != nil) {
            newSuperview.addObserver(self, forKeyPath: RefreshContentOffset as String, options: NSKeyValueObservingOptions.new, context: nil)
            var rect:CGRect = self.frame
            // 设置宽度   位置
            rect.size.width = newSuperview.frame.size.width
            rect.origin.x = 0
            self.frame = frame;
            //UIScrollView
            scrollView = newSuperview as! UIScrollView
            scrollViewOriginalInset = scrollView.contentInset;
        }
    }
    
    //显示到屏幕上
    override func draw(_ rect: CGRect) {
        superview?.draw(rect);
        if self.State == RefreshState.willRefreshing {
            self.State = RefreshState.refreshing
        }
    }
    
    // 刷新相关
    // 是否正在刷新
    func isRefreshing()->Bool{
        return RefreshState.refreshing == self.State;
    }
    
    // 开始刷新
    func beginRefreshing(){
        // self.State = RefreshState.Refreshing;
        
    
        if (self.window != nil) {
            self.State = RefreshState.refreshing;
        } else {
            //不能调用set方法
            State = RefreshState.willRefreshing;
            super.setNeedsDisplay()
        }
        
    }
    //结束刷新
    func endRefreshing(){
        let delayInSeconds:Double = 0.3
        let popTime:DispatchTime = DispatchTime.now() + Double(Int64(delayInSeconds)) / Double(NSEC_PER_SEC);
        
        DispatchQueue.main.asyncAfter(deadline: popTime, execute: {
            self.State = RefreshState.normal;
            })
    }
}







