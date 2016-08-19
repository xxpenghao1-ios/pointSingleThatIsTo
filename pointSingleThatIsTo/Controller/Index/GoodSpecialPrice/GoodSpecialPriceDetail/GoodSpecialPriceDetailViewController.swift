//
//  GoodSpecialPriceDetailViewController.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/2/24.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import SVProgressHUD
/// 特价商品详情
class GoodSpecialPriceDetailViewController:AddShoppingCartAnimation,UITableViewDataSource,UITableViewDelegate {
    
    /// 接收传入商品名称
    var goodEntity:GoodDetailEntity?
    ///店铺id
    var storeId:String?
    /// 接收商品详情信息
    var goodDeatilEntity:GoodDetailEntity?
    ///可滑动容器
    private var scrollView:UIScrollView?
    /// 商品图片
    private var goodImgView:UIImageView?
    /// 商品view
    private var goodView:UIView?
    /// 商品名称
    private var lblGoodName:UILabel?
    /// 商品现价
    private var lblUprice:UILabel?
    /// 零售价
    private var lblUitemPrice:UILabel?
    /// 商品单位
    private var lblUnit:UILabel?
    /// 商品规格
    private var lblUcode:UILabel?
    /// 加入购物车view
    private var insertShoppingCarView:UIView?
    /// 商品数量加减视图
    private var countView:UIView?
    /// 数量减少按钮
    private var btnReductionCount:UIButton?
    /// 商品数量lbl
    private var lblCountLeb:UILabel?
    /// 数量增加按钮
    private var btnAddCount:UIButton?
    /// 查看购物车按钮
    private var btnSelectShoppingCar:UIButton?
    /// table
    private var table:UITableView?
    /// 数据源
    private var arr=NSMutableArray()
    /// 商品数量
    private var count=1;
    /// 添加的总数量
    private var badgeCount=0
    override func viewDidLoad() {
        super.viewDidLoad()
        //动态显示标题
        self.title=goodEntity!.goodInfoName
        self.view.backgroundColor=UIColor.whiteColor()
        scrollView=UIScrollView(frame:self.view.bounds)
        scrollView!.contentSize=self.view.bounds.size
        self.view.addSubview(scrollView!)
        if IJReachability.isConnectedToNetwork(){
            //构建页面
            buildView()
            //发送商品详情请求
            httpGoodDetail()
        }else{
            SVProgressHUD.showWithStatus("无网络连接")
        }
    }
    
