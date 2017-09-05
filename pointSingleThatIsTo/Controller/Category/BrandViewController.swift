//
//  BrandViewController.swift
//  pointSingleThatIsTo
//
//  Created by 卢洋 on 16/1/31.
//  Copyright © 2016年 penghao. All rights reserved.
//
//品牌
import Foundation
import UIKit
import ObjectMapper
import SVProgressHUD
/// 品牌
class BrandViewController:BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource{
    //接受1级分类id
    var pid:Int?
    //判断页面从首页传过来还是底部工具栏(1-首页，其他从底部传过来)
    var pushState:Int=0
    //左边Table和右边UICollectionView的动态高度
    var flyHeight:CGFloat=0
    private let arr=NSMutableArray()
    private var collection:UICollectionView?
    //左边Table
    var leftTable:UITableView?
    //右边Collection
    var rightCollection:UICollectionView?
    //UICollectionView总宽度
    var cellPicW:CGFloat=0
    //存储二级分类实体类
    var childCategory:[GoodsCategoryEntity]=[]
    var nilView:UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.whiteColor()
        //根据push状态码动态修改Table的高度
        if(pushState == 1){
            flyHeight=boundsHeight - CGFloat(104)
            indexBuildView()
            queryChildCategory()
        }else{
            flyHeight=boundsHeight - CGFloat(153)
            bottomBuildView()
            queryChildCategoryBottom()
        }
    }
    /**
     首页点击进入页面
     */
    func indexBuildView(){
        let flowLayout=UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing=0//左右间隔
        flowLayout.minimumLineSpacing=0
        flowLayout.itemSize=CGSizeMake(boundsWidth/3,50)
        collection=UICollectionView(frame:CGRectMake(0,10,boundsWidth,flyHeight-20), collectionViewLayout: flowLayout)
        collection!.dataSource=self
        collection!.delegate=self
        collection!.backgroundColor=UIColor.whiteColor()
        collection!.registerClass(BrandCollectionCell.self, forCellWithReuseIdentifier: "BrandCollectionCell");
        self.view.addSubview(collection!)
    }
    /**
     底部菜单点击进入
     */
    func bottomBuildView(){
        leftTable=UITableView(frame: CGRectMake(0, 0, 100,flyHeight), style: UITableViewStyle.Plain)
        leftTable?.dataSource=self
        leftTable?.delegate=self
        leftTable?.backgroundColor=UIColor(red: 0.95, green: 0.96, blue: 0.96, alpha: 1.0)
        self.view.addSubview(leftTable!)
        //去掉15px空白
        if(leftTable!.respondsToSelector("setLayoutMargins:")){
            leftTable?.layoutMargins=UIEdgeInsetsZero
        }
        if(leftTable!.respondsToSelector("setSeparatorInset:")){
            leftTable!.separatorInset=UIEdgeInsetsZero;
        }
        leftTable?.separatorColor=UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1)
        //去除多余的单元格
        leftTable?.tableFooterView = UIView(frame:CGRectZero)
        let flowLayout=UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing=0//左右间隔
        flowLayout.minimumLineSpacing=0
        cellPicW=boundsWidth-leftTable!.frame.width
        flowLayout.itemSize=CGSizeMake(cellPicW/3,50)
        collection=UICollectionView(frame:CGRectMake(leftTable!.frame.width-1,10,cellPicW,flyHeight-20), collectionViewLayout: flowLayout)
        collection!.dataSource=self
        collection!.delegate=self
        collection!.backgroundColor=UIColor.whiteColor()
        collection!.registerClass(BrandCollectionCell.self, forCellWithReuseIdentifier: "BrandCollectionCell");
        self.view.addSubview(collection!)
    }
    //MARK ------------Table的代理--------------------------
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return childCategory.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let Identifier="MultilevelTableViewCell" + "\(indexPath.row)"
        var cell=tableView.dequeueReusableCellWithIdentifier(Identifier);
        if(cell == nil){
            cell=UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier:Identifier)
            
        }
        if(childCategory.count > 0){
            cell?.textLabel?.text=childCategory[indexPath.row].goodsCategoryName
        }
        cell?.textLabel?.font=UIFont.systemFontOfSize(14)
        cell?.backgroundColor=UIColor(red: 0.95, green: 0.96, blue: 0.96, alpha: 1.0)
        cell?.selectionStyle=UITableViewCellSelectionStyle.None
        if(cell!.respondsToSelector("setLayoutMargins:")){
            cell!.layoutMargins=UIEdgeInsetsZero
        }
        if(cell!.respondsToSelector("setSeparatorInset:")){
            cell!.separatorInset=UIEdgeInsetsZero;
        }
        //默认选中的视图背景颜色
        cell?.selectedBackgroundView?.backgroundColor=UIColor.whiteColor()
        //设置默认的字体颜色
        cell?.textLabel?.textColor=UIColor.blackColor()
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell=tableView.cellForRowAtIndexPath(indexPath)
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        cell?.backgroundColor=UIColor.whiteColor()
        cell?.textLabel?.textColor=UIColor.applicationMainColor()
        let pid=childCategory[indexPath.row].goodsCategoryId
        httpGoodCategoryThree(pid!)
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell=tableView.cellForRowAtIndexPath(indexPath)
        cell?.backgroundColor=UIColor(red: 0.95, green: 0.96, blue: 0.96, alpha: 1.0)
        cell?.textLabel?.textColor=UIColor.blackColor()
    }

    //MARK ----------UICollectionView的代理--------------------
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count;
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCellWithReuseIdentifier("BrandCollectionCell", forIndexPath: indexPath) as! BrandCollectionCell
        if arr.count > 0{
            let entity=arr[indexPath.row] as! GoodsCategoryEntity
            cell.updateCell(entity)
            cell.btn.addTarget(self, action:"pushGoodCategory3:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.btn.tag=indexPath.row
        }
        return cell;
    }
    func pushGoodCategory3(sender:UIButton){
        let entity=arr[sender.tag] as! GoodsCategoryEntity
        let GoodCategory3VC=GoodCategory3ViewController()
        GoodCategory3VC.hidesBottomBarWhenPushed=true
        GoodCategory3VC.flag=1
        GoodCategory3VC.goodsCategoryId=pid
        GoodCategory3VC.searchName=entity.brandname
        self.navigationController!.pushViewController(GoodCategory3VC, animated:true)
    }
    /**
     queryCategory4AndroidAll.xhtml   请求所有品牌
     - parameter goodsCategoryId: 一级分类ID
     */
    func queryChildCategory(){
        //判断网络状态
        if(IJReachability.isConnectedToNetwork()){
            SVProgressHUD.showWithStatus("数据加载中")
            let currPid=pid ?? 1
            //获取分站ID
            let substationId=userDefaults.objectForKey("substationId") as! String
            PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryTwoCategoryForMob(goodsCategoryId:currPid,substationId:substationId), successClosure: { (result) -> Void in
                let json=JSON(result)
                if let dic=json.dictionaryObject{
                    for(key,value) in dic{
                        if key == "全部"{
                            let jsonArr=JSON(value)
                            for(_,bValue) in jsonArr["brand"]{
                                
                                let entity=Mapper<GoodsCategoryEntity>().map(bValue.object)
                                self.arr.addObject(entity!)
                                
                            }
                            break
                        }
                        
                    }

                }
                if self.arr.count > 0{
                    self.nilView?.removeFromSuperview()
                }else{
                    self.nilView?.removeFromSuperview()
                    self.nilView=nilPromptView("还木有相关品牌")
                    self.nilView!.center=self.collection!.center
                    self.view.addSubview(self.nilView!)
                }
                SVProgressHUD.dismiss()
                self.collection!.reloadData()
                }) { (errorMsg) -> Void in
                    SVProgressHUD.showErrorWithStatus(errorMsg)
            }
            
        }else{
            SVProgressHUD.showErrorWithStatus("无网络连接")
        }
        
        
    }
    /**
     从底部点击分类
     */
    func queryChildCategoryBottom(){
        //判断网络状态
        if(IJReachability.isConnectedToNetwork()){
            let currPid=pid ?? 1
            SVProgressHUD.showWithStatus("数据加载中")
            PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryCategory4AndroidAll(goodsCategoryId:currPid), successClosure: { (result) -> Void in
                let json=JSON(result)
                print("二级分类\(json)")
                for(_,value) in json{
                    let entity=Mapper<GoodsCategoryEntity>().map(value.object)
                    self.childCategory.append(entity!)
                }
                SVProgressHUD.dismiss()
                self.leftTable?.reloadData()
                let first=NSIndexPath(forRow: 0, inSection: 0)
                self.leftTable?.selectRowAtIndexPath(first, animated: true, scrollPosition: UITableViewScrollPosition.None)
                if(self.leftTable!.delegate!.respondsToSelector("tableView:didSelectRowAtIndexPath:")){
                    self.leftTable!.delegate!.tableView!(self.leftTable!, didSelectRowAtIndexPath: first)
                }
                }, failClosure: { (errorMsg) -> Void in
                    SVProgressHUD.showErrorWithStatus(errorMsg)
            })
            
        }else{
            SVProgressHUD.showErrorWithStatus("无网络连接")
        }
    }
    /**
     queryCategory4Android.xhtml   发送三级分类请求
     - parameter goodsCategoryId: 二级分类ID
     - parameter substationId: 分站ID
     */
    func httpGoodCategoryThree(goodsCategoryId:Int){
        //获取分站ID
        let substationId=userDefaults.objectForKey("substationId") as! String
        if IJReachability.isConnectedToNetwork(){
            PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryBrandList4Android(goodscategoryId:goodsCategoryId, substationId: substationId), successClosure: { (result) -> Void in
                let json=JSON(result)
                print("3级分类\(json)")
                self.arr.removeAllObjects()
                for(_,value) in json{
                    let entity=Mapper<GoodsCategoryEntity>().map(value.object)
                    self.arr.addObject(entity!)
                }
                self.collection!.reloadData()
                if self.arr.count > 0{
                    self.nilView?.removeFromSuperview()
                }else{
                    self.nilView?.removeFromSuperview()
                    self.nilView=nilPromptView("还木有相关品牌")
                    self.nilView!.center=self.collection!.center
                    self.view.addSubview(self.nilView!)
                }
                }, failClosure: { (errorMsg) -> Void in
                    SVProgressHUD.showErrorWithStatus(errorMsg)
            })
        }else{
            SVProgressHUD.showErrorWithStatus("无网络连接")
        }
    }

}
   