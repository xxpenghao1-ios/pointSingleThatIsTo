//
//  ShoppingCarTableViewCell.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/2/16.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
//购物车cell协议。。
protocol ShoppingCarTableViewCellDelegate : NSObjectProtocol {
    /**
     计算选择商品的总价格
     
     - parameter totalPrice: 总价格  单个商品＊数量
     - parameter flag:       标示 是否选中 true ++  false  --
     - parameter good:       商品entity
     - parameter index:      行索引
     - parameter count:      每次加减数量
     */
    func calculationSelectTotalPrice(totalPrice:Double,flag:Bool,good:GoodDetailEntity,index:NSIndexPath,count:Int,seletedFlag:Int?);
    /**
     限购提示
     
     - parameter inventory: 库存数
     - parameter eachCount: 限购数
     - parameter count:     购买数量
     - parameter flag:      是否特价 1yes 2no
     */
    func reachALimitPrompt(inventory:Int,eachCount:Int?,count:Int,flag:Int)
    
}

class ShoppingCarTableViewCell:UITableViewCell {
    ///创建一个协议
    var delelgate:ShoppingCarTableViewCellDelegate?;
    
    ///接收传过来的数据
    var good:GoodDetailEntity?
    
    /// 默认图片
    var selectImg:UIImage!;
    
    /// 选中图片
    var selectImgSelected:UIImage!;
    
    /// 选中按钮
    var btnSelectImg:UIButton!;
    
    /// 商品图片边框
    var goodView:UIView!;
    
    /// 商品图片
    var goodImgView:UIImageView!;
    
    /// 特价商品标识图片
    var specialOfferImgView:UIImageView!;
    
    /// 商品名称
    var lblGoodName:UILabel!;
    
    /// 商品价格
    var lblGoodPirce:UILabel!;
    
    /// 数量加减视图
    var countView:UIView!;
    
    /// 增加按钮
    var btnAddCount:UIButton!;
    
    /// 减少按钮
    var btnReductionCount:UIButton!;
    
    /// 数量lab
    var lblCountLeb:UILabel!;
    
    /// 行索引
    var index:NSIndexPath?;
    
    /// 活动已结束
    var img:UIImageView?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //边框颜色
        let color=UIColor.borderColor();
        
        //选择图片
        selectImg=UIImage(named:"select_05");
        selectImgSelected=UIImage(named:"select_03");
        
        //给选择图片加上按钮实现点击切换
        btnSelectImg=UIButton(frame:CGRectMake(15,(120-25)/2,25,25));
        btnSelectImg.setImage(selectImg, forState:.Normal)
        btnSelectImg.setImage(selectImgSelected, forState:.Selected);
        btnSelectImg.addTarget(self, action:"selectImgSwitch:", forControlEvents: UIControlEvents.TouchUpInside);
        self.contentView.addSubview(btnSelectImg);
        
        //放商品图片的view
        goodView=UIView(frame:CGRectMake(CGRectGetMaxX(btnSelectImg.frame)+15,(120-90)/2,90,90))
        goodView.layer.borderColor=color.CGColor;
        goodView.layer.borderWidth=0.5;
        
        //商品图片
        goodImgView=UIImageView(frame:CGRectMake(0,0,goodView.frame.width,goodView.frame.height))
        goodImgView.image=nil;
        goodView.addSubview(goodImgView);
        self.contentView.addSubview(goodView)
        
        //特价图片
        specialOfferImgView=UIImageView(frame:CGRectMake(50,50,30, 30))
        specialOfferImgView.image=UIImage(named:"special_offer");
        specialOfferImgView.hidden=true;
        goodView.addSubview(specialOfferImgView);
        
        /// 活动已结束(默认隐藏)
        img=UIImageView(frame:CGRectMake(boundsWidth-70,40,60,60))
        img!.image=UIImage(named: "to_sell_end")
        img!.hidden=true
        self.contentView.addSubview(img!)
        
        //商品名称
        lblGoodName=UILabel(frame:CGRectMake(CGRectGetMaxX(goodView.frame)+10,goodView.frame.origin.y,boundsWidth-(CGRectGetMaxX(goodView.frame)+10)-10,40));
        lblGoodName.lineBreakMode=NSLineBreakMode.ByWordWrapping;
        lblGoodName.numberOfLines=0;
        lblGoodName.font=UIFont.systemFontOfSize(13);
        lblGoodName.textColor=UIColor.textColor()
        self.contentView.addSubview(lblGoodName)
        
