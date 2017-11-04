//
//  GoodCategory3ViewController.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/1/27.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import SVProgressHUD
import Alamofire
import SwiftyJSON
/// 商品3级分类(搜索条件) 3级分类传入flag=2,titleCategoryName,goodsCategoryId,搜索传入flag=1,searchName,goodsCategoryId 促销传入flag=4  5查询1元区商品
class  GoodCategory3ViewController:AddShoppingCartAnimation{
    
    /// 接收传入的状态 1表示搜索 2表示查询3级分类 3表示查询新品推荐 4表示促销 5查询1元区商品 6查询配送商商城
    var flag:Int?
    
    /// 接收传入搜索名称
    var searchName:String?
    
    /// 接收传过来的分类名称
    var titleCategoryName:String?
    
    /// 接收分类id
    var goodsCategoryId:Int?
    
    //接收配送商id
    var subSupplierId:Int?
    
    //接收配送商名称
    var subSupplierName:String?
    
//    /// 销量
//    var salesVC=SalesViewController()
//    
//    /// 价格
//    var priceVC=PriceViewController()
//    
//    /// 按字母排序
//    var letterVC=LetterViewController()
    
    fileprivate var table:UITableView!
    
    fileprivate var goodArr=NSMutableArray()
    
    /// 默认从第0页开始
    fileprivate var currentPage=0
    
    /// 没有数据加载该视图
    fileprivate var nilView:UIView?
    
    /// 查询购物车按钮
    fileprivate var selectShoppingCar:UIButton?
    
    /// 购物车按钮提示数量
    fileprivate var badgeCount=0
    
    /// 保存每一行的cell Entity
    fileprivate var cellGoodEntity:GoodDetailEntity?
    
