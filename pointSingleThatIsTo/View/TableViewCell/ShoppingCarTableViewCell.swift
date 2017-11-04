//
//  ShoppingCarTableViewCell.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/2/16.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
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
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}

//购物车cell协议。。
protocol ShoppingCarTableViewCellDelegate : NSObjectProtocol {
    /**
     计算选择商品的总价格
     - parameter index:      行索引
     */
    func calculationSelectTotalPrice(_ index:IndexPath);
    /**
     限购提示
     
     - parameter inventory: 库存数
     - parameter eachCount: 限购数
     - parameter count:     购买数量
     - parameter flag:      是否特价 1yes 2no
     */
    func reachALimitPrompt(_ inventory:Int,eachCount:Int?,count:Int,flag:Int)
    
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
    var index:IndexPath?;
    
    /// 活动已结束
    var img:UIImageView?
    
    /// 促销图片
    var CXImg:UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //边框颜色
        let color=UIColor.borderColor();
        
        //选择图片
        selectImg=UIImage(named:"select_05");
        selectImgSelected=UIImage(named:"select_03");
        
        //给选择图片加上按钮实现点击切换
        btnSelectImg=UIButton(frame:CGRect(x: 15,y: (120-25)/2,width: 25,height: 25));
        btnSelectImg.setImage(selectImg, for:UIControlState())
        btnSelectImg.setImage(selectImgSelected, for:.selected);
        btnSelectImg.addTarget(self, action:"selectImgSwitch:", for: UIControlEvents.touchUpInside);
        self.contentView.addSubview(btnSelectImg);
        
        
        //放商品图片的view
        goodView=UIView(frame:CGRect(x: btnSelectImg.frame.maxX+15,y: (120-90)/2,width: 90,height: 90))
        goodView.layer.borderColor=color.cgColor;
        goodView.layer.borderWidth=0.5;
        
        
        //商品图片
        goodImgView=UIImageView(frame:CGRect(x: 0,y: 0,width: goodView.frame.width,height: goodView.frame.height))
        goodImgView.image=nil;
        goodView.addSubview(goodImgView);
        self.contentView.addSubview(goodView)
        
        CXImg=UIImageView(frame:CGRect(x: goodView.frame.width-44,y: 0,width: 44,height: 46))
        CXImg.image=UIImage(named:"sales_promotion")
        CXImg.isHidden=true
        goodView.addSubview(CXImg)
        
        //特价图片
        specialOfferImgView=UIImageView(frame:CGRect(x: 50,y: 50,width: 30, height: 30))
        specialOfferImgView.image=UIImage(named:"special_offer");
        specialOfferImgView.isHidden=true;
        goodView.addSubview(specialOfferImgView);
        
        /// 活动已结束(默认隐藏)
        img=UIImageView(frame:CGRect(x: boundsWidth-70,y: 40,width: 60,height: 60))
        img!.image=UIImage(named: "to_sell_end")
        img!.isHidden=true
        self.contentView.addSubview(img!)
        
        //商品名称
        lblGoodName=UILabel(frame:CGRect(x: goodView.frame.maxX+10,y: goodView.frame.origin.y,width: boundsWidth-(goodView.frame.maxX+10)-10,height: 40));
        lblGoodName.lineBreakMode=NSLineBreakMode.byWordWrapping;
        lblGoodName.numberOfLines=0;
        lblGoodName.font=UIFont.systemFont(ofSize: 13);
        lblGoodName.textColor=UIColor.textColor()
        self.contentView.addSubview(lblGoodName)
        
        //商品价格
        lblGoodPirce=UILabel(frame:CGRect(x: goodView.frame.maxX+10,y: goodView.frame.maxY-50,width: 100,height: 20));
        lblGoodPirce.font=UIFont.systemFont(ofSize: 13);
        lblGoodPirce.textColor=UIColor(red:51/255, green:51/255, blue:51/255, alpha:1);
        self.contentView.addSubview(lblGoodPirce)
        
        //商品数量加减视图
        countView=UIView(frame:CGRect(x: goodView.frame.maxX+10,y: goodView.frame.maxY-30,width: 130,height: 30));
        countView!.layer.borderColor=UIColor(red:180/255, green:180/255, blue:180/255, alpha:1).cgColor
        countView!.layer.borderWidth=1
        countView!.layer.cornerRadius=3
        countView!.layer.masksToBounds=true
        countView!.backgroundColor=UIColor.white;
        
