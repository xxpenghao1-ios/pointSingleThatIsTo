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
import SwiftyJSON
/// 特价商品 价格
class GoodSpecialPriceUpriceViewController:AddShoppingCartAnimation,UITableViewDataSource,UITableViewDelegate,GoodSpecialPriceTableCellAddShoppingCartsDelegate {
    var flag:Int?
    
    /// 分类id 默认0
    var categoryId:Int?;
    
    /// 用于分页
    fileprivate var currentPage=0
    
    /// 数据源
    fileprivate var arr=NSMutableArray()
    
    
    fileprivate var cellArr=[GoodSpecialPriceTableCell]()
    
    /// table
    fileprivate var table:UITableView?
    
    /// 没有数据加载该视图
    fileprivate var nilView:UIView?
    
    
    ///保存cell entity
    fileprivate var goodDeatilEntity:GoodDetailEntity?
    
    /// 定时器
    fileprivate var timer:Timer?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        table?.headerBeginRefreshing()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="价格"
        self.view.backgroundColor=UIColor.white
        let countyId=UserDefaults.standard.object(forKey: "countyId") as! String
        let storeId=UserDefaults.standard.object(forKey: "storeId") as! String
        
        table=UITableView(frame:CGRect(x: 0,y: 0,width: boundsWidth,height: boundsHeight-64-40), style: UITableViewStyle.plain)
        table!.dataSource=self
        table!.delegate=self
        self.view.addSubview(table!)
        table!.rowHeight = UITableViewAutomaticDimension;
        // 设置tableView的估算高度
        table!.estimatedRowHeight = 120;
        //移除空单元格
        table!.tableFooterView = UIView(frame:CGRect.zero)
        //设置cell下边线全屏
        if(table!.responds(to: #selector(setter: UIView.layoutMargins))){
            table?.layoutMargins=UIEdgeInsets.zero
        }
        if(table!.responds(to: #selector(setter: UITableViewCell.separatorInset))){
            table?.separatorInset=UIEdgeInsets.zero;
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
        SVProgressHUD.show(withStatus: "数据加载中")
        table!.headerBeginRefreshing()
        //监听通知
        NotificationCenter.default.addObserver(self, selector:Selector(("updateGoodSpecialPriceView:")), name:NSNotification.Name(rawValue: "selectedCategory"), object:nil)
        
    }
    
    

    //返回tabview每一行显示什么
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell=tableView.dequeueReusableCell(withIdentifier: "GoodSpecialPriceTableCellId") as? GoodSpecialPriceTableCell
        if cell == nil{
            //加载xib
            cell=Bundle.main.loadNibNamed("GoodSpecialPriceTableCell", owner:self, options: nil)?.last as? GoodSpecialPriceTableCell
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arr.count
    }
//    //返回tabview的高度
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
//        let entity=arr[indexPath.row] as! GoodDetailEntity
//        
//        if entity.isPromotionFlag == 1{//如果是促销动态计算高度
//            let cell=cellArr[indexPath.row]
//            cell.updateCell(entity,flag:flag!)
//            cell.setNeedsUpdateConstraints()
//            cell.updateConstraintsIfNeeded()
//            let height=cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
//            return height
//        }else{
//            return 120;
//        }
//    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeTimer()
    }
    deinit{
        NotificationCenter.default.removeObserver(self)
    }

}
// MARK: - 页面逻辑
extension GoodSpecialPriceUpriceViewController{
    