    fileprivate let countyId=userDefaults.object(forKey: "countyId") as? String
    fileprivate let storeId=userDefaults.object(forKey: "storeId") as? String
    /// 索引组
    fileprivate var  indexSet=["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    /// 保存字母用于下拉加载
    fileprivate var seachLetter:String?
    //count 按销量查询 price按价格查询 letter根据字母排序升序； a-z  seachLetter根据字母搜索
    //默认销量查询
    fileprivate var order="count"
    //1从低到高 2从高到低
    fileprivate var tag=2
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //每次进入页面清零
        badgeCount=0
        self.selectShoppingCar!.badgeValue="\(badgeCount)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.white
        if flag == 1{
            self.title=searchName
        }else if flag == 2{
            self.title=titleCategoryName
        }else if flag == 3{
            self.title="新品推荐"
        }else if flag == 4{
            self.title="促销商品"
        }else if flag == 5{
            self.title="1元区"
        }else if flag == 6{
            self.title=subSupplierName
        }
        //加载查询购物车按钮
        buildView()
    }
    /**
     构建查看购物车按钮
     */
    func buildView(){
        let menu=DOPDropDownMenu(origin:CGPoint(x: 0,y: 64),andHeight:40)
        menu!.dataSource=self
        menu!.delegate=self
        self.view.addSubview(menu!)
        table=UITableView(frame:CGRect(x: 0,y: 104,width: boundsWidth,height: boundsHeight-64-40))
        table.dataSource=self
        table.delegate=self
        table.addHeaderWithCallback({//刷新
            //从第一页开始
            self.currentPage=1
            if self.flag == 1{//执行搜索请求
                //从新请求数据
                self.httpSearchGoodList(self.currentPage,isRefresh:true,order:self.order,tag:self.tag)
            }else if self.flag == 2{//查询3级分类
                self.httpSelectGoodCategoryList(self.currentPage,isRefresh:true,tag:self.tag,order:self.order)
            }else if self.flag == 3{//查询新品推荐
                self.httpNewGoodList(self.currentPage,isRefresh:true,order:self.order)
            }else if self.flag == 4{//查询促销商品
                self.httpQueryStorePromotionGoodsList(self.currentPage, isRefresh:true,order:self.order)
            }else if self.flag == 5{//查询1元区
                self.http1YuanArea(self.currentPage, isRefresh:true,order:self.order)
            }else if self.flag == 6{//查询配送商 商品
                self.queryShoppingCarMoreGoodsForSubSupplier(self.currentPage, isRefresh:true, order:self.order, tag:self.tag)
            }
            
        })
        table.addFooterWithCallback({//加载更多
            //每次页面索引加1
            self.currentPage+=1
            if self.flag == 1{//执行搜索请求
                //从新请求数据
                self.httpSearchGoodList(self.currentPage,isRefresh:false,order:self.order,tag:self.tag)
            }else if self.flag == 2{//查询3级分类
                self.httpSelectGoodCategoryList(self.currentPage,isRefresh:false,tag:self.tag,order:self.order)
            }else if self.flag == 3{//查询新品推荐
                self.httpNewGoodList(self.currentPage,isRefresh:false,order:self.order)
            }else if self.flag == 4{//查询促销商品
                self.httpQueryStorePromotionGoodsList(self.currentPage, isRefresh:false,order:self.order)
            }else if self.flag == 5{//查询1元区
                self.http1YuanArea(self.currentPage, isRefresh:false,order:self.order)
            }else if self.flag == 6{//查询配送商 商品
                self.queryShoppingCarMoreGoodsForSubSupplier(self.currentPage, isRefresh:false, order:self.order, tag:self.tag)
            }
        })
        self.view.addSubview(table)
        //移除空单元格
        table.tableFooterView = UIView(frame:CGRect.zero)
        //加载菊花图
        SVProgressHUD.show(withStatus: "数据加载中")
        //开始加载页面
        table.headerBeginRefreshing()
        //查看购物车按钮
        selectShoppingCar=UIButton(frame:CGRect(x: boundsWidth-75,y: boundsHeight-70,width: 60,height: 60));
        let shoppingCarImg=UIImage(named: "char1");
        selectShoppingCar!.addTarget(self, action:Selector("pushChoppingView:"), for:UIControlEvents.touchUpInside);
        self.selectShoppingCar?.badgeValue="\(self.badgeCount)"
        //默认隐藏按钮
        selectShoppingCar!.isHidden=true;
        selectShoppingCar!.setBackgroundImage(shoppingCarImg, for:UIControlState());
        self.view.addSubview(selectShoppingCar!)
    }

}
// MARK: - table协议
extension GoodCategory3ViewController:UITableViewDelegate,UITableViewDataSource,GoodCategory3TableViewCellAddShoppingCartsDelegate{
    //返回tabview每一行显示什么
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell=tableView.dequeueReusableCell(withIdentifier: "GoodCategory3TableViewCellId") as? GoodCategory3TableViewCell
        if cell == nil{
            //加载xib
            cell=Bundle.main.loadNibNamed("GoodCategory3TableViewCell", owner:self, options: nil)?.last as? GoodCategory3TableViewCell
        }
        cell!.layoutMargins=UIEdgeInsets.zero
        cell!.separatorInset=UIEdgeInsets.zero;
        if goodArr.count > 0{//进行判断  防止没有数据 程序崩溃
            let entity=goodArr[indexPath.row] as! GoodDetailEntity
            //关联协议
            cell!.delegate=self
            //拿到每行对应索引
            cell!.indexPath=indexPath
            cell!.updateCell(entity)
        }
        return cell!
        
    }
    
    //返回tabview的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return goodArr.count
    }
    //返回tabview的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 120;
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if flag == 2 {//当是3级分类查询的时候显示右侧字母
            if self.goodArr.count > 0{
                return indexSet
            }
        }
        return nil
    }
    //字母点击
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        //加载等待视图
        SVProgressHUD.show(withStatus: "数据加载中")
        seachLetter=title
        self.goodArr.removeAllObjects()
        self.currentPage=1
        httpSelectLetterGoodCategoryList(self.currentPage, seachLetterValue:title)
        return 0
    }

}
// MARK: - 页面逻辑
extension GoodCategory3ViewController{
    /**
     加入购物车
     
     - parameter imgView:   图片
     - parameter indexPath: table行
     */
    func goodCategory3TableViewCellAddShoppingCarts(_ imgView: UIImageView,indexPath:IndexPath,count:Int) {
        //拿到会员id
        let memberId=UserDefaults.standard.object(forKey: "memberId") as! String
        let storeId=userDefaults.object(forKey: "storeId") as! String
        //拿到对应的entity
        let entity=goodArr[indexPath.row] as! GoodDetailEntity
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.insertShoppingCar(memberId: memberId, goodId: entity.goodsbasicinfoId!, supplierId: entity.supplierId!, subSupplierId: entity.subSupplier!, goodsCount: count, flag: 2, goodsStock: entity.goodsStock!,storeId:storeId,promotionNumber:nil), successClosure: { (result) -> Void in
            let json=JSON(result)
            let success=json["success"].stringValue
            if success == "success"{
                //执行加入购车动画效果
                self.shoppingCharAnimation(indexPath,imgView:imgView, count:count)
            }else if success == "tjxgbz"{
                SVProgressHUD.showInfo(withStatus: "已超过该商品限购数")
            }else if success == "tjbz"{
                SVProgressHUD.showInfo(withStatus: "已超过该商品库存数")
            }else if success == "zcbz"{
                SVProgressHUD.showInfo(withStatus: "已超过该商品库存数")
            }else if success == "xgysq"{
                SVProgressHUD.showInfo(withStatus: "个人限购不足")
            }else if success == "grxgbz"{
                SVProgressHUD.showInfo(withStatus: "促销限购已售罄")
            }else{
                SVProgressHUD.showError(withStatus: "加入失败")
            }
            }) { (errorMsg) -> Void in
                SVProgressHUD.showError(withStatus: errorMsg)
        }
    }
    //执行购物车动画效果
    func shoppingCharAnimation(_ indexPath:IndexPath,imgView:UIImageView,count:Int){
        /// 当前行的位置
        var rect=table.rectForRow(at: indexPath)
        /// 重新设置y的位置(y-table距离顶部的frame偏移量)
        rect.origin.y=rect.origin.y-self.table.contentOffset.y
        /// 拿到图片的位置
        var headRect=imgView.frame
        headRect.origin.y=rect.origin.y+headRect.origin.y
        self.tableView=self.table
        self.button=self.selectShoppingCar
        self.startAnimationWithRect(headRect, imageView:imgView,isGoodDetail:2);
        //每次加
        self.badgeCount+=count
        //显示添加过的值
        self.selectShoppingCar!.badgeValue="\(self.badgeCount)"
        //发送通知更新角标
        NotificationCenter.default.post(name: Notification.Name(rawValue: "postBadgeValue"), object:2, userInfo:["carCount":count])
    }
    /**
     实现协议 选择购买数量
     
     - parameter inventory: 库存
     - parameter indexPath: 行索引
     */
    func purchaseCount(_ inventory: Int, indexPath: IndexPath) {
        //拿到对应的cell
        let cell=self.table.cellForRow(at: indexPath) as! GoodCategory3TableViewCell
        cellGoodEntity=cell.goodEntity
        let alertController = UIAlertController(title:nil, message:"输入您要购买的数量", preferredStyle: UIAlertControllerStyle.alert);
        alertController.addTextField {
            (textField: UITextField!) -> Void in
            textField.keyboardType=UIKeyboardType.numberPad
            if inventory == -1{//判断库存 等于-1 表示库存充足 由于UI大小最多显示3位数
                textField.placeholder = "请输入\(cell.goodEntity!.miniCount!)~999之间\(cell.goodEntity!.goodsBaseCount!)的倍数"
                textField.tag=999
            }else{
                textField.placeholder = "请输入\(cell.goodEntity!.miniCount!)~\(inventory)之间\(cell.goodEntity!.goodsBaseCount!)的倍数"
                textField.tag=inventory
            }
            NotificationCenter.default.addObserver(self, selector: Selector("alertTextFieldDidChange:"), name: NSNotification.Name.UITextFieldTextDidChange, object: textField)
        }
        //确定
        let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default,handler:{ Void in
            
            let text=(alertController.textFields?.first)! as UITextField
            cell.count=Int(text.text!)!
            cell.lblShoppingCartCount.text=text.text
        })
        //取消
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        okAction.isEnabled = false
        self.present(alertController, animated: true, completion: nil)
    }
    //检测输入框的字符是否大于库存数量 是解锁确定按钮
    func alertTextFieldDidChange(_ notification: Notification){
        let alertController = self.presentedViewController as! UIAlertController?
        if (alertController != nil) {
            let text = (alertController!.textFields?.first)! as UITextField
            let okAction = alertController!.actions.last! as UIAlertAction
            text.text=text.text ?? ""
            if text.text!.characters.count > 0{
                okAction.isEnabled = Int(text.text!)! % self.cellGoodEntity!.goodsBaseCount! == 0 && Int(text.text!)! <= text.tag && Int(text.text!)! >= self.cellGoodEntity!.miniCount!
            }else{
                okAction.isEnabled=false
            }
        }
    }
}
// MARK: - 页面跳转
extension GoodCategory3ViewController{
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
     跳转到商品详情页面
     