    /**
     构建页面
     */
    func buildView(){
        //设置字体
        let textFont=UIFont.systemFontOfSize(14);
        //文字颜色
        let textColor=UIColor(red:102/255, green:102/255, blue:102/255, alpha:1)
        //导航控制器搜索按钮
        buildNavSearch()
        
        //商品图片
        goodImgView=UIImageView(frame:CGRectMake((boundsWidth-250)/2,10,250,250));
        goodImgView!.sd_setImageWithURL(NSURL(string:URLIMG+goodEntity!.goodPic!), placeholderImage:UIImage(named: "def_nil"))
        self.scrollView!.addSubview(goodImgView!)
        
        //商品view(商品价格信息,名称,规格)
        goodView=UIView(frame:CGRectMake(0,CGRectGetMaxY(goodImgView!.frame),boundsWidth,152))
        goodView!.backgroundColor=UIColor.viewBackgroundColor()
        self.scrollView!.addSubview(goodView!)
        
        /// 4条边线边线
        let border1=UIView(frame:CGRectMake(0,0,boundsWidth,0.5))
        border1.backgroundColor=UIColor.borderColor()
        self.goodView!.addSubview(border1)
        
        let border2=UIView(frame:CGRectMake(0,50.5,boundsWidth,0.5))
        border2.backgroundColor=UIColor.borderColor()
        self.goodView!.addSubview(border2)
        
        let border3=UIView(frame:CGRectMake(0,101,boundsWidth,0.5))
        border3.backgroundColor=UIColor.borderColor()
        self.goodView!.addSubview(border3)
        
        let border4=UIView(frame:CGRectMake(0,151.5,boundsWidth,0.5))
        border4.backgroundColor=UIColor.borderColor()
        self.goodView!.addSubview(border4)
        
        //商品名称
        lblGoodName=UILabel(frame:CGRectMake(15,CGRectGetMaxY(border1.frame)+15,boundsWidth-30,25))
        lblGoodName!.font=textFont
        lblGoodName!.textColor=textColor
        self.goodView!.addSubview(lblGoodName!)
        
        //商品价格
        lblUprice=UILabel(frame:CGRectMake(15,CGRectGetMaxY(border2.frame)+15,(boundsWidth-30)/2,20))
        lblUprice!.textColor=UIColor.textColor()
        lblUprice!.font=textFont
        self.goodView!.addSubview(lblUprice!)
        
        //商品零售价
        lblUitemPrice=UILabel(frame:CGRectMake(CGRectGetMaxX(lblUprice!.frame),CGRectGetMaxY(border2.frame)+15,(boundsWidth-30)/2,20))
        lblUitemPrice!.textColor=textColor
        lblUitemPrice!.font=textFont
        self.goodView!.addSubview(lblUitemPrice!)
        
        //商品单位
        lblUnit=UILabel(frame:CGRectMake(15,CGRectGetMaxY(border3.frame)+15,(boundsWidth-30)/2,20))
        lblUnit!.textColor=textColor
        lblUnit!.font=textFont
        self.goodView!.addSubview(lblUnit!)
        
        //商品规格
        lblUcode=UILabel(frame:CGRectMake(CGRectGetMaxX(lblUprice!.frame),CGRectGetMaxY(border3.frame)+15,(boundsWidth-30)/2,20))
        lblUcode!.textColor=textColor
        lblUcode!.font=textFont
        self.goodView!.addSubview(lblUcode!)
        
        //下面加入购物车视图
        insertShoppingCarView=UIView(frame:CGRectMake(0,boundsHeight-50,boundsWidth,50));
        
        //左边商品加减视图
        let leftView=UIView(frame:CGRectMake(0,0,boundsWidth/2,50))
        leftView.backgroundColor=UIColor(red:32/255, green:32/255, blue:32/255, alpha:1)
        insertShoppingCarView!.addSubview(leftView)
        
        //右边加入购物视图
        let rightView=UIView(frame:CGRectMake(boundsWidth/2,0,boundsWidth/2,50))
        rightView.backgroundColor=UIColor.applicationMainColor();
        rightView.userInteractionEnabled=true
        rightView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:"addShoppingCar:"))
        
        //购物车按钮view
        let charView=UIView(frame:CGRectMake((rightView.frame.width-110)/2,(rightView.frame.height-20)/2,110,20))
        
        //图片
        let charImg=UIImageView(frame:CGRectMake(0,0,20,20))
        charImg.image=UIImage(named:"car")
        charView.addSubview(charImg)
        
        //加入购物车文字
        let lblChar=UILabel(frame:CGRectMake(30,0,80,20))
        lblChar.font=UIFont.boldSystemFontOfSize(14)
        lblChar.textColor=UIColor.whiteColor()
        lblChar.text="加入购物车"
        charView.addSubview(lblChar)
        rightView.addSubview(charView)
        insertShoppingCarView!.addSubview(rightView)
        
        //商品数量加减视图
        countView=UIView(frame:CGRectMake(0,0,132,30));
        countView!.layer.cornerRadius=3
        countView!.layer.masksToBounds=true
        countView!.backgroundColor=UIColor.whiteColor();
        countView!.center=leftView.center
        leftView.addSubview(countView!)
        
        //减号按钮
        let countWidth:CGFloat=40;
        btnReductionCount=UIButton(frame:CGRectMake(0,0,countWidth,countView!.frame.height));
        btnReductionCount!.setTitle("-", forState:.Normal);
        btnReductionCount!.titleLabel!.font=UIFont.systemFontOfSize(22)
        btnReductionCount!.setTitleColor(UIColor(red:204/255, green:204/255, blue:204/255, alpha: 1), forState: UIControlState.Normal)
        btnReductionCount!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        btnReductionCount!.addTarget(self, action:"reductionCount:", forControlEvents: UIControlEvents.TouchUpInside);
        btnReductionCount!.backgroundColor=UIColor.whiteColor()
        countView!.addSubview(btnReductionCount!);
        /// 边线
        let countReductionBorderView=UIView(frame:CGRectMake(countWidth,0,1,30))
        countReductionBorderView.backgroundColor=UIColor(red:180/255, green:180/255, blue:180/255, alpha:1)
        countView!.addSubview(countReductionBorderView)
        
        //数组lab
        lblCountLeb=UILabel(frame:CGRectMake(btnReductionCount!.frame.width+1,0,countWidth+10,countView!.frame.height));
        lblCountLeb!.textColor=UIColor.redColor()
        lblCountLeb!.text="1";
        lblCountLeb!.textAlignment=NSTextAlignment.Center;
        lblCountLeb!.font=UIFont.systemFontOfSize(16);
        countView!.addSubview(lblCountLeb!);
        
        /// 点击商品数量区域 弹出数量选择
        let countLebBtn=UIButton(frame:CGRectMake(btnReductionCount!.frame.width+1,0,countWidth+10,countView!.frame.height))
        countLebBtn.addTarget(self, action:"purchaseCount:", forControlEvents: UIControlEvents.TouchUpInside)
        countView!.addSubview(countLebBtn)
        
        //边线
        let countLebBorderView=UIView(frame:CGRectMake(CGRectGetMaxX(lblCountLeb!.frame),0,1,30))
        countLebBorderView.backgroundColor=UIColor(red:180/255, green:180/255, blue:180/255, alpha:1)
        countView!.addSubview(countLebBorderView)
        
        //加号按钮
        btnAddCount=UIButton(frame:CGRectMake(CGRectGetMaxX(lblCountLeb!.frame)+1,0,countWidth,countView!.frame.height));
        btnAddCount!.backgroundColor=UIColor.whiteColor()
        btnAddCount!.setTitle("+", forState:.Normal);
        btnAddCount!.titleLabel!.font=UIFont.systemFontOfSize(22)
        btnAddCount!.setTitleColor(UIColor(red:204/255, green:204/255, blue:204/255, alpha: 1), forState: UIControlState.Normal)
        btnAddCount!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        btnAddCount!.layer.masksToBounds=true
        btnAddCount!.addTarget(self, action:"addCount:", forControlEvents: UIControlEvents.TouchUpInside);
        countView!.addSubview(btnAddCount!);
        
        //查看购物车按钮
        btnSelectShoppingCar=UIButton(frame:CGRectMake(boundsWidth-75,boundsHeight-50-70,60,60));
        let shoppingCarImg=UIImage(named:"char1");
        
        btnSelectShoppingCar!.addTarget(self, action:"pushShoppingView:", forControlEvents:UIControlEvents.TouchUpInside);
        btnSelectShoppingCar!.setBackgroundImage(shoppingCarImg, forState:.Normal);
        btnSelectShoppingCar!.hidden=true
        self.view.addSubview(btnSelectShoppingCar!)
        insertShoppingCarView!.hidden=true
        self.view.addSubview(insertShoppingCarView!);
        
        
    }
    /**
     构建table
     */
    func buildTable(){
        //table
        table=UITableView(frame:CGRectMake(0,CGRectGetMaxY(goodView!.frame),boundsWidth,350), style: UITableViewStyle.Plain)
        table!.dataSource=self
        table!.delegate=self
        table!.scrollEnabled=false
        self.scrollView!.addSubview(table!)
        
        if CGRectGetMaxY(table!.frame) > boundsHeight-64-50{//如果结束边线的最大Y值大于屏幕高度-64-加入购车层的高度  设置可滑动容器的范围为结束边线最大Y值
            
            //设置滑动容器滚动范围
            self.scrollView!.contentSize=CGSizeMake(boundsWidth,CGRectGetMaxY(table!.frame)+50)
        }else{//否  直接设置滚动范围为屏幕范围
            //设置滑动容器滚动范围
            self.scrollView!.contentSize=CGSizeMake(boundsWidth,boundsHeight-64-50)
        }
        //设置cell下边线全屏
        if(table!.respondsToSelector("setLayoutMargins:")){
            table?.layoutMargins=UIEdgeInsetsZero
        }
        if(table!.respondsToSelector("setSeparatorInset:")){
            table!.separatorInset=UIEdgeInsetsZero;
        }
        
    }
    //展示每行cell数据
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //设置cell下边线全屏
        
        
        let cellId="cellid"
        var cell=table!.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil{
            cell=UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier:cellId)
            cell!.selectionStyle=UITableViewCellSelectionStyle.None;
        }
        if(cell!.respondsToSelector("setLayoutMargins:")){
            cell?.layoutMargins=UIEdgeInsetsZero
        }
        if(cell!.respondsToSelector("setSeparatorInset:")){
            cell!.separatorInset=UIEdgeInsetsZero;
        }
        //名称
        let name=UILabel(frame:CGRectMake(15,15,70,20))
        name.textColor=UIColor(red:102/255, green:102/255, blue:102/255, alpha:1)
        name.font=UIFont.systemFontOfSize(14)
        cell!.contentView.addSubview(name)
        
        //名称对应的值
        let nameValue=UILabel(frame:CGRectMake(CGRectGetMaxX(name.frame),15,boundsWidth-30,20))
        nameValue.textColor=UIColor(red:102/255, green:102/255, blue:102/255, alpha:1)
        nameValue.font=UIFont.systemFontOfSize(14)
        
        //促销活动vlaue
        let promotionsValue=UILabel(frame:CGRectMake(CGRectGetMaxX(name.frame),15,boundsWidth-CGRectGetMaxX(name.frame)-40,20))
        promotionsValue.textColor=UIColor.applicationMainColor()
        promotionsValue.font=UIFont.systemFontOfSize(14)
        
        //查看供应商
        let btnPushSupplier=UIButton(frame:CGRectMake(CGRectGetMaxX(name.frame),10,100,30))
        btnPushSupplier.backgroundColor=UIColor.applicationMainColor()
        btnPushSupplier.layer.cornerRadius=10
        btnPushSupplier.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        //        btnPushSupplier.addTarget(self, action:"pushSupplierView:", forControlEvents: UIControlEvents.TouchUpInside)
        btnPushSupplier.titleLabel!.font=UIFont.systemFontOfSize(13)
        
        switch indexPath.row{
        case 0:
            name.text="促销活动 : "
            if self.goodDeatilEntity?.goodsDes != nil{
                promotionsValue.text=self.goodDeatilEntity!.goodsDes
                cell!.accessoryType=UITableViewCellAccessoryType.DisclosureIndicator
            }else{
                promotionsValue.text="无"
            }
            
            cell!.contentView.addSubview(promotionsValue)
            break
        case 1:
            name.text="库存 : "
            if self.goodDeatilEntity?.goodsStock != nil{
                if self.goodDeatilEntity?.goodsStock == -1{
                    nameValue.text="库存充足"
                }else{
                    nameValue.text="\(self.goodDeatilEntity!.goodsStock!)"
                }
                cell!.contentView.addSubview(nameValue)
            }
            break
        case 2:
            name.text="最低配送 : "
            if self.goodDeatilEntity?.miniCount != nil && self.goodDeatilEntity?.goodsBaseCount != nil{
                
                nameValue.text="\(self.goodDeatilEntity!.miniCount!) (每次商品加减数量为\(self.goodDeatilEntity!.goodsBaseCount!))"
                
            }else{
                nameValue.text="1 (每次商品加减数量为1)"
            }
            cell!.contentView.addSubview(nameValue)
            break
        case 3:
            name.text="服务说明 :"
            if self.goodDeatilEntity?.goodService != nil{
                nameValue.text=self.goodDeatilEntity!.goodService
            }else{
                nameValue.text="无"
            }
            cell!.contentView.addSubview(nameValue)
            break
        case 4:
            name.text="供应商 :"
            //根据供应商名称长度设置按钮宽度
            let lblSupplierName=UILabel()
            if self.goodDeatilEntity?.supplierName != nil{
                lblSupplierName.text=self.goodDeatilEntity!.supplierName
            }else{
                lblSupplierName.text="该商品无供应商"
            }
            lblSupplierName.font=UIFont.systemFontOfSize(13)
            let size=lblSupplierName.text!.textSizeWithFont(lblSupplierName.font, constrainedToSize:CGSizeMake(boundsWidth-CGRectGetMaxX(name.frame)-15,20))
            btnPushSupplier.frame=CGRectMake(CGRectGetMaxX(name.frame),10,size.width+20,30)
            btnPushSupplier.setTitle(lblSupplierName.text,forState: UIControlState.Normal)
            cell!.contentView.addSubview(btnPushSupplier)
            
            break
        case 5:
            name.text="条码 :"
            if self.goodDeatilEntity?.goodInfoCode != nil{
                nameValue.text=self.goodDeatilEntity!.goodInfoCode
            }else{
                nameValue.text="无"
            }
            cell!.contentView.addSubview(nameValue)
            break
        case 6:
            name.text="保质期 :"
            if self.goodDeatilEntity?.goodLife != nil{
                nameValue.text=self.goodDeatilEntity!.goodLife
            }else{
                nameValue.text="无"
            }
            cell!.contentView.addSubview(nameValue)
            break
        default:
            break
        }
        return cell!
        
    }
    //返回tabview的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 7
    }
    //返回tabview的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 50;
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row{
        case 0:
            if self.goodDeatilEntity!.goodsDes != nil && self.goodDeatilEntity!.goodsDes != "无"{
                let vc=GoodDetailPromotionsDetailView()
                vc.str=self.goodDeatilEntity!.goodsDes
                self.navigationController!.pushViewController(vc, animated: true)
            }
            
            break
        default:
            break
        }
    }

    /**
     导航控制器搜索按钮
     */
    func buildNavSearch(){
        let searchBtn=UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.Search, target:self, action:"pushSearchView");
        self.navigationItem.rightBarButtonItem=searchBtn;
    }
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}
// MARK: - 页面逻辑
extension GoodSpecialPriceDetailViewController{
    /**
     增加商品数量
     
     - parameter sender: UIButton
     */
    func addCount(sender:UIButton){
        if self.goodDeatilEntity!.goodsStock == -1{//如果充足
            if count > self.goodDeatilEntity!.eachCount!-self.goodDeatilEntity!.goodsBaseCount!{//商品数量不能大于限购数-商品加减数量
                lblCountLeb!.textColor=UIColor.textColor()
            }else{
                count+=self.goodDeatilEntity!.goodsBaseCount!
                lblCountLeb!.text="\(count)"
            }
            
        }else{
            if self.goodDeatilEntity!.eachCount! > self.goodDeatilEntity!.goodsStock!{//限购数大于库存数
                if count > self.goodDeatilEntity!.goodsStock!-self.goodDeatilEntity!.goodsBaseCount!{//商品数量不能大于库存数-商品加减数量
                    lblCountLeb!.textColor=UIColor.textColor()
                }else{
                    count+=self.goodDeatilEntity!.goodsBaseCount!
                    lblCountLeb!.text="\(count)"
                }
            }else{
                if count > self.goodDeatilEntity!.eachCount!-self.goodDeatilEntity!.goodsBaseCount!{//商品数量不能大于限购数-商品加减数量
                    lblCountLeb!.textColor=UIColor.textColor()
                }else{
                    count+=self.goodDeatilEntity!.goodsBaseCount!
                    lblCountLeb!.text="\(count)"
                }
            }
        }
    }
    /**
     减少商品数量
     
     - parameter sender: UIButton
     */
    func reductionCount(sender:UIButton){
        if count > self.goodDeatilEntity!.miniCount!{
            count-=self.goodDeatilEntity!.goodsBaseCount!
            lblCountLeb!.textColor=UIColor.redColor()
            lblCountLeb!.text="\(count)"
        }
    }
    /**
     弹出数量选择
     
     - parameter sender:UIButton
     */
    func purchaseCount(sender:UIButton){
        let alertController = UIAlertController(title:nil, message:"输入您要购买的数量", preferredStyle: UIAlertControllerStyle.Alert);
        alertController.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
            textField.keyboardType=UIKeyboardType.NumberPad
            if self.goodDeatilEntity!.goodsStock == -1{//判断库存 等于-1 表示库存充足 由于UI大小最多显示3位数
                
                textField.placeholder="请输入\(self.goodDeatilEntity!.miniCount!)~\(self.goodDeatilEntity!.eachCount!)之间\(self.goodDeatilEntity!.goodsBaseCount!)的倍数"
                textField.tag=self.goodDeatilEntity!.eachCount!
            }else{
                if self.goodDeatilEntity!.eachCount! > self.goodDeatilEntity!.goodsStock{//如果限购数大于库存数
                    textField.placeholder = "请输入(self.goodDeatilEntity!.miniCount!)~\(self.goodDeatilEntity!.goodsStock!)之间\(self.goodDeatilEntity!.goodsBaseCount!)的倍数"
                    textField.tag=self.goodDeatilEntity!.goodsStock!
                }else{
                    textField.placeholder = "请输入\(self.goodDeatilEntity!.miniCount!)~\(self.goodDeatilEntity!.eachCount!)之间\(self.goodDeatilEntity!.goodsBaseCount!)的倍数"
                    textField.tag=self.goodDeatilEntity!.eachCount!
                }
            }
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("alertTextFieldDidChange:"), name: UITextFieldTextDidChangeNotification, object: textField)
        }
        //确定
        let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default,handler:{ Void in
            
            let text=(alertController.textFields?.first)! as UITextField
            self.count=Int(text.text!)!
            self.lblCountLeb!.text=text.text
        })
        //取消
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        okAction.enabled = false
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    //检测输入框的字符是否大于库存数量 是解锁确定按钮
    func alertTextFieldDidChange(notification: NSNotification){
        let alertController = self.presentedViewController as! UIAlertController?
        if (alertController != nil) {
            let text = (alertController!.textFields?.first)! as UITextField
            let okAction = alertController!.actions.last! as UIAlertAction
            if text.text?.characters.count > 0{
                okAction.enabled = Int(text.text!)! % self.goodDeatilEntity!.goodsBaseCount! == 0 && Int(text.text!)! <= text.tag && Int(text.text!) >= self.goodDeatilEntity!.miniCount!
            }else{
                okAction.enabled=false
            }
            
        }
    }
    /**
     加入购物车
     
     - parameter sender:UIButton
     */
    func addShoppingCar(sender:UIButton){
        //拿到会员id
        let memberId=NSUserDefaults.standardUserDefaults().objectForKey("memberId") as! String
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.insertShoppingCar(memberId: memberId, goodId: self.goodDeatilEntity!.goodsbasicinfoId!, supplierId: self.goodDeatilEntity!.supplierId!, subSupplierId: self.goodDeatilEntity!.subSupplier!, goodsCount: count, flag: 1, goodsStock:self.goodDeatilEntity!.goodsStock!), successClosure: { (result) -> Void in
            let json=JSON(result)
            let success=json["success"].stringValue
            if success == "success"{
                //执行加入购车动画效果
                self.shoppingCharAnimation()
            }else if success == "tjxgbz"{
                SVProgressHUD.showInfoWithStatus("已超过该商品限购数")
            }else if success == "tjbz"{
                SVProgressHUD.showInfoWithStatus("已超过该商品库存数")
            }else if success == "zcbz"{
                SVProgressHUD.showInfoWithStatus("已超过该商品库存数")
            }else{
                SVProgressHUD.showErrorWithStatus("加入失败")
            }

            }) { (errorMsg) -> Void in
                SVProgressHUD.showErrorWithStatus(errorMsg)
        }
    }
    
    /**
     加入购物车动画效果
     */
    func shoppingCharAnimation(){
        var rect=goodImgView!.frame
        rect.origin.y=rect.origin.y-self.scrollView!.contentOffset.y
        var headRect=goodImgView!.frame
        headRect.origin.y=rect.origin.y+headRect.origin.y
        self.button=self.btnSelectShoppingCar
        self.startAnimationWithRect(headRect, imageView:goodImgView!,isGoodDetail:1);
        //每次加
        self.badgeCount+=count
        //显示添加过的值
        self.btnSelectShoppingCar!.badgeValue="\(self.badgeCount)"
        //发送通知更新角标
        NSNotificationCenter.defaultCenter().postNotificationName("postBadgeValue", object:2, userInfo:["carCount":count])
    }
    
}
// MARK: - 网络请求
extension GoodSpecialPriceDetailViewController{
    /**
     发送商品详情请求
     */
    func httpGoodDetail(){
        SVProgressHUD.showWithStatus("数据加载中")
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryGoodsDetailsForAndroid(goodsbasicinfoId: goodEntity!.goodsbasicinfoId!, supplierId: goodEntity!.supplierId!, flag: 1, storeId: storeId!, aaaa: 11, subSupplier: goodEntity!.subSupplier!), successClosure: { (result) -> Void in
            SVProgressHUD.dismiss()
            let json=JSON(result)
            self.goodDeatilEntity=Mapper<GoodDetailEntity>().map(json.object)
            self.goodDeatilEntity!.preferentialPrice=json["prefertialPrice"].stringValue
            // 如果库存为空 默认给-1 表示库存充足
            if self.goodDeatilEntity!.goodsStock == nil{
                self.goodDeatilEntity!.goodsStock = -1
            }
            //最低配送量
            if self.goodDeatilEntity!.miniCount == nil{
                self.goodDeatilEntity!.miniCount = 1
            }
            //商品加减数量
            if self.goodDeatilEntity!.goodsBaseCount == nil{
                self.goodDeatilEntity!.goodsBaseCount=1
            }
            self.goodDeatilEntity!.flag=1
            self.count=self.goodDeatilEntity!.miniCount!
            //设置商品最低起送量
            self.lblCountLeb!.text="\(self.count)"
            //解析到数据更新各个lbl的值
            
            //商品名称
            self.lblGoodName!.text=self.goodDeatilEntity!.goodInfoName
            
            //商品现价
            if self.goodDeatilEntity!.preferentialPrice != nil{
                self.lblUprice!.text="进价 : ￥\(self.goodDeatilEntity!.preferentialPrice!)"
            }
            
            //商品零售价
            if self.goodDeatilEntity!.uitemPrice != nil{
                self.lblUitemPrice!.text="零售价 : \(self.goodDeatilEntity!.uitemPrice!)"
            }else{
                self.lblUitemPrice!.text="零售价 : 无"
            }
            
            if self.goodDeatilEntity!.goodUnit != nil{
                //商品单位
                self.lblUnit!.text="单位 : \(self.goodDeatilEntity!.goodUnit!)"
            }else{
                //商品单位
                self.lblUnit!.text="单位 : 无"
            }
            
            //商品规格
            if self.goodDeatilEntity!.ucode != nil{
                self.lblUcode!.text="规格 : \(self.goodDeatilEntity!.ucode!)"
            }else{
                self.lblUcode!.text="规格 : 无"
            }
            //如果有数据构建table
            self.buildTable()
            self.btnSelectShoppingCar!.hidden=false
            self.insertShoppingCarView!.hidden=false
            }) { (errorMsg) -> Void in
                SVProgressHUD.showErrorWithStatus(errorMsg)
        }
    }

}
// MARK: - 页面跳转
extension GoodSpecialPriceDetailViewController{
    /**
     跳转搜索页面
     */
    func pushSearchView(){
        let vc=SearchViewController();
        vc.hidesBottomBarWhenPushed=true;
        self.navigationController?.pushViewController(vc, animated:true);
    }
    /**
     跳转到购物车中
     
     - parameter sender:UIButton
     */
    func pushShoppingView(sender:UIButton){
        let vc=ShoppingCarViewContorller()
        vc.hidesBottomBarWhenPushed=true
        self.navigationController!.pushViewController(vc, animated:true)
    }
}