        //减号按钮
        let countWidth:CGFloat=40;
        btnReductionCount=UIButton(frame:CGRect(x: 0,y: 0,width: countWidth,height: countView.frame.height));
        btnReductionCount.setTitle("-", for:UIControlState());
        btnReductionCount.titleLabel!.font=UIFont.boldSystemFont(ofSize: 22)
        btnReductionCount.setTitleColor(UIColor(red:204/255, green:204/255, blue:204/255, alpha: 1), for: UIControlState())
        btnReductionCount.addTarget(self, action:"reductionCount:", for: UIControlEvents.touchUpInside);
        btnReductionCount.setTitleColor(UIColor.white, for: UIControlState.highlighted)
        btnReductionCount.backgroundColor=UIColor.white
        countView.addSubview(btnReductionCount);
        
        //数组lab
        lblCountLeb=UILabel(frame:CGRect(x: btnReductionCount.frame.width,y: 0,width: countWidth+10,height: countView.frame.height));
        lblCountLeb.textColor=UIColor(red:225/255, green:45/255, blue:45/255, alpha:1);
        lblCountLeb.layer.borderColor=UIColor(red:180/255, green:180/255, blue:180/255, alpha:1).cgColor;
        lblCountLeb.layer.borderWidth=1;
        lblCountLeb.text="1";
        lblCountLeb.textAlignment=NSTextAlignment.center;
        lblCountLeb.font=UIFont.systemFont(ofSize: 16);
        countView.addSubview(lblCountLeb);
        
        //加号按钮
        btnAddCount=UIButton(frame:CGRect(x: lblCountLeb.frame.maxX,y: 0,width: countWidth,height: countView.frame.height));
        btnAddCount.backgroundColor=UIColor.white
        btnAddCount.setTitle("+", for:UIControlState());
        btnAddCount.titleLabel!.font=UIFont.systemFont(ofSize: 22)
        btnAddCount.setTitleColor(UIColor(red:204/255, green:204/255, blue:204/255, alpha: 1), for: UIControlState())
        btnAddCount.setTitleColor(UIColor.white, for: UIControlState.highlighted)
        btnAddCount.addTarget(self, action:"addCount:", for: UIControlEvents.touchUpInside);
        countView.addSubview(btnAddCount);
        
