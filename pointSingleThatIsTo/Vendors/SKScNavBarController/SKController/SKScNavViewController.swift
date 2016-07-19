//
//  SKScNavViewController.swift
//  SCNavController
//
//  Created by Sukun on 15/9/29.
//  Copyright © 2015年 Sukun. All rights reserved.
//

import UIKit

class SKScNavViewController: UIViewController, SKScNavBarDelegate, UIScrollViewDelegate {

    //MARK:必须设置的一些属性
    /**
     * @param scNaBarColor
     * @param showArrowButton
     * @param lineColor
     */
    //MARK: -- 公共设置属性
    /**
     * 是否显示扩展按钮
     */
    var showArrowButton:Bool!         // 默认值是true
    /**
     * 导航栏的颜色
     */
    var scNavBarColor:UIColor!        //默认值clearColor
    /**
     * 扩展按钮上的图片
     */
    var scNavBarArrowImage:UIImage!
    /**
     * 包含所有子视图控制器的数组
     */
    var subViewControllers:NSArray!
    /**
     * 线的颜色
     */
    var lineColor:UIColor!           //默认值redColor
    
    /**
     * 扩展菜单栏的高度
     */
    var launchMenuHeight:CGFloat!
    
    //MARK: -- 私有属性
    private var currentIndex:Int!       //当前显示的页面的下标
    private var titles:NSMutableArray!  //子视图控制器的title数组
    private var scNavBar:SKScNavBar!    //导航栏视图
    private var mainView:UIScrollView!  //主页面的ScrollView
    
    //MARK: ----- 方法 -----
    
    //MARK: -- 外界接口
    
    /**
     * 初始化withShowArrowButton
     * @param showArrowButton 显示扩展菜单按钮
     */
    init(show:Bool){
        super.init(nibName: nil, bundle: nil)
        self.showArrowButton = show
    }
    
    /**
     * 初始化withSubViewControllers
     * @param subViewControllers 子视图控制器数组
     */
    init(subViewControllers:NSArray) {
        super.init(nibName: nil, bundle: nil)
        self.subViewControllers = subViewControllers
    }
    
    /**
     * 初始化withParentViewController
     * @param parentViewController 父视图控制器
     */
    init(parentViewController:UIViewController) {
        super.init(nibName: nil, bundle: nil)
        self.addParentController(parentViewController)
    }
    
    /**
     * 初始化SKScNavBarController
     * @param subViewControllers   子视图控制器
     * @param parentViewController 父视图控制器
     * @param show 是否显示展开扩展菜单栏按钮
     */
    init(subViewControllers:NSArray, parentViewController:UIViewController, show:Bool) {
        super.init(nibName: nil, bundle: nil)
        self.subViewControllers = subViewControllers
        self.showArrowButton = show
        self.addParentController(parentViewController)
    }
    /**
     * 添加父视图控制器的方法
     * @param viewController 父视图控制器
     */
    func addParentController(viewcontroller:UIViewController) {
        if viewcontroller.respondsToSelector("edgesForExtendedLayout") {
            viewcontroller.edgesForExtendedLayout = UIRectEdge.None
        }
        
        viewcontroller.addChildViewController(self)
        viewcontroller.view.addSubview(self.view)
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        //调用初始化属性的方法
        initParamConfig()
        //调用初始化、配置视图的方法
        viewParamConfig()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: -- 私有方法
    
    //初始化一些属性
    private func initParamConfig() {
        //初始化一些变量
        currentIndex = 1
        scNavBarColor = scNavBarColor != nil ? scNavBarColor : kNavColor
        if scNavBarArrowImage == nil {
            scNavBarArrowImage = UIImage(named: "arrow")
        }
        if showArrowButton == nil {
            showArrowButton = true
        }
        if lineColor == nil {
            lineColor = UIColor.applicationMainColor()
        }
        //获取所有子视图控制器上的title
        titles = NSMutableArray(capacity: subViewControllers.count)
        for vc in subViewControllers {
            titles.addObject(vc.navigationItem.title!)
        }
    }
    
    //初始化视图
    private func initWithScNavBarAndMainView() {
        scNavBar = SKScNavBar(frame: CGRectMake(0, 0, kScreenWidth, kScNavBarHeight), show: showArrowButton, image: scNavBarArrowImage)
        scNavBar.delegate = self
        scNavBar.backgroundColor = scNavBarColor
        scNavBar.itemsTitles = titles
        scNavBar.lineColor = lineColor
        scNavBar.setItemsData()
        
        mainView = UIScrollView(frame: CGRectMake(0, scNavBar.frame.origin.y + scNavBar.frame.size.height, kScreenWidth, kScreenHeight - scNavBar.frame.origin.y - scNavBar.frame.size.height))
        mainView.delegate = self
        mainView.pagingEnabled = true
        mainView.bounces = false
        mainView.showsHorizontalScrollIndicator = false
        mainView.contentSize = CGSizeMake(kScreenWidth * CGFloat(subViewControllers.count), 0)
        view.addSubview(mainView)
        view.addSubview(scNavBar)
    }
    
    //配置视图参数
    private func viewParamConfig() {
        
        initWithScNavBarAndMainView()
        
        //将子视图控制器的view添加到mainView上
        subViewControllers.enumerateObjectsUsingBlock { (_, index:Int, _) -> Void in
            let vc = self.subViewControllers[index] as! UIViewController
            vc.view.frame = CGRectMake(CGFloat(index) * kScreenWidth, 0, kScreenWidth, self.mainView.frame.size.height)
            self.mainView.addSubview(vc.view)
            self.mainView.backgroundColor = UIColor.cyanColor()
            self.addChildViewController(vc)
        }
    }
    
    //MARK: -- ScrollView Delegate 方法
    func scrollViewDidScroll(scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x / kScreenWidth)
        scNavBar.setViewWithItemIndex = currentIndex
    }
    
    //MARK: -- SKScNavBarDelegate 中的方法
    func didSelectedWithIndex(index: Int) {
        mainView.setContentOffset(CGPointMake(CGFloat(index) * kScreenWidth, 0), animated: true)
    }
    
    func isShowScNavBarItemMenu(show: Bool, height: CGFloat) {
        if show {
            UIView.animateWithDuration(0.5) { () -> Void in
                self.scNavBar.frame = CGRectMake(self.scNavBar.frame.origin.x, self.scNavBar.frame.origin.y, kScreenWidth, height)
            }
        }else{
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.scNavBar.frame = CGRectMake(self.scNavBar.frame.origin.x, self.scNavBar.frame.origin.y, kScreenWidth, kScNavBarHeight)
            })
        }
        scNavBar.refreshAll()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
