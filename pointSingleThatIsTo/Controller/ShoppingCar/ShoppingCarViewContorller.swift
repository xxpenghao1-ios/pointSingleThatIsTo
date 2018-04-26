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
import SwiftyJSON
/// 购物车
class ShoppingCarViewContorller:BaseViewController,ShoppingCarTableViewCellDelegate{
    
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
    var selectSumCount:Int = 0
    
    /// 编辑按钮
    var editBar:UIBarButtonItem?
    let storeId=userDefaults.object(forKey: "storeId") as! String
    /// 保存总价格
    var totalPirce="0.0"
    
    /// 空购物车提示
    var nilShoppingCarView:UIView?
    
    /// 页面加载标识
    var viewFlag=false;
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !viewFlag{//false 表示可以加载
            http()
            self.editBar?.title="编辑"
        }
        viewFlag=false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="购物车"
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        http()
        //拿到缓存中的会员id
        memberId=UserDefaults.standard.object(forKey: "memberId") as? String
        var tableY:CGFloat=0
        
        if self.hidesBottomBarWhenPushed == true {
            tableY=boundsHeight-50-bottomSafetyDistanceHeight-navHeight
        }else{
            tableY=boundsHeight-50-navHeight-self.tabBarController!.tabBar.frame.height
        }
        //初始化table
        table=UITableView(frame:CGRect(x:0,y:navHeight,width:boundsWidth,height:tableY), style: UITableViewStyle.grouped)
        table!.dataSource=self
        table!.delegate=self
        table!.backgroundColor=UIColor.clear
        table!.estimatedRowHeight = 0;
        table!.estimatedSectionHeaderHeight = 0;
        table!.estimatedSectionFooterHeight = 0;
        self.view.addSubview(table!)
        //移除空单元格
        table!.tableFooterView = UIView(frame:CGRect.zero)
        
