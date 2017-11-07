//
//  ItemsViewController.swift
//  pointSingleThatIsTo
//
//  Created by 卢洋 on 16/1/31.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import SVProgressHUD
import SwiftyJSON
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

///品项
class ItemsViewController:BaseViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource{
    //接收分类名称
    var itemsTitle:String?
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
    
    //存储二级分类实体类(从菜单栏点击进入)
    var childCategory:[GoodsCategoryEntity]=[]
    //存储分类String(从首页分类点击进入)
    var pushIndexChildCategory:[String]=[]
    //存储三级分类实体类
    var threeCategory:[GoodsCategoryEntity]=[]
    //存储23级分类数据源
    var categoryMap=Dictionary<String,NSMutableArray>()
    //判断页面从首页传过来还是底部工具栏(1-首页，其他从底部传过来)
    var pushState:Int=0
    //左边Table和右边UICollectionView的动态高度
    var flyHeight:CGFloat=0
    // 没有数据加载该视图
    var nilView:UIView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.white
        creatLeftView()
        creatRightCollection()
        //queryChildCategory()
        if(pushState == 1){//从首页点击
            queryChildCategory()
        }else{//从底部点击
            queryChildCategoryBottom()
        }
        if self.itemsTitle == "休闲零食"{
            self.navigationItem.rightBarButtonItem=UIBarButtonItem(title:"1元区", style: UIBarButtonItemStyle.done, target:self, action:#selector(push1yuanqu))
        }
    }
    //跳转1元区
    @objc func push1yuanqu(){
        /// 获取对应分类entity
        let GoodCategory3VC=GoodCategory3ViewController()
        GoodCategory3VC.flag=5
        GoodCategory3VC.goodsCategoryId=pid ?? 1
        self.navigationController!.pushViewController(GoodCategory3VC, animated:true)
    }
    //左边Table视图
    func creatLeftView(){
        //根据push状态码动态修改Table的高度
        if(pushState == 1){
            flyHeight=boundsHeight-navHeight-40-bottomSafetyDistanceHeight
        }else{
            flyHeight=boundsHeight-navHeight-40-tabBarHeight
        }
        leftTable=UITableView(frame: CGRect(x: 0, y: 0, width: 100,height: flyHeight), style: UITableViewStyle.plain)
        leftTable?.dataSource=self
        leftTable?.delegate=self
        leftTable?.backgroundColor=UIColor(red: 0.95, green: 0.96, blue: 0.96, alpha: 1.0)
        self.view.addSubview(leftTable!)
        //去掉15px空白
        if(leftTable!.responds(to: #selector(setter: UIView.layoutMargins))){
            leftTable?.layoutMargins=UIEdgeInsets.zero
        }
        if(leftTable!.responds(to: #selector(setter: UITableViewCell.separatorInset))){
            leftTable!.separatorInset=UIEdgeInsets.zero;
        }
        leftTable?.separatorColor=UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1)
        //去除多余的单元格
        leftTable?.tableFooterView = UIView(frame:CGRect.zero)
    }
    
    //右边UICollectionView视图
    func creatRightCollection(){
        let flowLayout=UICollectionViewFlowLayout()
        cellPicW=boundsWidth-leftTable!.frame.width
        flowLayout.minimumInteritemSpacing=0//左右间隔
        flowLayout.minimumLineSpacing=0
        flowLayout.itemSize=CGSize(width: cellPicW/3, height: cellPicW/3+20)
        rightCollection=UICollectionView(frame: CGRect(x: leftTable!.frame.width-1, y: 0, width: cellPicW, height: flyHeight), collectionViewLayout: flowLayout)
        rightCollection?.dataSource=self
        rightCollection?.delegate=self
        rightCollection?.backgroundColor=UIColor.white
        rightCollection?.register(categoryListCell.self, forCellWithReuseIdentifier: "rightCollection");
        self.view.addSubview(rightCollection!)
    }
    /**
     点击首页进来点击2级分类展示对应的3级分类
     
     - parameter key:String
     */
    func pushIndexpushIndex3Category(_ key:String){
        self.threeCategory.removeAll()
        //拿到对应分类的值
        let obj=categoryMap[key]
        if obj != nil{
            let map=obj![0] as! Dictionary<String,[GoodsCategoryEntity]>
            if map["goodsCategory"]?.count > 0{
                self.threeCategory=map["goodsCategory"]!
                self.nilView?.removeFromSuperview()
                self.rightCollection?.reloadData()
            }else{
                self.rightCollection?.reloadData()
                self.nilView?.removeFromSuperview()
                self.nilView=nilPromptView("还没有相关分类")
                self.nilView!.center=self.rightCollection!.center
                self.view.addSubview(self.nilView!)
            }
        }
        
    }
}
// MARK: - 协议实现
extension ItemsViewController{
    //MARK -------Table的代理-----------------------
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pushState == 1{
            return pushIndexChildCategory.count
        }else{
            return childCategory.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Identifier="MultilevelTableViewCell"+"\(indexPath.row)"
        var cell=tableView.dequeueReusableCell(withIdentifier: Identifier);
        if(cell == nil){
            cell=UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:Identifier)
        }
        //创建分割线
        rightLine=UILabel(frame: CGRect(x: leftTable!.frame.width-0.5, y: 0, width: 0.5, height: cell!.contentView.frame.height))
        rightLine.backgroundColor=UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1)
        cell!.contentView.addSubview(rightLine)
        if pushState == 1{
            if(pushIndexChildCategory.count > 0){
                cell?.textLabel?.text=pushIndexChildCategory[indexPath.row]
            }
        }else{
            if childCategory.count > 0{
                cell?.textLabel?.text=childCategory[indexPath.row].goodsCategoryName
            }
        }
        cell?.textLabel?.font=UIFont.systemFont(ofSize: 14)
        cell?.backgroundColor=UIColor(red: 0.95, green: 0.96, blue: 0.96, alpha: 1.0)
        if(cell!.responds(to: #selector(setter: UIView.layoutMargins))){
            cell!.layoutMargins=UIEdgeInsets.zero
        }
        if(cell!.responds(to: #selector(setter: UITableViewCell.separatorInset))){
            cell!.separatorInset=UIEdgeInsets.zero;
        }
        cell!.selectionStyle = UITableViewCellSelectionStyle.none
        //默认选中的视图背景颜色
        cell?.selectedBackgroundView?.backgroundColor=UIColor.white
        //设置默认的字体颜色
        cell?.textLabel?.textColor=UIColor.black
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell=tableView.cellForRow(at: indexPath)
        //自动滚动顶部
        tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: true)
        rightLine.backgroundColor=UIColor.white
        cell?.backgroundColor=UIColor.white
        cell?.textLabel?.textColor=UIColor.applicationMainColor()
        if pushState == 1{
            let key=pushIndexChildCategory[indexPath.row]
            pushIndexpushIndex3Category(key)
        }else{
            let pid=childCategory[indexPath.row].goodsCategoryId
            httpGoodCategoryThree(pid!)
        }

    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell=tableView.cellForRow(at: indexPath)
        cell?.backgroundColor=UIColor(red: 0.95, green: 0.96, blue: 0.96, alpha: 1.0)
        cell?.textLabel?.textColor=UIColor.black
    }
    
