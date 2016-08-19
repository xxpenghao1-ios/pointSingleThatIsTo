//
//  ShoppingCarViewContorller.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/1/18.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import Alamofire
import ObjectMapper
/// 购物车
class ShoppingCarViewContorller:UIViewController,ShoppingCarTableViewCellDelegate{
    
    /// 保存会员id
    var memberId:String?
    
    /// 数据源
    var arr=NSMutableArray()
    
    /// table
    var table:UITableView?
    
    /// 结算view
    var clearingView:UIView?
    
    /// 结算按钮
    var btnClearing:UIButton?
    
    /// 计算总价
    var lblTotalPrice:UILabel?
    
    /// 全选
    var btnCheckAll:UIButton?
    
    /// 选中的总数量
    var selectSumCount:Int=0
    
    /// 保存总价格
    var totalPirce:Double = 0.00{
        didSet{
            totalPirce=totalPirce.toDecimalNumberTwo(totalPirce)
        }
    };
    
    /// 空购物车提示
    var nilShoppingCarView:UIView?
    
    /// 页面加载标识
    var viewFlag=false;
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if !viewFlag{//false 表示可以加载
            arr.removeAllObjects()
            http()
        }
        viewFlag=false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="购物车"
        self.view.backgroundColor=UIColor.whiteColor()
        http()
        //table高度
        var tableHeight:CGFloat=0
        tableHeight=boundsHeight-50;
       