        //设置cell下边线全屏
        if(table!.responds(to: #selector(setter: UIView.layoutMargins))){
            table?.layoutMargins=UIEdgeInsets.zero
        }
        if(table!.responds(to: #selector(setter: UITableViewCell.separatorInset))){
            table!.separatorInset=UIEdgeInsets.zero;
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
        nilShoppingCarView=UIView(frame:CGRect(x: 0,y: 0,width: 300,height: 200));
        nilShoppingCarView!.center=self.view.center;
        //购物车图片
        let shoppingCarImg=UIImage(named:"nildd");
        let shoppingCarImgView=UIImageView(image:shoppingCarImg);
        shoppingCarImgView.frame=CGRect(x: (nilShoppingCarView!.frame.width-90)/2,y: 0,width: 90,height: 90);
        nilShoppingCarView!.addSubview(shoppingCarImgView);
        //提示文字
        let shoppingLbl=UILabel(frame:CGRect(x: 0,y: shoppingCarImgView.frame.height+10,width: 300,height: 20));
        shoppingLbl.textColor=UIColor.textColor();
        shoppingLbl.text="您的购物车还没有任何商品";
        shoppingLbl.font=UIFont.systemFont(ofSize: 15);
        shoppingLbl.textAlignment=NSTextAlignment.center;
        nilShoppingCarView!.addSubview(shoppingLbl);
        nilShoppingCarView!.isHidden=true
        self.view.addSubview(nilShoppingCarView!);
        
    }
    /**
     结算view
     */
    func buildClearingView(){
        
        /// 高度
        var clearingViewY:CGFloat=0
        if self.hidesBottomBarWhenPushed == true{//如果底部菜单隐藏 －50
            clearingViewY=boundsHeight-50-bottomSafetyDistanceHeight
        }else{// 没有 －50 －菜单高度
            clearingViewY=boundsHeight-50-self.tabBarController!.tabBar.frame.height
        }
        clearingView=UIView(frame:CGRect(x:0,y:clearingViewY,width:boundsWidth,height:50))
        self.view.addSubview(clearingView!)
        //默认隐藏
        clearingView!.isHidden=true
        //显示总价view
        let leftView=UIView(frame:CGRect(x: 0,y: 0,width: clearingView!.frame.width/3*2,height: 50))
        leftView.backgroundColor=UIColor(red:32/255, green: 32/255, blue: 32/255, alpha: 1)
        clearingView!.addSubview(leftView)
        
        //结算按钮
        btnClearing=UIButton(frame:CGRect(x: clearingView!.frame.width/3*2,y: 0,width: clearingView!.frame.width/3,height: 50))
        btnClearing!.backgroundColor=UIColor.applicationMainColor()
        btnClearing!.setTitle("去结算(0)", for: UIControlState())
        btnClearing!.setTitleColor(UIColor.white, for: UIControlState())
        btnClearing!.titleLabel!.font=UIFont.systemFont(ofSize: 15)
        btnClearing!.addTarget(self, action:#selector(pushOrderView), for: UIControlEvents.touchUpInside);
        clearingView!.addSubview(btnClearing!)
        
        
        //全选按钮
        btnCheckAll=UIButton(frame:CGRect(x: 15,y: 15,width: 20,height: 20))
        btnCheckAll!.setBackgroundImage(UIImage(named: "select_05"), for: UIControlState())
        btnCheckAll!.setBackgroundImage(UIImage(named: "select_03"), for: UIControlState.selected)
        //默认全选
        btnCheckAll!.isSelected=true
        btnCheckAll!.addTarget(self, action:#selector(checkAll), for: UIControlEvents.touchUpInside)
        leftView.addSubview(btnCheckAll!)
        
        //总价
        lblTotalPrice=UILabel(frame:CGRect(x: btnCheckAll!.frame.maxX+15,y: (clearingView!.frame.height-20)/2,width: leftView.frame.width-btnCheckAll!.frame.maxX-20,height: 20));
        lblTotalPrice!.text="总计:￥0.0";
        lblTotalPrice!.textColor=UIColor.white;
        lblTotalPrice!.font=UIFont.systemFont(ofSize: 14);
        leftView.addSubview(lblTotalPrice!);
    }
    
    override func viewWillDisappear(_ animated: Bool) {
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell=tableView.dequeueReusableCell(withIdentifier: "ShoppingCarCellId") as? ShoppingCarTableViewCell
        if cell == nil{
            cell=ShoppingCarTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:"ShoppingCarCellId")
        }
        //去除15px空白，分割线顶头对齐
        cell?.layoutMargins=UIEdgeInsets.zero
        cell?.separatorInset=UIEdgeInsets.zero
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
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vo=arr[section] as! ShoppingCarVo
        if vo.listGoods!.count == 0{//判断当前组下面是否有商品集合
            return nil
        }else{
            let view=UIView(frame:CGRect.zero)
            view.layer.borderWidth=0.5
            view.layer.borderColor=UIColor.borderColor().cgColor
            view.backgroundColor=UIColor.white
            //选择图片
            let selectImg=UIImage(named:"select_05");
            let selectImgSelected=UIImage(named:"select_03");
            
            //给选择图片加上按钮实现点击切换
            let btnSelectImg=UIButton(frame:CGRect(x: 10,y: (40-20)/2,width: 20,height: 20));
            btnSelectImg.setImage(selectImg, for:UIControlState())
            btnSelectImg.setImage(selectImgSelected, for:.selected);
            btnSelectImg.addTarget(self, action:#selector(selectImgSwitch), for: UIControlEvents.touchUpInside);
            btnSelectImg.tag=section
            view.addSubview(btnSelectImg)
            
            let lblSupplierName=UILabel()
            lblSupplierName.lineBreakMode=NSLineBreakMode.byWordWrapping
            lblSupplierName.numberOfLines=0
            if vo.lowestMoney != nil{
                lblSupplierName.text=vo.supplierName!+"(满\(vo.lowestMoney!)元起送)"
            }else{
                lblSupplierName.text=vo.supplierName!+"(满0元起送)"
            }
            lblSupplierName.font=UIFont.systemFont(ofSize: 14)
            lblSupplierName.frame=CGRect(x: btnSelectImg.frame.maxX+5,y: 5,width: boundsWidth-40,height: 30)
            view.addSubview(lblSupplierName)
            if vo.isSelected == 1{//如果等于1选中
                btnSelectImg.isSelected=true
            }
            return view
        }
        
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let vo=arr[section] as! ShoppingCarVo
        //每组小计价格
        var sum:String="0"
        if vo.listGoods!.count == 0{//判断当前组下面是否有商品集合
            return nil
        }else{
            //循环所有商品统计
            for i in 0..<vo.listGoods!.count{
                let entity=vo.listGoods![i] as! GoodDetailEntity
                //每个商品小计价格
                var sumMoney:String="0"
                if entity.isSelected == 1{//只计算选中的商品
                    if entity.flag == 1{//如果是特价
                        sumMoney=PriceComputationsUtil.decimalNumberWithString(multiplierValue: "\(entity.carNumber!)", multiplicandValue: entity.prefertialPrice!, type:.multiplication, position:2)
                    }else{//普通价格
                        sumMoney=PriceComputationsUtil.decimalNumberWithString(multiplierValue: "\(entity.carNumber!)", multiplicandValue: entity.uprice!, type:.multiplication, position:2)
                    }
                }
                sum=PriceComputationsUtil.decimalNumberWithString(multiplierValue:sumMoney, multiplicandValue:sum, type:.addition, position:2)
            }
            
        }
        let view=UIView(frame:CGRect.zero)
        view.backgroundColor=UIColor.white
        let btn=ButtonControl().button(ButtonType.cornerRadiusButton, text:"去凑单", textColor:UIColor.white, font:14, backgroundColor:UIColor.applicationMainColor(), cornerRadius:5)
        btn.addTarget(self, action:#selector(pushSubSuppingVC), for:UIControlEvents.touchUpInside)
        btn.tag=section
        btn.isHidden=true
        let name=buildLabel(UIColor.red, font: 14, textAlignment: NSTextAlignment.left)
        
        if Double(sum)! < Double(vo.lowestMoney!)!{//如果小计小于最低起送额
            name.text="还需\(PriceComputationsUtil.decimalNumberWithString(multiplierValue:vo.lowestMoney!, multiplicandValue: sum, type:.subtraction, position:2))元起送"
            btn.isHidden=false
        }else{
            name.text="您已达到配送标准"
            btn.isHidden=true
        }
        
        let size=name.text!.textSizeWithFont(UIFont.systemFont(ofSize: 14), constrainedToSize:CGSize(width: 300,height: 20))
        
        name.frame=CGRect(x: 15,y: 10,width: size.width,height: 20)
        view.addSubview(name)
        btn.frame=CGRect(x: name.frame.maxX+5,y: 5,width: 60,height: 30)
        view.addSubview(btn)
        
        let lblTotal=UILabel(frame:CGRect(x: name.frame.maxX+65,y: 5,width: boundsWidth-name.frame.maxX-15-65,height: 30))
        if self.editBar?.title != "完成"{//如果true显示小计
            lblTotal.text="小计:\(sum)"
            lblTotal.font=UIFont.systemFont(ofSize: 14)
            lblTotal.textAlignment = .right
            lblTotal.textColor=UIColor.red
            view.addSubview(lblTotal)
        }
        
        let borderView=UIView(frame:CGRect(x: 0,y: 40,width: boundsWidth,height: 7))
        borderView.backgroundColor=UIColor.viewBackgroundColor()
        view.addSubview(borderView)
        return view
    }
    //返回头部高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    //返回尾部高度
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 47
    }
    //2.返回几组
    func numberOfSections(in tableView: UITableView) -> Int {
        return arr.count;
    }
    //返回tabview的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if arr.count > 0{
            let vo=arr[section] as! ShoppingCarVo
            if vo.listGoods != nil{
                return vo.listGoods!.count
            }
        }
        return 0
    }
    //返回tabview的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 120;
    }
    //删除操作
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete{
            deleteShoppingCar(indexPath, tableView:tableView)
        }
    }
    //把delete 该成中文
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?{
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
        for i in 0..<arr.count{
            let vo=arr[i] as! ShoppingCarVo
            for j in 0..<vo.listGoods!.count{
                let entity=vo.listGoods![j] as! GoodDetailEntity
                goodArr.add(entity)
            }
        }
        print(toJSONString(goodArr))
        request(URL+"updateCarAllGoodsNumForMember.xhtml",method:.post, parameters:["memberId":IS_NIL_MEMBERID()!,"goodsList":toJSONString(goodArr),"tag":2])
    }
    /**
     删除购物车数据
     
     - parameter indexPath: 行索引
     - parameter tableView: UI
     */
    func deleteShoppingCar(_ indexPath:IndexPath,tableView:UITableView){
        //获取对应的entity
        let vo=arr[indexPath.section] as! ShoppingCarVo
        let entity=vo.listGoods![indexPath.row] as! GoodDetailEntity
        request(URL+"deleteShoppingCar.xhtml",method:.post, parameters:["memberId":memberId!,"goodsList":toJSONString(entity)]).responseJSON{ response in
            if response.result.error != nil{
                SVProgressHUD.showError(withStatus:response.result.error!.localizedDescription)
            }
            if response.result.value != nil{
                let json=JSON(response.result.value!)
                let success=json["success"].stringValue
                if success == "success"{
                    //获取对应cell
                    let cell = tableView.cellForRow(at: indexPath) as? ShoppingCarTableViewCell
                    if cell != nil{
                        //删除对应的cell
                        //删除数据源的对应数据
                        vo.listGoods!.removeObject(at: indexPath.row)
                        if vo.listGoods!.count > 0{
                            self.table!.deleteRows(at: [indexPath], with: UITableViewRowAnimation.none)
                            self.isSection(indexPath)
                        }else{
                            self.arr.removeObject(at:indexPath.section)
                            self.table!.deleteSections(NSIndexSet(index:indexPath.section) as IndexSet, with: UITableViewRowAnimation.none)
                            self.totalPriceAndSumCount()
                        }
                        self.table?.reloadData()
                        //发送通知更新角标
                        NotificationCenter.default.post(name:NSNotification.Name(rawValue:"postBadgeValue"), object: 3, userInfo: ["carCount":entity.carNumber!])
                        
                    }
                }
            }
        }
    }
    
