//
//  SearchSSearchViewController.swift
//  pointSingleThatIsTo
//
//  Created by nevermore on 16/1/27.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import SVProgressHUD
class SearchSSearchViewController:BaseViewController{
    ///搜索框容器view
    var searchView:UIView?
    /// 搜索框
    var searchFeild:UITextField?
    /// 搜索按钮
    var btnSearch:UIButton?
    /// 商品名称
    var goodsName:UILabel?
    /// 商品图片
    var goodsPic:UIImageView?
    /// 分销商
    var subSupplierVo:UILabel?
    /// 供应商名称
    var supplierName:UILabel?
    /// 可滑动容器
    var scollView:UIScrollView?
    /// 可滑动容器的高
    var scollViewH:CGFloat?
    /// 商品详情标签
    var goodsdetails:UILabel!
    /// //分销商标签
    var subSupplierVolbl:UILabel!
    var count=0
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置页面标题
        self.title="搜一搜"
        //设置页面背景色
        self.view.backgroundColor=UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        initui()
    }
    //ui布局
    func initui(){
        //顶部介绍标签
        let uplabel:UILabel=UILabel()
        uplabel.frame=CGRectMake(10, 80, boundsWidth-20, 20)
        uplabel.textAlignment=NSTextAlignment.Center
        uplabel.text="输入条形码查询商品在该地区的供应商和经销商"
        uplabel.font=UIFont.systemFontOfSize(12)
        self.view.addSubview(uplabel)
        //搜索框容器view
        searchView=UIView()
        searchView?.frame=CGRectMake(10, CGRectGetMaxY(uplabel.frame)+10, boundsWidth-20, 110)
        searchView?.backgroundColor=UIColor.whiteColor()
        searchView?.layer.cornerRadius=5
        self.view.addSubview(searchView!)
        //上横线
        let upline=UIView()
        upline.frame=CGRectMake(10, 10, boundsWidth-40, 0.5)
        upline.backgroundColor=UIColor(red: 0.49, green: 0.52, blue: 0.69, alpha: 1)
        searchView!.addSubview(upline)
        //搜索框
        searchFeild=UITextField()
        searchFeild?.frame=CGRectMake(15, CGRectGetMaxY(upline.frame)+10, upline.frame.width-10, 20)
        searchFeild?.font=UIFont.systemFontOfSize(16)
        searchFeild?.placeholder="商品条形码"
        searchFeild?.clearButtonMode=UITextFieldViewMode.Always
        searchFeild?.backgroundColor=UIColor.whiteColor()
        searchView!.addSubview(searchFeild!)
        //下横线
        let Downline=UIView()
        Downline.frame=CGRectMake(10, CGRectGetMaxY(searchFeild!.frame)+10, upline.frame.width, 0.5)
        Downline.backgroundColor=upline.backgroundColor
        searchView!.addSubview(Downline)
        //按钮
        btnSearch=UIButton()
        btnSearch?.frame=CGRectMake(10, CGRectGetMaxY(Downline.frame)+10, upline.frame.width, 40)
        btnSearch?.backgroundColor=UIColor.applicationMainColor()
        btnSearch?.setTitle("搜一搜", forState: UIControlState.Normal)
        btnSearch?.layer.cornerRadius=4
        btnSearch?.addTarget(self, action: "clickBtn:", forControlEvents: UIControlEvents.TouchUpInside)
        searchView!.addSubview(btnSearch!)
    }
    //点击按钮触发事件
    func clickBtn(sender:UIButton){
        //每次点击删除所有子视图
        self.scollView?.removeFromSuperview()
        let code=self.searchFeild?.text
        if code == nil || code=="" || code==" "{
            SVProgressHUD.showErrorWithStatus("条形码不能为空")
        }else{//发送请求
            let countyId=userDefaults.objectForKey("countyId") as? String
            PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.SuoYuan(countyId: countyId!, goodInfoCode: code!), successClosure: { (result) -> Void in
                //解析json
                let resJS=JSON(result)
                if resJS["supplierName"].stringValue==""{
                    SVProgressHUD.showErrorWithStatus("错误条形码")
                }else{
                    self.addGoodView(resJS["supplierName"].stringValue, goodsNamestringValue: resJS["goodsName"].stringValue)
                    for (_,value) in resJS["subSupplierVo"]{
                        
                        self.addSupplierName(value["subSupplierName"].stringValue)
                        self.count=self.count+1
                        
                    }
                    //设置可滑动容器的高
                    self.scollViewH=CGRectGetMaxY(self.subSupplierVolbl.frame)+CGFloat(self.count)*35+10
                    self.scollView?.frame=CGRectMake(10, CGRectGetMaxY(self.searchView!.frame)+10, boundsWidth-20, self.scollViewH!)
                    //容器可滑动的空间
                    self.scollView?.contentSize=CGSize(width: boundsWidth-20, height: self.scollViewH!+10)
                }

                }, failClosure: { (errorMsg) -> Void in
                    SVProgressHUD.showErrorWithStatus(errorMsg)
            })
        }
    }
    //添加分销商标签
    func addSupplierName(supplierNamestringValue:String){
        //创建分销商名称标签
        self.supplierName=UILabel()
        let subSupplierVoY:CGFloat=CGRectGetMaxY(self.subSupplierVolbl.frame)+10+CGFloat(count)*35
        self.supplierName?.text="\(supplierNamestringValue)"
        self.supplierName?.font=UIFont.systemFontOfSize(12)
        self.supplierName?.frame=CGRectMake(15, subSupplierVoY, 200, 20)
        self.supplierName?.textColor=UIColor(red: 0.45, green: 0.45, blue: 0.45, alpha: 1)
        self.scollView?.addSubview(self.supplierName!)
        //下划线
        let lian=UIView()
        let lianY:CGFloat=CGRectGetMaxY(self.supplierName!.frame)+5
        lian.backgroundColor=UIColor.blackColor()
        lian.frame=CGRectMake(15, lianY, boundsWidth-40, 0.5)
        self.scollView?.addSubview(lian)
    }
    //商品详情视图
    func addGoodView(supplierNamestringValue:String,goodsNamestringValue:String){
        //创建可滑动容器
        self.scollView=UIScrollView()
        self.scollView?.layer.cornerRadius=5
        self.scollView?.backgroundColor=UIColor.whiteColor()
        self.view.addSubview(self.scollView!)
        //初始化商品详情标签
        goodsdetails=UILabel()
        goodsdetails.frame=CGRectMake(15, 15, 100, 20)
        goodsdetails.text="商品详情"
        goodsdetails.textColor=UIColor.blackColor()
        goodsdetails.font=UIFont.boldSystemFontOfSize(14)
        self.scollView?.addSubview(goodsdetails)
        //红色横线
        let redLine=UIView()
        redLine.frame=CGRectMake(10, CGRectGetMaxY(goodsdetails.frame)+2, boundsWidth-40, 0.5)
        redLine.backgroundColor=UIColor.redColor()
        self.scollView?.addSubview(redLine)
        //供应商名称
        self.supplierName=UILabel()
        self.supplierName?.frame=CGRectMake(15, CGRectGetMaxY(redLine.frame)+10, 300, 20)
        self.supplierName?.text="供应商名称:\(supplierNamestringValue)"
        self.supplierName?.textColor=UIColor(red: 0.45, green: 0.45, blue: 0.45, alpha: 1)
        self.supplierName?.font=UIFont.systemFontOfSize(12)
        self.scollView?.addSubview(self.supplierName!)
        //商品名称
        self.goodsName=UILabel()
        self.goodsName?.frame=CGRectMake(15, CGRectGetMaxY(self.supplierName!.frame)+10, boundsWidth-50, 20)
        self.goodsName?.font=UIFont.systemFontOfSize(12)
        self.goodsName?.textColor=UIColor(red: 0.45, green: 0.45, blue: 0.45, alpha: 1)
        self.goodsName?.text="商品名称:\(goodsNamestringValue)"
        self.scollView?.addSubview(self.goodsName!)
        //分销商标签
        subSupplierVolbl=UILabel()
        subSupplierVolbl.frame=CGRectMake(15, CGRectGetMaxY(self.goodsName!.frame)+10, 100, 20)
        subSupplierVolbl.textColor=UIColor(red: 0.45, green: 0.45, blue: 0.45, alpha: 1)
        subSupplierVolbl.text="分销商:"
        subSupplierVolbl.font=UIFont.systemFontOfSize(12)
        self.scollView?.addSubview(subSupplierVolbl)
    }
    //点击view区域收起输入键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}
