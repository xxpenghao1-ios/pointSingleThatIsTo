//
//  GoodSpecialPriceTableCell.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/2/23.
//  Copyright © 2016年 penghao. All rights reserved.
//

import UIKit
/**
 计算剩余时间
 
 - parameter seconds: 秒
 
 - returns: 字符
 */
func lessSecondToDay(seconds:Int) -> String{
    let day=seconds/(24*3600)
    let hour=(seconds%(24*3600))/3600
    let min=(seconds%(3600))/60
    let second=(seconds%60)
    var time:NSString=""
    if seconds >= 0{
        if day == 0{//如果天数等于0
            time=NSString(format:"剩余时间:%i小时%i分钟%i秒",hour,min,second)
            if hour == 0{
                time=NSString(format:"剩余时间:%i分钟%i秒",min,second)
                if min == 0{
                    time=NSString(format:"剩余时间:%i秒",second)
                    if seconds == 0{
                        return "活动已结束"
                    }
                }
            }
        }else{
            time=NSString(format:"剩余时间:%i日%i小时%i分钟%i秒",day,hour,min,second)
        }
    }else{
        return "活动已结束"
    }
    return time as String
}

/**
 *  加入购物车协议
 */
protocol GoodSpecialPriceTableCellAddShoppingCartsDelegate:NSObjectProtocol{
    
    /**
     跳转特价商品详情
     
     - parameter entity:商品entity
     */
    func pushGoodSpecialPriceDetail(entity:GoodDetailEntity)
    /**
     加入购物车
     
     - parameter entity: 商品entity
     */
    func addCar(entity:GoodDetailEntity)
}
/// 特价cell
class GoodSpecialPriceTableCell: UITableViewCell {
    
    /// 定义协议
    var delegate:GoodSpecialPriceTableCellAddShoppingCartsDelegate?
    //促销展示图片
    @IBOutlet weak var CXImg: UIImageView!
    //特价展示图片
    @IBOutlet weak var TJImg: UIImageView!
    ///商品图片view
    @IBOutlet weak var goodImgView: UIView!
    
    /// 商品图片
    @IBOutlet weak var goodImg: UIImageView!
    
    /// 特价结束时间
    @IBOutlet weak var lblTime: UILabel!
    
    /// 商品库存
    @IBOutlet weak var lblGoodStock: UILabel!
    //加入购物车按钮
    @IBOutlet weak var addCarView: UIImageView!
    /// 商品名称
    @IBOutlet weak var lblGoodName: UILabel!
    
    /// 商品规格
    @IBOutlet weak var lblUcode: UILabel!
    
    /// 价钱view
    @IBOutlet weak var upriceView: UIView!
    //促销信息
    @IBOutlet weak var lblPromotionText: UILabel!
    /// 已卖完图片
    var img:UIImageView?
    
    /// 行索引
    var indexPath:NSIndexPath?
    
    var goodEntity:GoodDetailEntity?
    
    /// 现价
    var lblUprice:UILabel?
    
    /// 商品原价
    var lblOldPrice:UILabel?
    
    /// 原价view
    var oldPriceView:UIView?
    
    /// 销量
    var lblSalesCount:UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        TJImg.hidden=true
        CXImg.hidden=true
        //倒计时控件颜色
        lblTime.textColor=UIColor.applicationMainColor()
        
        //现价
        lblUprice=UILabel()
        lblUprice!.textColor=UIColor.redColor()
        lblUprice!.font=UIFont.systemFontOfSize(20)
        upriceView.addSubview(lblUprice!)
        
        //原价
        lblOldPrice=UILabel()
        lblOldPrice!.textColor=UIColor.textColor()
        lblOldPrice!.font=UIFont.systemFontOfSize(12)
        upriceView.addSubview(lblOldPrice!)
        
        //原价view
        oldPriceView=UIView()
        oldPriceView!.backgroundColor=UIColor.textColor()
        upriceView.addSubview(oldPriceView!)
        
        //销量
        lblSalesCount=UILabel()
        lblSalesCount!.textColor=UIColor.textColor()
        lblSalesCount!.font=UIFont.systemFontOfSize(12)
        upriceView.addSubview(lblSalesCount!)
        
        //设置商品图片view
        goodImgView.layer.masksToBounds=true
        goodImgView.layer.cornerRadius=3
        goodImgView.userInteractionEnabled=true
        goodImgView.addGestureRecognizer(UITapGestureRecognizer(target:self, action:"pushGoodSpecialPriceDetail"))
        
        lblPromotionText.textColor=UIColor.applicationMainColor()
        
        lblUcode.textColor=UIColor.textColor()
        lblGoodStock.textColor=UIColor.textColor()
        