        //商品价格
        lblGoodPirce=UILabel(frame:CGRectMake(CGRectGetMaxX(goodView.frame)+10,CGRectGetMaxY(goodView.frame)-50,100,20));
        lblGoodPirce.font=UIFont.systemFontOfSize(13);
        lblGoodPirce.textColor=UIColor(red:51/255, green:51/255, blue:51/255, alpha:1);
        self.contentView.addSubview(lblGoodPirce)
        
        //商品数量加减视图
        countView=UIView(frame:CGRectMake(CGRectGetMaxX(goodView.frame)+10,CGRectGetMaxY(goodView.frame)-30,130,30));
        countView!.layer.borderColor=UIColor(red:180/255, green:180/255, blue:180/255, alpha:1).CGColor
        countView!.layer.borderWidth=1
        countView!.layer.cornerRadius=3
        countView!.layer.masksToBounds=true
        countView!.backgroundColor=UIColor.whiteColor();
        
        //减号按钮
        let countWidth:CGFloat=40;
        btnReductionCount=UIButton(frame:CGRectMake(0,0,countWidth,countView.frame.height));
        btnReductionCount.setTitle("-", forState:.Normal);
        btnReductionCount.titleLabel!.font=UIFont.boldSystemFontOfSize(22)
        btnReductionCount.setTitleColor(UIColor(red:204/255, green:204/255, blue:204/255, alpha: 1), forState: UIControlState.Normal)
        btnReductionCount.addTarget(self, action:"reductionCount:", forControlEvents: UIControlEvents.TouchUpInside);
        btnReductionCount.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        btnReductionCount.backgroundColor=UIColor.whiteColor()
        countView.addSubview(btnReductionCount);
        
        //数组lab
        lblCountLeb=UILabel(frame:CGRectMake(btnReductionCount.frame.width,0,countWidth+10,countView.frame.height));
        lblCountLeb.textColor=UIColor(red:225/255, green:45/255, blue:45/255, alpha:1);
        lblCountLeb.layer.borderColor=UIColor(red:180/255, green:180/255, blue:180/255, alpha:1).CGColor;
        lblCountLeb.layer.borderWidth=1;
        lblCountLeb.text="1";
        lblCountLeb.textAlignment=NSTextAlignment.Center;
        lblCountLeb.font=UIFont.systemFontOfSize(16);
        countView.addSubview(lblCountLeb);
        
        //加号按钮
        btnAddCount=UIButton(frame:CGRectMake(CGRectGetMaxX(lblCountLeb.frame),0,countWidth,countView.frame.height));
        btnAddCount.backgroundColor=UIColor.whiteColor()
        btnAddCount.setTitle("+", forState:.Normal);
        btnAddCount.titleLabel!.font=UIFont.systemFontOfSize(22)
        btnAddCount.setTitleColor(UIColor(red:204/255, green:204/255, blue:204/255, alpha: 1), forState: UIControlState.Normal)
        btnAddCount.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        btnAddCount.addTarget(self, action:"addCount:", forControlEvents: UIControlEvents.TouchUpInside);
        countView.addSubview(btnAddCount);
        
