//
//  CollectListViewController.swift
//  pointSingleThatIsTo
//
//  Created by hao peng on 2017/3/22.
//  Copyright © 2017年 penghao. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import SVProgressHUD
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

///收藏列表
class CollectListViewController:BaseViewController,UITableViewDataSource,UITableViewDelegate,GoodCategory3TableViewCellAddShoppingCartsDelegate,CAAnimationDelegate{
    var goodArr=NSMutableArray()
    /// table
    fileprivate var goodTable:UITableView?
    /// 默认从第0页开始
    fileprivate var currentPage=0
    
    /// 没有数据加载该视图
    fileprivate var nilView:UIView?
    
    /// 查询购物车按钮
    fileprivate var selectShoppingCar:UIButton?
    
    /// 购物车按钮提示数量
    fileprivate var badgeCount=0
    
    fileprivate var _layer:CALayer?
    fileprivate var path:UIBezierPath?
    /// 保存每一行的cell Entity
    fileprivate var cellGoodEntity:GoodDetailEntity?
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //每次进入页面清零
        badgeCount=0
        self.selectShoppingCar!.badgeValue="\(badgeCount)"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="收藏区"
        self.view.backgroundColor=UIColor.white
        goodTable=UITableView(frame:self.view.bounds, style: UITableViewStyle.plain)
        goodTable!.delegate=self
        goodTable!.dataSource=self
        goodTable!.mj_header=MJRefreshNormalHeader(refreshingBlock: {
            //从第一页开始
            self.currentPage=1
            self.http(self.currentPage, isRefresh:true)
        })
        goodTable!.mj_footer=MJRefreshAutoNormalFooter(refreshingBlock: {
            //从第一页开始
            self.currentPage+=1
            self.http(self.currentPage, isRefresh:false)
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
        goodTable!.mj_header.beginRefreshing()
        //加载查询购物车按钮
        buildShoppingCarView()
    }
    
    /**
     构建查看购物车按钮
     */
    func buildShoppingCarView(){
        //查看购物车按钮
        selectShoppingCar=UIButton(frame:CGRect(x: boundsWidth-75,y: boundsHeight-70-bottomSafetyDistanceHeight,width: 60,height: 60));
        let shoppingCarImg=UIImage(named: "char1");
        selectShoppingCar!.addTarget(self, action:#selector(pushChoppingView), for:UIControlEvents.touchUpInside);
        self.selectShoppingCar?.badgeValue="\(self.badgeCount)"
        //默认隐藏按钮
        selectShoppingCar!.isHidden=true;
        selectShoppingCar!.setBackgroundImage(shoppingCarImg, for:UIControlState());
        self.view.addSubview(selectShoppingCar!)
    }
}
// MARK: - 页面逻辑
extension CollectListViewController{
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
            NotificationCenter.default.addObserver(self,selector: #selector(self.alertTextFieldDidChange), name: NSNotification.Name.UITextFieldTextDidChange, object: textField)
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
    @objc func alertTextFieldDidChange(_ notification: Notification){
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
    /**
     跳转到购物车
     
     - parameter sender:UIButton
     */
    @objc func pushChoppingView(_ sender:UIButton){
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

// MARK: - 协议
extension CollectListViewController{
    //返回tabview每一行显示什么
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell=tableView.dequeueReusableCell(withIdentifier: "GoodCategory3TableViewCellId") as? GoodCategory3TableViewCell
        if cell == nil{
            //加载xib
            cell=Bundle.main.loadNibNamed("GoodCategory3TableViewCell", owner:self, options: nil)?.last as? GoodCategory3TableViewCell
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
    //删除操作
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        deleteCollect(indexPath, tableView:tableView)
    }
    //把delete 该成中文
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?{
        return "删除"
    }

}
// MARK: - 网络请求
extension CollectListViewController{
    func http(_ currentPage:Int,isRefresh:Bool){
        var count=0
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryStoreCollectionList(memebrId:IS_NIL_MEMBERID()!,pageSize:30,currentPage:currentPage), successClosure: { (result) -> Void in
            let json=JSON(result)
            print(json)
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
                entity!.goodsbasicinfoId=value["collectionGoodId"].intValue
                entity!.supplierId=value["collectionSupplierId"].intValue
                entity!.subSupplier=value["collectionSubSupplierId"].intValue
                self.goodArr.add(entity!)
            }
            if count < 30{//判断count是否小于10  如果小于表示没有可以加载了 隐藏加载状态
                self.goodTable?.mj_footer.isHidden=true
            }else{//否则显示
                self.goodTable?.mj_footer.isHidden=false
            }
            if self.goodArr.count < 1{//表示没有数据加载空
                self.nilView?.removeFromSuperview()
                self.nilView=nilPromptView("收藏为空")
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
            self.goodTable?.mj_header.endRefreshing()
            //关闭加载状态
            self.goodTable?.mj_footer.endRefreshing()
            //关闭加载等待视图
            SVProgressHUD.dismiss()
            //刷新table
            self.goodTable?.reloadData()
            }) { (errorMsg) -> Void in
                //关闭刷新状态
                self.goodTable?.mj_header.endRefreshing()
                //关闭加载状态
                self.goodTable?.mj_footer.endRefreshing()
                //关闭加载等待视图
                SVProgressHUD.showError(withStatus: errorMsg)
        }
    }
    /**
     删除收藏
     
     */
    func deleteCollect(_ indexPath:IndexPath,tableView:UITableView){
        let entity=goodArr[indexPath.row] as! GoodDetailEntity
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.goodsCancelCollection(memberId:IS_NIL_MEMBERID()!, goodId:entity.goodsbasicinfoId!), successClosure: { (result) -> Void in
            let json=JSON(result)
            let success=json["success"].stringValue
            if success == "success"{
                self.goodArr.removeObject(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.none)
                if self.goodArr.count < 1{
                    self.nilView?.removeFromSuperview()
                    self.nilView=nilPromptView("收藏为空")
                    self.nilView!.center=self.goodTable!.center
                    self.view.addSubview(self.nilView!)
                    //隐藏跳转购物车按钮
                    self.selectShoppingCar!.isHidden=true
                }
                tableView.reloadData()
            }else{
                SVProgressHUD.showError(withStatus: "删除收藏失败")
            }
            }) { (errorMsg) -> Void in
                SVProgressHUD.showError(withStatus: errorMsg)
        }
    }
}
extension CollectListViewController{
    /**
     加入购物车特效
     
     - parameter rect:CGRect当前图片位置
     - parameter imageView:当前位置图片
     - parameter isGoodDetail:是否的商品详情1是否则商品列表
     */
    func startAnimationWithRect(_ rect:CGRect, imageView:UIImageView,isGoodDetail:Int){
        if _layer==nil{
            _layer=CALayer()
            _layer!.contents = imageView.layer.contents;
            
            _layer!.contentsGravity = kCAGravityResizeAspectFill;
            _layer!.bounds = rect;
            _layer!.cornerRadius=_layer!.bounds.height/2
            _layer!.masksToBounds=true;
            if isGoodDetail == 1{//如果是商品详情
                _layer!.position=CGPoint(x: imageView.center.x, y: rect.midY+120)
                self.view.layer.addSublayer(_layer!)
                path=UIBezierPath()
                path!.move(to: _layer!.position)
                path!.addQuadCurve(to: CGPoint(x: boundsWidth-40, y: UIScreen.main.bounds.height-90), controlPoint:CGPoint(x: boundsWidth/2,y: rect.origin.y-80))
            }else{
                _layer!.position=CGPoint(x: imageView.center.x, y: rect.midY)
                self.view.layer.addSublayer(_layer!)
                path=UIBezierPath()
                path!.move(to: _layer!.position)
                path!.addQuadCurve(to: CGPoint(x: boundsWidth-40, y: UIScreen.main.bounds.height-40), controlPoint:CGPoint(x: boundsWidth/2,y: rect.origin.y-80))
            }
        }
        self.groupAnimation()
    }
    /**
     启动动画组
     */
    func groupAnimation(){
        self.goodTable?.isUserInteractionEnabled=false
        let  animation=CAKeyframeAnimation(keyPath:"position")
        animation.path = path!.cgPath;
        animation.rotationMode = kCAAnimationRotateAuto;
        let expandAnimation = CABasicAnimation(keyPath:"transform.scale")
        expandAnimation.duration = 0.5;
        expandAnimation.fromValue = NSNumber(value: 1 as Float)
        expandAnimation.toValue = NSNumber(value: 2 as Float)
        expandAnimation.timingFunction=CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn)
        let narrowAnimation=CABasicAnimation(keyPath:"transform.scale")
        narrowAnimation.beginTime = 0.5;
        narrowAnimation.fromValue = NSNumber(value: 2.0 as Float)
        narrowAnimation.duration = 0.5;
        narrowAnimation.toValue = NSNumber(value: 0.3 as Float)
        
        narrowAnimation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        
        let groups = CAAnimationGroup()
        groups.animations = [animation,expandAnimation,narrowAnimation];
        groups.duration = 1.0;
        groups.isRemovedOnCompletion=false;
        groups.fillMode=kCAFillModeForwards;
        groups.delegate = self;
        _layer!.add(groups, forKey:"group")
        
        
    }
    
    /**
     删除对应的动画效果
     
     - parameter anim: CAAnimation
     - parameter flag: Bool
     */
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if (anim == _layer!.animation(forKey: "group")) {
            self.goodTable?.isUserInteractionEnabled=true
            _layer?.removeFromSuperlayer()
            _layer=nil
            let shakeAnimation = CABasicAnimation(keyPath:"transform.translation.y")
            shakeAnimation.duration = 0.25;
            shakeAnimation.fromValue =  NSNumber(value: -5 as Float)
            shakeAnimation.toValue =  NSNumber(value: 5 as Float)
            shakeAnimation.autoreverses = true
            UIView.animate(withDuration: 10, animations: { () -> Void in
                let shoppingCarImg2=UIImage(named: "char2");
                self.selectShoppingCar!.setBackgroundImage(shoppingCarImg2, for: UIControlState())
                self.selectShoppingCar!.layer.add(shakeAnimation, forKey:nil)
                
                }, completion: { (b) -> Void in
                    let delayInSeconds:Int64 = 1000000000 * 1
                    let c=delayInSeconds/4
                    let popTime:DispatchTime = DispatchTime.now() + Double(c) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: popTime, execute: {
                        let shoppingCarImg1=UIImage(named: "char1");
                        self.selectShoppingCar!.setBackgroundImage(shoppingCarImg1, for: UIControlState())
                    })
            })
            
        }
    }

}