    /**
     请求购物车数据
     */
    func http(){
        self.showSVProgressHUD(status:"正在加载...", type:HUD.textClear)

        request( URL+"queryShoppingCarNew.xhtml",method:.get, parameters:["memberId":IS_NIL_MEMBERID()!,"storeId":storeId]).responseJSON{ response in
            if response.result.error != nil{
                SVProgressHUD.showError(withStatus:response.result.error!.localizedDescription)
            }
            if response.result.value != nil{
                let json=JSON(response.result.value!)
                self.arr.removeAllObjects()
                for(_,value) in json{
                    let vo=Mapper<ShoppingCarVo>().map(JSONObject:value.object)
                    if vo!.lowestMoney == nil{//如果最低起送等于空
                        vo!.lowestMoney="0"
                    }
                    
                    //默认选中
                    vo?.isSelected=1
                    let goodList=NSMutableArray()
                    for(_,list) in value["listGoods"]{
                        let entity=Mapper<GoodDetailEntity>().map(JSONObject:list.object)
                        entity!.goodUnit=entity!.goodUnit ?? " "
                        //默认选中
                        entity!.isSelected=1
                        if entity!.flag == 1{//如果特价
                            if entity!.endTime == nil{
                                entity!.endTime="0"
                            }else{
                                //截取时间字符
                                entity!.endTime=entity!.endTime!.components(separatedBy:".")[0]
                                if Int(entity!.endTime!)! <= 0{//判断如果时间小于等于0
                                    entity!.carNumber=0//购物车单个商品数量等于0
                                }
                            }
                            
                        }else if entity!.flag == 3{//如果是促销
                            if entity!.promotionEndTime == nil {
                                entity!.promotionEndTime="0"
                            }
                            entity!.endTime=entity!.promotionEndTime
                            entity!.eachCount=entity!.promotionStoreEachCount
                            if Int(entity!.endTime!)! <= 0{//判断如果时间小于等于0
                                entity!.carNumber=0//购物车单个商品数量等于0
                            }
                            if entity!.promotionEachCount == nil{//如果促销商品还可以购买的数量等于空
                                entity!.stock = -1
                            }else{
                                entity!.stock=entity!.promotionEachCount
                            }
                        }
                        if entity!.stock == nil{//如果库存等于空
                            entity!.stock = -1//默认给-1
                        }
                        entity!.eachCount=entity!.eachCount ?? 0
                        goodList.add(entity!)
                    }
                    
                    vo!.listGoods=goodList
                    self.arr.add(vo!)
                }
                self.table?.reloadData()
                // 统计总价格 和总数量
                self.totalPriceAndSumCount()
                SVProgressHUD.dismiss()
                //发送通知更新角标
                NotificationCenter.default.post(name:NSNotification.Name(rawValue: "postBadgeValue"), object:1)
                
            }
        }
        
    }
}
// MARK: - 页面逻辑操作
extension ShoppingCarViewContorller{
    /**
     编辑
     
     - parameter sender:UIBarButtonItem
     */
    @objc func edit(_ sender:UIBarButtonItem){
        if sender.title == "编辑"{
            sender.title="完成"
            multiSelectDelete(2)
            //改变结算为删除按钮
            self.btnClearing!.setTitle("删除", for: UIControlState())
            self.lblTotalPrice!.text="全选"
            self.btnCheckAll!.isSelected=false
            
        }else{
            sender.title="编辑"
            multiSelectDelete(1)
            totalPriceAndSumCount()
        }
    }
    /**
     多选删除
     
     - parameter isDelete:是删除还是完成(2删除)
     */
    func multiSelectDelete(_ isDelete:Int){
        //如果是删除让选中状态变为不选中(完成回到选中状态)
        for i in 0..<arr.count{
            let vo=arr[i] as! ShoppingCarVo
            vo.isSelected=isDelete
            for j in 0..<vo.listGoods!.count{
                let entity=vo.listGoods![j] as! GoodDetailEntity
                entity.isSelected=isDelete
            }
        }
        self.table!.reloadData()
    }
    /**
     每组是否选中
     
     - parameter sender:UIButton
     */
    @objc func selectImgSwitch(_ sender:UIButton){
        var isSelected=0
        if sender.isSelected == true{
            sender.isSelected=false
            isSelected=2
            
        }else{
            sender.isSelected=true
            isSelected=1
        }
        let vo=arr[sender.tag] as! ShoppingCarVo
        vo.isSelected=isSelected
        for i in 0..<vo.listGoods!.count{
            let entity=vo.listGoods![i] as! GoodDetailEntity
            entity.isSelected=isSelected
        }
        totalPriceAndSumCount()
        self.table?.reloadSections(IndexSet(integer:sender.tag), with: UITableViewRowAnimation.none)
    }
    /**
     统计总价格 和总数量
     */
    func totalPriceAndSumCount(){
        /// 清零数据
        selectSumCount=0
        totalPirce="0.0"
        if arr.count > 0{//如果有数据
            if editBar == nil{
                editBar=UIBarButtonItem(title:"编辑", style: UIBarButtonItemStyle.done, target:self, action:#selector(edit))
                self.navigationItem.rightBarButtonItem=editBar
            }
            //显示结算视图
            clearingView!.isHidden=false
            for i in 0..<arr.count{
                let vo=arr[i] as! ShoppingCarVo
                for j in 0..<vo.listGoods!.count{
                    let entity=vo.listGoods![j] as! GoodDetailEntity
                    if entity.isSelected == 1{//只统计选中的商品
                        if entity.flag == 1{//如果是特价
                            if entity.endTime != nil{
                                if Int(entity.endTime!)! > 0{
                                    //计算总价格
                                    let price=PriceComputationsUtil.decimalNumberWithString(multiplierValue:"\(entity.carNumber!)", multiplicandValue: entity.prefertialPrice!, type: .multiplication, position:2)
                                    totalPirce=PriceComputationsUtil.decimalNumberWithString(multiplierValue:price, multiplicandValue: totalPirce, type:.addition, position: 2)
                                    //计算总数量
                                    selectSumCount+=entity.carNumber!
                                }
                            }
                        }else if entity.flag == 3{
                            if entity.endTime != nil{
                                if Int(entity.endTime!)! > 0{
                                    //计算总价格
                                    let price=PriceComputationsUtil.decimalNumberWithString(multiplierValue:"\(entity.carNumber!)", multiplicandValue: entity.uprice!, type: .multiplication, position:2)
                                    totalPirce=PriceComputationsUtil.decimalNumberWithString(multiplierValue:price, multiplicandValue: totalPirce, type:.addition, position: 2)
                                    //计算总数量
                                    selectSumCount+=entity.carNumber!
                                }
                            }
                        }else{
                            //计算总价格
                            let price=PriceComputationsUtil.decimalNumberWithString(multiplierValue:"\(entity.carNumber!)", multiplicandValue: entity.uprice!, type: .multiplication, position:2)
                            totalPirce=PriceComputationsUtil.decimalNumberWithString(multiplierValue:price, multiplicandValue: totalPirce, type:.addition, position: 2)
                            //计算总数量
                            selectSumCount+=entity.carNumber!
                        }
                    }
                }
                
            }
            switchEditBar()
            //隐藏购物车空提示视图
            nilShoppingCarView!.isHidden=true
            //用于判断当前所有商品是否全部选择 如果有一个为false表示还没有全部选中
            var cellSelectFlag=false
            //获取所有的cell
            for i in 0..<self.arr.count{
                let vo=self.arr[i] as! ShoppingCarVo
                if vo.isSelected == 1{//判断选中按钮是否选中 如果选中cellSelectFlag设为true
                    cellSelectFlag=true;
                }else{//只有有1个为没有选中cellSelectFlag设为false
                    cellSelectFlag=false
                    break
                }
            }
            if cellSelectFlag{//如果为true表示全部选中了
                self.btnCheckAll!.isSelected=true
            }else{
                self.btnCheckAll!.isSelected=false
            }
        }else{//如果没有数据 显示空提示视图
            nilShoppingCarView!.isHidden=false
            //隐藏结算视图
            clearingView!.isHidden=true
            //隐藏编辑按钮
            editBar=nil
            self.navigationItem.rightBarButtonItem=nil
            
        }
        
    }

    /**
     全选
     
     - parameter sender:UIButton
     */
    @objc func checkAll(_ sender:UIButton){
        var isSelected=0
        if sender.isSelected == false{//表示全部选中
            //设置按钮为选中状态
            sender.isSelected=true
            isSelected=1
            
        }else{//表示取消
            sender.isSelected=false
            isSelected=2
            
        }
        for i in 0..<arr.count{
            let vo=arr[i] as! ShoppingCarVo
            vo.isSelected=isSelected
            for j in 0..<vo.listGoods!.count{
                let entity=vo.listGoods![j] as! GoodDetailEntity
                entity.isSelected=isSelected
            }
        }
        if self.btnClearing!.titleLabel!.text == "删除"{
            //改变结算为删除按钮
            self.btnClearing!.setTitle("删除", for: UIControlState())
            self.lblTotalPrice!.text="全选"
        }else{
            totalPriceAndSumCount()
        }
        
        table!.reloadData()
        
    }
    /**
     切换编辑按钮状态
     */
    func switchEditBar(){
        if self.editBar!.title == "编辑"{
            //改变结算按钮状态
            self.btnClearing!.setTitle("去结算(\(self.selectSumCount))", for: UIControlState())
            self.lblTotalPrice!.text="总价:￥\(self.totalPirce)"
        }else{
            //改变结算按钮状态
            self.btnClearing!.setTitle("删除", for: UIControlState())
            self.lblTotalPrice!.text="全选"
        }
    }

    /**
     实现协议方法
     
     - parameter inventory: 库存数量
     - parameter eachCount: 限购数量
     - parameter count:     商品数量
     - parameter flag:      是否特价或者促销 1no 2yes
     */
    func reachALimitPrompt(_ inventory: Int, eachCount: Int?,count:Int,flag:Int) {
        if flag == 2{
            SVProgressHUD.showInfo(withStatus: "库存不足,目前库存为\(inventory)")
        }else{
            if inventory == -1{
                SVProgressHUD.showInfo(withStatus: "限购\(eachCount!)")
            }else{
                if eachCount! > inventory{
                    SVProgressHUD.showInfo(withStatus: "库存不足,目前库存为\(inventory)")
                }else{
                    SVProgressHUD.showInfo(withStatus: "限购\(eachCount!)")
                }
            }
        }
    }
    /**
     计算选择商品的总价格
     - parameter index:      行索引
     */
    func calculationSelectTotalPrice(_ index: IndexPath) {
        isSection(index)
        self.table?.reloadData()
        
    }
    /**
     是否让Section组选中
     
     - parameter index: NSIndexPath
     */
    func isSection(_ index:IndexPath){
        if arr.count > 0{
            let vo=arr[index.section] as! ShoppingCarVo
            if vo.listGoods!.count > 0{
                var isSelected=2
                for i in 0..<vo.listGoods!.count{
                    let goodEntity=vo.listGoods![i] as! GoodDetailEntity
                    if goodEntity.isSelected==1{
                        isSelected=1
                    }else{
                        isSelected=2
                        break
                    }
                }
                vo.isSelected=isSelected
            }
        }
        totalPriceAndSumCount()
    }
    /**
     跳转到结算页面
     
     - parameter sender: UIButton
     */
    @objc func pushOrderView(_ sender:UIButton){
        let orderArr=NSMutableArray()
        for i in 0..<arr.count{//循环所有的数据 判断有无选中的entity
            let vo=arr[i] as! ShoppingCarVo
            var sumMoney:Double=0
            for j in 0..<vo.listGoods!.count{
                let entity=vo.listGoods![j] as! GoodDetailEntity
                if entity.isSelected == 1{//如果有 添加进新集合
                    if entity.flag == 1 {//如果是特价商品
                        if entity.endTime != nil{ //如果剩余时间不等于空
                            if Int(entity.endTime!)! > 0{//如果剩余时间大于0
                                orderArr.add(entity)
                                sumMoney+=(Double(entity.carNumber!)*Double(entity.prefertialPrice!)!)
                            }
                        }else{
                            orderArr.add(entity)
                            sumMoney+=(Double(entity.carNumber!)*Double(entity.prefertialPrice!)!)
                        }
                    }else{//如果不是特价
                        if entity.flag == 3{//如果是促销
                            if Int(entity.endTime!)! > 0{//如果剩余时间大于0
                                orderArr.add(entity)
                                sumMoney+=(Double(entity.carNumber!)*Double(entity.uprice!)!)
                            }
                        }else{
                            orderArr.add(entity)
                            sumMoney+=(Double(entity.carNumber!)*Double(entity.uprice!)!)
                        }
                    }
                }
            }
            if sender.titleLabel!.text != "删除"{
                if vo.lowestMoney != nil{
                    if Double(vo.lowestMoney!)! > sumMoney{//比较最低起送额 是否大于 小计价格
                        UIAlertController.showAlertYesNo(self, title:"点单即到", message:"\(vo.supplierName!)配送最低起送额是\(vo.lowestMoney!),您还需要购买\(Double(vo.lowestMoney!)! - sumMoney)元才能结算", cancelButtonTitle:"知道了", okButtonTitle:"去凑单", okHandler: {   Void in
                            self.showSubSuppingVC(vo)
                            return
                        })
                    }
                }
            }
        }
        if sender.titleLabel!.text == "删除"{
            if orderArr.count > 0{
                self.showSVProgressHUD(status:"正在删除...", type: HUD.textClear)
                request(URL+"deleteShoppingCar.xhtml",method:.post,parameters:["memberId":IS_NIL_MEMBERID()!,"goodsList":toJSONString(orderArr)]).responseJSON{ response in
                    if response.result.error != nil{
                        SVProgressHUD.showError(withStatus: response.result.error!.localizedDescription)
                    }
                    if response.result.value != nil{
                        let json=JSON(response.result.value!)
                        let success=json["success"].stringValue
                        if success == "success"{
                            SVProgressHUD.showSuccess(withStatus: "删除成功")
                            self.editBar?.title="编辑"
                            self.http()

                        }else{
                            SVProgressHUD.showError(withStatus: "删除失败")
                        }
                    }
                }
            }else{
                SVProgressHUD.showInfo(withStatus: "请选择要删除的商品")
            }
        }else{
            if orderArr.count > 0{
                let vc=OrdersViewController()
                vc.arr=orderArr
                vc.totalPirce=Double(self.totalPirce)
                vc.sumCount=self.selectSumCount
                vc.hidesBottomBarWhenPushed=true
                self.navigationController!.pushViewController(vc, animated:true)
            }else{
                SVProgressHUD.showInfo(withStatus: "请选择要下单的商品")
            }
        }
    }
    
    /**
     跳转到配送商城
     
     - parameter sender:
     */
    @objc func pushSubSuppingVC(_ sender:UIButton){
        let entity=arr[sender.tag] as! ShoppingCarVo
        showSubSuppingVC(entity)
    }
    func showSubSuppingVC(_ entity:ShoppingCarVo){
        let vc=GoodCategory3ViewController()
        vc.flag=6
        vc.subSupplierId=entity.supplierId
        vc.subSupplierName=entity.supplierName
        vc.hidesBottomBarWhenPushed=true
        self.navigationController?.pushViewController(vc, animated:true)
    }

}
