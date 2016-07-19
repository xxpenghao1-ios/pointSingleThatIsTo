//
//  GrabASingleDetailsCell.swift
//  pointSingleThatIsTo
//
//  Created by 卢洋 on 16/2/19.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
///我要抢单
class GrabASingleDetailsCell:UITableViewCell{
    //cell的父容器
    var cellWarp:UIView!
    
    //顶部View
    var viewTop:UIView!;
    //订单时间
    var lblOrderId:UILabel!
    var lblOrderIdValue:UILabel?
    //总价
    var lblTotalPrice:UILabel!
    var lblTotalPriceValue:UILabel?
    //定义2条边框线
    var borderViewTop:UIView!;
    var borderViewButtom:UIView!;
    
    //中间抢单内容容器
    var viewMiddle:UIView!
    //商品View
    var goodView:UIView!;
    var goodImgView:UIImageView!;
    
    //右边小箭头
    var rightArrow:UIImageView!
    
    //商品数量
    var lblGoodCount:UILabel!;
    
    //底部送货地址容器
    var viewBottom:UIView!
    var lblAddress:UILabel!
    var lblAddressValue:UILabel?
    
    //增加两条边框线
    var borderLineTop:UIView!
    var borderLineBottom:UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //cell背景色
        self.contentView.backgroundColor=UIColor.goodDetailBorderColor()
        
        //cell的父容器
        cellWarp=UIView(frame: CGRectMake(0, 0, boundsWidth, 160))
        cellWarp.backgroundColor=UIColor.whiteColor()
        self.contentView.addSubview(cellWarp)
        
        //顶部布局
        viewTop=UIView(frame:CGRectMake(0,0,boundsWidth,40));
        cellWarp.addSubview(viewTop)
        
        //订单时间
        lblOrderId=UILabel()
        lblOrderId.font=UIFont.systemFontOfSize(14)
        lblOrderId.numberOfLines=1
        lblOrderId.textAlignment=NSTextAlignment.Center
        let lblOrderIdText="下单时间:"
        let lblOrderIdTextSize=lblOrderIdText.textSizeWithFont(lblOrderId.font, constrainedToSize: CGSizeMake(100, 20))
        lblOrderId.frame=CGRectMake(10, (viewTop.frame.height-lblOrderIdTextSize.height)/2, lblOrderIdTextSize.width, lblOrderIdTextSize.height)
        lblOrderId.text=lblOrderIdText
        viewTop.addSubview(lblOrderId)
        
        //增加的边框线
        borderLineTop=UIView(frame: CGRectMake(0, 0, boundsWidth, 0.5))
        borderLineTop.backgroundColor=UIColor.borderColor()
        viewTop.addSubview(borderLineTop)
        
        //加入边框线
        borderViewTop=UIView(frame: CGRectMake(0, viewTop.frame.height, boundsWidth, 0.5))
        borderViewTop.backgroundColor=UIColor.borderColor()
        viewTop.addSubview(borderViewTop)
        
        //订单时间值
        lblOrderIdValue=UILabel()
        lblOrderIdValue?.font=UIFont.systemFontOfSize(14)
        lblOrderIdValue?.textColor=UIColor.textColor()
        lblOrderIdValue?.numberOfLines=1
        viewTop.addSubview(lblOrderIdValue!)
        
        //右边总价的值
        lblTotalPriceValue=UILabel()
        lblTotalPriceValue?.font=UIFont.systemFontOfSize(14)
        lblTotalPriceValue?.textColor=UIColor.applicationMainColor()
        lblTotalPriceValue?.numberOfLines=1
        viewTop.addSubview(lblTotalPriceValue!)
        
        //左边总价的值标签
        lblTotalPrice=UILabel()
        lblTotalPrice.text="总价:￥";
        lblTotalPrice?.font=UIFont.systemFontOfSize(14)
        lblTotalPrice.textAlignment=NSTextAlignment.Center
        lblTotalPriceValue?.numberOfLines=1
        viewTop.addSubview(lblTotalPrice!)
        
        //中间抢单内容
        viewMiddle=UIView(frame: CGRectMake(0, CGRectGetMaxY(viewTop.frame), boundsWidth, 80))
        //viewMiddle.backgroundColor=UIColor.goodDetailBorderColor()
        self.contentView.addSubview(viewMiddle)
        
        //添加右边箭头
        rightArrow=UIImageView(frame: CGRectMake(boundsWidth-30, (viewMiddle.frame.height-18)/2, 20, 18))
        rightArrow.image=UIImage(named: "ly-rightArrow")
        viewMiddle.addSubview(rightArrow)
        
        //商品总数量标签
        lblGoodCount=UILabel()
        lblGoodCount?.font=UIFont.systemFontOfSize(14)
        lblGoodCount.textAlignment=NSTextAlignment.Center
        lblGoodCount?.numberOfLines=1
        viewMiddle.addSubview(lblGoodCount!)
        
        //送货地址父容器
        viewBottom=UIView(frame: CGRectMake(0, CGRectGetMaxY(viewMiddle.frame), boundsWidth, 40))
        self.contentView.addSubview(viewBottom)
        //送货地址标题标签
        lblAddress=UILabel()
        lblAddress.text="送货地址:"
        lblAddress.font=UIFont.systemFontOfSize(14)
        lblAddress.numberOfLines=1
        let lblAddressSize=lblAddress.text?.textSizeWithFont(lblAddress.font, constrainedToSize: CGSizeMake(100, 20))
        lblAddress.frame=CGRectMake(10, (viewBottom.frame.height-lblAddressSize!.height)/2, lblAddressSize!.width, lblAddressSize!.height)
        viewBottom.addSubview(lblAddress)
        
