//
//  SKScNavBar.swift
//  SCNavController
//
//  Created by Sukun on 15/9/29.
//  Copyright © 2015年 Sukun. All rights reserved.
//

import UIKit


protocol SKScNavBarDelegate: NSObjectProtocol{
    /**
     * 点击ScNavBar上的Items回调的方法
     * @param index 被点击的Item的下标
     */
    func didSelectedWithIndex(_ index:Int)
    
    /**
     * 点击扩展菜单键触发的方法
     */
    func isShowScNavBarItemMenu(_ show:Bool, height:CGFloat)
}

class SKScNavBar: UIView, SKLaunchMenuDelegate {
    
    //MARK: -- 公共属性
    /**
     * SKScnavBarDelegate的代理属性
     */
    weak var delegate: SKScNavBarDelegate?
    
    /**
     * 当前选中的Item的下标
     */
    var currentItemIndex:Int!
    /**
     * 所有Items的标题
     */
    var itemsTitles:NSArray!
    
    /**
     * 选中每个Item时下面的横线的颜色
     */
    var lineColor:UIColor!
    
    /**
     * 展开扩展菜单栏的按钮上的图片
     */
    var arrowBtnImage:UIImage!
    /**
     * 计算属性，根据currentItemIndex计算视图的Frame
     */
    var setViewWithItemIndex:Int {
        set{
            currentItemIndex = newValue
            let itemBtn = items[currentItemIndex] as! UIButton
            let flag = showArrowButton ? (kScreenWidth - kArrowButtonWidth) : kScreenWidth
            if (itemBtn.frame.origin.x + itemBtn.frame.size.width) > flag {
                var offsetX = itemBtn.frame.origin.x + itemBtn.frame.size.width - flag
                if currentItemIndex < (items.count - 1) {
                    offsetX = offsetX + 40.0
                }
                scNavBar.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
            }else{
                scNavBar.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                let lineWidth = self.itemsWidth[self.currentItemIndex] as! CGFloat
                self.line.frame = CGRect(x: itemBtn.frame.origin.x, y: self.line.frame.origin.y, width: lineWidth, height: self.line.frame.size.height)
                for btn in self.items {
                    let tempBtn = btn as! UIButton
                    tempBtn.setTitleColor(UIColor.black, for: UIControlState())
                    tempBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                }
                itemBtn.setTitleColor(UIColor.applicationMainColor(), for: UIControlState())
                itemBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            }) 
        }
        get{
            return currentItemIndex
        }
    }
    
    //MARK: -- 私有属性
    fileprivate var scNavBar:UIScrollView!            //可滑动导航栏
    fileprivate var arrowBtnImageView:UIImageView!    //展开扩展菜单栏的按钮
    fileprivate var line:UIView!                      //导航栏Item下面的线
    fileprivate var skLaunchMenu:SKLaunchMenu!        //扩展菜单栏
    fileprivate var items:NSMutableArray!             //导航栏上Item数组
    fileprivate var itemsWidth:NSArray!               //Items的宽度数组
    fileprivate var showArrowButton:Bool = true       //显示扩展菜单按钮
    fileprivate var showScNavBarItemMenu:Bool!        //是否展开扩展菜单
    
    //MARK: ---- 公共方法 -----
    
    /**
     * 自定义初始化方法
     * @param frame SKScNavBar的frame
     * @param show  显示扩展菜单按钮
     */
    init(frame:CGRect, show:Bool, image:UIImage) {
        super.init(frame: frame)
        self.showArrowButton = show
        self.arrowBtnImage = image
        self.showScNavBarItemMenu = false
        initWithConfig()
        
    }
    
    /**
     * 设置Item上的数据
     */
    func setItemsData() {
                
        itemsWidth = getItemsWidthWithTitles(itemsTitles)
        if itemsWidth.count != 0 {
            let contentWidth = getScNavContentAddScNavBarItemsWithItemsWidth(itemsWidth)
            scNavBar.contentSize = CGSize(width: contentWidth, height: 0)
        }
    }
    
    /**
     * 刷新所有的子视图
     */
    func refreshAll() {
        showLaunchMenu(showScNavBarItemMenu)
    }
    
    //MARK: ----- 私有方法 -----
    //MARK: -- 初始化方法
    fileprivate func initWithConfig() {
        items = NSMutableArray()
        //调用配置视图的方法
        configView()
    }
    
    //MARK: -- 配置视图
    fileprivate func configView() {
        let frameX = showArrowButton ? (kScreenWidth - kArrowButtonWidth) : kScreenWidth
        if showArrowButton {
            arrowBtnImageView = UIImageView(frame: CGRect(x: frameX, y: 0, width: kArrowButtonWidth, height: kArrowButtonWidth))
            arrowBtnImageView.isUserInteractionEnabled = true
            
            arrowBtnImageView.image = arrowBtnImage
            arrowBtnImageView.backgroundColor = self.backgroundColor
            self.addSubview(arrowBtnImageView)
            
            //setShadowForView(arrowBtnImageView, shadowRadius: 10.0, shadowOpacity: 10.0)
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(arrowBtnTapGesAction))
            arrowBtnImageView.addGestureRecognizer(tapGestureRecognizer)
        }
        scNavBar = UIScrollView(frame: CGRect(x: 0, y: 0, width: frameX, height: kScNavBarHeight))
        scNavBar.showsHorizontalScrollIndicator = false
        self.addSubview(scNavBar)
        //调用给视图设置阴影的方法
        setShadowForView(self, shadowRadius:5, shadowOpacity:5)
    }
    
    //MARK: -- 往导航栏上添加ItemButton
    fileprivate func getScNavContentAddScNavBarItemsWithItemsWidth(_ widths:NSArray) -> CGFloat {
        var buttonX:CGFloat = 0
        for index in 0..<itemsTitles.count{
            let button = UIButton(type: UIButtonType.custom)
            button.frame = CGRect(x: buttonX, y: 0, width: widths[index] as! CGFloat, height: kScNavBarHeight)
            button.setTitle((itemsTitles[index] as! String), for: UIControlState())
            button.setTitleColor(UIColor.black, for: UIControlState())
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.addTarget(self, action: #selector(itemsBtnAction), for: UIControlEvents.touchUpInside)
            scNavBar.addSubview(button)
            
            items.add(button)
            buttonX += widths[index] as! CGFloat
        }
        let btn = items[0] as! UIButton
        btn.setTitleColor(UIColor.applicationMainColor(), for: UIControlState())
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.setLineWithItensWidth(widths[0] as! CGFloat)
        
        return buttonX
    }
    
    //MARK: -- 根据Items的宽度设置Item下面的线
    fileprivate func setLineWithItensWidth(_ width:CGFloat) {
        line = UIView(frame: CGRect(x: 0, y: kScNavBarHeight - 3, width: width, height: 3))
        line.backgroundColor = lineColor
        scNavBar.addSubview(line)
    }
    
    //MARK: -- 给视图设置阴影的方法
    fileprivate func setShadowForView(_ view:UIView, shadowRadius:CGFloat, shadowOpacity:Float) {
        view.layer.shadowRadius = shadowRadius
        view.layer.shadowOpacity = shadowOpacity
    }
    
    //MARK: -- 通过Item上的标题获取每个Item的宽度组成的数组
    fileprivate func getItemsWidthWithTitles(_ titles:NSArray) -> NSArray {
        let itemsWidths = NSMutableArray()
        for _ in titles {
//            let str = title as! NSString
//            let size:CGSize = str.sizeWithAttributes([NSFontAttributeName:UIFont.systemFontOfSize(UIFont.systemFontSize())])
            let fValue:CGFloat = kScreenWidth/CGFloat(titles.count)
            itemsWidths.add(fValue)
        }
        return itemsWidths
    }
    
    //MARK: -- 添加扩展菜单栏
    fileprivate func showLaunchMenu(_ show:Bool) {
        if show {
            setShadowForView(arrowBtnImageView, shadowRadius:0, shadowOpacity:0)
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.scNavBar.isHidden = true
                self.arrowBtnImageView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
                }, completion: { (finished:Bool) -> Void in
                    UIView.animate(withDuration: 0.2, animations: { () -> Void in
                        if self.skLaunchMenu == nil {
                            let layout = UICollectionViewFlowLayout()
                            self.skLaunchMenu = SKLaunchMenu(layout: layout, subViewTitles: self.itemsTitles)
                            self.skLaunchMenu.delegate = self
                            self.addSubview(self.skLaunchMenu.launchMenu)
                            self.skLaunchMenu.launchMenu.reloadData()
                        }
                        self.skLaunchMenu.launchMenu.isHidden = false
                    })
            })
        }else{
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.skLaunchMenu.launchMenu.isHidden = !self.skLaunchMenu.launchMenu.isHidden
                self.arrowBtnImageView.transform = CGAffineTransform.identity
                }, completion: { (finished:Bool) -> Void in
                    self.scNavBar.isHidden = !self.scNavBar.isHidden
               self.setShadowForView(self.arrowBtnImageView, shadowRadius: 5, shadowOpacity:5)
            })
        }
    }
    
    //MARK: -- 导航栏上面Item的点击事件
    @objc func itemsBtnAction(_ sender:UIButton) {
        let index = items.index(of: sender)
        delegate?.didSelectedWithIndex(index)
    }
    
    //MARK: -- 展开扩展菜单栏按钮点击事件
    @objc func arrowBtnTapGesAction() {
        showScNavBarItemMenu = !showScNavBarItemMenu
        let height = kScreenWidth / 5.0 * CGFloat(itemsTitles.count / 4) + CGFloat(1.5)
        delegate?.isShowScNavBarItemMenu(showScNavBarItemMenu, height: height)
    }
    
    //MARK: -- SKLaunchMenuDelegate中的方法
    func itemPressedWithIndex(_ index: Int) {
        arrowBtnTapGesAction()
        delegate?.didSelectedWithIndex(index)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