        self.contentView.addSubview(countView);
        self.selectionStyle=UITableViewCellSelectionStyle.none;
    }
    /**
     减去购物车数量
     
     - parameter sender: UIButton
     */
    func reductionCount(_ sender:UIButton){
        if good!.carNumber > good!.miniCount{//购物车数量大于1的时候 可以进行减少操作
            good!.carNumber!-=good!.goodsBaseCount!
            lblCountLeb.text="\(good!.carNumber!)";
            delelgate?.calculationSelectTotalPrice(index!)
            //恢复增加按钮 操作
            btnAddCount.isEnabled=true;
            //恢复数量文字颜色
            lblCountLeb.textColor=UIColor(red:225/255, green:45/255, blue:45/255, alpha:1);
            //发送通知更新角标
            NotificationCenter.default.post(name: Notification.Name(rawValue: "postBadgeValue"), object:3, userInfo:["carCount":good!.goodsBaseCount!])
        }
    }
    /**
     增加购物车数量
     
     - parameter sender: UIButton
     */
    func addCount(_ sender:UIButton){
        if good!.flag == 1 || good!.flag == 3{//如果是特价商品 或者促销商品
            if good!.stock != -1{//特价库存是否充足
                if good!.eachCount > good!.stock{//如果特价限定数量 大于 库存数量
                    if good!.carNumber > good!.stock!-good!.goodsBaseCount!{//特价商品只能购买库存数量以内的商品数量
                        //调用达到限定数量方法
                        reachALimitCount()
                        //调用限购提示方法
                        delelgate?.reachALimitPrompt(good!.stock!, eachCount:good!.eachCount!,count:good!.carNumber!,flag:1)
                    }else{//如果不等于库存数量 继续增加
                        good!.carNumber!+=good!.goodsBaseCount!
                        //调用没有达到限定数量方法
                        noReachALimitCount()
                    }
                }else{//如果特价限定数量 小于 库存数量
                    if good!.carNumber > good!.eachCount!-good!.goodsBaseCount!{//如果商品数量大于限购数量
                        //调用达到限定数量方法
                        reachALimitCount()
                        //调用限购提示方法
                        delelgate?.reachALimitPrompt(good!.stock!, eachCount:good!.eachCount!,count:good!.carNumber!,flag: 1)
                        
                    }else{//如果没有达到限购数量 继续增加
                        good!.carNumber!+=good!.goodsBaseCount!
                        //调用没有达到限定数量方法
                        noReachALimitCount()
                    }
                }
            }else{
                if good!.carNumber > good!.eachCount!-good!.goodsBaseCount!{//如果商品数量 达到限购数量
                    //调用达到限定数量方法
                    reachALimitCount()
                    //调用限购提示方法
                    delelgate?.reachALimitPrompt(good!.goodsStock!, eachCount:good!.eachCount!,count:good!.carNumber!,flag:1)
                }else{
                    good!.carNumber!+=good!.goodsBaseCount!
                    //调用没有达到限定数量方法
                    noReachALimitCount()
                }
            }
        }else{//如果不是特价商品
            if good!.goodsStock != -1{//如果库存不充足
                if good!.carNumber > good!.goodsStock!-good!.goodsBaseCount!{//如果商品达到限购数量
                    //调用达到限定数量方法
                    reachALimitCount()
                    //调用限购提示方法
                    delelgate?.reachALimitPrompt(good!.goodsStock!, eachCount:good!.eachCount,count:good!.carNumber!,flag:2)
                    
                }else{//如果没有达到限购数量
                    //调用没有达到限定数量方法
                    good!.carNumber!+=good!.goodsBaseCount!
                    noReachALimitCount()
                }
            }else{
                //调用没有达到限定数量方法
                good!.carNumber!+=good!.goodsBaseCount!
                noReachALimitCount()
            }
            
        }
    }
    /**
     达到限定数量
     */
    func reachALimitCount(){
            //禁用增加按钮
            btnAddCount.isEnabled=false
            //改变文字颜色
            lblCountLeb.textColor=UIColor.textColor()
            //改变文字数量
            lblCountLeb.text="\(good!.carNumber!)"
        
    }
    /**
     没有达到限定数量
     
     - parameter totalPrice:价格
     */
    func noReachALimitCount(){
        
        delelgate?.calculationSelectTotalPrice(index!)
        //改变文字数量
        lblCountLeb.text="\(good!.carNumber!)"
        //发送通知更新角标
        NotificationCenter.default.post(name: Notification.Name(rawValue: "postBadgeValue"), object:2, userInfo:["carCount":good!.goodsBaseCount!])
        
    }
    /**
     选中购物车商品
     
     - parameter sender:UIButton
     */
    func selectImgSwitch(_ sender:UIButton){
        
        if sender.isSelected == true{//如果是选中状态 切换
            //设置按钮状态 为未选中
            sender.isSelected=false
            good!.isSelected=2
        }else{
            //设置按钮状态 为选中
            sender.isSelected=true
            good!.isSelected=1
            
        }
        delelgate?.calculationSelectTotalPrice(index!)
        
    }
    /**
     更新cell
     
     - parameter entity:商品entity
     */
    func updateCell(_ entity:GoodDetailEntity){
        //赋值
        good=entity
        entity.goodPic=entity.goodPic ?? ""
        //商品图片
        goodImgView.sd_setImage(with: Foundation.URL(string:URLIMG+entity.goodPic!), placeholderImage:UIImage(named: "def_nil"))
        if entity.flag == 1{//如果是特价
            //设置提示信息
            let str:NSMutableAttributedString=NSMutableAttributedString(string:"(特价商品)"+entity.goodInfoName!+"~~限购\(good!.eachCount!)\(entity.goodUnit!)");
            str.addAttribute(NSAttributedStringKey.foregroundColor, value:UIColor.red, range:NSMakeRange(0,6));
            lblGoodName.attributedText=str
            //显示特价价格
            lblGoodPirce.text="￥\(entity.prefertialPrice!)/\(entity.goodUnit!)"
            //显示特价小图标
            specialOfferImgView.isHidden=false;
            CXImg.isHidden=true
            if entity.endTime != nil{//判断活动时间是否已经结束
                if Int(entity.endTime!) <= 0{ //如果结束
                    img!.isHidden=false//显示活动已结束图片
                    countView.isHidden=true//隐藏数量加减视图
                    btnSelectImg.isHidden=true//隐藏商品选择视图
                }else{
                    img!.isHidden=true
                    countView.isHidden=false
                    btnSelectImg.isHidden=false
                }
            }else{
                countView.isHidden=false
                img!.isHidden=true
                btnSelectImg.isHidden=false
            }
        }else if entity.flag == 3{//如果为促销商品
            //设置提示信息
            let str:NSMutableAttributedString=NSMutableAttributedString(string:"(促销商品)"+entity.goodInfoName!+"~~限购\(good!.eachCount!)\(entity.goodUnit!)");
            str.addAttribute(NSAttributedStringKey.foregroundColor, value:UIColor.red, range:NSMakeRange(0,6));
            lblGoodName.attributedText=str
            lblGoodPirce.text="￥\(entity.uprice!)/\(entity.goodUnit!)";
            CXImg.isHidden=false
            specialOfferImgView.isHidden=true
            if entity.endTime != nil{//判断活动时间是否已经结束
                if Int(entity.endTime!) <= 0{ //如果结束
                    img!.isHidden=false//显示活动已结束图片
                    countView.isHidden=true//隐藏数量加减视图
                    btnSelectImg.isHidden=true//隐藏商品选择视图
                }else{
                    img!.isHidden=true
                    countView.isHidden=false
                    btnSelectImg.isHidden=false
                }
            }else{
                countView.isHidden=false
                img!.isHidden=true
                btnSelectImg.isHidden=false
            }

        }else{//如果不是 显示普通价格
            lblGoodPirce.text="￥\(entity.uprice!)/\(entity.goodUnit!)";
            lblGoodName.text=entity.goodInfoName
            //隐藏促销小图标
            CXImg.isHidden=true
            //隐藏特价小图标
            specialOfferImgView.isHidden=true;
            countView.isHidden=false
            img!.isHidden=true
            btnSelectImg.isHidden=false
        }

        //购物车数量
        lblCountLeb.text="\(good!.carNumber!)"
        //根据文字的宽度计算商品名称是否换行
        let size=lblGoodName.text!.textSizeWithFont(lblGoodName.font!, constrainedToSize:CGSize(width: boundsWidth-(goodView.frame.maxX+10)-10,height: 40));
        lblGoodName.frame=CGRect(x: goodView.frame.maxX+10,y: goodView.frame.origin.y ,width: size.width,height: size.height);
        
        if entity.stock != -1{//表示有库存限制
            if entity.flag == 1 || entity.flag == 3{//表示特价 或者促销
                if entity.eachCount > good!.stock{//表示 当前库存没有这么多特价商品
                    if entity.carNumber == good!.stock{//如果商品数量等于库存数量 禁用增加按钮 改变文字颜色
                        btnAddCount.isEnabled=false
                        lblCountLeb.textColor=UIColor.textColor()
                        
                    }else{
                        btnAddCount.isEnabled=true
                        lblCountLeb.textColor=UIColor.red
                    }
                }else{//如果 小于
                    if entity.carNumber == entity.eachCount{//如果商品数量 等于特价商品限定数量 禁用增加按钮 改变文字颜色
                        btnAddCount.isEnabled=false
                        lblCountLeb.textColor=UIColor.textColor()
                    }else{
                        btnAddCount.isEnabled=true
                        lblCountLeb.textColor=UIColor.red
                    }
                }
            }else{//如果不是特价商品
                if entity.carNumber == entity.goodsStock{//如果商品数量等于库存数量 禁用增加按钮 改变文字颜色
                    btnAddCount.isEnabled=false
                    lblCountLeb.textColor=UIColor.textColor()
                    
                }else{
                    btnAddCount.isEnabled=true
                    lblCountLeb.textColor=UIColor.red
                }
            }
        }else{//库存充足
            if entity.flag == 1 || entity.flag == 3{//表示特价或者促销
                if entity.carNumber == entity.eachCount{//如果商品数量 等于特价商品限定数量 禁用增加按钮 改变文字颜色
                    btnAddCount.isEnabled=false
                    lblCountLeb.textColor=UIColor.textColor()
                }else{
                    btnAddCount.isEnabled=true
                    lblCountLeb.textColor=UIColor.red
                }
            }
        }
        if entity.isSelected == 1{
            btnSelectImg.isSelected=true
        }else{
            btnSelectImg.isSelected=false
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
