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
import SwiftyJSON
/// 品牌
class BrandViewController:BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource{
    //接受1级分类id
    var pid:Int?
    //判断页面从首页传过来还是底部工具栏(1-首页，其他从底部传过来)
    var pushState:Int=0
    //左边Table和右边UICollectionView的动态高度
    var flyHeight:CGFloat=0
    fileprivate let arr=NSMutableArray()
    fileprivate var collection:UICollectionView?
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
        self.view.backgroundColor=UIColor.white
        //根据push状态码动态修改Table的高度
        if(pushState == 1){
            flyHeight=boundsHeight-navHeight-40-bottomSafetyDistanceHeight
            indexBuildView()
            queryChildCategory()
        }else{
            flyHeight=boundsHeight-navHeight-40-tabBarHeight
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
        flowLayout.itemSize=CGSize(width: boundsWidth/3,height: 50)
        collection=UICollectionView(frame:CGRect(x: 0,y: 10,width: boundsWidth,height: flyHeight-20), collectionViewLayout: flowLayout)
        collection!.dataSource=self
        collection!.delegate=self
        collection!.backgroundColor=UIColor.white
        collection!.register(BrandCollectionCell.self, forCellWithReuseIdentifier: "BrandCollectionCell");
        self.view.addSubview(collection!)
    }
    /**
     底部菜单点击进入
     */
    func bottomBuildView(){
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
        let flowLayout=UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing=0//左右间隔
        flowLayout.minimumLineSpacing=0
        cellPicW=boundsWidth-leftTable!.frame.width
        flowLayout.itemSize=CGSize(width: cellPicW/3,height: 50)
        collection=UICollectionView(frame:CGRect(x: leftTable!.frame.width-1,y: 10,width: cellPicW,height: flyHeight-20), collectionViewLayout: flowLayout)
        collection!.dataSource=self
        collection!.delegate=self
        collection!.backgroundColor=UIColor.white
        collection!.register(BrandCollectionCell.self, forCellWithReuseIdentifier: "BrandCollectionCell");
        self.view.addSubview(collection!)
    }
    //MARK ------------Table的代理--------------------------
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return childCategory.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Identifier="MultilevelTableViewCell" + "\(indexPath.row)"
        var cell=tableView.dequeueReusableCell(withIdentifier: Identifier);
        if(cell == nil){
            cell=UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:Identifier)
            
        }
        if(childCategory.count > 0){
            cell?.textLabel?.text=childCategory[indexPath.row].goodsCategoryName
        }
        cell?.textLabel?.font=UIFont.systemFont(ofSize: 14)
        cell?.backgroundColor=UIColor(red: 0.95, green: 0.96, blue: 0.96, alpha: 1.0)
        cell?.selectionStyle=UITableViewCellSelectionStyle.none
        if(cell!.responds(to: #selector(setter: UIView.layoutMargins))){
            cell!.layoutMargins=UIEdgeInsets.zero
        }
        if(cell!.responds(to: #selector(setter: UITableViewCell.separatorInset))){
            cell!.separatorInset=UIEdgeInsets.zero;
        }
        //默认选中的视图背景颜色
        cell?.selectedBackgroundView?.backgroundColor=UIColor.white
        //设置默认的字体颜色
        cell?.textLabel?.textColor=UIColor.black
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell=tableView.cellForRow(at: indexPath)
        tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: true)
        cell?.backgroundColor=UIColor.white
        cell?.textLabel?.textColor=UIColor.applicationMainColor()
        let pid=childCategory[indexPath.row].goodsCategoryId
        httpGoodCategoryThree(pid!)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell=tableView.cellForRow(at: indexPath)
        cell?.backgroundColor=UIColor(red: 0.95, green: 0.96, blue: 0.96, alpha: 1.0)
        cell?.textLabel?.textColor=UIColor.black
    }

    //MARK ----------UICollectionView的代理--------------------
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "BrandCollectionCell", for: indexPath) as! BrandCollectionCell
        if arr.count > 0{
            let entity=arr[indexPath.row] as! GoodsCategoryEntity
            cell.updateCell(entity)
            cell.btn.addTarget(self, action:#selector(pushGoodCategory3), for: UIControlEvents.touchUpInside)
            cell.btn.tag=indexPath.row
        }
        return cell;
    }
    @objc func pushGoodCategory3(_ sender:UIButton){
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
            SVProgressHUD.show(withStatus: "数据加载中")
            let currPid=pid ?? 1
            //获取分站ID
            let substationId=userDefaults.object(forKey: "substationId") as! String
            PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryTwoCategoryForMob(goodsCategoryId:currPid,substationId:substationId), successClosure: { (result) -> Void in
                let json=JSON(result)
                if let dic=json.dictionaryObject{
                    for(key,value) in dic{
                        if key == "全部"{
                            let jsonArr=JSON(value)
                            for(_,bValue) in jsonArr["brand"]{
                                
                                let entity=Mapper<GoodsCategoryEntity>().map(JSONObject:bValue.object)
                                self.arr.add(entity!)
                                
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
                print("二级分类\(json)")
                for(_,value) in json{
                    let entity=Mapper<GoodsCategoryEntity>().map(JSONObject: value.object)
                    self.childCategory.append(entity!)
                }
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
     - parameter substationId: 分站ID
     */
    func httpGoodCategoryThree(_ goodsCategoryId:Int){
        //获取分站ID
        let substationId=userDefaults.object(forKey: "substationId") as! String
        
            PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryBrandList4Android(goodscategoryId:goodsCategoryId, substationId: substationId), successClosure: { (result) -> Void in
                let json=JSON(result)
                print("3级分类\(json)")
                self.arr.removeAllObjects()
                for(_,value) in json{
                    let entity=Mapper<GoodsCategoryEntity>().map(JSONObject: value.object)
                    self.arr.add(entity!)
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
                    SVProgressHUD.showError(withStatus: errorMsg)
            })
        
    }

}
   
