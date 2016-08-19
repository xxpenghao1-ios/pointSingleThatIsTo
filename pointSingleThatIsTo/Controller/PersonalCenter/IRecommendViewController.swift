//
//  IRecommendViewController.swift
//  pointSingleThatIsTo
//
//  Created by nevermore on 16/1/27.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import SVProgressHUD

class IRecommendViewController:BaseViewController,UITableViewDataSource,UITableViewDelegate {
    /// table
    var tableView:UITableView?
    /// 接收请求数据的集合（推荐人）
    var IREntity=NSMutableArray()
    /// 会员ID
    var storeId:String?
    var nilView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //从缓存拿到ID
        storeId=userDefaults.objectForKey("storeId") as? String
        //设置页面标题
        self.title="我推荐的人"
        //设置页面背景色
        self.view.backgroundColor=UIColor.whiteColor()
        
        if IJReachability.isConnectedToNetwork(){
            //发送网络请求
            http()
            self.tabel()
        }else{
            SVProgressHUD.showErrorWithStatus("无网络连接")
        }
    }
    //初始化UI
    func tabel(){
        //初始化table
        tableView=UITableView(frame: CGRectMake(0, 0, boundsWidth,boundsHeight), style: UITableViewStyle.Plain)
        tableView?.backgroundColor=UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1)
        tableView?.backgroundColor=UIColor.whiteColor()
        tableView?.delegate=self
        tableView?.dataSource=self
        tableView?.showsVerticalScrollIndicator=false
        tableView?.showsHorizontalScrollIndicator=false
        //移除空单元格
        tableView!.tableFooterView = UIView(frame:CGRectZero)
        self.view.addSubview(tableView!)
        //去除15px的空白线
        if(tableView!.respondsToSelector("setLayoutMargins:")){
            tableView?.layoutMargins=UIEdgeInsetsZero
        }
        if(tableView!.respondsToSelector("setSeparatorInset:")){
            tableView!.separatorInset=UIEdgeInsetsZero;
        }
        
    }
    //2.返回几组
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    //3.返回多少行
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IREntity.count
    }
    //4.返回行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    //5.数据源
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //定义标示符
        let cells:String="cells";
        var cell=tableView.dequeueReusableCellWithIdentifier(cells) as? IRecommendViewControllerCell
        if(cell == nil){
            cell=IRecommendViewControllerCell(style: UITableViewCellStyle.Default, reuseIdentifier: cells)
        }
        
        if self.IREntity.count > 0{
            //插入数据显示
            let entity:IRecommendEntity=self.IREntity[indexPath.row] as! IRecommendEntity
            cell?.dateshow(entity)
        }
        ///取消点击效果（如QQ空间）
        cell?.selectionStyle=UITableViewCellSelectionStyle.None;
        //去除15px的空白线
        if(cell!.respondsToSelector("setLayoutMargins:")){
            cell!.layoutMargins=UIEdgeInsetsZero
        }
        if(cell!.respondsToSelector("setSeparatorInset:")){
            cell!.separatorInset=UIEdgeInsetsZero;
        }
        //添加系统箭头
        cell?.accessoryType = .DisclosureIndicator;
        return cell!
    }
    //6.表格点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //释放选中效果
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
        let vc=IRecommendViewControllerAgain();
        vc.IREntity=self.IREntity[indexPath.row] as! IRecommendEntity
        self.navigationController?.pushViewController(vc, animated:true);
        
    }
    //发送请求
    func http(){
        //加载等待视图
        SVProgressHUD.showWithStatus("数据加载中", maskType: .Clear)
        let storeId=self.storeId
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryRecommended(storeId: storeId!), successClosure: { (result) -> Void in
            SVProgressHUD.dismiss()
            //解析json
            let jsonResult=JSON(result)
            for (_,value) in jsonResult{
                let entity=Mapper<IRecommendEntity>().map(value.object)
                self.IREntity.addObject(entity!)
            }
            if self.IREntity.count > 0{
                self.tableView?.reloadData()
            }else{
                self.nilView?.removeFromSuperview()
                self.nilView=nilPromptView("没有该信息记录")
                self.nilView!.center=self.view.center
                self.view.addSubview(self.nilView!)
            }
            }) { (errorMsg) -> Void in
                SVProgressHUD.showErrorWithStatus(errorMsg)
        }
    }
}