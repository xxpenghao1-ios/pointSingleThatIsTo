//
//  GoodSpecialPriceUpriceViewController.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/2/23.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import SVProgressHUD
/// 特价商品 价格
class GoodSpecialPriceUpriceViewController:AddShoppingCartAnimation,UITableViewDataSource,UITableViewDelegate,GoodSpecialPriceTableCellAddShoppingCartsDelegate {
    var flag:Int?
    
    /// 分类id 默认0
    var categoryId:Int?;
    
    /// 用于分页
    private var currentPage=0
    
    /// 数据源
    private var arr=NSMutableArray()
    
    /// table
    private var table:UITableView?
    
    /// 没有数据加载该视图
    private var nilView:UIView?
    
    
    ///保存cell entity
    private var goodDeatilEntity:GoodDetailEntity?
    
    /// 定时器
    private var timer:NSTimer?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        table?.headerBeginRefreshing()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="价格"
        self.view.backgroundColor=UIColor.whiteColor()
        let countyId=NSUserDefaults.standardUserDefaults().objectForKey("countyId") as! String
        let storeId=NSUserDefaults.standardUserDefaults().objectForKey("storeId") as! String
        
        table=UITableView(frame:CGRectMake(0,0,boundsWidth,boundsHeight-64-40), style: UITableViewStyle.Plain)
        table!.dataSource=self
        table!.delegate=self
        self.view.addSubview(table!)
        //移除空单元格
        table!.tableFooterView = UIView(frame:CGRectZero)
        //设置cell下边线全屏
        if(table!.respondsToSelector("setLayoutMargins:")){
            table?.layoutMargins=UIEdgeInsetsZero
        }
        if(table!.respondsToSelector("setSeparatorInset:")){
            table?.separatorInset=UIEdgeInsetsZero;
        }
        table!.addHeaderWithCallback({//刷新
            //从第一页开始
            self.currentPage=1
            if self.flag == 1{
                //发送网络请求
                self.httpSpecialPrice(self.categoryId!, countyId:countyId, storeId:storeId, currentPage:self.currentPage,isRefresh: true)
            }else{
                self.httpQueryStorePromotionGoodsList(self.currentPage, isRefresh:true, order:"price", storeId:storeId)
            }
            
        })
        table!.addFooterWithCallback({//加载更多
            //每次页面索引加1
            self.currentPage+=1
            if self.flag == 1{
                //发送网络请求
                self.httpSpecialPrice(self.categoryId!, countyId:countyId, storeId:storeId, currentPage:self.currentPage,isRefresh: false)
            }else{
                self.httpQueryStorePromotionGoodsList(self.currentPage, isRefresh:false, order:"price", storeId:storeId)
            }
        })
        //加载视图
        SVProgressHUD.showWithStatus("数据加载中")
        table!.headerBeginRefreshing()
        //监听通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"updateGoodSpecialPriceView:", name:"selectedCategory", object:nil)
        
    }
    
    

    //返回tabview每一行显示什么
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell=tableView.dequeueReusableCellWithIdentifier("GoodSpecialPriceTableCellId") as? GoodSpecialPriceTableCell
        if cell == nil{
            //加载xib
            cell=NSBundle.mainBundle().loadNibNamed("GoodSpecialPriceTableCell", owner:self, options: nil).last as? GoodSpecialPriceTableCell
        }
        //设置cell下边线全屏
        if(cell!.respondsToSelector("setLayoutMargins:")){
            cell?.layoutMargins=UIEdgeInsetsZero
        }
        if(cell!.respondsToSelector("setSeparatorInset:")){
            cell?.separatorInset=UIEdgeInsetsZero;
        }
        if arr.count > 0{//进行判断  防止没有数据 程序崩溃
            let entity=arr[indexPath.row] as! GoodDetailEntity
            //关联协议
            cell!.delegate=self
            //拿到每行对应索引
            cell!.indexPath=indexPath
            cell!.updateCell(entity,flag:flag!)
        }
        return cell!
        
    }
    
    //返回tabview的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arr.count
    }
    //返回tabview的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 120;
    }
    //tableview开始载入的动画
    func tableView(tableView: UITableView, willDisplayCell cell:UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath){
        
        //设置cell的显示动画为3D缩放
        
        //xy方向缩放的初始值为0.1
        
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        
        //设置动画时间为0.25秒,xy方向缩放的最终值为1
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
            
        })
        
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        removeTimer()
    }
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}
// MARK: - 页面逻辑
extension GoodSpecialPriceUpriceViewController{
    
