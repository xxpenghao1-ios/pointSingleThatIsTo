//
//  IndexViewController.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/1/15.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import SVProgressHUD
import SDCycleScrollView
import SwiftyJSON
/// 首页
class IndexViewController:UIViewController,SDCycleScrollViewDelegate,UITextFieldDelegate,UIScrollViewDelegate{
    /// 可滑动容器
    fileprivate var scrollView:UIScrollView?
    /// 滚动显示地址信息
    fileprivate var lblAddress:CBAutoScrollLabel?
    /// 幻灯片控件
    fileprivate var netWorkBanner:SDCycleScrollView?
    /// 幻灯片图片数组
    fileprivate var zwadImgArr=NSMutableArray()
    fileprivate var classifyArr=NSMutableArray()
    /// 分类
    fileprivate var classifyCollectionView:UICollectionView?
    /// 分类下边背景view
    fileprivate var classifyCollectionBorderView:UIView?
    /// 特价和促销区
    fileprivate var specialAndPromotionsCollectionView:UICollectionView?
    ///分割线
    fileprivate var specialAndPromotionsCollectionBorderView:UIView?
    fileprivate var specialAndPromotionsCollectionButtomBorderView:UIView?
    fileprivate var specialAndPromotionsArr=[SpecialAndPromotionsEntity]()
    //******新品推荐begin********
    fileprivate var newProductArr=NSMutableArray()
    /// 新品推荐
    fileprivate var newProductCollectionView:UICollectionView?
    /// 新品推荐为空提示
    fileprivate var lblNilNewProduct:UILabel?
    /// 新品推荐下边背景view
    fileprivate var newProductBorderView:UIView?
    /// 热门商品数组
    fileprivate var hotGoodArr=NSMutableArray()
    /// 热门商品CollectionView
    fileprivate var hotGoodCollectionView:UICollectionView?
    /// 公告栏entity
    fileprivate var adMessgInfoEntity:AdMessgInfoEntity?
    /// 用于页面自动刷新
    fileprivate var updateViewFlag=false
    /// 定时器
    fileprivate var timer:Timer?
    //分站信息
    fileprivate var substationEntity:SubstationEntity?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addTimer()
        if updateViewFlag{//如果等于true 自动刷新页面
            self.scrollView?.mj_header.beginRefreshing()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        //设置当前页面导航控制器背景色为0.2透明度
//        self.navigationController!.navigationBar.lt_setBackgroundColor(UIColor.applicationMainColor().colorWithAlphaComponent(0.2))
        //设置view背景颜色
        self.view.backgroundColor=UIColor.white
        //初始化可滑动容器
        scrollView=UIScrollView(frame:self.view.bounds)
        scrollView!.contentSize=self.view.bounds.size
        scrollView!.delegate=self
        scrollView!.tag=2016
        self.view.addSubview(scrollView!)
//        //设置view从顶端开始
//        self.automaticallyAdjustsScrollViewInsets=false
        //加载页面
        buildView()
        //发送网络请求
        http()
        scrollView!.mj_header=MJRefreshNormalHeader(refreshingBlock: {
            //清空所有的数据源重新请求
            self.zwadImgArr.removeAllObjects()
            self.classifyArr.removeAllObjects()
            self.newProductArr.removeAllObjects()
            self.hotGoodArr.removeAllObjects()
            self.specialAndPromotionsArr.removeAll()
            //发送数据请求
            self.http()
        })
    }
    
    
    //实现可滑动容器协议
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == 2016{//判断tag防止其他类似控件执行
//            //在可滑动容器滚动的时候控制导航栏背景颜色渐变
//            let color=UIColor.applicationMainColor()
//            let offsetY=scrollView.contentOffset.y
//            if  offsetY > 25{//如果滑动的距离大于25开始渐变颜色
//                let alpha:CGFloat=min(1,1 - ((25 + 64 - offsetY) / 64))
//                self.navigationController!.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(alpha))
//            }else{//否者 回复原来0.2的透明度
//                self.navigationController!.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(0.2))
//            }
        }
    }
    //当前用户正在滑动的时候
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView.tag == 200{
            removeTimer()
        }
    }
    //当前用户结束滑动的时候
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.tag == 200{
            addTimer()
        }
    }

    //页面退出
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeTimer()
//        //重新设置导航栏的背景颜色
//        self.navigationController!.navigationBar.lt_setBackgroundColor(UIColor.applicationMainColor())
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
// MARK: - 页面布局
extension IndexViewController{
    /**
     构建页面
     */
    func buildView(){
        
        //构建导航控制器布局
        buildNavigationBarView()
        
        //构建幻灯view
        netWorkBanner=SDCycleScrollView(frame: CGRect(x: 0, y: 0,width: boundsWidth,height: 160), delegate: self, placeholderImage: UIImage(named: "def_nil"))
        netWorkBanner!.autoScrollTimeInterval=5.0
        netWorkBanner!.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated
        netWorkBanner!.pageControlAliment = SDCycleScrollViewPageContolAlimentRight
        netWorkBanner!.backgroundColor=UIColor.white
        self.scrollView!.addSubview(netWorkBanner!)
        //构建分类collectionView
        buildClassifCollectionView()
        //构建特价与促销collectionView
        buildSpecialAndPromotionsCollectionView()
        //构建新品推荐collectionView
        buildNewProductCollectonView()
        //构建热门商品collectionView
        buildHotGoodCollectionView()
        
    }
    /**
     构建导航控制器布局
     */
    func buildNavigationBarView(){
        //因为UIBarButtonItem会有边距用一个空的填充进去
        let leftBarNil=UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.fixedSpace, target:nil, action:nil);
        let barImg=UIImage(named:"gps");
        let barImgView=UIImageView(image:barImg);
        barImgView.frame=CGRect(x: 0,y: 0,width: 11.5,height: 18);
        //gps图片按钮
        let leftBarImg=UIBarButtonItem(customView:barImgView);
        //设置这个的UIBarButtonItem的宽为-10
        leftBarNil.width = -10;
        //直接创建一个文本框
        let txt=UITextField(frame:CGRect(x: 0,y: 0,width: boundsWidth-135,height: 30))
        txt.backgroundColor=UIColor.white
        txt.delegate=self
        txt.placeholder="请输入您要搜索的商品"
        txt.font=UIFont.systemFont(ofSize: 14)
        txt.resignFirstResponder()
        txt.layer.cornerRadius=3
        let leftView=UIView(frame:CGRect(x: 0,y: 0,width: 30,height: 30))
        let leftImageView=UIImageView(frame:CGRect(x: 10,y: 8.5,width: 13.5,height: 13))
        leftImageView.image=UIImage(named:"ss")
        leftView.addSubview(leftImageView)
        txt.leftView=leftView
        txt.leftViewMode=UITextFieldViewMode.always
        let leftBarTxt=UIBarButtonItem(customView:txt)
        //公告
        let noticeImg=UIImageView(frame:CGRect(x: 0,y: 0,width:25,height: 25))
        noticeImg.image=UIImage(named:"notice")?.reSizeImage(reSize:CGSize(width:25, height: 25))
        noticeImg.isUserInteractionEnabled=true
        noticeImg.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(showActivityAlert)))
        
        let barNotice=UIBarButtonItem(customView:noticeImg)
        ///定位文字
        lblAddress=CBAutoScrollLabel(frame:CGRect(x: 0,y: 0,width: 50,height: 20))
        lblAddress!.textColor=UIColor.white
        lblAddress!.font=UIFont.boldSystemFont(ofSize: 16)
        //获取缓登录中得到的缓存地址
        lblAddress!.text=UserDefaults.standard.object(forKey: "address") as? String
        lblAddress!.labelSpacing = 30; // distance between start and end labels
        lblAddress!.pauseInterval = 1.7; // seconds of pause before scrolling starts again
        lblAddress!.scrollSpeed = 30; // pixels per second
        lblAddress!.textAlignment = NSTextAlignment.center// centers text when no auto-scrolling is applied
        lblAddress!.fadeLength = 12;
        lblAddress!.scrollDirection = CBAutoScrollDirection.left;
        lblAddress!.isUserInteractionEnabled=true
        lblAddress!.observeApplicationNotifications()
        /// 定位titleBar
        let addressTitleBar=UIBarButtonItem(customView:lblAddress!)
        self.navigationItem.leftBarButtonItems=[leftBarNil,leftBarImg,addressTitleBar,leftBarTxt,barNotice]
    }
    /**
     构建分类collectionView
     */
    func buildClassifCollectionView(){
        let flowLayout = UICollectionViewFlowLayout()
        let widthH=(boundsWidth-50)/4
        flowLayout.itemSize = CGSize(width: widthH,height: widthH)
        
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical//设置垂直显示
        
        
        //        flowLayout.sectionInset = UIEdgeInsetsMake(10,10,10,10)//设置边距
        //
        flowLayout.minimumLineSpacing = 10;//每个相邻layout的上下
        
        flowLayout.minimumInteritemSpacing = 0;//每个相邻layout的左右
        
        flowLayout.headerReferenceSize = CGSize(width: 0, height: 0);
        classifyCollectionView=UICollectionView(frame:CGRect(x: 15,y: (netWorkBanner!.frame).maxY+15,width: boundsWidth-30,height: boundsWidth/4*2), collectionViewLayout:flowLayout)
        classifyCollectionView!.backgroundColor=UIColor.white;
        classifyCollectionView!.alwaysBounceVertical=true;
        classifyCollectionView!.delegate=self;
        classifyCollectionView!.dataSource=self;
        classifyCollectionView!.register(IndexClassifyCollectionViewCell.self, forCellWithReuseIdentifier:"IndexClassifyCollectionViewCell");
        classifyCollectionView!.tag=100
        self.scrollView!.addSubview(classifyCollectionView!);
        //商品分类borderView
        classifyCollectionBorderView=UIView(frame:CGRect(x: 0,y: classifyCollectionView!.frame.maxY,width: boundsWidth,height: 7))
        classifyCollectionBorderView!.backgroundColor=UIColor.viewBackgroundColor();
        self.scrollView!.addSubview(classifyCollectionBorderView!)
    }
    /**
     构建特价与促销collectionView
     */
    func buildSpecialAndPromotionsCollectionView(){
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: boundsWidth/2,height: boundsWidth/2-70)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical//设置垂直显示
        flowLayout.minimumLineSpacing = 0;//每个相邻layout的上下
        flowLayout.minimumInteritemSpacing = 0;//每个相邻layout的左右
        flowLayout.headerReferenceSize = CGSize(width: 0, height: 0);
        specialAndPromotionsCollectionView=UICollectionView(frame:CGRect(x: 0,y: classifyCollectionBorderView!.frame.maxY+8,width: boundsWidth,height: boundsWidth/2-70), collectionViewLayout:flowLayout)
        specialAndPromotionsCollectionView!.backgroundColor=UIColor.white;
        specialAndPromotionsCollectionView!.alwaysBounceVertical=true;
        specialAndPromotionsCollectionView!.delegate=self;
        specialAndPromotionsCollectionView!.dataSource=self;
        specialAndPromotionsCollectionView!.register(IndexSpecialAndPromotions.self, forCellWithReuseIdentifier:"IndexSpecialAndPromotions");
        specialAndPromotionsCollectionView!.tag=700
        self.scrollView!.addSubview(specialAndPromotionsCollectionView!);
        specialAndPromotionsCollectionBorderView=UIView(frame:CGRect(x: boundsWidth/2-2,y: specialAndPromotionsCollectionView!.frame.origin.y,width: 1,height: specialAndPromotionsCollectionView!.frame.height))
        specialAndPromotionsCollectionBorderView!.backgroundColor=UIColor.viewBackgroundColor()
        self.scrollView!.addSubview(specialAndPromotionsCollectionBorderView!)
        specialAndPromotionsCollectionButtomBorderView=UIView(frame:CGRect(x: 0,y: specialAndPromotionsCollectionView!.frame.maxY+8,width: boundsWidth,height: 7))
        specialAndPromotionsCollectionButtomBorderView!.backgroundColor=UIColor.viewBackgroundColor()
        self.scrollView!.addSubview(specialAndPromotionsCollectionButtomBorderView!)
        
    }
    /**
     构建新品推荐collectionView
     */
    func buildNewProductCollectonView(){
        
        //边线
        let lblNewProductBorderView=UIView(frame:CGRect(x: 10,y: specialAndPromotionsCollectionButtomBorderView!.frame.maxY+20,width: boundsWidth-20,height: 1))
        lblNewProductBorderView.backgroundColor=UIColor(red:215/255, green:215/255, blue: 215/255, alpha: 1)
        self.scrollView!.addSubview(lblNewProductBorderView)
        
        //新品推荐标题
        let lblNewProductTitle=UILabel(frame:CGRect(x: (boundsWidth-80)/2,y: specialAndPromotionsCollectionButtomBorderView!.frame.maxY+10,width: 80,height: 20))
        lblNewProductTitle.textColor=UIColor.applicationMainColor()
        lblNewProductTitle.text="新品推荐"
        lblNewProductTitle.backgroundColor=UIColor.white
        lblNewProductTitle.textAlignment = .center
        if #available(iOS 8.2, *) {
            lblNewProductTitle.font=UIFont.systemFont(ofSize:16, weight:UIFont.Weight(rawValue: 0.5))
        } else {
            lblNewProductTitle.font=UIFont.systemFont(ofSize: 16)
        }
        self.scrollView!.addSubview(lblNewProductTitle)
        
        
        
        let flowLayout = UICollectionViewFlowLayout()
        let widthH=(boundsWidth-20-10)/2
        flowLayout.itemSize = CGSize(width: widthH,height: 220)
        
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal//设置垂直显示
        
        //        flowLayout.sectionInset = UIEdgeInsetsMake(10,10,10,10)//设置边距
        //
        flowLayout.minimumLineSpacing = 10;//每个相邻layout的上下
        
        flowLayout.minimumInteritemSpacing = 0;//每个相邻layout的左右
        
        flowLayout.headerReferenceSize = CGSize(width: 0, height: 0);
        newProductCollectionView=UICollectionView(frame:CGRect(x: 10,y: lblNewProductTitle.frame.maxY+10,width: boundsWidth-20,height: 230), collectionViewLayout:flowLayout)
        newProductCollectionView!.backgroundColor=UIColor.clear;
        newProductCollectionView!.delegate=self;
        newProductCollectionView!.dataSource=self;
        newProductCollectionView!.showsHorizontalScrollIndicator=false
        newProductCollectionView!.register(IndexHotGoodCollectionViewCell.self, forCellWithReuseIdentifier:"NewProductCollectionViewCell");
        newProductCollectionView!.tag=200
        self.scrollView!.addSubview(newProductCollectionView!)
        
        //背景view
        newProductBorderView=UIView(frame:CGRect(x: 0,y: newProductCollectionView!.frame.maxY+10,width: boundsWidth,height: 10))
        newProductBorderView!.backgroundColor=UIColor.viewBackgroundColor()
        self.scrollView!.addSubview(newProductBorderView!)
        addTimer()
    }
    /**
     构建热门商品
     */
    func buildHotGoodCollectionView(){
        
        //边线
        let lblHotGoodTitleBorderView=UIView(frame:CGRect(x: 10,y: newProductBorderView!.frame.maxY+20,width: boundsWidth-20,height: 1))
        lblHotGoodTitleBorderView.backgroundColor=UIColor(red:215/255, green:215/255, blue: 215/255, alpha: 1)
        self.scrollView!.addSubview(lblHotGoodTitleBorderView)
        
        //热门商品标题
        let lblHotGoodTitle=UILabel(frame:CGRect(x: (boundsWidth-80)/2,y: newProductBorderView!.frame.maxY+10,width: 80,height: 20))
        lblHotGoodTitle.textColor=UIColor.applicationMainColor()
        lblHotGoodTitle.text="热门商品"
        lblHotGoodTitle.backgroundColor=UIColor.white
        lblHotGoodTitle.textAlignment = .center
        if #available(iOS 8.2, *) {
            lblHotGoodTitle.font=UIFont.systemFont(ofSize: 16, weight:UIFont.Weight(rawValue: 0.5))
        } else {
            lblHotGoodTitle.font=UIFont.systemFont(ofSize: 16)
        }
        self.scrollView!.addSubview(lblHotGoodTitle)
        
        
        let flowLayout = UICollectionViewFlowLayout()
        let widthH=(boundsWidth-20-5)/2
        flowLayout.itemSize = CGSize(width: widthH,height: 220)
        
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical//设置垂直显示
        
        //        flowLayout.sectionInset = UIEdgeInsetsMake(10,10,10,10)//设置边距
        //
        flowLayout.minimumLineSpacing = 5;//每个相邻layout的上下
        
        flowLayout.minimumInteritemSpacing = 0;//每个相邻layout的左右
        
        flowLayout.headerReferenceSize = CGSize(width: 0,height: 0);
        hotGoodCollectionView=UICollectionView(frame:CGRect(x: 10,y: newProductBorderView!.frame.maxY+40,width: boundsWidth-20,height: 0), collectionViewLayout:flowLayout)
        hotGoodCollectionView!.backgroundColor=UIColor.white;
        hotGoodCollectionView!.delegate=self;
        hotGoodCollectionView!.dataSource=self;
        hotGoodCollectionView!.register(IndexHotGoodCollectionViewCell.self, forCellWithReuseIdentifier:"IndexHotGoodCollectionViewCell");
        hotGoodCollectionView!.tag=300
        self.scrollView!.addSubview(hotGoodCollectionView!);
    }

}
// MARK: - 协议实现
extension IndexViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    //每个collectionViewCell展示的内容
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cells=UICollectionViewCell()
        if collectionView.tag == 100{//分类
            let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "IndexClassifyCollectionViewCell", for:indexPath) as! IndexClassifyCollectionViewCell
            if classifyArr.count > 0{//如果大于0更新cell  防止空数据  导致程序直接崩溃
                let entity=classifyArr[indexPath.row] as! GoodsCategoryEntity
                cell.updaeCell(entity)
               
            }
            cells=cell
        }else if collectionView.tag == 200{//新品推荐
            let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "NewProductCollectionViewCell", for:indexPath) as! IndexHotGoodCollectionViewCell
            if newProductArr.count > 0{//如果大于0更新cell  防止空数据  导致程序直接崩溃
                let img=UIImageView(frame:CGRect(x: cell.goodImgView.frame.maxX-44,y: 20,width: 44, height: 46))
                img.image=UIImage(named: "newGood")
                
                let entity=newProductArr[indexPath.row] as! GoodDetailEntity
                cell.updateCell(entity)
                cell.contentView.addSubview(img)
            }
            cells=cell
        }else if collectionView.tag == 300{//热门商品
            let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "IndexHotGoodCollectionViewCell", for:indexPath) as! IndexHotGoodCollectionViewCell
            if hotGoodArr.count > 0{//如果大于0更新cell  防止空数据  导致程序直接崩溃
                let entity=hotGoodArr[indexPath.row] as! GoodDetailEntity
                cell.updateCell(entity)
            }
            cells=cell
        }else if collectionView.tag == 700{//特价与促销
            let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "IndexSpecialAndPromotions", for:indexPath) as! IndexSpecialAndPromotions
            if specialAndPromotionsArr.count > 0{//如果大于0更新cell  防止空数据  导致程序直接崩溃
                let entity=specialAndPromotionsArr[indexPath.row]
                cell.updateCell(entity)
            }
            cells=cell
        }
        
        return cells
    }
    
    //定义展示的UICollectionViewCell的个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count=0
        if collectionView.tag == 100{//分类
            count=classifyArr.count
        }else if collectionView.tag == 200{//新品推荐
            count=newProductArr.count
        }else if collectionView.tag == 300{//热门商品
            count=hotGoodArr.count
        }else if collectionView.tag == 700{
            count=specialAndPromotionsArr.count
        }
        return count
    }
    //定义展示的Section的个数 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView.tag == 200{
            return 10
        }else{
            return 1;
        }
        
    }
    //每个collectionViewCell点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 100{//分类
            let entity=self.classifyArr[indexPath.row] as! GoodsCategoryEntity
            if entity.categoryType == 1{//跳转到收藏区
                let vc=CollectListViewController()
                vc.hidesBottomBarWhenPushed=true
                self.navigationController?.pushViewController(vc, animated:true)
            }else if entity.categoryType == 2{//跳转到积分商城
                if self.substationEntity?.subStationBalanceStatu == 1{
                    /// 跳转到积分商城
                    let vc=PresentExpViewController()
                    vc.hidesBottomBarWhenPushed=true
                    self.navigationController?.pushViewController(vc, animated:true)
                }else{
                    SVProgressHUD.showInfo(withStatus:"该区域暂未开放,请联系业务员申请开通")
                }
            }else{//其他跳转到分类
                let goodCaregoryVc=CategoryListController()
                goodCaregoryVc.pid=entity.goodsCategoryId
                goodCaregoryVc.pushState=1
                goodCaregoryVc.categoryName=entity.goodsCategoryName
                goodCaregoryVc.hidesBottomBarWhenPushed=true
                self.navigationController?.pushViewController(goodCaregoryVc, animated:true);
            }
        }else if collectionView.tag == 200{//新品推荐
            let vc=GoodCategory3ViewController()
            vc.flag=3
            vc.hidesBottomBarWhenPushed=true
            self.navigationController!.pushViewController(vc, animated:true)
            
        }else if collectionView.tag == 300{//热门商品
            let entity=hotGoodArr[indexPath.row] as! GoodDetailEntity
            let vc=GoodDetailViewController()
            vc.hidesBottomBarWhenPushed=true
            vc.goodEntity=entity
            vc.storeId=UserDefaults.standard.object(forKey: "storeId") as? String
            self.navigationController!.pushViewController(vc, animated:true)
        }else if collectionView.tag == 700{
            print("数组数量\(specialAndPromotionsArr.count)")
            print("数组索引\(indexPath.item)")
            let entity=specialAndPromotionsArr[indexPath.item]
            if entity.mobileOrPc == 3{
                let vc=GoodSpecialPriceViewController()
                vc.flag=1
                vc.hidesBottomBarWhenPushed=true
                self.navigationController!.pushViewController(vc, animated:true)
            }else if entity.mobileOrPc == 2{
                let vc=GoodSpecialPriceViewController()
                vc.flag=3
                vc.hidesBottomBarWhenPushed=true
                self.navigationController?.pushViewController(vc, animated:true)
            }
        }
    }

}
// MARK: - 页面逻辑
extension IndexViewController{
    /**
     新品推荐页面切换
     
     - parameter sender: NSTimer
     */
    @objc func newProductSwitch(_ sender:Timer){
        if self.newProductCollectionView!.indexPathsForVisibleItems.last != nil{
            let currentIndexPath=self.newProductCollectionView!.indexPathsForVisibleItems.last!
            let currentIndexPathReset=IndexPath(item: currentIndexPath.item, section:10/2)
            self.newProductCollectionView!.scrollToItem(at: currentIndexPathReset, at: UICollectionViewScrollPosition.left,animated:false)
            var nextItem=currentIndexPathReset.item+2;
            var nextSection = currentIndexPathReset.section;
            if (nextItem>=self.newProductArr.count){
                nextItem=0
                nextSection+=1
            }
            let nextIndexPath=IndexPath(item:nextItem, section:nextSection)
            self.newProductCollectionView!.scrollToItem(at: nextIndexPath, at: UICollectionViewScrollPosition.left,animated:true)
        }
        
        
    }
    /**
     添加定时器
     */
    func addTimer(){
        if timer == nil{
            timer=Timer.scheduledTimer(timeInterval: 4, target: self, selector:#selector(newProductSwitch), userInfo:nil, repeats: true)
        }
        
    }
    func removeTimer(){
        self.timer?.invalidate()
        self.timer=nil
    }
    /**
     弹出活动内容
     */
    @objc func showActivityAlert(){
        var message:String?="暂无内容"
        var title:String?="点单即到"
        if self.adMessgInfoEntity != nil{//弹出公告信息
            message=self.adMessgInfoEntity!.messContent
            title=self.adMessgInfoEntity!.messTitle
        }
        let alert=UIAlertController(title:title, message:message, preferredStyle: UIAlertControllerStyle.alert)
        let ok=UIAlertAction(title:"确定", style: UIAlertActionStyle.default, handler:nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion:nil)
    }
    /**
     点击幻灯片图片回调事件
     
     - parameter cycleScrollView:SDCycleScrollView!
     - parameter index:          Int
     */
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAtIndex index: Int) {
        let entity=zwadImgArr[index] as! AdvertisingEntity
        if entity.searchStatu == 2{
            let vc=GoodCategory3ViewController()
            vc.flag=1
            vc.searchName=entity.advertisingDescription
            vc.hidesBottomBarWhenPushed=true
            self.navigationController?.pushViewController(vc, animated:true)
        }
         
    }

}
// MARK: - 网络请求
extension IndexViewController{
    /**
     发送网络请求
     */
    func http(){
        /// 获取登录中  保存的县区id
        let countyId=UserDefaults.standard.object(forKey: "countyId") as!String
        let storeId=UserDefaults.standard.object(forKey: "storeId") as!String
        let substationId=UserDefaults.standard.object(forKey: "substationId") as! String
        /// 创建一个任务队列组
        let group = DispatchGroup()
        /// 创建一个并行队列(传入 DISPATCH_QUEUE_SERIAL 或 NIL 表示创建串行队列。传入 DISPATCH_QUEUE_CONCURRENT 表示创建并行队列.)
        let queue = DispatchQueue(label: "com.gcd-group.www",attributes: DispatchQueue.Attributes.concurrent);
        //把所有的网络请求放到一个个异步线程中 在queue中执行
        queue.async(group: group,execute: {
            //发送幻灯片请求
            self.httpSlide(countyId)
            //发分站信息请求
            self.querySubstationInfo(storeId)
        })
        queue.async(group: group,execute: {
            //发送促销与特价图片请求
            self.httpPromotionImg()
        })
        queue.async(group: group,execute: {
            //发送分类请求
            self.httpClassify()
        })
        queue.async(group: group,execute: {
            //发送新品请求
            self.httpNewProduct(countyId,storeId:storeId)
        })
        queue.async(group: group,execute: {
            //发送热门商品请求
            self.httpHotGood(countyId, storeId:storeId)
        })
        queue.async(group: group,execute: {
            //发送公告栏请求
            self.httpAdMessgInfo(substationId)
        })
        //任务完成执行
        group.notify(queue: queue,execute: {
            
        });
        
        self.updateViewFlag=false
        
        
    }
    /**
     发送促销图片请求
     */
    func httpPromotionImg(){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.mobileAdvertisingPromotionAndPreferential(), successClosure: { (result) -> Void in
            let json=JSON(result)
            for(_,value) in json{
                let entity=Mapper<SpecialAndPromotionsEntity>().map(JSONObject: value.object)
                self.specialAndPromotionsArr.append(entity!)
            }
            self.specialAndPromotionsCollectionView?.reloadData()
            }) { (errorMsg) -> Void in
                SVProgressHUD.showError(withStatus: errorMsg)
        }
    }
    /**
     发送公告栏请求
     
     - parameter substationId: 分站id
     */
    func httpAdMessgInfo(_ substationId:String){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryAdMessgInfo(substationId:substationId), successClosure: { (result) -> Void in
            let json=JSON(result)
            self.adMessgInfoEntity=Mapper<AdMessgInfoEntity>().map(JSONObject: json.object)
            //弹出公告栏提示
            self.showActivityAlert()
            }) { (errorMsg) -> Void in
                
        }
        
    }
    /**
     发送热门商品请求
     
     - parameter countyId: 县区id
     - parameter storeId:  这里storeId=memberId
     */
    func httpHotGood(_ countyId:String,storeId:String){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryGoodsForAndroidIndexForStore(countyId: countyId, isDisplayFlag: 2, storeId: storeId), successClosure: { (result) -> Void in
            let json=JSON(result)
            for(_,value) in json{
                let entity=Mapper<GoodDetailEntity>().map(JSONObject:value.object)
                self.hotGoodArr.add(entity!)
                
            }
            //数据请求完 更新
            self.hotGoodCollectionView?.reloadData()
            //重新计算高度
            var hotGoodCollectionViewY:CGFloat=0
            //计算高度
            if self.hotGoodArr.count > 0{
                if  self.hotGoodArr.count <= 2 {
                    hotGoodCollectionViewY=225
                }else{
                    if self.hotGoodArr.count % 2 == 0{
                        hotGoodCollectionViewY=CGFloat(225*(self.hotGoodArr.count/2))
                    }else{
                        hotGoodCollectionViewY=CGFloat(225*((self.hotGoodArr.count+1)/2))
                    }
                }
            }
            //更新hotGoodCollectionView的高度
            self.hotGoodCollectionView!.frame=CGRect(x:10,y:self.newProductBorderView!.frame.maxY+40, width:boundsWidth-20,height:hotGoodCollectionViewY)
            //重新计算可滑动容器的可滑动size
            self.scrollView!.contentSize=CGSize(width: boundsWidth, height: self.hotGoodCollectionView!.frame.maxY)
            //在热门商品加载完成后结束刷新
            self.scrollView!.mj_header.endRefreshing()
            }) { (errorMsg) -> Void in
                SVProgressHUD.showError(withStatus: errorMsg)
        }
    }
    /**
     发送新品推荐请求
     
     - parameter countyId: 县区id
     - parameter storeId:  这里storeId
     */
    func httpNewProduct(_ countyId:String,storeId:String){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryGoodsForAndroidIndexForStoreNew(countyId: countyId, storeId: storeId, isDisplayFlag: 2, currentPage: 1, pageSize:30, order:""), successClosure: { (result) -> Void in
            let json=JSON(result)
            for(_,value) in json{
                let entity=Mapper<GoodDetailEntity>().map(JSONObject:value.object)
                self.newProductArr.add(entity!)
                
            }
            if self.newProductArr.count > 0{//如果新品推荐有数据刷新
                //不管加没有加载直接先删除视图
                self.lblNilNewProduct?.removeFromSuperview()
                //数据请求完刷新数据
                self.newProductCollectionView?.reloadData()
            }else{//如果没有数据给出提示
                //不管加没有加载直接先删除视图
                self.lblNilNewProduct?.removeFromSuperview()
                self.lblNilNewProduct=nilTitle("没有新品推荐商品")
                self.lblNilNewProduct!.center=self.newProductCollectionView!.center
                self.scrollView!.addSubview(self.lblNilNewProduct!)
            }
            }) { (errorMsg) -> Void in
                SVProgressHUD.showError(withStatus: errorMsg)
        }
    }
    /**
     发送分类请求
     */
    func httpClassify(){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryOneCategory(isDisplayFlag: 2), successClosure: { (result) -> Void in
            let json=JSON(result)
            for(_,value) in json{
                let entity=Mapper<GoodsCategoryEntity>().map(JSONObject:value.object)
                self.classifyArr.add(entity!)
            }
            //数据加载完成分类
            self.classifyCollectionView?.reloadData()
            }) { (errorMsg) -> Void in
                SVProgressHUD.showError(withStatus:errorMsg)
        }
    }
    /**
     发送幻灯片请求
     
     - parameter countyId:县区id
     */
    func httpSlide(_ countyId:String){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.mobileAdvertising(countyId: countyId), successClosure: { (result) -> Void in
            let json=JSON(result)
            
            let imgArr=NSMutableArray()
            for(_,value) in json{
                let entity=Mapper<AdvertisingEntity>().map(JSONObject:value.object)
                imgArr.add(URLIMG+entity!.advertisingURL!)
                self.zwadImgArr.add(entity!)
            }
            self.netWorkBanner?.imageURLStringsGroup=imgArr as [AnyObject]
            }) { (errorMsg) -> Void in
                SVProgressHUD.showError(withStatus: errorMsg)
        }
    }
    /**
     请求分站信息和推荐人
     */
    func querySubstationInfo(_ storeId:String){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryStoreMember(storeId: storeId, memberId: IS_NIL_MEMBERID()!), successClosure: { (result) -> Void in
            //解析json
            let json=JSON(result)
            self.substationEntity=Mapper<SubstationEntity>().map(JSONObject:json["substationEntity"].object)
            }) { (errorMsg) -> Void in
                SVProgressHUD.showError(withStatus: errorMsg)
        }
    }

}
// MARK: - 跳转页面
extension IndexViewController{
    //实现导航控制器文本框的协议
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //点击文本框不让键盘弹出来
        textField.resignFirstResponder()
        let vc=SearchViewController();
        vc.hidesBottomBarWhenPushed=true;
        self.navigationController?.pushViewController(vc, animated:true);
    }
}