        //送货地址值
        lblAddressValue=UILabel(frame: CGRectMake(CGRectGetMaxX(lblAddress.frame), (viewBottom.frame.height-20)/2, boundsWidth-CGRectGetMaxX(lblAddress.frame)-10, 20))
        lblAddressValue?.font=UIFont.systemFontOfSize(14)
        lblAddressValue?.numberOfLines=1
        lblAddressValue?.textColor=UIColor.applicationMainColor()
        viewBottom.addSubview(lblAddressValue!)
        
        //底部边框线
        borderViewButtom=UIView(frame: CGRectMake(0, viewBottom.frame.height, boundsWidth, 0.5))
        borderViewButtom.backgroundColor=UIColor.borderColor()
        viewBottom.addSubview(borderViewButtom)
        
        //增加的边框线
        borderLineBottom=UIView(frame: CGRectMake(0, 0, boundsWidth, 0.5))
        borderLineBottom.backgroundColor=UIColor.borderColor()
        viewBottom.addSubview(borderLineBottom)
    }
    /**
    加载我要抢单数据
    
    - parameter Oentity: 订单实体类
    - parameter GEntity: 商品详情实体类
    */
    func loadGrabASingleData(Oentity:OrderListEntity){
        //订单下单日期
        let lblOrderIdValueText=Oentity.add_time ?? ""
        let lblOrderIdValueTextSize=lblOrderIdValueText.textSizeWithFont(lblOrderIdValue!.font, constrainedToSize: CGSizeMake(300, 20))
        lblOrderIdValue!.frame=CGRectMake(CGRectGetMaxX(lblOrderId.frame), (viewTop.frame.height-lblOrderIdValueTextSize.height)/2, lblOrderIdValueTextSize.width, lblOrderIdValueTextSize.height)
        lblOrderIdValue?.text=lblOrderIdValueText
        //先判断用户是否加价
        let additionalMoney=Oentity.additionalMoney ?? "0"
        //订单总价
        var lblTotalPriceValueText=Oentity.orderPrice ?? "0"
        if(additionalMoney != "0"){//只要加价不为空，显示加价
            //先转Float，再转String
            let price=Float(lblTotalPriceValueText)!
            lblTotalPriceValueText = String(price)+"(+"+additionalMoney+")"
        }
        //计算总价的宽高
        let lblTotalPriceValueTextSize=lblTotalPriceValueText.textSizeWithFont(lblTotalPriceValue!.font, constrainedToSize: CGSizeMake(200, 20))
        lblTotalPriceValue?.frame=CGRectMake(boundsWidth-lblTotalPriceValueTextSize.width-10, (viewTop!.frame.height-lblTotalPriceValueTextSize.height)/2, lblTotalPriceValueTextSize.width, lblTotalPriceValueTextSize.height)
        lblTotalPriceValue?.text=lblTotalPriceValueText
        //计算总价标签的宽高
        let lblTotalPriceSize=lblTotalPrice.text?.textSizeWithFont(lblTotalPrice!.font, constrainedToSize: CGSizeMake(80, 20))
        lblTotalPrice.frame=CGRectMake(CGRectGetMinX(lblTotalPriceValue!.frame)-lblTotalPriceSize!.width, (viewTop!.frame.height-lblTotalPriceSize!.height)/2, lblTotalPriceSize!.width, lblTotalPriceSize!.height)

        //送货地址
        let lblAddressValueText=Oentity.address
        lblAddressValue?.text=lblAddressValueText
        
        //商品容器的宽高
        let viewMiddleGoodsW=viewMiddle.frame.height-30
        
        //商品数量，最多显示三条
        var recieveGoodsNum:Int?
        let goodsNum=Oentity.list!
        if(goodsNum.count > 0 && goodsNum.count <= 3){
            recieveGoodsNum=goodsNum.count
        }else if(goodsNum.count>3){
            recieveGoodsNum=3
        }else{
            recieveGoodsNum=0
        }
        for(var i=0;i<recieveGoodsNum;i++){
            let GoodsList=goodsNum[i] as! GoodDetailEntity
//            //中间商品图片
//            goodView=UIView(frame: CGRectMake(viewMiddleGoodsW * CGFloat(i) + 10 * CGFloat(i+1) , (viewMiddle.frame.height-viewMiddleGoodsW)/2, viewMiddleGoodsW, viewMiddleGoodsW))
//            goodView.layer.borderWidth=0.5
//            goodView.layer.borderColor=UIColor.borderColor().CGColor
//            viewMiddle.addSubview(goodView)
            goodImgView=UIImageView(frame: CGRectMake(viewMiddleGoodsW * CGFloat(i) + 10 * CGFloat(i+1), (viewMiddle.frame.height-viewMiddleGoodsW)/2, viewMiddleGoodsW, viewMiddleGoodsW))
            goodImgView.layer.borderWidth=0.5
            goodImgView.layer.borderColor=UIColor.borderColor().CGColor
            goodImgView.tag=10
            let goodImgPlaceHodle=GoodsList.goodPic ?? ""
            goodImgView.sd_setImageWithURL(NSURL(string: URLIMG+goodImgPlaceHodle), placeholderImage: UIImage(named: "def_nil"))
            viewMiddle.addSubview(goodImgView)
        }
        //接收商品数量
        let goodCount=Oentity.goods_amount ?? "0"
        lblGoodCount.text="共计"+"\(goodCount)"+"件商品";
        let goodCountSize=lblGoodCount.text?.textSizeWithFont(lblGoodCount!.font, constrainedToSize: CGSizeMake(100, 20))
        lblGoodCount.frame=CGRectMake(CGRectGetMinX(rightArrow!.frame)-goodCountSize!.width, (viewMiddle!.frame.height-goodCountSize!.height)/2, goodCountSize!.width, goodCountSize!.height)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}