     - parameter entity: 商品entity
     */
    func pushGoodDetailView(_ entity: GoodDetailEntity) {
        let vc=GoodDetailViewController()
        vc.hidesBottomBarWhenPushed=true
        vc.goodEntity=entity
        vc.storeId=UserDefaults.standard.object(forKey: "storeId") as? String
        self.navigationController!.pushViewController(vc, animated:true)
    }
}
// MARK: - 网络请求
extension GoodCategory3ViewController{
    /**
     查询3级分类
     
     - parameter currentPage: 展示到第几页
     - parameter isRefresh:   是否刷新true是
     */
    func httpSelectGoodCategoryList(_ currentPage:Int,isRefresh:Bool,tag:Int,order:String){
        var count=0
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryGoodsInfoByCategoryForAndroidForStore(goodsCategoryId: goodsCategoryId!, countyId: countyId!, IPhonePenghao: 520, isDisplayFlag: 2, pageSize: 10, currentPage: currentPage, storeId: storeId!, order:order,tag:tag), successClosure: { (result) -> Void in
            let json=JSON(result)
            if isRefresh{//如果是刷新先删除数据
                self.goodArr.removeAllObjects()
            }
            for(_,value) in json{
                // 每次循环加1
                count+=1
                let entity=Mapper<GoodDetailEntity>().map(JSONObject:value.object)
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
                self.goodArr.add(entity!)
            }
            if count < 10{//判断count是否小于10  如果小于表示没有可以加载了 隐藏加载状态
                self.table.setFooterHidden(true)
            }else{//否则显示
                self.table.setFooterHidden(false)
            }
            if self.goodArr.count < 1{//表示没有数据加载空
                self.nilView?.removeFromSuperview()
                self.nilView=nilPromptView("商品正在上传中...")
                self.nilView!.center=self.table.center
                self.view.addSubview(self.nilView!)
                //隐藏跳转购物车按钮
                self.selectShoppingCar!.isHidden=true
                
            }else{//如果有数据清除
                self.nilView?.removeFromSuperview()
                //显示跳转购物车按钮
                self.selectShoppingCar!.isHidden=false
                
            }
            //关闭刷新状态
            self.table.headerEndRefreshing()
            //关闭加载状态
            self.table.footerEndRefreshing()
            //关闭加载等待视图
            SVProgressHUD.dismiss()
            //刷新table
            self.table.reloadData()
            }) { (errorMsg) -> Void in
                //关闭刷新状态
                self.table.headerEndRefreshing()
                //关闭加载状态
                self.table.footerEndRefreshing()
                
                SVProgressHUD.showError(withStatus: errorMsg)
        }
    }
    /**
     根据搜索条件查询商品数据
     
     - parameter currentPage:展示到第几页
     - parameter isRefresh:   是否刷新true是
     */
    func httpSearchGoodList(_ currentPage:Int,isRefresh:Bool,order:String,tag:Int){
        searchName=searchName ?? ""
        /// 定义一个int类型的值 用于判断是否还有数据加载
        var count=0
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.searchGoodsInterfaceForStore(searchCondition: searchName!, countyId:countyId!, IPhonePenghao: 520, isDisplayFlag: 2, pageSize: 10, currentPage: currentPage, storeId: storeId!, order:order,tag:tag,goodsCategoryId:goodsCategoryId), successClosure: { (result) -> Void in
            let json=JSON(result)
            if isRefresh{//如果是刷新先删除数据
                self.goodArr.removeAllObjects()
            }
            for(_,value) in json{
                // 每次循环加1
                count+=1
                let entity=Mapper<GoodDetailEntity>().map(JSONObject: value.object)
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
                self.goodArr.add(entity!)
            }
            if count < 10{//判断count是否小于10  如果小于表示没有可以加载了 隐藏加载状态
                self.table.setFooterHidden(true)
            }else{//否则显示
                self.table.setFooterHidden(false)
            }
            if self.goodArr.count < 1{//表示没有数据加载空
                self.nilView?.removeFromSuperview()
                self.nilView=nilPromptView("商品正在上传中...")
                self.nilView!.center=self.table.center
                self.view.addSubview(self.nilView!)
                //隐藏跳转购物车按钮
                self.selectShoppingCar!.isHidden=true
                
            }else{//如果有数据清除
                self.nilView?.removeFromSuperview()
                //显示跳转购物车按钮
                self.selectShoppingCar!.isHidden=false
                
            }
            //关闭刷新状态
            self.table.headerEndRefreshing()
            //关闭加载状态
            self.table.footerEndRefreshing()
            //关闭加载等待视图
            SVProgressHUD.dismiss()
            //刷新table
            self.table.reloadData()
            }) { (errorMsg) -> Void in
                //关闭刷新状态
                self.table.headerEndRefreshing()
                //关闭加载状态
                self.table.footerEndRefreshing()
                //关闭加载等待视图
                SVProgressHUD.showError(withStatus: errorMsg)
        }
    }
    /**
     发送查询新品推荐请求
     
     - parameter currentPage:展示到第几页
     - parameter isRefresh:   是否刷新true是
     */
    func httpNewGoodList(_ currentPage:Int,isRefresh:Bool,order:String){
        /// 定义一个int类型的值 用于判断是否还有数据加载
        var count=0
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryGoodsForAndroidIndexForStoreNew(countyId: countyId!, storeId: storeId!, isDisplayFlag: 2, currentPage: currentPage, pageSize:10, order:order), successClosure: { (result) -> Void in
            let json=JSON(result)
            if isRefresh{//如果是刷新先删除数据
                self.goodArr.removeAllObjects()
            }
            for(_,value) in json{
                // 每次循环加1
                count+=1
                let entity=Mapper<GoodDetailEntity>().map(JSONObject: value.object)
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
                entity!.isNewGoodFlag=1
                
                self.goodArr.add(entity!)
            }
            if count < 10{//判断count是否小于10  如果小于表示没有可以加载了 隐藏加载状态
                self.table.setFooterHidden(true)
            }else{//否则显示
                self.table.setFooterHidden(false)
            }
            if self.goodArr.count < 1{//表示没有数据加载空
                self.nilView?.removeFromSuperview()
                self.nilView=nilPromptView("还没有新品哦...")
                self.nilView!.center=self.table.center
                self.view.addSubview(self.nilView!)
                //隐藏跳转购物车按钮
                self.selectShoppingCar!.isHidden=true
                
            }else{//如果有数据清除
                self.nilView?.removeFromSuperview()
                //显示跳转购物车按钮
                self.selectShoppingCar!.isHidden=false
                
            }
            //关闭刷新状态
            self.table.headerEndRefreshing()
            //关闭加载状态
            self.table.footerEndRefreshing()
            //关闭加载等待视图
            SVProgressHUD.dismiss()
            //刷新table
            self.table.reloadData()
            }) { (errorMsg) -> Void in
                //关闭刷新状态
                self.table.headerEndRefreshing()
                //关闭加载状态
                self.table.footerEndRefreshing()
                //关闭加载等待视图
                SVProgressHUD.showError(withStatus: errorMsg)
        }
    }
    /**
     查询促销商品
     
     - parameter currentPage: 展示到第几页
     - parameter isRefresh:   是否刷新true是
     */
    func httpQueryStorePromotionGoodsList(_ currentPage:Int,isRefresh:Bool,order:String){
        /// 定义一个int类型的值 用于判断是否还有数据加载
        var count=0
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryStorePromotionGoodsList(storeId: storeId!, order:order, pageSize: 10, currentPage: currentPage), successClosure: { (result) -> Void in
            let json=JSON(result)
            if isRefresh{//如果是刷新先删除数据
                self.goodArr.removeAllObjects()
            }
            for(_,value) in json{
                // 每次循环加1
                count+=1
                let entity=Mapper<GoodDetailEntity>().map(JSONObject: value.object)
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
                
                self.goodArr.add(entity!)
            }
            if count < 10{//判断count是否小于10  如果小于表示没有可以加载了 隐藏加载状态
                self.table.setFooterHidden(true)
            }else{//否则显示
                self.table.setFooterHidden(false)
            }
            if self.goodArr.count < 1{//表示没有数据加载空
                self.nilView?.removeFromSuperview()
                self.nilView=nilPromptView("还没有促销商品哦...")
                self.nilView!.center=self.table.center
                self.view.addSubview(self.nilView!)
                //隐藏跳转购物车按钮
                self.selectShoppingCar!.isHidden=true
                
            }else{//如果有数据清除
                self.nilView?.removeFromSuperview()
                //显示跳转购物车按钮
                self.selectShoppingCar!.isHidden=false
                
            }
            //关闭刷新状态
            self.table.headerEndRefreshing()
            //关闭加载状态
            self.table.footerEndRefreshing()
            //关闭加载等待视图
            SVProgressHUD.dismiss()
            //刷新table
            self.table.reloadData()
            }) { (errorMsg) -> Void in
                //关闭刷新状态
                self.table.headerEndRefreshing()
                //关闭加载状态
                self.table.footerEndRefreshing()
                //关闭加载等待视图
                SVProgressHUD.showError(withStatus: errorMsg)
        }
    }
    /**
     按字母查询商品
     
     - parameter currentPage:
     - parameter seachLetterValue:
     */
    func httpSelectLetterGoodCategoryList(_ currentPage:Int,seachLetterValue:String){
        var count=0
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.letterQueryGoodsInfoByCategoryForAndroidForStore(goodsCategoryId:goodsCategoryId!, countyId: countyId!, IPhonePenghao:520, isDisplayFlag: 2, pageSize: 10, currentPage: currentPage, storeId: storeId!, order: "seachLetter",seachLetterValue:seachLetterValue), successClosure: { (result) -> Void in
            let json=JSON(result)
            for(_,value) in json{
                // 每次循环加1
                count+=1
                let entity=Mapper<GoodDetailEntity>().map(JSONObject: value.object)
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
                self.goodArr.add(entity!)
            }
            if count < 10{//判断count是否小于10  如果小于表示没有可以加载了 隐藏加载状态
                self.table.setFooterHidden(true)
            }else{//否则显示
                self.table.setFooterHidden(false)
            }
            //关闭刷新状态
            self.table.headerEndRefreshing()
            //关闭加载状态
            self.table.footerEndRefreshing()
            //关闭加载等待视图
            SVProgressHUD.dismiss()
            //刷新table
            self.table.reloadData()
            if self.goodArr.count < 1{//表示没有数据加载空
                SVProgressHUD.showInfo(withStatus: "该字母下面没有商品")
            }else{//如果有数据清除
                self.nilView?.removeFromSuperview()
                //显示跳转购物车按钮
                self.selectShoppingCar!.isHidden=false
                
            }
            }) { (errorMsg) -> Void in
                //关闭刷新状态
                self.table.headerEndRefreshing()
                //关闭加载状态
                self.table.footerEndRefreshing()
                //关闭加载等待视图
                SVProgressHUD.showError(withStatus: errorMsg)
        }
        
    }

    /**
     1元区
     - parameter currentPage: 展示到第几页
     - parameter isRefresh:   是否刷新true是
     */
    func http1YuanArea(_ currentPage:Int,isRefresh:Bool,order:String){
        var count=0
        Alamofire.request(URL+"queryGoodsInfoByCategoryForAndroidForStore.xhtml",parameters:["goodsCategoryId":goodsCategoryId!,"countyId":countyId!,"IPhonePenghao": 520, "isDisplayFlag": 2,"pageSize": 10, "currentPage": currentPage, "storeId":storeId!,"order":order,"priceScreen":1]).responseJSON { res in
            if(res.result.error != nil){
                SVProgressHUD.showError(withStatus:res.result.error?.localizedDescription)
                //关闭刷新状态
                self.table.headerEndRefreshing()
                //关闭加载状态
                self.table.footerEndRefreshing()
            }
            if(res.result.value != nil){
                let json=JSON(res.result.value!)
                if isRefresh{//如果是刷新先删除数据
                    self.goodArr.removeAllObjects()
                }
                for(_,value) in json{
                    // 每次循环加1
                    count+=1
                    let entity=Mapper<GoodDetailEntity>().map(JSONObject:value.object)
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
                    self.goodArr.add(entity!)
                }
                if count < 10{//判断count是否小于10  如果小于表示没有可以加载了 隐藏加载状态
                    self.table.setFooterHidden(true)
                }else{//否则显示
                    self.table.setFooterHidden(false)
                }
                if self.goodArr.count < 1{//表示没有数据加载空
                    self.nilView?.removeFromSuperview()
                    self.nilView=nilPromptView("商品正在上传中...")
                    self.nilView!.center=self.table.center
                    self.view.addSubview(self.nilView!)
                    //隐藏跳转购物车按钮
                    self.selectShoppingCar!.isHidden=true
                    
                }else{//如果有数据清除
                    self.nilView?.removeFromSuperview()
                    //显示跳转购物车按钮
                    self.selectShoppingCar!.isHidden=false
                    
                }
                //关闭刷新状态
                self.table.headerEndRefreshing()
                //关闭加载状态
                self.table.footerEndRefreshing()
                //关闭加载等待视图
                SVProgressHUD.dismiss()
                //刷新table
                self.table.reloadData()
                
            }
        }
    }
    
    /**
     查询配送商商品
     
     - parameter currentPage:
     - parameter isRefresh:
     - parameter order:
     - parameter tag:
     */
    func queryShoppingCarMoreGoodsForSubSupplier(_ currentPage:Int,isRefresh:Bool,order:String,tag:Int){
        var count=0
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryShoppingCarMoreGoodsForSubSupplier(storeId:Int(storeId!)!, subSupplierId: subSupplierId!, pageSize:10, currentPage:currentPage, order:order,seachLetterValue:"", tag:tag), successClosure: { (result) -> Void in
            let json=JSON(result)
            if isRefresh{//如果是刷新先删除数据
                self.goodArr.removeAllObjects()
            }
            for(_,value) in json{
                // 每次循环加1
                count+=1
                let entity=Mapper<GoodDetailEntity>().map(JSONObject: value.object)
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
                self.goodArr.add(entity!)
            }
            if count < 10{//判断count是否小于10  如果小于表示没有可以加载了 隐藏加载状态
                self.table.setFooterHidden(true)
            }else{//否则显示
                self.table.setFooterHidden(false)
            }
            if self.goodArr.count < 1{//表示没有数据加载空
                self.nilView?.removeFromSuperview()
                self.nilView=nilPromptView("商品正在上传中...")
                self.nilView!.center=self.table.center
                self.view.addSubview(self.nilView!)
                //隐藏跳转购物车按钮
                self.selectShoppingCar!.isHidden=true
                
            }else{//如果有数据清除
                self.nilView?.removeFromSuperview()
                //显示跳转购物车按钮
                self.selectShoppingCar!.isHidden=false
                
            }
            //关闭刷新状态
            self.table.headerEndRefreshing()
            //关闭加载状态
            self.table.footerEndRefreshing()
            //关闭加载等待视图
            SVProgressHUD.dismiss()
            //刷新table
            self.table.reloadData()
            }) { (errorMsg) -> Void in
                //关闭刷新状态
                self.table.headerEndRefreshing()
                //关闭加载状态
                self.table.footerEndRefreshing()
                //关闭加载等待视图
                SVProgressHUD.showError(withStatus: errorMsg)
        }
    }
}

