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

/// 特价/促销商品详情
class GoodSpecialPriceDetailViewController:AddShoppingCartAnimation,UITableViewDataSource,UITableViewDelegate {
    
    /// 接收传入entity
    var goodEntity:GoodDetailEntity?
    ///店铺id
    var storeId:String?
    /// 接收商品详情信息
    var goodDeatilEntity:GoodDetailEntity?
    //1特价,3促销
    var flag:Int?
    ///可滑动容器
    fileprivate var scrollView:UIScrollView?
    /// 商品图片
    fileprivate var goodImgView:UIImageView?
    /// 商品view
    fileprivate var goodView:UIView?
    /// 商品名称
    fileprivate var lblGoodName:UILabel?
    /// 商品现价
    fileprivate var lblUprice:UILabel?
    /// 零售价
    fileprivate var lblUitemPrice:UILabel?
    /// 商品单位
    fileprivate var lblUnit:UILabel?
    /// 商品规格
    fileprivate var lblUcode:UILabel?
    /// 加入购物车view
    fileprivate var insertShoppingCarView:UIView?
    /// 商品数量加减视图
    fileprivate var countView:UIView?
    /// 数量减少按钮
    fileprivate var btnReductionCount:UIButton?
    /// 商品数量lbl
    fileprivate var lblCountLeb:UILabel?
    /// 数量增加按钮
    fileprivate var btnAddCount:UIButton?
    /// 查看购物车按钮
    fileprivate var btnSelectShoppingCar:UIButton?
    /// table
    fileprivate var table:UITableView?
    /// 数据源
    fileprivate var arr=NSMutableArray()
    /// 商品数量
    fileprivate var count=1;
    /// 添加的总数量
    fileprivate var badgeCount=0
    override func viewDidLoad() {
        super.viewDidLoad()
        //动态显示标题
        self.title=goodEntity!.goodInfoName
        self.view.backgroundColor=UIColor.white
        scrollView=UIScrollView(frame:self.view.bounds)
        scrollView!.contentSize=self.view.bounds.size
        self.view.addSubview(scrollView!)
        
            //构建页面
            buildView()
            //发送商品详情请求
            httpGoodDetail()
    }
    
