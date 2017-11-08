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

///搜索页面
class SearchViewController:BaseViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource{
    
    ///把搜索记录保存进缓存
    var search=UserDefaults.standard;
    
    ///搜索框
    var searchBarControl: UISearchBar?
    
    ///搜索按钮
    var btnSearch:UIButton?;
    
    ///搜索记录lbl
    var lblSearchRecords:UILabel?;
    
    ///取出搜索记录arr
    var outSearchArr=[String]()
    
    ///清除搜索按钮
    var btnRemoveSearchRecords:UIButton?;
    
    /// 边线
    var btnRemoveSearchRecordsborderView:UIView?
    
    /// 搜索记录table
    var searchRecordTableView:UITableView?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //清空原有数据
        self.searchBarControl?.text = nil
        
        //获取缓存中的数据 重新赋值
        outSearchArr=search.object(forKey: "search") as? [String] ?? [String]();
        
        if outSearchArr.count > 0{//表示有数据
            //显示清除按钮
            btnRemoveSearchRecords?.isHidden=false
            btnRemoveSearchRecordsborderView?.isHidden=false
            
            //刷新
            searchRecordTableView?.reloadData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title="商品搜索"
        
        self.view.backgroundColor=UIColor.white
        
        //加载页面
        buildView()
    }
    
