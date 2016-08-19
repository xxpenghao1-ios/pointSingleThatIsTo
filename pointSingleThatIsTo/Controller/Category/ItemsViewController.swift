//
//  ItemsViewController.swift
//  pointSingleThatIsTo
//
//  Created by 卢洋 on 16/1/31.
//  Copyright © 2016年 penghao. All rights reserved.
//
//品项
import Foundation
import UIKit
import ObjectMapper
import SVProgressHUD

class ItemsViewController:BaseViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource{
    
    //用户信息
    var userDefaults=NSUserDefaults.standardUserDefaults()
    
    //左边Table
    var leftTable:UITableView?
    
    //右边Collection
    var rightCollection:UICollectionView?
    
    //UICollectionView总宽度
    var cellPicW:CGFloat=0
    
    //Table右垂直分割线
    var rightLine:UILabel!
    
    //一级分类ID
    var pid:Int?
    
    //存储二级分类实体类
    var childCategory:[GoodsCategoryEntity]=[]
    
    //存储三级分类实体类
    var threeCategory:[GoodsCategoryEntity]=[]
    
    //网络连接状态码
    private var isNetWork:Bool=true
    
    //判断页面从首页传过来还是底部工具栏(1-首页，其他从底部传过来)
    var pushState:Int=0
    