        //拿到缓存中的会员id
        memberId=NSUserDefaults.standardUserDefaults().objectForKey("memberId") as? String
        //初始化table
        table=UITableView(frame:CGRectMake(0,0,boundsWidth,tableHeight), style: UITableViewStyle.Plain)
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
            table!.separatorInset=UIEdgeInsetsZero;
        }
        //加载空购物车提示视图
        shoppingCarNilStyle()
        //加载结算视图
        buildClearingView()
        viewFlag=true
        
    }
    /**
     空购物车布局
     */
    func shoppingCarNilStyle(){
        nilShoppingCarView=UIView(frame:CGRectMake(0,0,300,200));
        nilShoppingCarView!.center=self.view.center;
        //购物车图片
        let shoppingCarImg=UIImage(named:"nulChar");
        let shoppingCarImgView=UIImageView(image:shoppingCarImg);
        shoppingCarImgView.frame=CGRectMake((nilShoppingCarView!.frame.width-90)/2,0,90,90);
        nilShoppingCarView!.addSubview(shoppingCarImgView);
        //提示文字
        let shoppingLbl=UILabel(frame:CGRectMake(0,shoppingCarImgView.frame.height+10,300,20));
        shoppingLbl.textColor=UIColor.textColor();
        shoppingLbl.text="您的购物车还没有任何商品";
        shoppingLbl.font=UIFont.systemFontOfSize(15);
        shoppingLbl.textAlignment=NSTextAlignment.Center;
        nilShoppingCarView!.addSubview(shoppingLbl);
        nilShoppingCarView!.hidden=true
        self.view.addSubview(nilShoppingCarView!);
        
    }
    /**
     结算view
     */
    func buildClearingView(){
        
        /// 高度
        var clearingViewY:CGFloat=0
        
        if self.hidesBottomBarWhenPushed.boolValue == true{//如果底部菜单隐藏 －50
            clearingViewY=boundsHeight-50
        }else{// 没有 －50 －菜单高度
            clearingViewY=boundsHeight-49-50
        }
        clearingView=UIView(frame:CGRectMake(0,clearingViewY,boundsWidth,50))
        //默认隐藏
        clearingView!.hidden=true
        //显示总价view
        let leftView=UIView(frame:CGRectMake(0,0,clearingView!.frame.width/3*2,50))
        leftView.backgroundColor=UIColor(red:32/255, green: 32/255, blue: 32/255, alpha: 1)
        clearingView!.addSubview(leftView)
        
        //结算按钮
        btnClearing=UIButton(frame:CGRectMake(clearingView!.frame.width/3*2,0,clearingView!.frame.width/3,50))
        btnClearing!.backgroundColor=UIColor.applicationMainColor()
        btnClearing!.setTitle("去结算(0)", forState: UIControlState.Normal)
        btnClearing!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btnClearing!.titleLabel!.font=UIFont.systemFontOfSize(15)
        btnClearing!.addTarget(self, action:"pushOrderView:", forControlEvents: UIControlEvents.TouchUpInside);
        clearingView!.addSubview(btnClearing!)
        
        
        //全选按钮
        btnCheckAll=UIButton(frame:CGRectMake(15,15,20,20))
        btnCheckAll!.setBackgroundImage(UIImage(named: "select_05"), forState: UIControlState.Normal)
        btnCheckAll!.setBackgroundImage(UIImage(named: "select_03"), forState: UIControlState.Selected)
        //默认全选
        btnCheckAll!.selected=true
        btnCheckAll!.addTarget(self, action:"checkAll:", forControlEvents: UIControlEvents.TouchUpInside)
        leftView.addSubview(btnCheckAll!)
        
        //总价
        lblTotalPrice=UILabel(frame:CGRectMake(CGRectGetMaxX(btnCheckAll!.frame)+15,(clearingView!.frame.height-20)/2,leftView.frame.width-CGRectGetMaxX(btnCheckAll!.frame)-20,20));
        lblTotalPrice!.text="总计:￥0.0";
        lblTotalPrice!.textColor=UIColor.whiteColor();
        lblTotalPrice!.font=UIFont.systemFontOfSize(14);
        leftView.addSubview(lblTotalPrice!);
        self.view.addSubview(clearingView!)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if arr.count > 0{
            //购物车每次退出页面都会对服务器发送请求更新商品数量
            updateCarAllGoodsNumForMember()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
/// MARK: - 实现table协议
extension ShoppingCarViewContorller:UITableViewDelegate,UITableViewDataSource{
    
    //返回tabview每一行显示什么
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell=tableView.dequeueReusableCellWithIdentifier("ShoppingCarCellId") as? ShoppingCarTableViewCell
        if cell == nil{
            cell=ShoppingCarTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier:"ShoppingCarCellId")
        }
        //去除15px空白，分割线顶头对齐
        cell?.layoutMargins=UIEdgeInsetsZero
        cell?.separatorInset=UIEdgeInsetsZero
        if arr.count > 0{//进行判断  防止没有数据 程序崩溃
            let vo=arr[indexPath.section] as! ShoppingCarVo
            let entity=vo.listGoods![indexPath.row] as! GoodDetailEntity
            //关联协议
            cell!.delelgate=self
            //拿到每行对应索引
            cell!.index=indexPath
            cell!.updateCell(entity)
        }
        return cell!
        
    }
    //3.5.1返回头部组视图
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vo=arr[section] as! ShoppingCarVo
        let view=UIView(frame:CGRectZero)
        view.layer.borderWidth=0.5
        view.layer.borderColor=UIColor.borderColor().CGColor
        view.backgroundColor=UIColor.whiteColor()
        
        let lblSupplierName=UILabel()
        lblSupplierName.lineBreakMode=NSLineBreakMode.ByWordWrapping
        lblSupplierName.numberOfLines=0
        if vo.lowestMoney != nil{
            lblSupplierName.text=vo.supplierName!+"(满\(vo.lowestMoney!)元起送)"
        }else{
            lblSupplierName.text=vo.supplierName!+"(满0元起送)"
        }
        lblSupplierName.font=UIFont.systemFontOfSize(14)
        let size=lblSupplierName.text!.textSizeWithFont(lblSupplierName.font, constrainedToSize:CGSizeMake(300,30))
        lblSupplierName.frame=CGRectMake(15,5,size.width,30)
        view.addSubview(lblSupplierName)
        
        
        let lblTotal=UILabel(frame:CGRectMake(CGRectGetMaxX(lblSupplierName.frame),5,boundsWidth-CGRectGetMaxX(lblSupplierName.frame)-15,30))
        var sum:Double=0
        for var i=0;i<vo.listGoods!.count;i++ {
            let entity=vo.listGoods![i] as! GoodDetailEntity
            var sumMoney:Double=0
            if entity.selectedFlag == 1{
                if entity.flag == 1{
                    sumMoney=(Double(entity.carNumber!)*Double(entity.prefertialPrice!)!)
                }else{
                    sumMoney=(Double(entity.carNumber!)*Double(entity.uprice!)!)
                }
            }
            sum+=sumMoney
        }
        lblTotal.text="小计:\(sum)"
        lblTotal.font=UIFont.systemFontOfSize(14)
        lblTotal.textAlignment = .Right
        lblTotal.textColor=UIColor.redColor()
        view.addSubview(lblTotal)
        return view
    }
    //返回头部高度
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    //2.返回几组
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return arr.count;
    }
    //返回tabview的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        let vo=arr[section] as! ShoppingCarVo
        return vo.listGoods!.count
    }
    //返回tabview的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 120;
    }
    //删除操作
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        deleteShoppingCar(indexPath, tableView:tableView)
    }
    //把delete 该成中文
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String?{
        return "删除"
    }
}
// MARK: - 购物车网络请求
extension ShoppingCarViewContorller{
    /**
     发送请求更新服务器上购物车商品数量
     */
    func updateCarAllGoodsNumForMember(){
        let goodArr=NSMutableArray()
        for(var i=0;i<arr.count;i++){
            let vo=arr[i] as! ShoppingCarVo
            for(var j=0;j<vo.listGoods!.count;j++){
                let entity=vo.listGoods![j] as! GoodDetailEntity
                goodArr.addObject(entity)
            }
        }
        request(.POST,URL+"updateCarAllGoodsNumForMember.xhtml", parameters:["memberId":IS_NIL_MEMBERID()!,"goodsList":toJSONString(goodArr),"tag":2])
    }
    /**
     删除购物车数据
     
     - parameter indexPath: 行索引
     - parameter tableView: UI
     */
    func deleteShoppingCar(indexPath:NSIndexPath,tableView:UITableView){
        //获取对应的entity
        let vo=arr[indexPath.section] as! ShoppingCarVo
        let entity=vo.listGoods![indexPath.row] as! GoodDetailEntity
        request(.POST,URL+"deleteShoppingCar.xhtml", parameters:["memberId":IS_NIL_MEMBERID()!,"goodsList":toJSONString(entity)]).responseJSON{ response in
            if response.result.error != nil{
                SVProgressHUD.showErrorWithStatus(response.result.error!.localizedDescription)
            }
            if response.result.value != nil{
                let json=JSON(response.result.value!)
                let success=json["success"].stringValue
                if success == "success"{
                    //获取对应cell
                    let cell = tableView.cellForRowAtIndexPath(indexPath) as? ShoppingCarTableViewCell
                    if cell != nil{
                        if  cell!.btnSelectImg.selected == true{//如果当前删除 是选中状态
                            var price:Double=0
                            if entity.flag == 1{
                                if entity.endTime != nil{
                                    if Int(entity.endTime!) >= 0{
                                        //计算价格
                                        price+=Double(entity.prefertialPrice!)!*Double(entity.carNumber!)
                                    }
                                }
                            }else{
                                //价格
                                price=Double(entity.uprice!)!*Double(entity.carNumber!);
                            }
                            //截取
                            let toPrice=price.toDecimalNumberTwo(price);
                            //总价-去对应的删除的单价
                            self.totalPirce-=toPrice;
                            //减去对应的数量
                            self.selectSumCount-=entity.carNumber!
                            self.btnClearing!.setTitle("去结算(\(self.selectSumCount))", forState: UIControlState.Normal)
                            self.lblTotalPrice!.text="总价:￥\(self.totalPirce)"
                            
                        }
                        //删除数据源的对应数据
                        vo.listGoods!.removeObjectAtIndex(indexPath.row)
                        //删除对应的cell
                        if vo.listGoods!.count > 0{
                            self.table!.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
                        }else{
                            self.arr.removeObjectAtIndex(indexPath.section)
                            self.table!.deleteSections(NSIndexSet(index:indexPath.section), withRowAnimation: UITableViewRowAnimation.Top)
                        }
                        
                        //用于判断当前所有商品是否全部选择 如果有一个为false表示还没有全部选中
                        var cellSelectFlag=false
                        //获取所有的cell
                        for(var i=0;i<self.arr.count;i++){
                            let vo=self.arr[i] as! ShoppingCarVo
                            for(var j=0;j<vo.listGoods!.count;j++){
                                let entity=vo.listGoods![j] as! GoodDetailEntity
                                if entity.selectedFlag == 1{//判断选中按钮是否选中 如果选中cellSelectFlag设为true
                                    cellSelectFlag=true;
                                }else{//只有有1个为没有选中cellSelectFlag设为false
                                    cellSelectFlag=false
                                    break
                                }
                            }
                        }
                        if cellSelectFlag{//如果为true表示全部选中了
                            self.btnCheckAll!.selected=true
                        }else{
                            self.btnCheckAll!.selected=false
                        }
                        
                        if self.arr.count < 1{//如果没有数据 显示空提示视图 隐藏结算视图
                            self.nilShoppingCarView!.hidden=false
                            self.clearingView!.hidden=true
                        }
                        //发送通知更新角标
                        NSNotificationCenter.defaultCenter().postNotificationName("postBadgeValue", object:3, userInfo:["carCount":entity.carNumber!])
                        self.table?.reloadData()
                    }
                }
            }
        }

    }
    func http(){
        request(.GET,URL+"queryShoppingCarNew.xhtml", parameters:["memberId":IS_NIL_MEMBERID()!]).responseJSON{ response in
            if response.result.error != nil{
                SVProgressHUD.showErrorWithStatus(response.result.error!.localizedDescription)
            }
            if response.result.value != nil{
                let json=JSON(response.result.value!)
                for(_,value) in json{
                    let vo=Mapper<ShoppingCarVo>().map(value.object)
                    if vo!.lowestMoney == nil{
                        vo!.lowestMoney="0"
                    }
                    let goodList=NSMutableArray()
                    for(_,list) in value["listGoods"]{
                        let entity=Mapper<GoodDetailEntity>().map(list.object)
                        entity!.selectedFlag=1
                        if entity!.prefertialPrice != nil{//如果特价价格不等于空(表示是特价)
                            entity!.flag=1 //特价
                            if entity!.endTime == nil{
                                entity!.endTime="0"
                            }else{
                                entity!.endTime=entity!.endTime!.componentsSeparatedByString(".")[0]
                                if Int(entity!.endTime!) <= 0{
                                    entity!.carNumber=0
                                }
                            }
                        }else{
                            entity!.flag=2 //非特价
                        }
                        if entity!.stock == nil{
                            entity!.stock = -1
                        }
                        goodList.addObject(entity!)
                    }
                    vo!.listGoods=goodList
                    self.arr.addObject(vo!)
                }
                self.table?.reloadData()
                // 统计总价格 和总数量
                self.totalPriceAndSumCount()
                //发送通知更新角标
               NSNotificationCenter.defaultCenter().postNotificationName("postBadgeValue",object:1)
                
            }
        }
        
    }
}
// MARK: - 页面逻辑操作
extension ShoppingCarViewContorller{
    /**
     统计总价格 和总数量
     */
    func totalPriceAndSumCount(){
        if arr.count > 0{//如果有数据
            /// 清零数据
            selectSumCount=0
            totalPirce=0.0
            //显示结算视图
            clearingView!.hidden=false
            for var i=0;i<arr.count;i++ {
                
                let vo=arr[i] as! ShoppingCarVo
                for var j=0;j<vo.listGoods!.count;j++ {
                    let entity=vo.listGoods![j] as! GoodDetailEntity
                    if entity.flag == 1{//如果是特价
                        if entity.endTime != nil{
                            if Int(entity.endTime!) > 0{
                                //计算总价格
                                totalPirce+=Double(entity.prefertialPrice!)!*Double(entity.carNumber!)
                                //计算总数量
                                selectSumCount+=entity.carNumber!
                            }
                        }
                    }else{
                        //计算总价格
                        totalPirce+=Double(entity.uprice!)!*Double(entity.carNumber!)
                        //计算总数量
                        selectSumCount+=entity.carNumber!
                    }

                }
                
            }
            //改变结算按钮状态
            self.btnClearing!.setTitle("去结算(\(self.selectSumCount))", forState: UIControlState.Normal)
            self.lblTotalPrice!.text="总价:￥\(self.totalPirce)"
            //全选
            btnCheckAll!.selected=true
            let cellArr=table!.visibleCells
            //获取所有的cell
            for(var i=0;i<cellArr.count;i++){//所有cell选中状态设为true
                let cell:ShoppingCarTableViewCell=cellArr[i] as! ShoppingCarTableViewCell
                cell.btnSelectImg.selected=true;
            }
            nilShoppingCarView!.hidden=true
        }else{//如果没有数据 显示空提示视图
            nilShoppingCarView!.hidden=false
            //隐藏结算视图
            clearingView!.hidden=true
            
        }
        
    }

