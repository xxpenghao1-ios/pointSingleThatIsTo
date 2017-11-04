//
//  LetterViewController.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/11/25.
//  Copyright © 2016年 penghao. All rights reserved.
//
import Foundation
import UIKit
import ObjectMapper
import SVProgressHUD
import Alamofire
import SwiftyJSON
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}

/// 价格
class LetterViewController:AddShoppingCartAnimation,UITableViewDataSource,UITableViewDelegate,GoodCategory3TableViewCellAddShoppingCartsDelegate{
    
    /// 接收传入的状态 1表示搜索 2表示查询3级分类
    var flag:Int?
    
    /// 接收传入店铺id
    var storeId:String?
    
    /// 接收传入的县区id
    var countyId:String?
    
    /// 分类id
    var goodsCategoryId:Int?
    
    /// 接收传入搜索条件
    var searchName:String?
    
    /// table
    fileprivate var goodTable:UITableView?
    
    /// 数据源
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
    /// 保存字母用于下拉加载
    fileprivate var seachLetter:String?
    
    fileprivate var indexSet=["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //每次进入页面清零
        badgeCount=0
        self.selectShoppingCar!.badgeValue="\(badgeCount)"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="首字母"
        self.view.backgroundColor=UIColor.white
        goodTable=UITableView(frame:CGRect(x: 0,y: 0,width: boundsWidth,height: boundsHeight-64-40), style: UITableViewStyle.plain)
        goodTable!.delegate=self
        goodTable!.dataSource=self
        goodTable!.addHeaderWithCallback({//刷新
            //从第一页开始
            self.currentPage=1
            self.goodArr.removeAllObjects()
            self.seachLetter=nil
            if self.flag == 2{//查询3级分类
                self.httpSelectGoodCategoryList(self.currentPage,isRefresh: false)
            }
            
        })
        goodTable!.addFooterWithCallback({//加载更多
            //每次页面索引加1
            self.currentPage+=1
            if self.flag == 2{//查询3级分类
                if self.seachLetter != nil{
                    self.httpSelectLetterGoodCategoryList(self.currentPage, seachLetterValue:self.seachLetter!)
                }else{
                    self.httpSelectGoodCategoryList(self.currentPage,isRefresh: false)
                }
            }
        })
        self.view.addSubview(goodTable!)
        //移除空单元格
        goodTable!.tableFooterView = UIView(frame:CGRect.zero)
        //设置cell下边线全屏
        if(goodTable!.responds(to: #selector(setter: UIView.layoutMargins))){
            goodTable?.layoutMargins=UIEdgeInsets.zero
        }
        if(goodTable!.responds(to: #selector(setter: UITableViewCell.separatorInset))){
            goodTable?.separatorInset=UIEdgeInsets.zero;
        }
        
        //加载等待视图
        SVProgressHUD.show(withStatus: "数据加载中")
        goodTable!.headerBeginRefreshing()
        //加载查询购物车按钮
        buildShoppingCarView()
    }
    /**
     构建查看购物车按钮
     */
    func buildShoppingCarView(){
        //查看购物车按钮
        selectShoppingCar=UIButton(frame:CGRect(x: boundsWidth-75,y: boundsHeight-70-40-64,width: 60,height: 60));
        let shoppingCarImg=UIImage(named: "char1");
        selectShoppingCar!.addTarget(self, action:Selector(("pushChoppingView:")), for:UIControlEvents.touchUpInside);
        self.selectShoppingCar?.badgeValue="\(self.badgeCount)"
        //默认隐藏按钮
        selectShoppingCar!.isHidden=true;
        selectShoppingCar!.setBackgroundImage(shoppingCarImg, for:UIControlState());
        self.view.addSubview(selectShoppingCar!)
    }
    //返回tabview每一行显示什么
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell=tableView.dequeueReusableCell(withIdentifier: "GoodCategory3TableViewCellId") as? GoodCategory3TableViewCell
        if cell == nil{
            //加载xib
            cell=Bundle.main.loadNibNamed("GoodCategory3TableViewCell", owner:self, options: nil)?.last as? GoodCategory3TableViewCell
        }
        //设置cell下边线全屏
        if(cell!.responds(to: #selector(setter: UIView.layoutMargins))){
            cell?.layoutMargins=UIEdgeInsets.zero
        }
        if(cell!.responds(to: #selector(setter: UITableViewCell.separatorInset))){
            cell?.separatorInset=UIEdgeInsets.zero;
        }
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
    //返回右边字母表
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if self.goodArr.count > 0{
            return indexSet
        }
        return nil
    }
    //字母点击
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        //加载等待视图
        SVProgressHUD.show(withStatus: "数据加载中")
        seachLetter=title
        self.goodArr.removeAllObjects()
        //按字母查询商品
        httpSelectLetterGoodCategoryList(1, seachLetterValue:title)
        return 0
    }
    //tableview开始载入的动画
    func tableView(_ tableView: UITableView, willDisplay cell:UITableViewCell, forRowAt indexPath: IndexPath){
        
        //设置cell的显示动画为3D缩放
        
        //xy方向缩放的初始值为0.1
        
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        
        //设置动画时间为0.25秒,xy方向缩放的最终值为1
        
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
            
        })
        
    }
    
}
// MARK: - 页面逻辑
extension LetterViewController{
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
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.insertShoppingCar(memberId:memberId, goodId: entity.goodsbasicinfoId!, supplierId: entity.supplierId!, subSupplierId: entity.subSupplier!, goodsCount: count, flag: 2, goodsStock: entity.goodsStock!,storeId:storeId,promotionNumber:nil), successClosure: { (result) -> Void in
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
        var rect=goodTable!.rectForRow(at: indexPath)
        /// 重新设置y的位置(y-table距离顶部的frame偏移量)
        rect.origin.y=rect.origin.y-self.goodTable!.contentOffset.y
        /// 拿到图片的位置
        var headRect=imgView.frame
        headRect.origin.y=rect.origin.y+headRect.origin.y
        self.tableView=self.goodTable
        self.button=self.selectShoppingCar
        self.startAnimationWithRect(headRect, imageView:imgView,isGoodDetail: 2);
        //每次加一
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
        let cell=self.goodTable!.cellForRow(at: indexPath) as! GoodCategory3TableViewCell
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
            NotificationCenter.default.addObserver(self, selector: Selector(("alertTextFieldDidChange:")), name: NSNotification.Name.UITextFieldTextDidChange, object: textField)
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
            if text.text?.characters.count > 0{
                okAction.isEnabled = Int(text.text!)! % self.cellGoodEntity!.goodsBaseCount! == 0 && Int(text.text!)! <= text.tag && Int(text.text!) >= self.cellGoodEntity!.miniCount!
            }else{
                okAction.isEnabled=false
            }
        }
    }
}
// MARK: - 网络请求
extension LetterViewController{
    /**
     查询3级分类
     
     - parameter currentPage: 展示到第几页
     - parameter isRefresh:   是否刷新true是
     */
    func httpSelectGoodCategoryList(_ currentPage:Int,isRefresh:Bool){
        var count=0
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryGoodsInfoByCategoryForAndroidForStore(goodsCategoryId:goodsCategoryId!, countyId: countyId!, IPhonePenghao:520, isDisplayFlag: 2, pageSize: 10, currentPage: currentPage, storeId: storeId!, order: "letter",tag:3), successClosure: { (result) -> Void in
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
                self.goodTable?.setFooterHidden(true)
            }else{//否则显示
                self.goodTable?.setFooterHidden(false)
            }
            if self.goodArr.count < 1{//表示没有数据加载空
                self.nilView?.removeFromSuperview()
                self.nilView=nilPromptView("商品正在上传中...")
                self.nilView!.center=self.goodTable!.center
                self.view.addSubview(self.nilView!)
                //隐藏跳转购物车按钮
                self.selectShoppingCar!.isHidden=true
                
            }else{//如果有数据清除
                self.nilView?.removeFromSuperview()
                //显示跳转购物车按钮
                self.selectShoppingCar!.isHidden=false
                
            }
            //关闭刷新状态
            self.goodTable?.headerEndRefreshing()
            //关闭加载状态
            self.goodTable?.footerEndRefreshing()
            //关闭加载等待视图
            SVProgressHUD.dismiss()
            //刷新table
            self.goodTable?.reloadData()
            }) { (errorMsg) -> Void in
                //关闭刷新状态
                self.goodTable?.headerEndRefreshing()
                //关闭加载状态
                self.goodTable?.footerEndRefreshing()
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
                self.goodTable?.setFooterHidden(true)
            }else{//否则显示
                self.goodTable?.setFooterHidden(false)
            }
            //关闭刷新状态
            self.goodTable?.headerEndRefreshing()
            //关闭加载状态
            self.goodTable?.footerEndRefreshing()
            //关闭加载等待视图
            SVProgressHUD.dismiss()
            //刷新table
            self.goodTable?.reloadData()
            if self.goodArr.count < 1{//表示没有数据加载空
                SVProgressHUD.showInfo(withStatus: "该字母下面没有商品")
            }else{//如果有数据清除
                self.nilView?.removeFromSuperview()
                //显示跳转购物车按钮
                self.selectShoppingCar!.isHidden=false
                
            }
            }) { (errorMsg) -> Void in
                //关闭刷新状态
                self.goodTable?.headerEndRefreshing()
                //关闭加载状态
                self.goodTable?.footerEndRefreshing()
                //关闭加载等待视图
                SVProgressHUD.showError(withStatus: errorMsg)
        }

    }
    /**
     1元区
     - parameter currentPage: 展示到第几页
     - parameter isRefresh:   是否刷新true是
     */
    func http1YuanArea(_ currentPage:Int,isRefresh:Bool){
        var count=0
        Alamofire.request(URL+"queryGoodsInfoByCategoryForAndroidForStore.xhtml",method:.get, parameters:["goodsCategoryId":goodsCategoryId!,"countyId":countyId!,"IPhonePenghao": 520, "isDisplayFlag": 2,"pageSize": 10, "currentPage": currentPage, "storeId":storeId!,"order": "count","priceScreen":1]).responseJSON { res in
            if(res.result.error != nil){
                SVProgressHUD.showError(withStatus:res.result.error?.localizedDescription)
                //关闭刷新状态
                self.goodTable?.headerEndRefreshing()
                //关闭加载状态
                self.goodTable?.footerEndRefreshing()
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
                    self.goodTable?.setFooterHidden(true)
                }else{//否则显示
                    self.goodTable?.setFooterHidden(false)
                }
                if self.goodArr.count < 1{//表示没有数据加载空
                    self.nilView?.removeFromSuperview()
                    self.nilView=nilPromptView("商品正在上传中...")
                    self.nilView!.center=self.goodTable!.center
                    self.view.addSubview(self.nilView!)
                    //隐藏跳转购物车按钮
                    self.selectShoppingCar!.isHidden=true
                    
                }else{//如果有数据清除
                    self.nilView?.removeFromSuperview()
                    //显示跳转购物车按钮
                    self.selectShoppingCar!.isHidden=false
                    
                }
                //关闭刷新状态
                self.goodTable?.headerEndRefreshing()
                //关闭加载状态
                self.goodTable?.footerEndRefreshing()
                //关闭加载等待视图
                SVProgressHUD.dismiss()
                //刷新table
                self.goodTable?.reloadData()
                
            }
        }
    }
    
}
// MARK: - 页面跳转
extension LetterViewController{
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
