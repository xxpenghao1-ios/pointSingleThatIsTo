//
//  SearchViewController.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/1/26.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
///搜索页面
class SearchViewController:BaseViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource{
    
    ///把搜索记录保存进缓存
    var search=NSUserDefaults.standardUserDefaults();
    
    ///搜索框
    var searchBarControl: UISearchBar?
    
    ///搜索按钮
    var btnSearch:UIButton?;
    
    ///搜索记录lbl
    var lblSearchRecords:UILabel?;
    
    ///取出搜索记录arr
    var outSearchArr:NSArray?;
    
    ///清除搜索按钮
    var btnRemoveSearchRecords:UIButton?;
    
    /// 边线
    var btnRemoveSearchRecordsborderView:UIView?
    
    /// 搜索记录table
    var searchRecordTableView:UITableView?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //清空原有数据
        self.searchBarControl?.text = nil
        
        //获取缓存中的数据 重新赋值
        outSearchArr=search.objectForKey("search") as? NSArray;
        
        if outSearchArr?.count > 0{//表示有数据
            //显示清除按钮
            btnRemoveSearchRecords?.hidden=false
            btnRemoveSearchRecordsborderView?.hidden=false
            
            //刷新
            searchRecordTableView?.reloadData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title="商品搜索"
        
        self.view.backgroundColor=UIColor.whiteColor()
        
        //加载页面
        buildView()
    }
    
    /**
     构建页面
     */
    func buildView(){
        
        //取出缓存中的搜索记录
        outSearchArr=search.objectForKey("search") as? NSArray;
        
        //搜索框
        searchBarControl = UISearchBar(frame: CGRectMake(0,64,boundsWidth-50,45))
        searchBarControl!.delegate = self;
        searchBarControl!.barStyle = .Default
        searchBarControl!.placeholder = "请输入商品类型"
        self.view.addSubview(searchBarControl!);
        
        //搜索按钮
        btnSearch=UIButton(frame:CGRectMake(boundsWidth-50,64,50,45));
        btnSearch!.setTitle("搜索", forState:.Normal);
        btnSearch!.setTitleColor(UIColor.applicationMainColor(), forState:.Normal);
        btnSearch!.backgroundColor=UIColor(red:200/255, green:199/255, blue:205/255, alpha:1.0);
        btnSearch!.addTarget(self, action:"searchGood:", forControlEvents: UIControlEvents.TouchUpInside);
        btnSearch!.titleLabel!.font=UIFont.systemFontOfSize(14);
        self.view.addSubview(btnSearch!)
        
        //搜索记录lbl
        lblSearchRecords=UILabel(frame:CGRectMake(10,CGRectGetMaxY(searchBarControl!.frame),boundsWidth,30));
        lblSearchRecords!.text="搜索历史:";
        lblSearchRecords!.textColor=UIColor.blackColor();
        lblSearchRecords!.font=UIFont.systemFontOfSize(14);
        self.view.addSubview(lblSearchRecords!);
        
        //边线
        let borderView=UIView(frame:CGRectMake(0,CGRectGetMaxY(lblSearchRecords!.frame),boundsWidth,0.5));
        borderView.backgroundColor=UIColor.viewBackgroundColor();
        self.view.addSubview(borderView);
        
        //清除搜索按钮
        btnRemoveSearchRecords=UIButton(frame:CGRectMake(0,CGRectGetMaxY(borderView.frame),boundsWidth,50));
        btnRemoveSearchRecords!.setTitle("清除历史记录", forState:.Normal);
        btnRemoveSearchRecords!.setTitleColor(UIColor.textColor(), forState: .Normal);
        btnRemoveSearchRecords!.addTarget(self, action:"removeSearchRecords:", forControlEvents:UIControlEvents.TouchUpInside);
        btnRemoveSearchRecords!.titleLabel!.font=UIFont.systemFontOfSize(15);
        self.view.addSubview(btnRemoveSearchRecords!);
        
        //边线
        btnRemoveSearchRecordsborderView=UIView(frame:CGRectMake(0,CGRectGetMaxY(btnRemoveSearchRecords!.frame),boundsWidth,0.5));
        btnRemoveSearchRecordsborderView!.backgroundColor=UIColor.viewBackgroundColor();
        self.view.addSubview(btnRemoveSearchRecordsborderView!);
        
        //搜索记录table
        searchRecordTableView=UITableView(frame:CGRectMake(0,CGRectGetMaxY(btnRemoveSearchRecords!.frame)+0.5,boundsWidth,boundsHeight-(CGRectGetMaxY(btnRemoveSearchRecords!.frame)+0.5)));
        searchRecordTableView!.dataSource=self;
        searchRecordTableView!.delegate=self;
        //移除空单元格
        searchRecordTableView!.tableFooterView = UIView(frame:CGRectZero)
        self.view.addSubview(searchRecordTableView!);
        
        if outSearchArr?.count > 0{//判断搜索记录是否有数据 如果有显示删除按钮 边线
            btnRemoveSearchRecords!.hidden=false;
            btnRemoveSearchRecordsborderView!.hidden=false;
        }else{//如果没有 隐藏
            btnRemoveSearchRecords!.hidden=true;
            btnRemoveSearchRecordsborderView!.hidden=true;
        }

    }
    