    /**
     全选
     
     - parameter sender:UIButton
     */
    func checkAll(sender:UIButton){
        var cellArr=self.table!.visibleCells;
        if sender.selected.boolValue == false{//表示全部选中
            //先清0所有数据
            selectSumCount=0
            totalPirce=0.00;
            //设置按钮为选中状态
            sender.selected=true
            //获取屏幕可见cell
            for(var i=0;i<cellArr.count;i++){//所有cell选中状态设为true
                let cell:ShoppingCarTableViewCell=cellArr[i] as! ShoppingCarTableViewCell
                cell.btnSelectImg.selected=true;
            }
            for(var j=0;j<arr.count;j++){//循环所有entity 计算总价 和总数
                let vo=arr[j] as! ShoppingCarVo
                for(var t=0;t<vo.listGoods!.count;t++){
                    let entity=vo.listGoods![t] as! GoodDetailEntity
                    entity.selectedFlag=1
                    if entity.flag == 1{//如果是特价
                        if entity.endTime != nil{
                            if Int(entity.endTime!) > 0{
                                //计算总价格
                                totalPirce+=Double(entity.prefertialPrice!)!*Double(entity.carNumber!)
                                //计算总数量
                                selectSumCount+=entity.carNumber!
                            }
                        }
                    }else{
                        //计算总价格
                        totalPirce+=Double(entity.uprice!)!*Double(entity.carNumber!)
                        //计算总数量
                        selectSumCount+=entity.carNumber!
                    }
                }
                
            }
            //重新设置总价
            self.lblTotalPrice!.text="总价:￥\(self.totalPirce)"
            //重新设置总结算数
            self.btnClearing!.setTitle("去结算(\(selectSumCount))", forState: .Normal)
            
        }else{//表示取消
            sender.selected=false
            for(var i=0;i<cellArr.count;i++){
                let cell:ShoppingCarTableViewCell=cellArr[i] as! ShoppingCarTableViewCell
                cell.btnSelectImg.selected=false;
            }
            for(var j=0;j<arr.count;j++){//循环所有entity
                let vo=arr[j] as! ShoppingCarVo
                for(var t=0;t<vo.listGoods!.count;t++){
                    let entity=vo.listGoods![t] as! GoodDetailEntity
                    entity.selectedFlag=2
                }
            }
            //所有数据请0
            totalPirce=0.00;
            selectSumCount=0
            self.lblTotalPrice!.text="总价:￥\(self.totalPirce)"
            self.btnClearing!.setTitle("去结算(\(0))", forState: UIControlState.Normal)
        }
        table!.reloadData()
        
    }

