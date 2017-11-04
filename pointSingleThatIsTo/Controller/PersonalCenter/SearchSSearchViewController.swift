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
import SwiftyJSON
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
        uplabel.frame=CGRect(x: 10, y: 80, width: boundsWidth-20, height: 20)
        uplabel.textAlignment=NSTextAlignment.center
        uplabel.text="输入条形码查询商品在该地区的供应商和经销商"
        uplabel.font=UIFont.systemFont(ofSize: 12)
        self.view.addSubview(uplabel)
        //搜索框容器view
        searchView=UIView()
        searchView?.frame=CGRect(x: 10, y: uplabel.frame.maxY+10, width: boundsWidth-20, height: 110)
        searchView?.backgroundColor=UIColor.white
        searchView?.layer.cornerRadius=5
        self.view.addSubview(searchView!)
        //上横线
        let upline=UIView()
        upline.frame=CGRect(x: 10, y: 10, width: boundsWidth-40, height: 0.5)
        upline.backgroundColor=UIColor(red: 0.49, green: 0.52, blue: 0.69, alpha: 1)
        searchView!.addSubview(upline)
        //搜索框
        searchFeild=UITextField()
        searchFeild?.frame=CGRect(x: 15, y: upline.frame.maxY+10, width: upline.frame.width-10, height: 20)
        searchFeild?.font=UIFont.systemFont(ofSize: 16)
        searchFeild?.placeholder="商品条形码"
        searchFeild?.clearButtonMode=UITextFieldViewMode.always
        searchFeild?.backgroundColor=UIColor.white
        searchView!.addSubview(searchFeild!)
        //下横线
        let Downline=UIView()
        Downline.frame=CGRect(x: 10, y: searchFeild!.frame.maxY+10, width: upline.frame.width, height: 0.5)
        Downline.backgroundColor=upline.backgroundColor
        searchView!.addSubview(Downline)
        //按钮
        btnSearch=UIButton()
        btnSearch?.frame=CGRect(x: 10, y: Downline.frame.maxY+10, width: upline.frame.width, height: 40)
        btnSearch?.backgroundColor=UIColor.applicationMainColor()
        btnSearch?.setTitle("搜一搜", for: UIControlState())
        btnSearch?.layer.cornerRadius=4
        btnSearch?.addTarget(self, action: Selector("clickBtn:"), for: UIControlEvents.touchUpInside)
        searchView!.addSubview(btnSearch!)
    }
    //点击按钮触发事件
    func clickBtn(_ sender:UIButton){
        //每次点击删除所有子视图
        self.scollView?.removeFromSuperview()
        let code=self.searchFeild?.text
        if code == nil || code=="" || code==" "{
            SVProgressHUD.showError(withStatus: "条形码不能为空")
        }else{//发送请求
            let countyId=userDefaults.object(forKey: "countyId") as? String
            PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.suoYuan(countyId: countyId!, goodInfoCode: code!), successClosure: { (result) -> Void in
                //解析json
                let resJS=JSON(result)
                if resJS["supplierName"].stringValue==""{
                    SVProgressHUD.showError(withStatus: "错误条形码")
                }else{
                    self.addGoodView(resJS["supplierName"].stringValue, goodsNamestringValue: resJS["goodsName"].stringValue)
                    for (_,value) in resJS["subSupplierVo"]{
                        
                        self.addSupplierName(value["subSupplierName"].stringValue)
                        self.count=self.count+1
                        
                    }
                    //设置可滑动容器的高
                    self.scollViewH=self.subSupplierVolbl.frame.maxY+CGFloat(self.count)*35+10
                    self.scollView?.frame=CGRect(x:10, y:self.searchView!.frame.maxY+10,width: boundsWidth-20,height:self.scollViewH!)
                    //容器可滑动的空间
                    self.scollView?.contentSize=CGSize(width: boundsWidth-20, height: self.scollViewH!+10)
                }

                }, failClosure: { (errorMsg) -> Void in
                    SVProgressHUD.showError(withStatus: errorMsg)
            })
        }
    }
    //添加分销商标签
    func addSupplierName(_ supplierNamestringValue:String){
        //创建分销商名称标签
        self.supplierName=UILabel()
        let subSupplierVoY:CGFloat=self.subSupplierVolbl.frame.maxY+10+CGFloat(count)*35
        self.supplierName?.text="\(supplierNamestringValue)"
        self.supplierName?.font=UIFont.systemFont(ofSize: 12)
        self.supplierName?.frame=CGRect(x: 15, y: subSupplierVoY, width: 200, height: 20)
        self.supplierName?.textColor=UIColor(red: 0.45, green: 0.45, blue: 0.45, alpha: 1)
        self.scollView?.addSubview(self.supplierName!)
        //下划线
        let lian=UIView()
        let lianY:CGFloat=self.supplierName!.frame.maxY+5
        lian.backgroundColor=UIColor.black
        lian.frame=CGRect(x: 15, y: lianY, width: boundsWidth-40, height: 0.5)
        self.scollView?.addSubview(lian)
    }
    //商品详情视图
    func addGoodView(_ supplierNamestringValue:String,goodsNamestringValue:String){
        //创建可滑动容器
        self.scollView=UIScrollView()
        self.scollView?.layer.cornerRadius=5
        self.scollView?.backgroundColor=UIColor.white
        self.view.addSubview(self.scollView!)
        //初始化商品详情标签
        goodsdetails=UILabel()
        goodsdetails.frame=CGRect(x: 15, y: 15, width: 100, height: 20)
        goodsdetails.text="商品详情"
        goodsdetails.textColor=UIColor.black
        goodsdetails.font=UIFont.boldSystemFont(ofSize: 14)
        self.scollView?.addSubview(goodsdetails)
        //红色横线
        let redLine=UIView()
        redLine.frame=CGRect(x: 10, y: goodsdetails.frame.maxY+2, width: boundsWidth-40, height: 0.5)
        redLine.backgroundColor=UIColor.red
        self.scollView?.addSubview(redLine)
        //供应商名称
        self.supplierName=UILabel()
        self.supplierName?.frame=CGRect(x: 15, y: redLine.frame.maxY+10, width: 300, height: 20)
        self.supplierName?.text="供应商名称:\(supplierNamestringValue)"
        self.supplierName?.textColor=UIColor(red: 0.45, green: 0.45, blue: 0.45, alpha: 1)
        self.supplierName?.font=UIFont.systemFont(ofSize: 12)
        self.scollView?.addSubview(self.supplierName!)
        //商品名称
        self.goodsName=UILabel()
        self.goodsName?.frame=CGRect(x: 15, y: self.supplierName!.frame.maxY+10, width: boundsWidth-50, height: 20)
        self.goodsName?.font=UIFont.systemFont(ofSize: 12)
        self.goodsName?.textColor=UIColor(red: 0.45, green: 0.45, blue: 0.45, alpha: 1)
        self.goodsName?.text="商品名称:\(goodsNamestringValue)"
        self.scollView?.addSubview(self.goodsName!)
        //分销商标签
        subSupplierVolbl=UILabel()
        subSupplierVolbl.frame=CGRect(x: 15, y: self.goodsName!.frame.maxY+10, width: 100, height: 20)
        subSupplierVolbl.textColor=UIColor(red: 0.45, green: 0.45, blue: 0.45, alpha: 1)
        subSupplierVolbl.text="分销商:"
        subSupplierVolbl.font=UIFont.systemFont(ofSize: 12)
        self.scollView?.addSubview(subSupplierVolbl)
    }
    //点击view区域收起输入键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