    //左边Table和右边UICollectionView的动态高度
    var flyHeight:CGFloat=0
    
    
    // 没有数据加载该视图
    var nilView:UIView?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        //若无网络,改变状态码下次进来直接刷新
        if(!IJReachability.isConnectedToNetwork()){
            isNetWork=false
        }
        //状态码变成false并且有网络则发送二级分类请求
        if(!isNetWork){
            if(IJReachability.isConnectedToNetwork()){
                queryChildCategory()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.whiteColor()
        creatLeftView()
        creatRightCollection()
        //queryChildCategory()
        if(pushState == 1){//从首页点击
            queryChildCategory()
        }else{//从底部点击
            queryChildCategoryBottom()
        }
    }
    //左边Table视图
    func creatLeftView(){
        //根据push状态码动态修改Table的高度
        if(pushState == 1){
            flyHeight=boundsHeight - CGFloat(104)
        }else{
            flyHeight=boundsHeight - CGFloat(153)
        }
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
    }
    
    //右边UICollectionView视图
    func creatRightCollection(){
        let flowLayout=UICollectionViewFlowLayout()
        cellPicW=boundsWidth-leftTable!.frame.width
        flowLayout.minimumInteritemSpacing=0//左右间隔
        flowLayout.minimumLineSpacing=0
        flowLayout.itemSize=CGSizeMake(cellPicW/3, cellPicW/3+20)
        rightCollection=UICollectionView(frame: CGRectMake(leftTable!.frame.width-1, 0, cellPicW, flyHeight), collectionViewLayout: flowLayout)
        rightCollection?.dataSource=self
        rightCollection?.delegate=self
        rightCollection?.backgroundColor=UIColor.whiteColor()
        rightCollection?.registerClass(categoryListCell.self, forCellWithReuseIdentifier: "rightCollection");
        self.view.addSubview(rightCollection!)
    }
    
    //MARK -------Table的代理-----------------------
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
        let Identifier="MultilevelTableViewCell"+"\(indexPath.row)"
        var cell=tableView.dequeueReusableCellWithIdentifier(Identifier);
        if(cell == nil){
            cell=UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier:Identifier)
        }
        //创建分割线
        rightLine=UILabel(frame: CGRectMake(leftTable!.frame.width-0.5, 0, 0.5, cell!.contentView.frame.height))
        rightLine.backgroundColor=UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1)
        cell!.contentView.addSubview(rightLine)
        if(childCategory.count > 0){
            cell?.textLabel?.text=childCategory[indexPath.row].goodsCategoryName
        }
        cell?.textLabel?.font=UIFont.systemFontOfSize(14)
        cell?.backgroundColor=UIColor(red: 0.95, green: 0.96, blue: 0.96, alpha: 1.0)
        if(cell!.respondsToSelector("setLayoutMargins:")){
            cell!.layoutMargins=UIEdgeInsetsZero
        }
        if(cell!.respondsToSelector("setSeparatorInset:")){
            cell!.separatorInset=UIEdgeInsetsZero;
        }
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        //默认选中的视图背景颜色
        cell?.selectedBackgroundView?.backgroundColor=UIColor.whiteColor()
        //设置默认的字体颜色
        cell?.textLabel?.textColor=UIColor.blackColor()
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell=tableView.cellForRowAtIndexPath(indexPath)
        //自动滚动顶部
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        rightLine.backgroundColor=UIColor.whiteColor()
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
        return threeCategory.count;
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell=collectionView.dequeueReusableCellWithReuseIdentifier("rightCollection", forIndexPath: indexPath) as? categoryListCell
        if(cell == nil){
            cell=collectionView.dequeueReusableCellWithReuseIdentifier("rightCollection", forIndexPath: indexPath) as? categoryListCell
        }
        //图片和文字
        if(threeCategory.count > 0){
            cell!.loadItemsData(threeCategory[indexPath.row])
        }
        cell!.backgroundColor=UIColor.whiteColor()
        return cell!;
    }
    //点击事件
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        /// 获取对应分类entity
        let entity=threeCategory[indexPath.row]
        let GoodCategory3VC=GoodCategory3ViewController()
        GoodCategory3VC.hidesBottomBarWhenPushed=true
        GoodCategory3VC.flag=2
        GoodCategory3VC.goodsCategoryId=entity.goodsCategoryId
        GoodCategory3VC.titleCategoryName=entity.goodsCategoryName
        self.navigationController!.pushViewController(GoodCategory3VC, animated:true)
    }
    /**
    queryCategory4AndroidAll.xhtml   发送二级分类请求
    - parameter goodsCategoryId: 一级分类ID
    */
    func queryChildCategory(){
        //判断网络状态
        if(IJReachability.isConnectedToNetwork()){
            SVProgressHUD.showWithStatus("数据加载中")
            let currPid=pid ?? 1
            PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryCategory4Android(goodsCategoryId:currPid), successClosure: { (result) -> Void in
                let json=JSON(result)
                //每次发请求之前先清除数据源，否则数据会叠加
                self.childCategory.removeAll()
                for(_,value) in json{
                    let entity=Mapper<GoodsCategoryEntity>().map(value.object)
                    self.childCategory.append(entity!);
                }
                SVProgressHUD.dismiss()
                self.leftTable?.reloadData()
                let first=NSIndexPath(forRow: 0, inSection: 0)
                self.leftTable?.selectRowAtIndexPath(first, animated: true, scrollPosition: UITableViewScrollPosition.None)
                if(self.leftTable!.delegate!.respondsToSelector("tableView:didSelectRowAtIndexPath:")){
                    self.leftTable!.delegate!.tableView!(self.leftTable!, didSelectRowAtIndexPath: first)
                }
                self.isNetWork=true
                }, failClosure: { (errorMsg) -> Void in
                    SVProgressHUD.showErrorWithStatus(errorMsg)
            })
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
                //每次发请求之前先清除数据源，否则数据会叠加
                self.childCategory.removeAll()
                for(_,value) in json{
                    let entity=Mapper<GoodsCategoryEntity>().map(value.object)
                    self.childCategory.append(entity!);
                }
                //NSLog("二级分类结果：\(json)")
                SVProgressHUD.dismiss()
                self.leftTable?.reloadData()
                let first=NSIndexPath(forRow: 0, inSection: 0)
                self.leftTable?.selectRowAtIndexPath(first, animated: true, scrollPosition: UITableViewScrollPosition.None)
                if(self.leftTable!.delegate!.respondsToSelector("tableView:didSelectRowAtIndexPath:")){
                    self.leftTable!.delegate!.tableView!(self.leftTable!, didSelectRowAtIndexPath: first)
                }
                self.isNetWork=true
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
    */
    func httpGoodCategoryThree(goodsCategoryId:Int){
        if IJReachability.isConnectedToNetwork(){
            PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryCategory4Android(goodsCategoryId:goodsCategoryId), successClosure: { (result) -> Void in
                let json=JSON(result)
                self.threeCategory.removeAll()
                if(json.count > 0){
                    for(_,value) in json{
                        let entity=Mapper<GoodsCategoryEntity>().map(value.object)
                        self.threeCategory.append(entity!);
                    }
                    self.nilView?.removeFromSuperview()
                    self.rightCollection?.reloadData()
                }else{
                    self.rightCollection?.reloadData()
                    self.nilView?.removeFromSuperview()
                    self.nilView=nilPromptView("赶快上传商品吧")
                    self.nilView!.center=self.rightCollection!.center
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