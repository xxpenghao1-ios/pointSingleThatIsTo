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
/// 首页
class IndexViewController:UIViewController,SDCycleScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate,UIScrollViewDelegate{
    /// 可滑动容器
    private var scrollView:UIScrollView?
    
    //*****导航控制器begin******
    /// 滚动显示地址信息
    private var lblAddress:CBAutoScrollLabel?
    //*****导航控制器end********
    
    //*****幻灯片begin**********
    /// 幻灯片控件
    private var netWorkBanner:SDCycleScrollView?
    /// 幻灯片图片数组
    private var zwadImgArr=NSMutableArray()
    //*****幻灯片end************
    
    /// 促销
    private var promotionImageView:UIImageView?
    
    
    //******分类begin*******
    private var classifyArr=NSMutableArray()
    /// 分类
    private var classifyCollectionView:UICollectionView?
    /// 分类下边背景view
    private var classifyCollectionBorderView:UIView?
    //******分类end*********
    
    //******新品推荐begin********
    private var newProductArr=NSMutableArray()
    /// 新品推荐
    private var newProductCollectionView:UICollectionView?
    /// 新品推荐为空提示
    private var lblNilNewProduct:UILabel?
    /// 新品推荐下边背景view
    private var newProductBorderView:UIView?
    //******新品推荐end**********
    
    //******热门商品begin*******
    /// 热门商品数组
    private var hotGoodArr=NSMutableArray()
    /// 热门商品CollectionView
    private var hotGoodCollectionView:UICollectionView?
    //******热门商品end*********
    
    /// 公告栏entity
    private var adMessgInfoEntity:AdMessgInfoEntity?
    
    /// 用于页面自动刷新
    private var updateViewFlag=false
    
    /// 定时器
    private var timer:NSTimer?
    