    /**
     更新特价view
     
     - parameter obj:NSNotification
     */
    func updateGoodSpecialPriceView(obj:NSNotification){
        categoryId=obj.object as? Int
        let countyId=NSUserDefaults.standardUserDefaults().objectForKey("countyId") as! String
        let storeId=NSUserDefaults.standardUserDefaults().objectForKey("storeId") as! String
        //加载视图
        SVProgressHUD.showWithStatus("数据加载中")
        //默认从第1页开始
        currentPage=1
        //发送网络请求
        httpSpecialPrice(categoryId!, countyId:countyId, storeId:storeId, currentPage:currentPage,isRefresh: true)
        
    }

}
// MARK: - 跳转页面
extension GoodSpecialPriceUpriceViewController{
    /**
     跳转到购物车
     
     - parameter sender:UIButton
     */
    func pushChoppingView(sender:UIButton){
        let vc=ShoppingCarViewContorller()
        vc.hidesBottomBarWhenPushed=true
        self.navigationController!.pushViewController(vc, animated:true)
    }
    /**
     跳转到特价商品详情
     
     - parameter entity: 商品entity
     */
    func pushGoodSpecialPriceDetail(entity: GoodDetailEntity) {
        if flag == 1{
            let vc=GoodSpecialPriceDetailViewController()
            vc.hidesBottomBarWhenPushed=true
            vc.goodEntity=entity
            vc.storeId=NSUserDefaults.standardUserDefaults().objectForKey("storeId") as? String
            self.navigationController!.pushViewController(vc, animated:true)
        }else{
            let vc=GoodDetailViewController()
            vc.hidesBottomBarWhenPushed=true
            vc.goodEntity=entity
            vc.storeId=NSUserDefaults.standardUserDefaults().objectForKey("storeId") as? String
            self.navigationController!.pushViewController(vc, animated:true)
        }

    }

}
// MARK: - 网络请求
extension GoodSpecialPriceUpriceViewController{
    /**
     发送网络请求
     
     - parameter categoryId:  分类id
     - parameter countyId:    县区id
     - parameter storeId:     店铺id
     - parameter currentPage: 展示的页数
     - parameter isRefresh:   是否是刷新true
     */
    func httpSpecialPrice(categoryId:Int,countyId:String,storeId:String,currentPage:Int,isRefresh:Bool){
        var count=0
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryPreferentialAndGoods4Store(countyId: countyId, categoryId: categoryId, storeId: storeId, pageSize: 10, currentPage: currentPage, order: "price"), successClosure: { (result) -> Void in
            let json=JSON(result)
            if isRefresh{//如果是重新请求数据 先删除原来数据
                self.arr.removeAllObjects()
            }
            for(_,value) in json{
                count++
                let entity=Mapper<GoodDetailEntity>().map(value.object)
                //如果库存为空
                if entity!.goodsStock == nil{
                    entity!.goodsStock = -1
                }
                if entity!.endTime == nil{
                    entity!.endTime="0"
                }else{
                    entity!.endTime=entity!.endTime!.componentsSeparatedByString(".")[0]
                }
                //如果最低起送量为空
                if entity!.miniCount == nil{
                    entity!.miniCount=1
                }
                //如果商品加减数量为空
                if entity!.goodsBaseCount == nil{
                    entity!.goodsBaseCount=1
                }
                if entity!.salesCount == nil{
                    entity!.salesCount=0
                }
                entity!.flag=1
                entity!.goodsbasicinfoId=value["goodsId"].intValue
                self.arr.addObject(entity!)
            }
            if count < 10{//判断count是否小于10  如果小于表示没有可以加载了 隐藏加载状态
                self.table?.setFooterHidden(true)
            }else{//否则显示
                self.table?.setFooterHidden(false)
            }
            if self.arr.count < 1{//表示没有数据加载空
                self.nilView?.removeFromSuperview()
                self.nilView=nilPromptView("目前还没有特价商品...")
                self.nilView!.center=self.table!.center
                self.view.addSubview(self.nilView!)
                
            }else{//如果有数据清除
                self.nilView?.removeFromSuperview()
                self.createTimer()
            }
            //关闭刷新状态
            self.table?.headerEndRefreshing()
            //关闭加载状态
            self.table?.footerEndRefreshing()
            //关闭加载等待视图
            SVProgressHUD.dismiss()
            //刷新table
            self.table?.reloadData()

            }) { (errorMsg) -> Void in
                //关闭刷新状态
                self.table?.headerEndRefreshing()
                //关闭加载状态
                self.table?.footerEndRefreshing()
                //关闭加载等待视图
                SVProgressHUD.showErrorWithStatus(errorMsg)
        }
    }
    /**
     查询促销商品
     
     - parameter currentPage: 展示到第几页
     - parameter isRefresh:   是否刷新true是
     */
    func httpQueryStorePromotionGoodsList(currentPage:Int,isRefresh:Bool,order:String,storeId:String){
        /// 定义一个int类型的值 用于判断是否还有数据加载
        var count=0
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryStorePromotionGoodsList(storeId:storeId, order:order, pageSize: 10, currentPage: currentPage), successClosure: { (result) -> Void in
            let json=JSON(result)
            if isRefresh{//如果是刷新先删除数据
                self.arr.removeAllObjects()
            }
            for(_,value) in json{
                // 每次循环加1
                count++
                let entity=Mapper<GoodDetailEntity>().map(value.object)
                //如果销量为空
                if entity!.salesCount == nil{
                    entity!.salesCount=0
                }
                
                if entity!.promotionEndTime == nil{
                    entity!.promotionEndTime="0"
                }
                //如果库存为空
                if entity!.goodsStock == nil{
                    entity!.goodsStock = -1
                }
                //如果最低起送量为空
                if entity!.miniCount == nil{
                    entity!.miniCount=1
                }
                //如果商品加减数量为空
                if entity!.goodsBaseCount == nil{
                    entity!.goodsBaseCount=1
                }
                
                self.arr.addObject(entity!)
            }
            if count < 10{//判断count是否小于10  如果小于表示没有可以加载了 隐藏加载状态
                self.table!.setFooterHidden(true)
            }else{//否则显示
                self.table!.setFooterHidden(false)
            }
            if self.arr.count < 1{//表示没有数据加载空
                self.nilView?.removeFromSuperview()
                self.nilView=nilPromptView("还没有促销商品哦...")
                self.nilView!.center=self.table!.center
                self.view.addSubview(self.nilView!)
                
            }else{//如果有数据清除
                self.nilView?.removeFromSuperview()
                //加载定时器
                self.createTimer()
            }
            //关闭刷新状态
            self.table!.headerEndRefreshing()
            //关闭加载状态
            self.table!.footerEndRefreshing()
            //关闭加载等待视图
            SVProgressHUD.dismiss()
            //刷新table
            self.table!.reloadData()
            }) { (errorMsg) -> Void in
                //关闭刷新状态
                self.table!.headerEndRefreshing()
                //关闭加载状态
                self.table!.footerEndRefreshing()
                //关闭加载等待视图
                SVProgressHUD.showErrorWithStatus(errorMsg)
        }
    }

}
// MARK: - 倒计时
extension GoodSpecialPriceUpriceViewController{
    /**
     创建定时器
     */
    func createTimer(){
        if timer == nil{
            timer=NSTimer(timeInterval:1, target:self, selector:"timerEvent", userInfo:nil, repeats:true)
            //避免tableView滑动的时候卡死
            NSRunLoop.currentRunLoop().addTimer(timer!,forMode:NSRunLoopCommonModes)
        }
    }
    /**
     定时器每次执行
     */
    func timerEvent(){
        for(var j=0;j<arr.count;j++){//获取数据源所有剩余时间
            let entity=arr[j] as! GoodDetailEntity
            var time=0
            if flag == 1{
                time=Int(entity.endTime!)!
            }else{
                time=Int(entity.promotionEndTime!)!
            }
            //每次-1
            --time
            if flag == 1{
                //从新赋值保证所有的剩余时间都更新
                entity.endTime="\(time)"
            }else{
                //从新赋值保证所有的剩余时间都更新
                entity.promotionEndTime="\(time)"
            }
            //从新保存到指定位置
            arr.removeObjectAtIndex(j)
            arr.insertObject(entity, atIndex:j)
        }
        //获取屏幕内可见的cell
        let cells=table!.visibleCells
        for(var i=0;i<cells.count;i++){
            let cell=cells[i] as! GoodSpecialPriceTableCell
            let entity=arr[cell.indexPath!.row] as! GoodDetailEntity
            var time=0
            if flag == 1{
                time=Int(entity.endTime!)!
            }else{
                time=Int(entity.promotionEndTime!)!
            }
            if entity.goodsStock != 0{
                if time <= 0{//如果剩余时间小于等于0 表示活动已经结束
                    cell.img?.removeFromSuperview()
                    /// 展示活动已结束
                    cell.img=UIImageView(frame:CGRectMake(boundsWidth-70,30,60,60))
                    cell.img!.image=UIImage(named: "to_sell_end")
                    cell.contentView.addSubview(cell.img!)
                    //禁止进入商品详情
                    cell.goodImgView.userInteractionEnabled=false
                }else{
                    cell.goodImgView.userInteractionEnabled=true
                }
                cell.lblTime.hidden=false
            }
            cell.lblTime.text=lessSecondToDay(time)
        }
        
    }
    /**
     关闭定时器
     */
    func removeTimer(){
        timer?.invalidate()
        timer=nil
    }
}