    /**
     实现协议方法
     
     - parameter inventory: 库存数量
     - parameter eachCount: 限购数量
     - parameter count:     商品数量
     - parameter flag:      是否特价 1no 2yes
     */
    func reachALimitPrompt(inventory: Int, eachCount: Int?,count:Int,flag:Int) {
        if flag == 2{
            SVProgressHUD.showInfoWithStatus("库存不足,目前库存为\(inventory)")
        }else{
            if inventory == -1{
                SVProgressHUD.showInfoWithStatus("限购\(eachCount!)")
            }else{
                if eachCount > inventory{
                    SVProgressHUD.showInfoWithStatus("库存不足,目前库存为\(inventory)")
                }else{
                    SVProgressHUD.showInfoWithStatus("限购\(eachCount!)")
                }
            }
        }
    }
    /**
     计算选择商品的总价格
     
     - parameter totalPrice: 总价格  单个商品＊数量
     - parameter flag:       标示 是否选中 true ++  false  --
     - parameter good:       商品entity
     - parameter index:      行索引
     - parameter seletedFlag: 是否选中
     */
    func calculationSelectTotalPrice(totalPrice:Double,flag: Bool, good: GoodDetailEntity, index: NSIndexPath,count:Int,seletedFlag:Int?) {
        if seletedFlag != nil{//如果不为空
            if seletedFlag == 1 { // 表示选中 更新arr中对应entity的flag状态
                let vo=arr[index.section] as! ShoppingCarVo
                let entity=vo.listGoods![index.row] as! GoodDetailEntity
                entity.selectedFlag=1
            }else{
                let vo=arr[index.section] as! ShoppingCarVo
                let entity=vo.listGoods![index.row] as! GoodDetailEntity
                entity.selectedFlag=2
            }
        }
        //用于判断当前所有商品是否全部选择 如果有一个为false表示还没有全部选中
        var cellSelectFlag=false
        //获取所有的cell
        for(var i=0;i<arr.count;i++){
            let vo=arr[i] as! ShoppingCarVo
            for(var j=0;j<vo.listGoods!.count;j++){
                let entity=vo.listGoods![j] as! GoodDetailEntity
                if entity.selectedFlag == 1{//判断选中按钮是否选中 如果选中cellSelectFlag设为true
                    cellSelectFlag=true;
                }else{//只有有1个为没有选中cellSelectFlag设为false
                    cellSelectFlag=false
                    break
                }
            }
        }
        /// 截取小数点后2位数
        var toPrice=totalPirce.toDecimalNumberTwo(totalPirce);
        if flag{//判断是++ 还是-- true表示++
            //累加总和价格
            toPrice+=totalPrice
            //累加总数
            self.selectSumCount+=count
            if cellSelectFlag{//如果为true表示全部选中了  设置全选按钮为全选状态
                btnCheckAll!.selected=true
            }else{//设置全选按钮为取消状态
                btnCheckAll!.selected=false
            }
            
        }else{
            //累减总和价格
            toPrice-=totalPrice
            //累减总数
            self.selectSumCount-=count
            if cellSelectFlag{//如果为true表示全部选中了  设置全选按钮为全选状态
                btnCheckAll!.selected=true
            }else{//设置全选按钮为取消状态
                btnCheckAll!.selected=false
            }
        }
        //把计算出来的总价 赋值给全局变量总价
        totalPirce=toPrice;
        if totalPirce < 0{//ios浮点数计算 会产生小于0的负值 目前没有解决方案  小于0 直接给0
            totalPirce=0.00;
        }
        
        //改变结算按钮状态
        self.btnClearing!.setTitle("去结算(\(self.selectSumCount))", forState: UIControlState.Normal)
        self.lblTotalPrice!.text="总价:￥\(self.totalPirce)"
        self.table!.reloadSections(NSIndexSet(index:index.section), withRowAnimation: UITableViewRowAnimation.None)
        
    }

