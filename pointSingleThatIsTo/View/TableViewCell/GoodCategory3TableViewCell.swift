//
//  GoodCategory3TableViewCell.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/1/28.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
/**
 *  加入购物车协议
 */
protocol GoodCategory3TableViewCellAddShoppingCartsDelegate:NSObjectProtocol{
    /**
     需要主页面实现的方法
     */
    //加入购物车
    func goodCategory3TableViewCellAddShoppingCarts(imgView:UIImageView,indexPath:NSIndexPath,count:Int)
    /**
     弹出文本输入框 选择数量
     
     - parameter inventory: 库存数量
     - parameter indexPath: 行索引
     */
    func purchaseCount(inventory:Int,indexPath:NSIndexPath)
    
    /**
     跳转到商品详情页
     
     - parameter entity: 商品entity
     */
    func pushGoodDetailView(entity:GoodDetailEntity)
}
///商品3级分类TableViewCell
class GoodCategory3TableViewCell:UITableViewCell {
    
    /// 定义协议
    var delegate:GoodCategory3TableViewCellAddShoppingCartsDelegate?
    
    /// 商品图片
    @IBOutlet weak var goodImg: UIImageView!
    
    /// 商品促销图片
    @IBOutlet weak var salesPromotionImgView: UIImageView!
    
    /// 购物数量view
    @IBOutlet weak var shoppingCartCountView: UIView!
    
    /// 加入购物车View
    @IBOutlet weak var addShoppingCart: UIView!
    
    /// 加入购物车数量
    @IBOutlet weak var lblShoppingCartCount: UILabel!
    
    /// 商品进价
    @IBOutlet weak var lblGoodPrice: UILabel!
    
    /// 减去数量
    @IBOutlet weak var btnReduceCount: UIButton!
    
    /// 增加数量
    @IBOutlet weak var btnAddCount: UIButton!
    
    /// 商品规格
    @IBOutlet weak var lblGoodUcode: UILabel!
    
    /// 商品图片view
    @IBOutlet weak var goodImgView: UIView!
    
    //商品零售价
    @IBOutlet weak var lblGoodRetailPrice: UILabel!
    
    
    /// 商品名称
    @IBOutlet weak var lblGoodName: UILabel!
    
    /// 商品库存
    @IBOutlet weak var lblGoodStock: UILabel!
    
    /// 已卖完
    var img:UIImageView?
    
    /// 保存每行的索引
    var indexPath:NSIndexPath?
    
    /// 商品数量 默认1
    var count=1;
    
    /// 库存
    var inventory=0
    
    /// 保存商品entity
    var goodEntity:GoodDetailEntity?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //默认隐藏商品促销活动
        salesPromotionImgView.hidden=true
        //设置加入购物车view背景颜色
        addShoppingCart.backgroundColor=UIColor.applicationMainColor()
        addShoppingCart.layer.masksToBounds=true
        addShoppingCart.layer.cornerRadius=3
        addShoppingCart.userInteractionEnabled=true
        addShoppingCart.addGestureRecognizer(UITapGestureRecognizer(target:self, action:"addShoppingCarts"))
        
        //设置商品图片view
        goodImgView.layer.masksToBounds=true
        goodImgView.layer.cornerRadius=3
        goodImgView.userInteractionEnabled=true
        goodImgView.addGestureRecognizer(UITapGestureRecognizer(target:self, action:"pushGoodDetail"))
        
        //设置购物数量view
        shoppingCartCountView.layer.cornerRadius=5
        shoppingCartCountView.layer.borderWidth=1
        shoppingCartCountView.layer.borderColor=UIColor(red:180/255, green:180/255, blue:180/255, alpha:1).CGColor
        
        //设置加入购物车数量的边线
        lblShoppingCartCount.layer.borderColor=UIColor(red:180/255, green:180/255, blue:180/255, alpha:1).CGColor
        lblShoppingCartCount.layer.borderWidth=1
        
        //设置文字颜色
        lblGoodPrice.textColor=UIColor.redColor()
        lblGoodUcode.textColor=UIColor.textColor()
        lblGoodRetailPrice.textColor=UIColor.textColor()
        lblGoodStock.textColor=UIColor.textColor()
        