    /**
     构建页面
     */
    func buildView(){
        //搜索框
        searchBarControl = UISearchBar(frame: CGRect(x: 0,y: navHeight,width: boundsWidth-50,height:45))
        searchBarControl!.delegate = self;
        searchBarControl!.barStyle = .default
        searchBarControl!.placeholder = "请输入商品类型"
        self.view.addSubview(searchBarControl!);
        
        //搜索按钮
        btnSearch=UIButton(frame:CGRect(x: boundsWidth-50,y: navHeight,width: 50,height: 45));
        btnSearch!.setTitle("搜索", for:UIControlState());
        btnSearch!.setTitleColor(UIColor.applicationMainColor(), for:UIControlState());
        btnSearch!.backgroundColor=UIColor(red:200/255, green:199/255, blue:205/255, alpha:1.0);
        btnSearch!.addTarget(self, action:#selector(searchGood), for: UIControlEvents.touchUpInside);
        btnSearch!.titleLabel!.font=UIFont.systemFont(ofSize: 14);
        self.view.addSubview(btnSearch!)
        
        //搜索记录lbl
        lblSearchRecords=UILabel(frame:CGRect(x: 10,y: searchBarControl!.frame.maxY,width: boundsWidth,height: 30));
        lblSearchRecords!.text="搜索历史:";
        lblSearchRecords!.textColor=UIColor.black;
        lblSearchRecords!.font=UIFont.systemFont(ofSize: 14);
        self.view.addSubview(lblSearchRecords!);
        
        //边线
        let borderView=UIView(frame:CGRect(x: 0,y: lblSearchRecords!.frame.maxY,width: boundsWidth,height: 0.5));
        borderView.backgroundColor=UIColor.viewBackgroundColor();
        self.view.addSubview(borderView);
        
        //清除搜索按钮
        btnRemoveSearchRecords=UIButton(frame:CGRect(x: 0,y: borderView.frame.maxY,width: boundsWidth,height: 50));
        btnRemoveSearchRecords!.setTitle("清除历史记录", for:UIControlState());
        btnRemoveSearchRecords!.setTitleColor(UIColor.textColor(), for: UIControlState());
        btnRemoveSearchRecords!.addTarget(self, action:#selector(removeSearchRecords), for:UIControlEvents.touchUpInside);
        btnRemoveSearchRecords!.titleLabel!.font=UIFont.systemFont(ofSize: 15);
        self.view.addSubview(btnRemoveSearchRecords!);
        
        //边线
        btnRemoveSearchRecordsborderView=UIView(frame:CGRect(x: 0,y: btnRemoveSearchRecords!.frame.maxY,width: boundsWidth,height: 0.5));
        btnRemoveSearchRecordsborderView!.backgroundColor=UIColor.viewBackgroundColor();
        self.view.addSubview(btnRemoveSearchRecordsborderView!);
        
        //搜索记录table
        searchRecordTableView=UITableView(frame:CGRect(x: 0,y: btnRemoveSearchRecords!.frame.maxY+0.5,width: boundsWidth,height: boundsHeight-(btnRemoveSearchRecords!.frame.maxY+0.5)-bottomSafetyDistanceHeight));
        searchRecordTableView!.dataSource=self;
        searchRecordTableView!.delegate=self;
        //移除空单元格
        searchRecordTableView!.tableFooterView = UIView(frame:CGRect.zero)
        self.view.addSubview(searchRecordTableView!);
        
        if outSearchArr.count > 0{//判断搜索记录是否有数据 如果有显示删除按钮 边线
            btnRemoveSearchRecords!.isHidden=false;
            btnRemoveSearchRecordsborderView!.isHidden=false;
        }else{//如果没有 隐藏
            btnRemoveSearchRecords!.isHidden=true;
            btnRemoveSearchRecordsborderView!.isHidden=true;
        }

    }
    
    /**
     清除历史记录
     
     - parameter sender:UIButton
     */
    @objc func removeSearchRecords(_ sender:UIButton!){
        
        //先清除缓存中的数据
        search.removeObject(forKey: "search");
        
        //写入磁盘
        search.synchronize();
        
        //直接赋空
        outSearchArr=[String]()
        
        //隐藏清除按钮
        btnRemoveSearchRecords!.isHidden=true;
        
        //隐藏边线
        btnRemoveSearchRecordsborderView!.isHidden=true;
        
        //刷新数据
        searchRecordTableView!.reloadData();
        
    }
    // 即将输入UISearchBar
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsScopeBar = true
        return true
    }
    
    //保存搜索记录
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchGoodList(text: searchBar.text)
    }
    //点击搜索按钮
    @objc func searchGood(_ sender:UIButton){
        searchGoodList(text: searchBarControl!.text)
    }
    //搜索商品
    func searchGoodList(text:String?){
        //创建2个数组互转  是因为缓存里面不能保存NSMutableArray(可变)类型的数组
        if  text != nil && text!.characters.count > 0{//判断搜索条件是否为空
            //先从缓存取出arr
            var searchArr=search.object(forKey: "search") as? [String]
            if searchArr == nil{//如果为空 直接实例化个空的数组
                searchArr=[String]();
            }
            
            //把搜索条件添加到可变数组里面
            searchArr!.append(text!)
            //数组去重
            searchArr=searchArr!.filterDuplicates({$0})
            //保存进缓存
            search.set(searchArr!, forKey:"search");
            
            //写入磁盘
            search.synchronize();
            
            //跳转到3级分类
            let vc=GoodCategory3ViewController()
            vc.searchName=searchBarControl!.text
            vc.flag=1
            self.navigationController?.pushViewController(vc, animated:true);
            self.view.endEditing(true)
        }else{
            SVProgressHUD.showInfo(withStatus: "搜索条件不能为空")
        }
    }
    //返回tabview每一行显示什么
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell=tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil{
            cell=UITableViewCell(style:UITableViewCellStyle.value1, reuseIdentifier:"cell")
        }
        //去掉选中背景
        cell!.selectionStyle=UITableViewCellSelectionStyle.none;
        cell!.textLabel!.font=UIFont.systemFont(ofSize: 13)
        if outSearchArr.count > 0{//判断下数组是否有值  防止程序崩溃
            cell!.textLabel!.text=outSearchArr[indexPath.row]
        }
        
        return cell!;
    }
    //tabview每行的点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if outSearchArr.count > 0{
            let searchName=outSearchArr[indexPath.row]
            //跳转到3级分类
            let vc=GoodCategory3ViewController()
            vc.flag=1
            vc.searchName=searchName
            self.navigationController?.pushViewController(vc, animated:true);
        }
    }
    
    //返回tabview的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if outSearchArr.count == 0 {
            return 0;
        }else{
            return outSearchArr.count;
        }
    }
    //返回tabview的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 40;
    }
    //点击view区域收起键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