    /**
     跳转到结算页面
     
     - parameter sender: UIButton
     */
    func pushOrderView(sender:UIButton){
        let orderArr=NSMutableArray()
        for(var i=0;i<arr.count;i++){//循环所有的数据 判断有无选中的entity
            let vo=arr[i] as! ShoppingCarVo
            var sumMoney:Double=0
            for(var j=0;j<vo.listGoods!.count;j++){
                let entity=vo.listGoods![j] as! GoodDetailEntity
                if entity.selectedFlag == 1{//如果有 添加进新集合
                    if entity.flag == 1{//如果是特价商品
                        if entity.endTime != nil{ //如果剩余时间不等于空
                            if Int(entity.endTime!) > 0{//如果剩余时间大于0
                                orderArr.addObject(entity)
                                sumMoney+=(Double(entity.carNumber!)*Double(entity.prefertialPrice!)!)
                            }
                        }else{
                            orderArr.addObject(entity)
                            sumMoney+=(Double(entity.carNumber!)*Double(entity.prefertialPrice!)!)
                        }
                    }else{
                        orderArr.addObject(entity)
                        sumMoney+=(Double(entity.carNumber!)*Double(entity.uprice!)!)
                    }
                }
            }
            if vo.lowestMoney != nil{
                if Double(vo.lowestMoney!) > sumMoney{//比较最低起送额 是否大于 小计价格
                    UIAlertController.showAlertYes(self, title:"点单即到", message:"\(vo.supplierName!)配送最低起送额是\(vo.lowestMoney!),您还需要购买\(Double(vo.lowestMoney!)! - sumMoney)元才能结算", okButtonTitle:"确定", okHandler: {  Void in
                        return
                    })
                }
            }
        }
        if orderArr.count > 0{
            let vc=OrdersViewController()
            vc.arr=orderArr
            vc.totalPirce=self.totalPirce
            vc.sumCount=self.selectSumCount
            vc.hidesBottomBarWhenPushed=true
            self.navigationController!.pushViewController(vc, animated:true)
        }else{
            SVProgressHUD.showInfoWithStatus("请选择要下单的商品")
        }
    }

}