    /**
     构建页面
     */
    func buildView(){
        //设置字体
        let textFont=UIFont.systemFont(ofSize: 14);
        //文字颜色
        let textColor=UIColor(red:102/255, green:102/255, blue:102/255, alpha:1)
        //导航控制器搜索按钮
        buildNavSearch()
        
        //商品图片
        goodImgView=UIImageView(frame:CGRect(x: (boundsWidth-250)/2,y: 10,width: 250,height: 250));
        goodEntity!.goodPic=goodEntity!.goodPic ?? ""
        goodImgView!.sd_setImage(with: Foundation.URL(string:URLIMG+goodEntity!.goodPic!), placeholderImage:UIImage(named: "def_nil"))
        self.scrollView!.addSubview(goodImgView!)
        
        //商品view(商品价格信息,名称,规格)
        goodView=UIView(frame:CGRect(x: 0,y: goodImgView!.frame.maxY,width: boundsWidth,height: 152))
        goodView!.backgroundColor=UIColor.viewBackgroundColor()
        self.scrollView!.addSubview(goodView!)
        
        /// 4条边线边线
        let border1=UIView(frame:CGRect(x: 0,y: 0,width: boundsWidth,height: 0.5))
        border1.backgroundColor=UIColor.borderColor()
        self.goodView!.addSubview(border1)
        
        let border2=UIView(frame:CGRect(x: 0,y: 50.5,width: boundsWidth,height: 0.5))
        border2.backgroundColor=UIColor.borderColor()
        self.goodView!.addSubview(border2)
        
        let border3=UIView(frame:CGRect(x: 0,y: 101,width: boundsWidth,height: 0.5))
        border3.backgroundColor=UIColor.borderColor()
        self.goodView!.addSubview(border3)
        
        let border4=UIView(frame:CGRect(x: 0,y: 151.5,width: boundsWidth,height: 0.5))
        border4.backgroundColor=UIColor.borderColor()
        self.goodView!.addSubview(border4)
        
        //商品名称
        lblGoodName=UILabel(frame:CGRect(x: 15,y: border1.frame.maxY+15,width: boundsWidth-30,height: 25))
        lblGoodName!.font=textFont
        lblGoodName!.textColor=textColor
        self.goodView!.addSubview(lblGoodName!)
        
        //商品价格
        lblUprice=UILabel(frame:CGRect(x: 15,y: border2.frame.maxY+15,width: (boundsWidth-30)/2,height: 20))
        lblUprice!.textColor=UIColor.textColor()
        lblUprice!.font=textFont
        self.goodView!.addSubview(lblUprice!)
        
        //商品零售价
        lblUitemPrice=UILabel(frame:CGRect(x: lblUprice!.frame.maxX,y: border2.frame.maxY+15,width: (boundsWidth-30)/2,height: 20))
        lblUitemPrice!.textColor=textColor
        lblUitemPrice!.font=textFont
        self.goodView!.addSubview(lblUitemPrice!)
        
        //商品单位
        lblUnit=UILabel(frame:CGRect(x: 15,y: border3.frame.maxY+15,width: (boundsWidth-30)/2,height: 20))
        lblUnit!.textColor=textColor
        lblUnit!.font=textFont
        self.goodView!.addSubview(lblUnit!)
        
        //商品规格
        lblUcode=UILabel(frame:CGRect(x: lblUprice!.frame.maxX,y: border3.frame.maxY+15,width: (boundsWidth-30)/2,height: 20))
        lblUcode!.textColor=textColor
        lblUcode!.font=textFont
        self.goodView!.addSubview(lblUcode!)
        
        //下面加入购物车视图
        insertShoppingCarView=UIView(frame:CGRect(x: 0,y: boundsHeight-50,width: boundsWidth,height: 50));
        
        //左边商品加减视图
        let leftView=UIView(frame:CGRect(x: 0,y: 0,width: boundsWidth/2,height: 50))
        leftView.backgroundColor=UIColor(red:32/255, green:32/255, blue:32/255, alpha:1)
        insertShoppingCarView!.addSubview(leftView)
        
        //右边加入购物视图
        let rightView=UIView(frame:CGRect(x: boundsWidth/2,y: 0,width: boundsWidth/2,height: 50))
        rightView.backgroundColor=UIColor.applicationMainColor();
        rightView.isUserInteractionEnabled=true
        rightView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:Selector("addShoppingCar:")))
        
        //购物车按钮view
        let charView=UIView(frame:CGRect(x: (rightView.frame.width-110)/2,y: (rightView.frame.height-20)/2,width: 110,height: 20))
        
        //图片
        let charImg=UIImageView(frame:CGRect(x: 0,y: 0,width: 20,height: 20))
        charImg.image=UIImage(named:"car")
        charView.addSubview(charImg)
        
        //加入购物车文字
        let lblChar=UILabel(frame:CGRect(x: 30,y: 0,width: 80,height: 20))
        lblChar.font=UIFont.boldSystemFont(ofSize: 14)
        lblChar.textColor=UIColor.white
        lblChar.text="加入购物车"
        charView.addSubview(lblChar)
        rightView.addSubview(charView)
        insertShoppingCarView!.addSubview(rightView)
        
        //商品数量加减视图
        countView=UIView(frame:CGRect(x: 0,y: 0,width: 132,height: 30));
        countView!.layer.cornerRadius=3
        countView!.layer.masksToBounds=true
        countView!.backgroundColor=UIColor.white;
        countView!.center=leftView.center
        leftView.addSubview(countView!)
        
        //减号按钮
        let countWidth:CGFloat=40;
        btnReductionCount=UIButton(frame:CGRect(x: 0,y: 0,width: countWidth,height: countView!.frame.height));
        btnReductionCount!.setTitle("-", for:UIControlState());
        btnReductionCount!.titleLabel!.font=UIFont.systemFont(ofSize: 22)
        btnReductionCount!.setTitleColor(UIColor(red:204/255, green:204/255, blue:204/255, alpha: 1), for: UIControlState())
        btnReductionCount!.setTitleColor(UIColor.white, for: UIControlState.highlighted)
        btnReductionCount!.addTarget(self, action:Selector("reductionCount:"), for: UIControlEvents.touchUpInside);
        btnReductionCount!.backgroundColor=UIColor.white
        countView!.addSubview(btnReductionCount!);
        /// 边线
        let countReductionBorderView=UIView(frame:CGRect(x: countWidth,y: 0,width: 1,height: 30))
        countReductionBorderView.backgroundColor=UIColor(red:180/255, green:180/255, blue:180/255, alpha:1)
        countView!.addSubview(countReductionBorderView)
        
        //数组lab
        lblCountLeb=UILabel(frame:CGRect(x: btnReductionCount!.frame.width+1,y: 0,width: countWidth+10,height: countView!.frame.height));
        lblCountLeb!.textColor=UIColor.red
        lblCountLeb!.text="1";
        lblCountLeb!.textAlignment=NSTextAlignment.center;
        lblCountLeb!.font=UIFont.systemFont(ofSize: 16);
        countView!.addSubview(lblCountLeb!);
        
        /// 点击商品数量区域 弹出数量选择
        let countLebBtn=UIButton(frame:CGRect(x: btnReductionCount!.frame.width+1,y: 0,width: countWidth+10,height: countView!.frame.height))
        countLebBtn.addTarget(self, action:Selector("purchaseCount:"), for: UIControlEvents.touchUpInside)
        countView!.addSubview(countLebBtn)
        
        //边线
        let countLebBorderView=UIView(frame:CGRect(x: lblCountLeb!.frame.maxX,y: 0,width: 1,height: 30))
        countLebBorderView.backgroundColor=UIColor(red:180/255, green:180/255, blue:180/255, alpha:1)
        countView!.addSubview(countLebBorderView)
        
        //加号按钮
        btnAddCount=UIButton(frame:CGRect(x: lblCountLeb!.frame.maxX+1,y: 0,width: countWidth,height: countView!.frame.height));
        btnAddCount!.backgroundColor=UIColor.white
        btnAddCount!.setTitle("+", for:UIControlState());
        btnAddCount!.titleLabel!.font=UIFont.systemFont(ofSize: 22)
        btnAddCount!.setTitleColor(UIColor(red:204/255, green:204/255, blue:204/255, alpha: 1), for: UIControlState())
        btnAddCount!.setTitleColor(UIColor.white, for: UIControlState.highlighted)
        btnAddCount!.layer.masksToBounds=true
        btnAddCount!.addTarget(self, action:Selector("addCount:"), for: UIControlEvents.touchUpInside);
        countView!.addSubview(btnAddCount!);
        
        //查看购物车按钮
        btnSelectShoppingCar=UIButton(frame:CGRect(x: boundsWidth-75,y: boundsHeight-50-70,width: 60,height: 60));
        let shoppingCarImg=UIImage(named:"char1");
        
        btnSelectShoppingCar!.addTarget(self, action:Selector("pushShoppingView:"), for:UIControlEvents.touchUpInside);
        btnSelectShoppingCar!.setBackgroundImage(shoppingCarImg, for:UIControlState());
        btnSelectShoppingCar!.isHidden=true
        self.view.addSubview(btnSelectShoppingCar!)
        insertShoppingCarView!.isHidden=true
        self.view.addSubview(insertShoppingCarView!);
        
        
    }
    /**
     构建table
     */
    func buildTable(){
        //table
        if self.goodDeatilEntity?.returnGoodsFlag == 3{
            table=UITableView(frame:CGRect(x: 0,y: goodView!.frame.maxY,width: boundsWidth,height: 400), style: UITableViewStyle.plain)
        }
        else{
            table=UITableView(frame:CGRect(x: 0,y: goodView!.frame.maxY,width: boundsWidth,height: 450), style: UITableViewStyle.plain)
        }
        table!.dataSource=self
        table!.delegate=self
        table!.isScrollEnabled=false
        self.scrollView!.addSubview(table!)
            
        
        if table!.frame.maxY > boundsHeight-64-50{//如果结束边线的最大Y值大于屏幕高度-64-加入购车层的高度  设置可滑动容器的范围为结束边线最大Y值
            
            //设置滑动容器滚动范围
            self.scrollView!.contentSize=CGSize(width: boundsWidth,height: table!.frame.maxY+50)
        }else{//否  直接设置滚动范围为屏幕范围
            //设置滑动容器滚动范围
            self.scrollView!.contentSize=CGSize(width: boundsWidth,height: boundsHeight-64-50)
        }
        //设置cell下边线全屏
        if(table!.responds(to: #selector(setter: UIView.layoutMargins))){
            table?.layoutMargins=UIEdgeInsets.zero
        }
        if(table!.responds(to: #selector(setter: UITableViewCell.separatorInset))){
            table!.separatorInset=UIEdgeInsets.zero;
        }
        
    }
    //展示每行cell数据
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //设置cell下边线全屏
        
        
        let cellId="cellid"
        var cell=table!.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil{
            cell=UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:cellId)
            cell!.selectionStyle=UITableViewCellSelectionStyle.none;
        }
        if(cell!.responds(to: #selector(setter: UIView.layoutMargins))){
            cell?.layoutMargins=UIEdgeInsets.zero
        }
        if(cell!.responds(to: #selector(setter: UITableViewCell.separatorInset))){
            cell!.separatorInset=UIEdgeInsets.zero;
        }
        //名称
        let name=UILabel(frame:CGRect(x: 15,y: 15,width: 70,height: 20))
        name.textColor=UIColor(red:102/255, green:102/255, blue:102/255, alpha:1)
        name.font=UIFont.systemFont(ofSize: 14)
        cell!.contentView.addSubview(name)
        
        //名称对应的值
        let nameValue=UILabel(frame:CGRect(x: name.frame.maxX,y: 15,width: boundsWidth-30,height: 20))
        nameValue.textColor=UIColor(red:102/255, green:102/255, blue:102/255, alpha:1)
        nameValue.font=UIFont.systemFont(ofSize: 14)
        
        //促销活动vlaue
        let promotionsValue=UILabel(frame:CGRect(x: name.frame.maxX,y: 15,width: boundsWidth-name.frame.maxX-40,height: 20))
        promotionsValue.textColor=UIColor.applicationMainColor()
        promotionsValue.font=UIFont.systemFont(ofSize: 14)
        
        //查看配送商
        let btnPushSupplier=UIButton(frame:CGRect(x: name.frame.maxX,y: 10,width: 100,height: 30))
        btnPushSupplier.backgroundColor=UIColor.applicationMainColor()
        btnPushSupplier.layer.cornerRadius=10
        btnPushSupplier.setTitleColor(UIColor.white, for: UIControlState())
        btnPushSupplier.addTarget(self, action:Selector("showSubSuppingVC"), for: UIControlEvents.touchUpInside)
        btnPushSupplier.titleLabel!.font=UIFont.systemFont(ofSize: 13)
        
        switch indexPath.row{
        case 0:
            if flag == 1{
                name.text="该商品正在打特价!"
                name.frame=CGRect(x: 15,y: 15,width: 200,height: 20)
                name.textColor=UIColor.applicationMainColor()
            }else{
                name.text="促销活动 : "
                if self.goodDeatilEntity?.goodsDes != nil{
                    promotionsValue.text=self.goodDeatilEntity!.goodsDes
                    cell!.accessoryType=UITableViewCellAccessoryType.disclosureIndicator
                }else{
                    promotionsValue.text="无"
                }
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
            name.text="限购 : "
            if self.goodDeatilEntity?.eachCount != nil{
                nameValue.text="\(self.goodDeatilEntity!.eachCount!)"+(self.goodDeatilEntity?.goodUnit!)!
            }
            cell!.contentView.addSubview(nameValue)
            break
        case 3:
            name.text="最低配送 : "
            if self.goodDeatilEntity?.miniCount != nil && self.goodDeatilEntity?.goodsBaseCount != nil{
                
                nameValue.text="\(self.goodDeatilEntity!.miniCount!) (每次商品加减数量为\(self.goodDeatilEntity!.goodsBaseCount!))"
                
            }else{
                nameValue.text="1 (每次商品加减数量为1)"
            }
            cell!.contentView.addSubview(nameValue)
            break
        case 4:
            name.text="服务说明 :"
            if self.goodDeatilEntity?.goodService != nil{
                nameValue.text=self.goodDeatilEntity!.goodService
            }else{
                nameValue.text="无"
            }
            cell!.contentView.addSubview(nameValue)
            break
        case 5:
            name.text="配送商 :"
            //根据供应商名称长度设置按钮宽度
            let lblSupplierName=UILabel()
            if self.goodDeatilEntity?.supplierName != nil{
                lblSupplierName.text=self.goodDeatilEntity!.supplierName
            }else{
                lblSupplierName.text="该商品无配送商"
            }
            lblSupplierName.font=UIFont.systemFont(ofSize: 13)
            let size=lblSupplierName.text!.textSizeWithFont(lblSupplierName.font, constrainedToSize:CGSize(width: boundsWidth-name.frame.maxX-15,height: 20))
            btnPushSupplier.frame=CGRect(x: name.frame.maxX,y: 10,width: size.width+20,height: 30)
            btnPushSupplier.setTitle(lblSupplierName.text,for: UIControlState())
            cell!.contentView.addSubview(btnPushSupplier)
            
            break
        case 6:
            name.text="条码 :"
            if self.goodDeatilEntity?.goodInfoCode != nil{
                nameValue.text=self.goodDeatilEntity!.goodInfoCode
            }else{
                nameValue.text="无"
            }
            cell!.contentView.addSubview(nameValue)
            break
        case 7:
            name.text="保质期 :"
            if self.goodDeatilEntity?.goodLife != nil{
                nameValue.text=self.goodDeatilEntity!.goodLife
            }else{
                nameValue.text="无"
            }
            cell!.contentView.addSubview(nameValue)
            break
        case 8:
            name.text="是否可退 : "
            if self.goodDeatilEntity?.returnGoodsFlag != nil{
                if self.goodDeatilEntity?.returnGoodsFlag == 1{
                    nameValue.text="该商品可退换"
                }else if self.goodDeatilEntity?.returnGoodsFlag == 2{
                    nameValue.text="该商品不可退换"
                }
            }
            cell!.contentView.addSubview(nameValue)
            break
        default:
            break
        }
        return cell!
        
    }
    //返回tabview的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if self.goodDeatilEntity?.returnGoodsFlag == 3{
            return 8
        }else{
            return 9
        }
    }
    //返回tabview的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 50;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        let searchBtn=UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.search, target:self, action:Selector("pushSearchView"));
        self.navigationItem.rightBarButtonItem=searchBtn;
    }
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
}
// MARK: - 页面逻辑
extension GoodSpecialPriceDetailViewController{
    /**
     增加商品数量
     
     - parameter sender: UIButton
     */
    func addCount(_ sender:UIButton){
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
    func reductionCount(_ sender:UIButton){
        if count > self.goodDeatilEntity!.miniCount!{
            count-=self.goodDeatilEntity!.goodsBaseCount!
            lblCountLeb!.textColor=UIColor.red
            lblCountLeb!.text="\(count)"
        }
    }
    /**
     弹出数量选择
     
     - parameter sender:UIButton
     */
    func purchaseCount(_ sender:UIButton){
        let alertController = UIAlertController(title:nil, message:"输入您要购买的数量", preferredStyle: UIAlertControllerStyle.alert);
        alertController.addTextField {
            (textField: UITextField!) -> Void in
            textField.keyboardType=UIKeyboardType.numberPad
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
            NotificationCenter.default.addObserver(self, selector: Selector(("alertTextFieldDidChange:")), name: NSNotification.Name.UITextFieldTextDidChange, object: textField)
        }
        //确定
        let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default,handler:{ Void in
            
            let text=(alertController.textFields?.first)! as UITextField
            self.count=Int(text.text!)!
            self.lblCountLeb!.text=text.text
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
                okAction.isEnabled = Int(text.text!)! % self.goodDeatilEntity!.goodsBaseCount! == 0 && Int(text.text!)! <= text.tag && Int(text.text!) >= self.goodDeatilEntity!.miniCount!
            }else{
                okAction.isEnabled=false
            }
            
        }
    }
    /**
     加入购物车
     
     - parameter sender:UIButton
     */
    func addShoppingCar(_ sender:UIButton){
        //拿到会员id
        let memberId=UserDefaults.standard.object(forKey: "memberId") as! String
        let storeId=userDefaults.object(forKey: "storeId") as! String
        var promotionNumber:Int?=nil
        if flag == 3{//如果是促销
            promotionNumber=self.goodDeatilEntity!.promotionNumber
        }
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.insertShoppingCar(memberId: memberId, goodId: self.goodDeatilEntity!.goodsbasicinfoId!, supplierId: self.goodDeatilEntity!.supplierId!, subSupplierId: self.goodDeatilEntity!.subSupplier!, goodsCount: count, flag:flag!, goodsStock:self.goodDeatilEntity!.goodsStock!,storeId:storeId,promotionNumber: promotionNumber), successClosure: { (result) -> Void in
            let json=JSON(result)
            let success=json["success"].stringValue
            print(json)
            if success == "success"{
                //执行加入购车动画效果
                self.shoppingCharAnimation()
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
        NotificationCenter.default.post(name: Notification.Name(rawValue: "postBadgeValue"), object:2, userInfo:["carCount":count])
    }
    
}
// MARK: - 网络请求
extension GoodSpecialPriceDetailViewController{
    /**
     发送商品详情请求
     */
    func httpGoodDetail(){
        SVProgressHUD.show(withStatus: "数据加载中")
        var promotionFlag:Int?=nil
        var prefertialFlag:Int?=nil
        if goodEntity!.isPromotionFlag == 1{//查询促销详情
            promotionFlag=1
        }
        if goodEntity!.preferentialPrice != nil{//查询特价详情
            prefertialFlag=1
        }
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryGoodsDetailsForAndroid(goodsbasicinfoId: goodEntity!.goodsbasicinfoId!, supplierId: goodEntity!.supplierId!, flag:prefertialFlag, storeId: storeId!, aaaa: 11, subSupplier: goodEntity!.subSupplier!,memberId:IS_NIL_MEMBERID()!,promotionFlag:promotionFlag), successClosure: { (result) -> Void in
            SVProgressHUD.dismiss()
            let json=JSON(result)
            self.goodDeatilEntity=Mapper<GoodDetailEntity>().map(JSONObject:json.object)
            self.goodDeatilEntity!.preferentialPrice=json["prefertialPrice"].stringValue
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
            
            if self.flag == 1{
                //商品现价
                if self.goodDeatilEntity!.preferentialPrice != nil{
                    self.lblUprice!.text="批价 : ￥\(self.goodDeatilEntity!.preferentialPrice!)"
                }
                // 如果库存为空 默认给-1 表示库存充足
                
                if self.goodDeatilEntity!.goodsStock == nil{
                    self.goodDeatilEntity!.goodsStock = -1
                }
            }else{//如果为促销
                //商品现价
                if self.goodDeatilEntity!.uprice != nil{
                    self.lblUprice!.text="批价 : ￥\(self.goodDeatilEntity!.uprice!)"
                }
                if self.goodDeatilEntity!.promotionEachCount != nil{//如果促销商品还可以购买的数量不为空
                    //把促销商品还可以购买的数量设置为库存数
                    self.goodDeatilEntity!.goodsStock=self.goodDeatilEntity!.promotionEachCount
                }else{
                    self.goodDeatilEntity!.goodsStock=0
                }
                if self.goodDeatilEntity!.promotionStoreEachCount == nil{
                    self.goodDeatilEntity!.promotionStoreEachCount=0
                }
                self.goodDeatilEntity!.eachCount=self.goodDeatilEntity!.promotionStoreEachCount
            }
            
            //商品零售价
            if self.goodDeatilEntity!.uitemPrice != nil{
                self.lblUitemPrice!.text="建议零售价 : \(self.goodDeatilEntity!.uitemPrice!)"
            }else{
                self.lblUitemPrice!.text="建议零售价 : 无"
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
            self.btnSelectShoppingCar!.isHidden=false
            self.insertShoppingCarView!.isHidden=false
            }) { (errorMsg) -> Void in
                SVProgressHUD.showError(withStatus: errorMsg)
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
    func pushShoppingView(_ sender:UIButton){
        let vc=ShoppingCarViewContorller()
        vc.hidesBottomBarWhenPushed=true
        self.navigationController!.pushViewController(vc, animated:true)
    }
    func showSubSuppingVC(){
        let vc=GoodCategory3ViewController()
        vc.flag=6
        vc.subSupplierId=self.goodDeatilEntity!.subSupplier
        vc.subSupplierName=self.goodDeatilEntity!.supplierName
        vc.hidesBottomBarWhenPushed=true
        self.navigationController?.pushViewController(vc, animated:true)
    }
}