        //设置加减数量点击事件
        btnAddCount.addTarget(self, action:"addCount:", forControlEvents: UIControlEvents.TouchUpInside)
        btnReduceCount.addTarget(self, action:"reduceCount:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //设置数量选择事件
        lblShoppingCartCount.userInteractionEnabled=true
        lblShoppingCartCount.addGestureRecognizer(UITapGestureRecognizer(target:self, action:"showCountText"))
        
        
        //去掉选中背景
        self.selectionStyle=UITableViewCellSelectionStyle.None;
    }
    /**
     跳转到商品详情页
     */
    func pushGoodDetail(){
        delegate?.pushGoodDetailView(goodEntity!)
    }
    /**
     加入购物车
     */
    func addShoppingCarts(){
        delegate?.goodCategory3TableViewCellAddShoppingCarts(goodImg, indexPath: indexPath!,count:count)
    }
    /**
     弹出数量选择框
     */
    func showCountText(){
        delegate?.purchaseCount(inventory,indexPath:indexPath!)
    }
    /**
     添加商品数量
     
     - parameter sender: UIButton
     */
    func addCount(sender:UIButton){
        if inventory == -1{//如果库存充足
            count+=goodEntity!.goodsBaseCount!
            lblShoppingCartCount.text="\(count)"
        }else{
            if count > inventory-self.goodEntity!.goodsBaseCount!{//判断数量是否已经大于等于库存总数了 等于了改变文本颜色 不进行任何操作
                lblShoppingCartCount!.textColor=UIColor.textColor()
            }else{
                count+=self.goodEntity!.goodsBaseCount!
                lblShoppingCartCount!.text="\(count)"
            }
        }
        
    }
    /**
     减少数量
     
     - parameter sender: UIButton
     */
    func reduceCount(sender:UIButton){
        if count > goodEntity!.miniCount{//数量到最低起送数量不进行操作
            count-=goodEntity!.goodsBaseCount!
            lblShoppingCartCount.text="\(count)"
            lblShoppingCartCount.textColor=UIColor.redColor()
        }
    }
    /**
     更新cell
     
     - parameter entity:商品详情entity
     */
    func updateCell(entity:GoodDetailEntity){
        img?.removeFromSuperview()
        goodEntity=entity
        inventory=entity.goodsStock!
        count=entity.miniCount!
        //设置商品起送数量
        lblShoppingCartCount.text="\(count)"
        
        //商品名称
        lblGoodName.text=entity.goodInfoName
        
        
        //商品图片
        goodImg.sd_setImageWithURL(NSURL(string:URLIMG+entity.goodPic!), placeholderImage:UIImage(named: "def_nil"))
        
        //商品零售价
        if entity.uitemPrice != nil{
            lblGoodRetailPrice.text="建议零售价 : \(entity.uitemPrice!)"
        }else{
            lblGoodRetailPrice.text="建议零售价 : 暂无"
        }
        
        //商品进价
        if entity.uprice != nil{
            lblGoodPrice.text="￥\(entity.uprice!)"
        }else{
            lblGoodPrice.text="无"
        }
        //商品单位
        if entity.goodUnit != nil{
            if entity.ucode != nil{
                lblGoodUcode.text="单位 : \(entity.goodUnit!)/\(entity.ucode!)"
            }else{
                lblGoodUcode.text="单位 : \(entity.goodUnit!)"
            }
            
        }else{
            lblGoodUcode.text="单位 : 无"
        }
        //商品库存
        if entity.goodsStock != nil{
            if entity.goodsStock == -1{
                lblGoodStock.text="库存充足"
            }else{
                lblGoodStock.text="库存:\(entity.goodsStock!)"
            }
        }
        //是否促销标识
        if entity.isPromotionFlag != nil{
//            if entity.isPromotionFlag == 1{
//                //显示促销标识
//                salesPromotionImgView.hidden=false
//            }else{
//                salesPromotionImgView.hidden=true
//            }
        }else if entity.isNewGoodFlag != nil{
            if entity.isNewGoodFlag == 1{
                //显示新品标识
                salesPromotionImgView.hidden=false
                salesPromotionImgView.image=UIImage(named: "newGood")
            }else{
                salesPromotionImgView.hidden=true
            }
        }
        if entity.goodsStock == 0{//库存等于0的时候
            /// 隐藏加入购车 相关控件
            addShoppingCart.hidden=true
            shoppingCartCountView.hidden=true
            /// 展示已售
            img=UIImageView(frame:CGRectMake(boundsWidth-70,30,60,60))
            img!.image=UIImage(named: "to_sell_out")
            self.contentView.addSubview(img!)
            goodImgView.userInteractionEnabled=false
        }else{
            addShoppingCart.hidden=false
            shoppingCartCountView.hidden=false
            goodImgView.userInteractionEnabled=true
        }
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}