    /**
     清除历史记录
     
     - parameter sender:UIButton
     */
    func removeSearchRecords(sender:UIButton!){
        
        //先清除缓存中的数据
        search.removeObjectForKey("search");
        
        //写入磁盘
        search.synchronize();
        
        //直接赋空
        outSearchArr=search.objectForKey("search") as? NSArray;
        
        //隐藏清除按钮
        btnRemoveSearchRecords!.hidden=true;
        
        //隐藏边线
        btnRemoveSearchRecordsborderView!.hidden=true;
        
        //刷新数据
        searchRecordTableView!.reloadData();
        
    }
    // 即将输入UISearchBar
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.showsScopeBar = true
        return true
    }
    
    //保存搜索记录
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        //创建2个数组互转  是因为缓存里面不能保存NSMutableArray(可变)类型的数组
        //保存搜索记录arr
        var searchArr:NSArray?;
        //再创建一个可变数组
        var searchMuArr:NSMutableArray?;
        if  searchBar.text != nil && searchBar.text!.characters.count > 0{//判断搜索条件是否为空
            //先从缓存取出arr
            searchArr=search.objectForKey("search") as? NSArray;
            if searchArr == nil{//如果为空 直接实例化个空的数组
                searchArr=NSArray();
            }
            //将不可变的转换成可变数组
            searchMuArr=NSMutableArray(array:searchArr!);
            
            //把搜索条件添加到可变数组里面
            searchMuArr!.addObject(searchBarControl!.text!);
            
            //再次转换成不可变数组
            searchArr=NSArray(array:searchMuArr!);
            
            //保存进缓存
            search.setObject(searchArr!, forKey:"search");
            
            //写入磁盘
            search.synchronize();
            
            //跳转到3级分类
            let vc=GoodCategory3ViewController()
            vc.searchName=searchBarControl!.text
            vc.flag=1
            self.navigationController?.pushViewController(vc, animated:true);
            self.view.endEditing(true)
        }else{
            SVProgressHUD.showInfoWithStatus("搜索条件不能为空")
        }
    }
    //点击搜索按钮
    func searchGood(sender:UIButton){
        //创建2个数组互转  是因为缓存里面不能保存NSMutableArray(可变)类型的数组
        
        //保存搜索记录arr
        var searchArr:NSArray?;
        
        //再创建一个可变数组
        var searchMuArr:NSMutableArray?;
        
        if  searchBarControl!.text != nil && searchBarControl!.text?.characters.count > 0{//判断搜索条件是否为空
            //先从缓存取出arr
            searchArr=search.objectForKey("search") as? NSArray;
            if searchArr == nil{//如果为空 直接实例化个空的数组
                searchArr=NSArray();
            }
            //将不可变的转换成可变数组
            searchMuArr=NSMutableArray(array:searchArr!);
            
            //把搜索条件添加到可变数组里面
            searchMuArr!.addObject(searchBarControl!.text!);
            
            //再次转换成不可变数组
            searchArr=NSArray(array:searchMuArr!);
            
            //保存进缓存
            search.setObject(searchArr!, forKey:"search");
            
            //写入磁盘
            search.synchronize();
            
            //跳转到3级分类
            let vc=GoodCategory3ViewController()
            vc.flag=1
            vc.searchName=searchBarControl!.text
            self.navigationController?.pushViewController(vc, animated:true);
            self.view.endEditing(true)
        }else{
           SVProgressHUD.showInfoWithStatus("搜索条件不能为空")
        }
    }
    //返回tabview每一行显示什么
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell=tableView.dequeueReusableCellWithIdentifier("cell")
        if cell == nil{
            cell=UITableViewCell(style:UITableViewCellStyle.Value1, reuseIdentifier:"cell")
        }
        //去掉选中背景
        cell!.selectionStyle=UITableViewCellSelectionStyle.None;
        cell!.textLabel!.font=UIFont.systemFontOfSize(13)
        if outSearchArr?.count > 0{//判断下数组是否有值  防止程序崩溃
            cell!.textLabel!.text=outSearchArr![indexPath.row] as? String;
        }
        
        return cell!;
    }
    //tabview每行的点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if outSearchArr?.count > 0{
            let searchName=outSearchArr![indexPath.row] as! String
            //跳转到3级分类
            let vc=GoodCategory3ViewController()
            vc.flag=1
            vc.searchName=searchName
            self.navigationController?.pushViewController(vc, animated:true);
        }
    }
    
    //返回tabview的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if outSearchArr == nil{
            return 0;
        }else{
            return outSearchArr!.count;
        }
    }
    //返回tabview的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 40;
    }
    //点击view区域收起键盘
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

}