    //保存索引(用于新品推荐滚动)
    private var index=0

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        addTimer()
        if updateViewFlag{//如果等于true 自动刷新页面
            self.scrollView?.headerBeginRefreshing()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        //设置当前页面导航控制器背景色为0.2透明度
//        self.navigationController!.navigationBar.lt_setBackgroundColor(UIColor.applicationMainColor().colorWithAlphaComponent(0.2))
        //设置view背景颜色
        self.view.backgroundColor=UIColor.whiteColor()
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
        if IJReachability.isConnectedToNetwork(){
            //发送网络请求
            http()
        }else{
            SVProgressHUD.showErrorWithStatus("无网络连接")
            updateViewFlag=true
        }
        scrollView!.addHeaderWithCallback({//下拉刷新首页数据
            if IJReachability.isConnectedToNetwork(){//先判断是否有网络
                //清空所有的数据源重新请求
                self.zwadImgArr.removeAllObjects()
                self.classifyArr.removeAllObjects()
                self.newProductArr.removeAllObjects()
                self.hotGoodArr.removeAllObjects()
                //发送数据请求
                self.http()
            }else{//如果没有给出提示结束刷新
                self.scrollView!.headerEndRefreshing()
                SVProgressHUD.showErrorWithStatus("无网络连接")
                self.updateViewFlag=true
            }
            
        })
    }
    
    
    /**
     构建页面
     */
    func buildView(){
        
        //构建导航控制器布局
        buildNavigationBarView()
        
        //构建幻灯view
        netWorkBanner=SDCycleScrollView(frame: CGRectMake(0, 0,boundsWidth,160), delegate: self, placeholderImage: UIImage(named: "def_nil"))
        netWorkBanner!.autoScrollTimeInterval=5.0
        netWorkBanner!.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated
        netWorkBanner!.pageControlAliment = SDCycleScrollViewPageContolAlimentRight
        netWorkBanner!.backgroundColor=UIColor.whiteColor()
        self.scrollView!.addSubview(netWorkBanner!)
        //构建促销图片
        promotionImageView=UIImageView(frame:CGRectMake(0,CGRectGetMaxY(netWorkBanner!.frame),boundsWidth,140))
        promotionImageView!.userInteractionEnabled=true
        promotionImageView!.image=UIImage(named:"def_promotion")
        promotionImageView!.addGestureRecognizer(UITapGestureRecognizer(target:self, action:"pushPromotionView:"))
        self.scrollView!.addSubview(promotionImageView!)
        //构建分类collectionView
        buildClassifCollectionView()
        
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
        let leftBarNil=UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.FixedSpace, target:nil, action:nil);
        let barImg=UIImage(named:"gps");
        let barImgView=UIImageView(image:barImg);
        barImgView.frame=CGRectMake(0,0,11.5,18);
        //gps图片按钮
        let leftBarImg=UIBarButtonItem(customView:barImgView);
        //设置这个的UIBarButtonItem的宽为-15
        leftBarNil.width = -10;
        //直接创建一个文本框
        let txt=UITextField(frame:CGRectMake(0,0,boundsWidth-120,30))
        txt.backgroundColor=UIColor.whiteColor()
        txt.delegate=self
        txt.placeholder="请输入您要搜索的商品"
        txt.font=UIFont.systemFontOfSize(14)
        txt.resignFirstResponder()
        txt.layer.cornerRadius=3
        let leftView=UIView(frame:CGRectMake(0,0,30,30))
        let leftImageView=UIImageView(frame:CGRectMake(10,8.5,13.5,13))
        leftImageView.image=UIImage(named:"ss")
        leftView.addSubview(leftImageView)
        txt.leftView=leftView
        txt.leftViewMode=UITextFieldViewMode.Always
        let leftBarTxt=UIBarButtonItem(customView:txt)
        ///定位文字
        lblAddress=CBAutoScrollLabel(frame:CGRectMake(0,0,60,20))
        lblAddress!.textColor=UIColor.whiteColor()
        lblAddress!.font=UIFont.boldSystemFontOfSize(16)
        //获取缓登录中得到的缓存地址
        lblAddress!.text=NSUserDefaults.standardUserDefaults().objectForKey("address") as? String
        lblAddress!.labelSpacing = 30; // distance between start and end labels
        lblAddress!.pauseInterval = 1.7; // seconds of pause before scrolling starts again
        lblAddress!.scrollSpeed = 30; // pixels per second
        lblAddress!.textAlignment = NSTextAlignment.Center// centers text when no auto-scrolling is applied
        lblAddress!.fadeLength = 12;
        lblAddress!.scrollDirection = CBAutoScrollDirection.Left;
        lblAddress!.userInteractionEnabled=true
        lblAddress!.observeApplicationNotifications()
        /// 定位titleBar
        let addressTitleBar=UIBarButtonItem(customView:lblAddress!)
        self.navigationItem.leftBarButtonItems=[leftBarNil,leftBarImg,addressTitleBar,leftBarTxt]
    }
    /**
     构建分类collectionView
     */
    func buildClassifCollectionView(){
        let flowLayout = UICollectionViewFlowLayout()
        let widthH=(boundsWidth-50)/4
        flowLayout.itemSize = CGSizeMake(widthH,widthH)
        
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Vertical//设置垂直显示
        
        
        //        flowLayout.sectionInset = UIEdgeInsetsMake(10,10,10,10)//设置边距
        //
        flowLayout.minimumLineSpacing = 10;//每个相邻layout的上下
        
        flowLayout.minimumInteritemSpacing = 0;//每个相邻layout的左右
        
        flowLayout.headerReferenceSize = CGSizeMake(0, 0);
        classifyCollectionView=UICollectionView(frame:CGRectMake(15,CGRectGetMaxY(promotionImageView!.frame)+15,boundsWidth-30,boundsWidth/4*2), collectionViewLayout:flowLayout)
        classifyCollectionView!.backgroundColor=UIColor.whiteColor();
        classifyCollectionView!.alwaysBounceVertical=true;
        classifyCollectionView!.delegate=self;
        classifyCollectionView!.dataSource=self;
        classifyCollectionView!.registerClass(IndexClassifyCollectionViewCell.self, forCellWithReuseIdentifier:"IndexClassifyCollectionViewCell");
        classifyCollectionView!.tag=100
        self.scrollView!.addSubview(classifyCollectionView!);
        //商品分类borderView
        classifyCollectionBorderView=UIView(frame:CGRectMake(0,CGRectGetMaxY(classifyCollectionView!.frame),boundsWidth,10))
        classifyCollectionBorderView!.backgroundColor=UIColor.viewBackgroundColor();
        self.scrollView!.addSubview(classifyCollectionBorderView!)
    }
    /**
     构建新品推荐collectionView
     */
    func buildNewProductCollectonView(){
        
        //边线
        let lblNewProductBorderView=UIView(frame:CGRectMake(10,CGRectGetMaxY(classifyCollectionBorderView!.frame)+20,boundsWidth-20,1))
        lblNewProductBorderView.backgroundColor=UIColor(red:215/255, green:215/255, blue: 215/255, alpha: 1)
        self.scrollView!.addSubview(lblNewProductBorderView)
        
        //新品推荐标题
        let lblNewProductTitle=UILabel(frame:CGRectMake((boundsWidth-80)/2,CGRectGetMaxY(classifyCollectionBorderView!.frame)+10,80,20))
        lblNewProductTitle.textColor=UIColor.applicationMainColor()
        lblNewProductTitle.text="新品推荐"
        lblNewProductTitle.backgroundColor=UIColor.whiteColor()
        lblNewProductTitle.textAlignment = .Center
        if #available(iOS 8.2, *) {
            lblNewProductTitle.font=UIFont.systemFontOfSize(16, weight:0.5)
        } else {
            lblNewProductTitle.font=UIFont.systemFontOfSize(16)
        }
        self.scrollView!.addSubview(lblNewProductTitle)
        
        
        
        let flowLayout = UICollectionViewFlowLayout()
        let widthH=(boundsWidth-20-10)/2
        flowLayout.itemSize = CGSizeMake(widthH,220)
        
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal//设置垂直显示
        
        //        flowLayout.sectionInset = UIEdgeInsetsMake(10,10,10,10)//设置边距
        //
        flowLayout.minimumLineSpacing = 10;//每个相邻layout的上下
        
        flowLayout.minimumInteritemSpacing = 0;//每个相邻layout的左右
        
        flowLayout.headerReferenceSize = CGSizeMake(0, 0);
        newProductCollectionView=UICollectionView(frame:CGRectMake(10,CGRectGetMaxY(lblNewProductTitle.frame)+10,boundsWidth-20,230), collectionViewLayout:flowLayout)
        newProductCollectionView!.backgroundColor=UIColor.clearColor();
        newProductCollectionView!.delegate=self;
        newProductCollectionView!.dataSource=self;
        newProductCollectionView!.showsHorizontalScrollIndicator=false
        newProductCollectionView!.registerClass(IndexHotGoodCollectionViewCell.self, forCellWithReuseIdentifier:"NewProductCollectionViewCell");
        newProductCollectionView!.tag=200
        self.scrollView!.addSubview(newProductCollectionView!)
        
        //背景view
        newProductBorderView=UIView(frame:CGRectMake(0,CGRectGetMaxY(newProductCollectionView!.frame)+10,boundsWidth,10))
        newProductBorderView!.backgroundColor=UIColor.viewBackgroundColor()
        self.scrollView!.addSubview(newProductBorderView!)
        addTimer()
    }
    /**
     构建热门商品
     */
    func buildHotGoodCollectionView(){
        
        //边线
        let lblHotGoodTitleBorderView=UIView(frame:CGRectMake(10,CGRectGetMaxY(newProductBorderView!.frame)+20,boundsWidth-20,1))
        lblHotGoodTitleBorderView.backgroundColor=UIColor(red:215/255, green:215/255, blue: 215/255, alpha: 1)
        self.scrollView!.addSubview(lblHotGoodTitleBorderView)
        
        //热门商品标题
        let lblHotGoodTitle=UILabel(frame:CGRectMake((boundsWidth-80)/2,CGRectGetMaxY(newProductBorderView!.frame)+10,80,20))
        lblHotGoodTitle.textColor=UIColor.applicationMainColor()
        lblHotGoodTitle.text="热门商品"
        lblHotGoodTitle.backgroundColor=UIColor.whiteColor()
        lblHotGoodTitle.textAlignment = .Center
        if #available(iOS 8.2, *) {
            lblHotGoodTitle.font=UIFont.systemFontOfSize(16, weight:0.5)
        } else {
            lblHotGoodTitle.font=UIFont.systemFontOfSize(16)
        }
        self.scrollView!.addSubview(lblHotGoodTitle)
        
        
        let flowLayout = UICollectionViewFlowLayout()
        let widthH=(boundsWidth-20-5)/2
        flowLayout.itemSize = CGSizeMake(widthH,220)
        
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Vertical//设置垂直显示
        
        //        flowLayout.sectionInset = UIEdgeInsetsMake(10,10,10,10)//设置边距
        //
        flowLayout.minimumLineSpacing = 5;//每个相邻layout的上下
        
        flowLayout.minimumInteritemSpacing = 0;//每个相邻layout的左右
        
        flowLayout.headerReferenceSize = CGSizeMake(0,0);
        hotGoodCollectionView=UICollectionView(frame:CGRectMake(10,CGRectGetMaxY(newProductBorderView!.frame)+40,boundsWidth-20,0), collectionViewLayout:flowLayout)
        hotGoodCollectionView!.backgroundColor=UIColor.whiteColor();
        hotGoodCollectionView!.delegate=self;
        hotGoodCollectionView!.dataSource=self;
        hotGoodCollectionView!.registerClass(IndexHotGoodCollectionViewCell.self, forCellWithReuseIdentifier:"IndexHotGoodCollectionViewCell");
        hotGoodCollectionView!.tag=300
        self.scrollView!.addSubview(hotGoodCollectionView!);
    }


            //每个collectionViewCell展示的内容
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cells=UICollectionViewCell()
        if collectionView.tag == 100{//分类
            let cell=collectionView.dequeueReusableCellWithReuseIdentifier("IndexClassifyCollectionViewCell", forIndexPath:indexPath) as! IndexClassifyCollectionViewCell
            if classifyArr.count > 0{//如果大于0更新cell  防止空数据  导致程序直接崩溃
                if indexPath.row < classifyArr.count{
                    let entity=classifyArr[indexPath.row] as! GoodsCategoryEntity
                    cell.updaeCell(entity)
                }else{
                    if indexPath.row == classifyArr.count{
                        cell.updateCell1("公告栏", pic:"category7")
                    }else if indexPath.row == classifyArr.count+1{
                        cell.updateCell1("每日特惠", pic:"category8")
                    }
                }
            }
            cells=cell
        }else if collectionView.tag == 200{//新品推荐
            let cell=collectionView.dequeueReusableCellWithReuseIdentifier("NewProductCollectionViewCell", forIndexPath:indexPath) as! IndexHotGoodCollectionViewCell
            if newProductArr.count > 0{//如果大于0更新cell  防止空数据  导致程序直接崩溃
                let img=UIImageView(frame:CGRectMake(CGRectGetMaxX(cell.goodImgView.frame)-44,20,44, 46))
                img.image=UIImage(named: "newGood")
                
                let entity=newProductArr[indexPath.row] as! GoodDetailEntity
                cell.updateCell(entity)
                cell.contentView.addSubview(img)
            }
            cells=cell
        }else if collectionView.tag == 300{//热门商品
            let cell=collectionView.dequeueReusableCellWithReuseIdentifier("IndexHotGoodCollectionViewCell", forIndexPath:indexPath) as! IndexHotGoodCollectionViewCell
            if hotGoodArr.count > 0{//如果大于0更新cell  防止空数据  导致程序直接崩溃
                let entity=hotGoodArr[indexPath.row] as! GoodDetailEntity
                cell.updateCell(entity)
            }
            cells=cell
        }
        
        return cells
    }
    //定义展示的UICollectionViewCell的个数
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count=0
        if collectionView.tag == 100{//分类
            count=classifyArr.count+2
        }else if collectionView.tag == 200{//新品推荐
            count=newProductArr.count
        }else if collectionView.tag == 300{//热门商品
            count=hotGoodArr.count
        }
        return count
    }
    //定义展示的Section的个数
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    //每个collectionViewCell点击事件
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView.tag == 100{//分类
            if indexPath.row < self.classifyArr.count{
                let entity=self.classifyArr[indexPath.row] as! GoodsCategoryEntity
                let goodCaregoryVc=CategoryListController()
                goodCaregoryVc.pid=entity.goodsCategoryId
                goodCaregoryVc.pushState=1
                goodCaregoryVc.hidesBottomBarWhenPushed=true
                self.navigationController?.pushViewController(goodCaregoryVc, animated:true);
            }else{
                if indexPath.row == self.classifyArr.count{//弹出提示
                    self.showActivityAlert()
                }else if indexPath.row == classifyArr.count+1{//跳转特价区
                    let vc=GoodSpecialPriceViewController()
                    vc.arr=classifyArr
                    vc.hidesBottomBarWhenPushed=true
                    self.navigationController!.pushViewController(vc, animated:true)
                }
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
            vc.storeId=NSUserDefaults.standardUserDefaults().objectForKey("storeId") as? String
            self.navigationController!.pushViewController(vc, animated:true)
        }
    }
    
    //实现可滑动容器协议
    func scrollViewDidScroll(scrollView: UIScrollView) {
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
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if scrollView.tag == 200{
            removeTimer()
        }
    }
    //当前用户结束滑动的时候
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.tag == 200{
            //拿到当前展示的cell中的第一个
            let indexPath=newProductCollectionView!.indexPathsForVisibleItems().last
            if indexPath != nil{//判断是否为空
                index=indexPath!.row
            }
            addTimer()
        }
    }

    //页面退出
    override func viewWillDisappear(animated: Bool) {
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
// MARK: - 页面逻辑
extension IndexViewController{
    /**
     新品推荐页面切换
     
     - parameter sender: NSTimer
     */
    func newProductSwitch(sender:NSTimer){
        self.index+=2
            if self.newProductArr.count > 0{//判断新品是否有数据
                if self.newProductArr.count > 2{
                    if self.index < self.newProductArr.count{//如果当前索引小于数组长度
                        self.newProductCollectionView!.scrollToItemAtIndexPath(NSIndexPath(forItem:self.index, inSection:0), atScrollPosition: UICollectionViewScrollPosition.Left, animated:true)
                    }else{
                        self.index=0
                        self.newProductCollectionView!.scrollToItemAtIndexPath(NSIndexPath(forItem:self.index, inSection:0), atScrollPosition: UICollectionViewScrollPosition.Left, animated:true)
                        
                    }
                }
            }
    }
    /**
     添加定时器
     */
    func addTimer(){
        if timer == nil{
            timer=NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector:"newProductSwitch:", userInfo:nil, repeats: true)
        }
        
    }
    func removeTimer(){
        self.timer?.invalidate()
        self.timer=nil
    }
    /**
     弹出活动内容
     */
    func showActivityAlert(){
        var message:String?="暂无内容"
        var title:String?="点单即到"
        if self.adMessgInfoEntity != nil{//弹出公告信息
            message=self.adMessgInfoEntity!.messContent
            title=self.adMessgInfoEntity!.messTitle
        }
        let alert=UIAlertController(title:title, message:message, preferredStyle: UIAlertControllerStyle.Alert)
        let ok=UIAlertAction(title:"确定", style: UIAlertActionStyle.Default, handler:nil)
        alert.addAction(ok)
        self.presentViewController(alert, animated: true, completion:nil)
    }
    /**
     点击幻灯片图片回调事件
     
     - parameter cycleScrollView:SDCycleScrollView!
     - parameter index:          Int
     */
    func cycleScrollView(cycleScrollView: SDCycleScrollView!, didSelectItemAtIndex index: Int) {
         
    }

}
// MARK: - 网络请求
extension IndexViewController{
    /**
     发送网络请求
     */
    func http(){
        /// 获取登录中  保存的县区id
        let countyId=NSUserDefaults.standardUserDefaults().objectForKey("countyId") as!String
        let storeId=NSUserDefaults.standardUserDefaults().objectForKey("storeId") as!String
        let substationId=NSUserDefaults.standardUserDefaults().objectForKey("substationId") as! String
        /// 创建一个任务队列组
        let group = dispatch_group_create()
        /// 创建一个并行队列(传入 DISPATCH_QUEUE_SERIAL 或 NIL 表示创建串行队列。传入 DISPATCH_QUEUE_CONCURRENT 表示创建并行队列.)
        let queue = dispatch_queue_create("com.gcd-group.www",DISPATCH_QUEUE_CONCURRENT);
        //把所有的网络请求放到一个个异步线程中 在queue中执行
        dispatch_group_async(group,queue,{
            //发送幻灯片请求
            self.httpSlide(countyId)
        })
        dispatch_group_async(group,queue,{
            //发送促销图片请求
            self.httpPromotionImg()
        })
        dispatch_group_async(group,queue,{
            //发送分类请求
            self.httpClassify()
        })
        dispatch_group_async(group,queue,{
            //发送新品请求
            self.httpNewProduct(countyId,storeId:storeId)
        })
        dispatch_group_async(group,queue,{
            //发送热门商品请求
            self.httpHotGood(countyId, storeId:storeId)
        })
        dispatch_group_async(group,queue,{
            //发送公告栏请求
            self.httpAdMessgInfo(substationId)
        })
        //任务完成执行
        dispatch_group_notify(group, queue,{
            log.info("网络请求执行完毕")
        });
        
        self.updateViewFlag=false
        
        
    }
    /**
     发送促销图片请求
     */
    func httpPromotionImg(){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.mobileAdvertisingPromotion(), successClosure: { (result) -> Void in
            let json=JSON(result)
            let advertisingURL=json["advertisingURL"].stringValue
            self.promotionImageView!.sd_setImageWithURL(NSURL(string:URLIMG+advertisingURL), placeholderImage:UIImage(named: "def_promotion"))
            }) { (errorMsg) -> Void in
                SVProgressHUD.showErrorWithStatus(errorMsg)
        }
    }
    /**
     发送公告栏请求
     
     - parameter substationId: 分站id
     */
    func httpAdMessgInfo(substationId:String){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryAdMessgInfo(substationId:substationId), successClosure: { (result) -> Void in
            let json=JSON(result)
            self.adMessgInfoEntity=Mapper<AdMessgInfoEntity>().map(json.object)
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
    func httpHotGood(countyId:String,storeId:String){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryGoodsForAndroidIndexForStore(countyId: countyId, isDisplayFlag: 2, storeId: storeId), successClosure: { (result) -> Void in
            let json=JSON(result)
            for(_,value) in json{
                let entity=Mapper<GoodDetailEntity>().map(value.object)
                self.hotGoodArr.addObject(entity!)
                
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
            self.hotGoodCollectionView!.frame=CGRectMake(10,CGRectGetMaxY(self.newProductBorderView!.frame)+40,boundsWidth-20,hotGoodCollectionViewY)
            //重新计算可滑动容器的可滑动size
            self.scrollView!.contentSize=CGSizeMake(boundsWidth,CGRectGetMaxY(self.hotGoodCollectionView!.frame))
            //在热门商品加载完成后结束刷新
            self.scrollView!.headerEndRefreshing()
            }) { (errorMsg) -> Void in
                SVProgressHUD.showErrorWithStatus(errorMsg)
        }
    }
    /**
     发送新品推荐请求
     
     - parameter countyId: 县区id
     - parameter storeId:  这里storeId
     */
    func httpNewProduct(countyId:String,storeId:String){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryGoodsForAndroidIndexForStoreNew(countyId: countyId, storeId: storeId, isDisplayFlag: 2, currentPage: 1, pageSize:18, order:""), successClosure: { (result) -> Void in
            let json=JSON(result)
            for(_,value) in json{
                let entity=Mapper<GoodDetailEntity>().map(value.object)
                self.newProductArr.addObject(entity!)
                
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
                SVProgressHUD.showErrorWithStatus(errorMsg)
        }
    }
    /**
     发送分类请求
     */
    func httpClassify(){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryOneCategory(isDisplayFlag: 2), successClosure: { (result) -> Void in
            let json=JSON(result)
            for(_,value) in json{
                let entity=Mapper<GoodsCategoryEntity>().map(value.object)
                self.classifyArr.addObject(entity!)
            }
            //数据加载完成分类
            self.classifyCollectionView?.reloadData()
            }) { (errorMsg) -> Void in
                SVProgressHUD.showErrorWithStatus(errorMsg)
        }
    }
    /**
     发送幻灯片请求
     
     - parameter countyId:县区id
     */
    func httpSlide(countyId:String){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.mobileAdvertising(countyId: countyId), successClosure: { (result) -> Void in
            let json=JSON(result)
            for(_,value) in json{
                let entity=Mapper<AdvertisingEntity>().map(value.object)
                self.zwadImgArr.addObject(URLIMG+entity!.advertisingURL!)
            }
            self.netWorkBanner?.imageURLStringsGroup=self.zwadImgArr as [AnyObject]
            }) { (errorMsg) -> Void in
                SVProgressHUD.showErrorWithStatus(errorMsg)
        }
    }

}
// MARK: - 跳转页面
extension IndexViewController{
    /**
     跳转到促销区
     
     - parameter sender:UIButton
     */
    func pushPromotionView(sender:UIButton){
        let vc=GoodCategory3ViewController()
        vc.flag=4
        vc.hidesBottomBarWhenPushed=true
        self.navigationController!.pushViewController(vc, animated:true)
    }
    //实现导航控制器文本框的协议
    func textFieldDidBeginEditing(textField: UITextField) {
        //点击文本框不让键盘弹出来
        textField.resignFirstResponder()
        let vc=SearchViewController();
        vc.hidesBottomBarWhenPushed=true;
        self.navigationController?.pushViewController(vc, animated:true);
    }
}