    //MARK ----------UICollectionView的代理--------------------
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return threeCategory.count;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell=collectionView.dequeueReusableCell(withReuseIdentifier: "rightCollection", for: indexPath) as? categoryListCell
        if(cell == nil){
            cell=collectionView.dequeueReusableCell(withReuseIdentifier: "rightCollection", for: indexPath) as? categoryListCell
        }
        //图片和文字
        if(threeCategory.count > 0){
            cell!.loadItemsData(threeCategory[indexPath.row])
        }
        cell!.backgroundColor=UIColor.white
        return cell!;
    }
    //点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /// 获取对应分类entity
        let entity=threeCategory[indexPath.row]
        let GoodCategory3VC=GoodCategory3ViewController()
        GoodCategory3VC.hidesBottomBarWhenPushed=true
        GoodCategory3VC.flag=2
        GoodCategory3VC.goodsCategoryId=entity.goodsCategoryId
        GoodCategory3VC.titleCategoryName=entity.goodsCategoryName
        self.navigationController!.pushViewController(GoodCategory3VC, animated:true)
    }
    
    
}
// MARK: - 网络请求
extension ItemsViewController{
    /**
     queryCategory4AndroidAll.xhtml   发送二级分类请求
     - parameter goodsCategoryId: 一级分类ID
     */
    func queryChildCategory(){
        //判断网络状态
        
        SVProgressHUD.show(withStatus: "数据加载中")
            let currPid=pid ?? 1
            //获取分站ID
            let substationId=userDefaults.object(forKey: "substationId") as! String
            
            PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryTwoCategoryForMob(goodsCategoryId:currPid,substationId:substationId), successClosure: { (result) -> Void in
                let json=JSON(result)

                //先添加全部的2级分类
                self.pushIndexChildCategory.append("全部")
                if let dic=json.dictionaryObject{
                    for(key,value) in dic{
                        let arr=NSMutableArray()
                        if key != "全部"{//循环2级分类
                            self.pushIndexChildCategory.append(key)
                        }
                        let jsonArr=JSON(value)
                        for(titleKey,value1) in jsonArr{
                            var map=Dictionary<String,[GoodsCategoryEntity]>()
                            var entityArr=[GoodsCategoryEntity]()
                            for(_,entityValue) in value1{
                                let entity=Mapper<GoodsCategoryEntity>().map(JSONObject:entityValue.object)
                                entityArr.append(entity!)
                            }
                            map[titleKey]=entityArr
                            arr.add(map)
                        }
                        self.categoryMap[key]=arr
                    }
                    SVProgressHUD.dismiss()
                    self.leftTable?.reloadData()
                    let first=IndexPath(row:0, section:0)
                    self.leftTable?.selectRow(at: first, animated:true, scrollPosition: UITableViewScrollPosition.none)
                    if self.leftTable!.delegate!.responds(to: #selector(UITableViewDelegate.tableView(_:didSelectRowAt:))){
                        self.leftTable!.delegate!.tableView!(self.leftTable!, didSelectRowAt: first)
                    }
                    
                }else{
                    SVProgressHUD.showError(withStatus: "数据解析出错")
                }
                
                }) { (errorMsg) -> Void in
                    SVProgressHUD.showError(withStatus: errorMsg)
            }
            
        
        
        
    }
    
    /**
     从底部点击分类
     */
    func queryChildCategoryBottom(){
        
            let currPid=pid ?? 1
        SVProgressHUD.show(withStatus: "数据加载中")
            PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryCategory4AndroidAll(goodsCategoryId:currPid), successClosure: { (result) -> Void in
                let json=JSON(result)
                //每次发请求之前先清除数据源，否则数据会叠加
                self.childCategory.removeAll()
                for(_,value) in json{
                    let entity=Mapper<GoodsCategoryEntity>().map(JSONObject: value.object)
                    self.childCategory.append(entity!);
                }
                //NSLog("二级分类结果：\(json)")
                SVProgressHUD.dismiss()
                self.leftTable?.reloadData()
                let first=IndexPath(row:0, section:0)
                self.leftTable?.selectRow(at: first, animated:true, scrollPosition: UITableViewScrollPosition.none)
                if self.leftTable!.delegate!.responds(to: #selector(UITableViewDelegate.tableView(_:didSelectRowAt:))){
                    self.leftTable!.delegate!.tableView!(self.leftTable!, didSelectRowAt: first)
                }
                }, failClosure: { (errorMsg) -> Void in
                    SVProgressHUD.showError(withStatus: errorMsg)
            })
        
    }
    
        /**
        queryCategory4Android.xhtml   发送三级分类请求
        - parameter goodsCategoryId: 二级分类ID
        */
        func httpGoodCategoryThree(_ goodsCategoryId:Int){
            
                PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryCategory4Android(goodsCategoryId:goodsCategoryId), successClosure: { (result) -> Void in
                    let json=JSON(result)
                    self.threeCategory.removeAll()
                    if(json.count > 0){
                        for(_,value) in json{
                            let entity=Mapper<GoodsCategoryEntity>().map(JSONObject:value.object)
                            self.threeCategory.append(entity!);
                        }
                        self.nilView?.removeFromSuperview()
                        self.rightCollection?.reloadData()
                    }else{
                        self.rightCollection?.reloadData()
                        self.nilView?.removeFromSuperview()
                        self.nilView=nilPromptView("还没有相关分类")
                        self.nilView!.center=self.rightCollection!.center
                        self.view.addSubview(self.nilView!)
                    }
                    }, failClosure: { (errorMsg) -> Void in
                        SVProgressHUD.showError(withStatus: errorMsg)
                })
            
        }
}