        self.contentView.addSubview(countView);
        self.selectionStyle=UITableViewCellSelectionStyle.None;
    }
    /**
     减去购物车数量
     
     - parameter sender: UIButton
     */
    func reductionCount(sender:UIButton){
        if good!.carNumber > good!.miniCount{//购物车数量大于1的时候 可以进行减少操作
            good!.carNumber!-=good!.goodsBaseCount!
            var totalPrice:Double=0;
            if good!.flag! == 1{//如果是特价商品计算特价价格
                totalPrice=Double(good!.prefertialPrice!)!*Double(good!.goodsBaseCount!);
            }else{
                totalPrice=Double(good!.uprice!)!*Double(good!.goodsBaseCount!);
            }
            lblCountLeb.text="\(good!.carNumber!)";
            if btnSelectImg.selected == true {//判断是否是选中状态 如果是通过协议 实现价格操作
                    delelgate?.calculationSelectTotalPrice(totalPrice,flag:false, good: good!, index: index!,count:good!.goodsBaseCount!,seletedFlag:nil)
            }
            //恢复增加按钮 操作
            btnAddCount.enabled=true;
            //恢复数量文字颜色
            lblCountLeb.textColor=UIColor(red:225/255, green:45/255, blue:45/255, alpha:1);
            //发送通知更新角标
            NSNotificationCenter.defaultCenter().postNotificationName("postBadgeValue", object:3, userInfo:["carCount":good!.goodsBaseCount!])
        }
    }
    /**
     增加购物车数量
     
     - parameter sender: UIButton
     */
    func addCount(sender:UIButton){
        var totalPrice:Double=0;
        if good!.flag! == 1{//如果是特价商品计算特价价格
            if good!.stock != -1{//特价库存是否充足
                //计算价格
                totalPrice=Double(good!.prefertialPrice!)!*Double(good!.goodsBaseCount!);
                if good!.eachCount > good!.stock{//如果特价限定数量 大于 库存数量
                    if good!.carNumber > good!.stock!-good!.goodsBaseCount!{//特价商品只能购买库存数量以内的商品数量
                        //调用达到限定数量方法
                        reachALimitCount(totalPrice)
                        //调用限购提示方法
                        delelgate?.reachALimitPrompt(good!.stock!, eachCount:good!.eachCount!,count:good!.carNumber!,flag:1)
                    }else{//如果不等于库存数量 继续增加
                        good!.carNumber!+=good!.goodsBaseCount!
                        //调用没有达到限定数量方法
                        noReachALimitCount(totalPrice)
                    }
                }else{//如果特价限定数量 小于 库存数量
                    if good!.carNumber > good!.eachCount!-good!.goodsBaseCount!{//如果商品数量大于限购数量
                        //调用达到限定数量方法
                        reachALimitCount(totalPrice)
                        //调用限购提示方法
                        delelgate?.reachALimitPrompt(good!.stock!, eachCount:good!.eachCount!,count:good!.carNumber!,flag: 1)
                        
                    }else{//如果没有达到限购数量 继续增加
                        good!.carNumber!+=good!.goodsBaseCount!
                        //调用没有达到限定数量方法
                        noReachALimitCount(totalPrice)
                    }
                }
            }else{
                //计算价格
                totalPrice=Double(good!.prefertialPrice!)!*Double(good!.goodsBaseCount!);
                if good!.carNumber > good!.eachCount!-good!.goodsBaseCount!{//如果商品数量 达到限购数量
                    //调用达到限定数量方法
                    reachALimitCount(totalPrice)
                    //调用限购提示方法
                    delelgate?.reachALimitPrompt(good!.goodsStock!, eachCount:good!.eachCount!,count:good!.carNumber!,flag:1)
                }else{
                    good!.carNumber!+=good!.goodsBaseCount!
                    //调用没有达到限定数量方法
                    noReachALimitCount(totalPrice)
                }
            }
        }else{//如果不是特价商品
            if good!.goodsStock != -1{//如果库存不充足
                totalPrice=Double(good!.uprice!)!*Double(good!.goodsBaseCount!);
                if good!.carNumber > good!.goodsStock!-good!.goodsBaseCount!{//如果商品达到限购数量
                    //调用达到限定数量方法
                    reachALimitCount(totalPrice)
                    //调用限购提示方法
                    delelgate?.reachALimitPrompt(good!.goodsStock!, eachCount:good!.eachCount,count:good!.carNumber!,flag:2)
                    
                }else{//如果没有达到限购数量
                    //调用没有达到限定数量方法
                    good!.carNumber!+=good!.goodsBaseCount!
                    noReachALimitCount(totalPrice)
                }
            }else{
                //计算价格
                totalPrice=Double(good!.uprice!)!*Double(good!.goodsBaseCount!);
                //调用没有达到限定数量方法
                good!.carNumber!+=good!.goodsBaseCount!
                noReachALimitCount(totalPrice)
            }
            
        }
    }
    /**
     达到限定数量
     */
    func reachALimitCount(totalPrice:Double){
            //禁用增加按钮
            btnAddCount.enabled=false
            //改变文字颜色
            lblCountLeb.textColor=UIColor.textColor()
            //改变文字数量
            lblCountLeb.text="\(good!.carNumber!)"
        
    }
    /**
     没有达到限定数量
     
     - parameter totalPrice:价格
     */
    func noReachALimitCount(totalPrice:Double){
        if btnSelectImg.selected.boolValue == true {//判断是否是选中状态 如果是通过协议 实现价格操作
            delelgate?.calculationSelectTotalPrice(totalPrice,flag:true, good: good!, index: index!,count:good!.goodsBaseCount!,seletedFlag:nil)
        }
        //改变文字数量
        lblCountLeb.text="\(good!.carNumber!)"
        //发送通知更新角标
        NSNotificationCenter.defaultCenter().postNotificationName("postBadgeValue", object:2, userInfo:["carCount":good!.goodsBaseCount!])
        
    }
    /**
     选中购物车商品
     
     - parameter sender:UIButton
     */
    func selectImgSwitch(sender:UIButton){
        
        /// 定义变量 计算单个商品总价格
        var totalPrice:Double=0;
        
        if good!.flag == 1{//如果等于2 表示是特价 计算特价价格
            totalPrice=Double(good!.prefertialPrice!)!*Double(good!.carNumber!)
        }else{//计算普通价格
            totalPrice=Double(good!.uprice!)!*Double(good!.carNumber!)
        }
        if sender.selected.boolValue == true{//如果是选中状态 切换
            //设置按钮状态 为未选中
            sender.selected=false
            //通过协议传参
            delelgate?.calculationSelectTotalPrice(totalPrice,flag: false, good: good!, index: index!,count:good!.carNumber!,seletedFlag:2)
        }else{
            //设置按钮状态 为选中
            sender.selected=true
            //通过协议传参
            delelgate?.calculationSelectTotalPrice(totalPrice,flag: true, good: good!, index: index!,count:good!.carNumber!,seletedFlag:1)
        }
        
    }
    /**
     更新cell
     
     - parameter entity:商品entity
     */
    func updateCell(entity:GoodDetailEntity){
        //赋值
        good=entity
        //商品图片
        goodImgView.sd_setImageWithURL(NSURL(string:URLIMG+entity.goodPic!), placeholderImage:UIImage(named: "def_nil"))
        if entity.flag == 1{//如果是特价
            //设置提示信息
            let str:NSMutableAttributedString=NSMutableAttributedString(string:"(特价商品)"+entity.goodInfoName!+"~~限购\(good!.eachCount!)");
            str.addAttribute(NSForegroundColorAttributeName, value:UIColor.redColor(), range:NSMakeRange(0,6));
            lblGoodName.attributedText=str
            //显示特价价格
            lblGoodPirce.text="￥\(entity.prefertialPrice!)"
            //显示特价小图标
            specialOfferImgView.hidden=false;
            if entity.endTime != nil{//判断活动时间是否已经结束
                if Int(entity.endTime!) <= 0{ //如果结束
                    img!.hidden=false//显示活动已结束图片
                    countView.hidden=true//隐藏数量加减视图
                    btnSelectImg.hidden=true//隐藏商品选择视图
                }else{
                    img!.hidden=true
                    countView.hidden=false
                    btnSelectImg.hidden=false
                }
            }else{
                countView.hidden=false
                img!.hidden=true
                btnSelectImg.hidden=false
            }
        }else{//如果不是 显示普通价格
            lblGoodPirce.text="￥\(entity.uprice!)";
            lblGoodName.text=entity.goodInfoName!;
            //隐藏特价小图标
            specialOfferImgView.hidden=true;
            countView.hidden=false
            img!.hidden=true
            btnSelectImg.hidden=false
        }

        //购物车数量
        lblCountLeb.text="\(good!.carNumber!)"
        //根据文字的宽度计算商品名称是否换行
        let size=lblGoodName.text!.textSizeWithFont(lblGoodName.font!, constrainedToSize:CGSizeMake(boundsWidth-(CGRectGetMaxX(goodView.frame)+10)-10,40));
        lblGoodName.frame=CGRectMake(CGRectGetMaxX(goodView.frame)+10,goodView.frame.origin.y ,size.width,size.height);
        
        if entity.stock != -1{//表示有库存限制
            if entity.flag == 1{//表示特价
                if entity.eachCount > good!.stock{//表示 当前库存没有这么多特价商品
                    if entity.carNumber == good!.stock{//如果商品数量等于库存数量 禁用增加按钮 改变文字颜色
                        btnAddCount.enabled=false
                        lblCountLeb.textColor=UIColor.textColor()
                        
                    }else{
                        btnAddCount.enabled=true
                        lblCountLeb.textColor=UIColor.redColor()
                    }
                }else{//如果 小于
                    if entity.carNumber == entity.eachCount{//如果商品数量 等于特价商品限定数量 禁用增加按钮 改变文字颜色
                        btnAddCount.enabled=false
                        lblCountLeb.textColor=UIColor.textColor()
                    }else{
                        btnAddCount.enabled=true
                        lblCountLeb.textColor=UIColor.redColor()
                    }
                }
            }else{//如果不是特价商品
                if entity.carNumber == entity.goodsStock{//如果商品数量等于库存数量 禁用增加按钮 改变文字颜色
                    btnAddCount.enabled=false
                    lblCountLeb.textColor=UIColor.textColor()
                    
                }else{
                    btnAddCount.enabled=true
                    lblCountLeb.textColor=UIColor.redColor()
                }
            }
        }else{//库存充足
            if entity.flag == 1{//表示特价
                if entity.carNumber == entity.eachCount{//如果商品数量 等于特价商品限定数量 禁用增加按钮 改变文字颜色
                    btnAddCount.enabled=false
                    lblCountLeb.textColor=UIColor.textColor()
                }else{
                    btnAddCount.enabled=true
                    lblCountLeb.textColor=UIColor.redColor()
                }
            }
        }
        if entity.selectedFlag == 1{
            btnSelectImg.selected=true
        }else{
            btnSelectImg.selected=false
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}