    /**
     更新特价view
     
     - parameter obj:NSNotification
     */
    func updateGoodSpecialPriceView(_ obj:Notification){
        categoryId=obj.object as? Int
        let countyId=UserDefaults.standard.object(forKey: "countyId") as! String
        let storeId=UserDefaults.standard.object(forKey: "storeId") as! String
        //加载视图
        SVProgressHUD.show(withStatus: "数据加载中")
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
    func pushChoppingView(_ sender:UIButton){
        let vc=ShoppingCarViewContorller()
        vc.hidesBottomBarWhenPushed=true
        self.navigationController!.pushViewController(vc, animated:true)
    }
    /**
     加入购物车
     
     - parameter entity:商品entity
     */
    func addCar(_ entity: GoodDetailEntity) {
        //拿到会员id
        let memberId=UserDefaults.standard.object(forKey: "memberId") as! String
        let storeId=userDefaults.object(forKey: "storeId") as! String
        var promotionNumber:Int?=nil
        if flag == 3{//如果是促销
            promotionNumber=entity.promotionNumber
        }
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.insertShoppingCar(memberId: memberId, goodId: entity.goodsbasicinfoId!, supplierId: entity.supplierId!, subSupplierId: entity.subSupplier!, goodsCount:entity.miniCount!,flag:flag!, goodsStock:entity.goodsStock!,storeId:storeId,promotionNumber: promotionNumber), successClosure: { (result) -> Void in
            let json=JSON(result)
            let success=json["success"].stringValue
            if success == "success"{
                SVProgressHUD.showSuccess(withStatus:"成功加入购物车")
            }else if success == "tjxgbz"{
                SVProgressHUD.showInfo(withStatus: "已超过该商品限购数")
            }else if success == "tjbz"{
                SVProgressHUD.showInfo(withStatus: "已超过该商品库存数")
            }else if success == "zcbz"{
                SVProgressHUD.showInfo(withStatus: "已超过该商品库存数")
            }else if success == "grxgbz"{
                SVProgressHUD.showInfo(withStatus: "个人限购不足")
            }else if success == "xgysq"{
                SVProgressHUD.showInfo(withStatus: "促销限购已售罄")
            }else{
                SVProgressHUD.showError(withStatus: "加入失败")
            }
            
            }) { (errorMsg) -> Void in
                SVProgressHUD.showError(withStatus: errorMsg)
        }
    }
    /**
     跳转到特价商品详情
     
     - parameter entity: 商品entity
     */
    func pushGoodSpecialPriceDetail(_ entity: GoodDetailEntity) {
        let vc=GoodSpecialPriceDetailViewController()
        vc.hidesBottomBarWhenPushed=true
        vc.goodEntity=entity
        vc.flag=flag
        vc.storeId=UserDefaults.standard.object(forKey: "storeId") as? String
        self.navigationController!.pushViewController(vc, animated:true)
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
    func httpSpecialPrice(_ categoryId:Int,countyId:String,storeId:String,currentPage:Int,isRefresh:Bool){
        var count=0
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryPreferentialAndGoods4Store(countyId: countyId, categoryId: categoryId, storeId: storeId, pageSize: 10, currentPage: currentPage, order: "price"), successClosure: { (result) -> Void in
            let json=JSON(result)
            if isRefresh{//如果是重新请求数据 先删除原来数据
                self.arr.removeAllObjects()
            }
            for(_,value) in json{
                count+=1
                let entity=Mapper<GoodDetailEntity>().map(JSONObject:value.object)
                //如果库存为空
                if entity!.goodsStock == nil{
                    entity!.goodsStock = -1
                }
                if entity!.endTime == nil{
                    entity!.endTime="0"
                }else{
                    entity!.endTime=entity!.endTime!.components(separatedBy:".")[0]
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
                self.arr.add(entity!)
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
                SVProgressHUD.showError(withStatus: errorMsg)
        }
    }
    /**
     查询促销商品
     
     - parameter currentPage: 展示到第几页
     - parameter isRefresh:   是否刷新true是
     */
    func httpQueryStorePromotionGoodsList(_ currentPage:Int,isRefresh:Bool,order:String,storeId:String){
        /// 定义一个int类型的值 用于判断是否还有数据加载
        var count=0
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryStorePromotionGoodsList(storeId:storeId, order:order, pageSize:7, currentPage: currentPage), successClosure: { (result) -> Void in
            let json=JSON(result)
            if isRefresh{//如果是刷新先删除数据
                self.arr.removeAllObjects()
            }
            for(_,value) in json{
                // 每次循环加1
                count+=1
                let entity=Mapper<GoodDetailEntity>().map(JSONObject:value.object)
                //如果销量为空
                if entity!.salesCount == nil{
                    entity!.salesCount=0
                }
                
                if entity!.promotionEndTime == nil{
                    entity!.promotionEndTime="0"
                }
                //如果促销商品还可以购买的数量 不等于空设为库存数
                if entity!.promotionEachCount != nil{
                    entity!.goodsStock = entity!.promotionEachCount
                }else{
                    entity!.goodsStock = -1
                }
                if entity!.promotionStoreEachCount != nil{
                    entity!.eachCount=entity!.promotionStoreEachCount
                }
                //如果最低起送量为空
                if entity!.miniCount == nil{
                    entity!.miniCount=1
                }
                //如果商品加减数量为空
                if entity!.goodsBaseCount == nil{
                    entity!.goodsBaseCount=1
                }
                self.arr.add(entity!)
            }
            if count < 7{//判断count是否小于10  如果小于表示没有可以加载了 隐藏加载状态
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
                SVProgressHUD.showError(withStatus: errorMsg)
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
            timer=Timer(timeInterval:1, target:self, selector:Selector("timerEvent"), userInfo:nil, repeats:true)
            //避免tableView滑动的时候卡死
            RunLoop.current.add(timer!,forMode:RunLoopMode.commonModes)
        }
    }
    /**
     定时器每次执行
     */
    func timerEvent(){
        for j in 0...arr.count{//获取数据源所有剩余时间
            let entity=arr[j] as! GoodDetailEntity
            var time=0
            if flag == 1{
                time=Int(entity.endTime!)!
            }else{
                time=Int(entity.promotionEndTime!)!
            }
            //每次-1
            time-=1
            if flag == 1{
                //从新赋值保证所有的剩余时间都更新
                entity.endTime="\(time)"
            }else{
                //从新赋值保证所有的剩余时间都更新
                entity.promotionEndTime="\(time)"
            }
            //从新保存到指定位置
            arr.removeObject(at: j)
            arr.insert(entity, at:j)
        }
        //获取屏幕内可见的cell
        let cells=table!.visibleCells
        for i in 0...cells.count{
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
                    cell.img=UIImageView(frame:CGRect(x: boundsWidth-70,y: 30,width: 60,height: 60))
                    cell.img!.image=UIImage(named: "to_sell_end")
                    cell.contentView.addSubview(cell.img!)
                    //禁止进入商品详情
                    cell.goodImgView.isUserInteractionEnabled=false
                }
                cell.lblTime.isHidden=false
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