// MARK: -DOP协议
extension GoodCategory3ViewController:DOPDropDownMenuDataSource,DOPDropDownMenuDelegate{
    func numberOfColumns(in menu: DOPDropDownMenu!) -> Int {
        return 2
    }
    func menu(_ menu: DOPDropDownMenu!, numberOfRowsInColumn column: Int) -> Int {
        if flag == 2 {
            return 4
        }else if flag == 1 || flag == 6{
            return 3
        }else{
            return 1
        }
    }
    func menu(_ menu: DOPDropDownMenu!, titleForRowAt indexPath: DOPIndexPath!) -> String! {
        if indexPath.column == 0{
            if indexPath.row == 0{
                return "销量"
            }else if indexPath.row == 1{
                return "销量从高到低"
            }else if indexPath.row == 2{
                return "销量从低到高"
            }else{
                return "字母A—Z"
            }
        }else{
            if indexPath.row == 0{
                return "价格"
            }else if indexPath.row == 1{
                return "价格从高到低"
            }else if indexPath.row == 2{
                return "价格从低到高"
            }else{
                return "字母A—Z"
            }
        }
    }
    func menu(_ menu: DOPDropDownMenu!, didSelectRowAt indexPath: DOPIndexPath!) {
        if indexPath.column == 0{
            if indexPath.row == 0{
                self.order="count"
            }else if indexPath.row == 1{
                self.order="count"
                self.tag=2
            }else if indexPath.row == 2{
                self.order="count"
                self.tag=1
            }else{
                self.order="letter"
                self.seachLetter="A"
            }
        }else{
            if indexPath.row == 0{
                self.order="price"
            }else if indexPath.row == 1{
                self.order="price"
                self.tag=2
            }else if indexPath.row == 2{
                self.order="price"
                self.tag=1
            }else{
                self.order="letter"
                self.seachLetter="A"
            }
        }
        self.table.reloadData()
        self.table.headerBeginRefreshing()
    }
}