        addCarView.userInteractionEnabled=true
        addCarView.addGestureRecognizer(UITapGestureRecognizer(target:self, action:"addShoppingCarts"))
        
        
        //去掉选中背景
        self.selectionStyle=UITableViewCellSelectionStyle.None;
    }
    /**
     加入购物车
     */
    func addShoppingCarts(){
        delegate?.addCar(goodEntity!)
    }
    /**
     跳转到特价商品详情
     */
    func pushGoodSpecialPriceDetail(){
        delegate?.pushGoodSpecialPriceDetail(goodEntity!)
    }
    /**
     更新cell
     
     - parameter entity: 商品entity
     flag 1特价 2促销
     */
    func updateCell(entity:GoodDetailEntity,flag:Int){
        img?.removeFromSuperview()
        goodEntity=entity
        print(entity.goodsDes)
        //商品名称
        if entity.eachCount <= 0{
            lblGoodName.text=entity.goodInfoName
        }else{
            
            lblGoodName.text=entity.goodInfoName!+"(限购~~\(entity.eachCount!)\(entity.goodUnit!))"
        }
        
        //商品图片
        goodImg.sd_setImageWithURL(NSURL(string:URLIMG+entity.goodPic!), placeholderImage:UIImage(named: "def_nil"))
        lblSalesCount!.text="销量\(entity.salesCount!)"
        let salesCountSize=lblSalesCount!.text!.textSizeWithFont(lblSalesCount!.font, constrainedToSize:CGSizeMake(100,20))
        if flag == 1{//如果是特价
            lblUprice!.text="￥\(entity.preferentialPrice!)"
            lblOldPrice!.text="￥\(entity.oldPrice!)"
            
            let upriceSize=lblUprice!.text!.textSizeWithFont(lblUprice!.font, constrainedToSize:CGSizeMake(200,20))
            let oldPriceSize=lblOldPrice!.text!.textSizeWithFont(lblOldPrice!.font, constrainedToSize:CGSizeMake(100,20))
        
            lblUprice!.frame=CGRectMake(0,0,upriceSize.width,20)
            lblOldPrice!.frame=CGRectMake(CGRectGetMaxX(lblUprice!.frame)+5,0,oldPriceSize.width,20)
            oldPriceView!.frame=CGRectMake(CGRectGetMaxX(lblUprice!.frame)+2,9.75,oldPriceSize.width+6,0.5)
            lblSalesCount!.frame=CGRectMake(CGRectGetMaxX(lblOldPrice!.frame)+5,0,salesCountSize.width,20)
        }else{//如果是促销
            lblUprice!.text="￥\(entity.uprice!)"
            let upriceSize=lblUprice!.text!.textSizeWithFont(lblUprice!.font, constrainedToSize:CGSizeMake(200,20))
            lblUprice!.frame=CGRectMake(0,0,upriceSize.width,20)
            lblSalesCount!.frame=CGRectMake(CGRectGetMaxX(lblUprice!.frame)+5,0,salesCountSize.width,20)
            lblPromotionText.text=entity.goodsDes
        }
        //商品单位
        if entity.goodUnit != nil{
            if entity.ucode != nil{
                lblUcode.text="单位 : \(entity.goodUnit!)/\(entity.ucode!)"
            }else{
                lblUcode.text="单位 : \(entity.goodUnit!)"
            }
            
        }else{
            lblUcode.text="单位 : 无"
        }
        //商品库存
        if entity.goodsStock != nil{
            if entity.goodsStock == -1{
                lblGoodStock.text="库存充足"
            }else{
                lblGoodStock.text="库存:\(entity.goodsStock!)"
            }
        }
        if entity.goodsStock == 0{//库存等于0的时候
            /// 展示已售完
            addImg("to_sell_out")
            disablePushDetailsView()
            if flag == 1{
                TJImg.hidden=false
            }else{
                CXImg.hidden=false
            }
        }else{
            var time=0
            if flag == 1{//如果是特价
                TJImg.hidden=false
                time=Int(entity.endTime!)!
            }else{
                CXImg.hidden=false
                time=Int(entity.promotionEndTime!)!
            }
            if time <= 0{//如果剩余时间小于等于0 表示活动已经结束
                /// 展示活动已结束
                addImg("to_sell_end")
                disablePushDetailsView()
            }else{//如果活动时间没有结束
                if flag == 3{//如果是促销
                    if entity.promotionStoreEachCount <= 0{
                        /// 展示活动已购满
                        addImg("ygm")
                        //禁止进入商品详情
                        disablePushDetailsView()
                    }else{
                       okPushDetailsView(time)
                    }
                }else{//如果是特价
                    okPushDetailsView(time)
                }
                
            }
        }

    }
    /**
     禁止进入商品详情页面
     */
    func disablePushDetailsView(){
        goodImgView.userInteractionEnabled=false
        lblTime.hidden=true
        addCarView.hidden=true
    }
    /**
     可以进入商品详情页面
     */
    func okPushDetailsView(time:Int){
        goodImgView.userInteractionEnabled=true
        lblTime.hidden=false
        addCarView.hidden=false
        //剩余时间
        lblTime.text=lessSecondToDay(time)
    }
    /**
     添加提示图片
     
     - parameter imgName:图片名称
     */
    func addImg(imgName:String){
        /// 展示活动已购满
        img=UIImageView(frame:CGRectMake(boundsWidth-70,50,60,60))
        img!.image=UIImage(named:imgName)
        self.contentView.addSubview(img!)
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
