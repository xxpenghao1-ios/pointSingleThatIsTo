//
//  SKLaunchMenu.swift
//  SCNavController
//
//  Created by Sukun on 15/9/30.
//  Copyright © 2015年 Sukun. All rights reserved.
//

import UIKit

protocol SKLaunchMenuDelegate: NSObjectProtocol {
    
    func itemPressedWithIndex(index:Int)
}

class SKLaunchMenu: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    /**
     * 子视图控制器的title数组
     */
    var subViewTitles:NSArray!
    
    /**
     * 扩展菜单
     */
    var launchMenu:UICollectionView!
    
    /**
     * SKLaunchMenuDelegate的代理对象
     */
    weak var delegate:SKLaunchMenuDelegate?
    
    //layout属性
    private var layout:UICollectionViewFlowLayout!
    
    /**
     * 计算属性:SetLayout
     */
    var setLayout:UICollectionViewFlowLayout {
        set{
            let count:CGFloat = 5.0 //每行需要显示的Item个数
            layout = newValue
            layout.itemSize = CGSizeMake(kScreenWidth / count, 30)
            layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            layout.minimumInteritemSpacing = 5
            layout.minimumLineSpacing = 5
        }
        get{
            return layout
        }
    }
    //MARK: -- 初始化方法
    init(layout:UICollectionViewFlowLayout, subViewTitles:NSArray) {
        super.init(nibName: nil, bundle: nil)
        self.setLayout = layout
        self.subViewTitles = subViewTitles
        //调用创建LaunchMenu方法
        createLaunchMenu()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //调用创建LaunchMenu方法
        createLaunchMenu()
    }
    
    //MARK: -- 创建LaunchMenu
    private func createLaunchMenu() {
        let height = layout.itemSize.height * CGFloat(subViewTitles.count / 4 + 2)
        launchMenu = UICollectionView(frame: CGRectMake(0, kScNavBarHeight, kScreenWidth, height), collectionViewLayout: layout)
        launchMenu.delegate = self
        launchMenu.dataSource = self
        launchMenu.backgroundColor = UIColor.whiteColor()
        launchMenu.registerClass(SKLaunchMenuItem.self, forCellWithReuseIdentifier: "ITEM")
        self.view.addSubview(launchMenu)
    }

    //MARK: -- collection View delegate 方法
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subViewTitles.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ITEM", forIndexPath: indexPath) as! SKLaunchMenuItem
        let title = subViewTitles[indexPath.row] as! String
        cell.titleLabel.text = title
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        delegate?.itemPressedWithIndex(indexPath.row)
    }
    
    func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    //MARK: -- 处理内存方法
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
