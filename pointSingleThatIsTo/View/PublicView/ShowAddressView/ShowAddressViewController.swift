//
//  ShowAddressViewController.swift
//  unclePhone1
//
//  Created by hefeiyue on 15/11/9.
//  Copyright © 2015年 penghao. All rights reserved.
//

import Foundation
import UIKit
///弹出地区选择
class ShowAddressViewController:UIViewController,UITableViewDataSource,UITableViewDelegate {
    var table:UITableView?
    var displayType=0
    var provinces=NSArray()
    var citys=NSArray()
    var areas=NSArray()
    var selectedProvince:String?
    var selectedCity:String?
    var selectedArea:String?
    var selectedIndexPath:NSIndexPath?
    var selectedStr:UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="地区选择"
        self.view.backgroundColor=UIColor.whiteColor()
        configureData()
        configureViews()

    }
    func configureData(){
        if (self.displayType == 0) {
            //从文件读取地址字典
            let addressPath=NSBundle.mainBundle().pathForResource("address", ofType:"plist")
            let dict=NSMutableDictionary(contentsOfFile:addressPath!)
            self.provinces=dict!.objectForKey("address") as! NSArray
        }
    }
    func configureViews(){
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target:self, action:"cancel")
        self.table = UITableView(frame:self.view.bounds)
        self.table!.delegate = self;
        self.table!.dataSource = self;
        self.view.addSubview(self.table!)
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.displayType == 0{
            return self.provinces.count
        }else if self.displayType == 1{
            return self.citys.count
        }else{
            return self.areas.count
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellid="cityCell"
        var cell=tableView.dequeueReusableCellWithIdentifier(cellid)
        if cell == nil{
            cell=UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier:cellid)
            if self.displayType == 2{
                cell!.accessoryType=UITableViewCellAccessoryType.None
            }else{
                cell!.accessoryType=UITableViewCellAccessoryType.DisclosureIndicator
            }
        }
        if self.displayType == 0{
            let province:NSDictionary=self.provinces[indexPath.row] as! NSDictionary
            let provinceName=province.objectForKey("name") as! String
            cell!.textLabel!.text=provinceName
            
        }else if self.displayType == 1{
            let city=self.citys[indexPath.row] as! NSDictionary
            let cityName=city.objectForKey("name") as! String
            cell!.textLabel!.text=cityName
        }else{
           cell!.textLabel!.text=self.areas[indexPath.row] as? String
           cell!.imageView!.image=UIImage(named:"unchecked")
        }
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.displayType == 0{
            let province=self.provinces[indexPath.row] as! NSDictionary
            let citys=province.objectForKey("sub") as! NSArray
            self.selectedProvince=province.objectForKey("name") as? String
            //构建下一级视图控制器
            let cityVC=ShowAddressViewController()
            cityVC.displayType=1//显示模式为城市
            cityVC.citys=citys
            cityVC.selectedProvince=self.selectedProvince
            self.navigationController!.pushViewController(cityVC, animated:true)
        }else if self.displayType == 1{
            let city=self.citys[indexPath.row] as! NSDictionary
            self.selectedCity=city.objectForKey("name") as? String
            let areas=city.objectForKey("sub") as! NSArray
            //构建下一级视图控制器
            let areaVC=ShowAddressViewController()
            areaVC.displayType=2
            areaVC.areas=areas
            areaVC.selectedProvince=self.selectedProvince
            areaVC.selectedCity=self.selectedCity
            self.navigationController!.pushViewController(areaVC, animated:true)
        }else{
            if self.selectedIndexPath != nil{
                //取消上一次选定状态
                let oldCell=table?.cellForRowAtIndexPath(self.selectedIndexPath!)
                oldCell?.imageView?.image=UIImage(named:"unchecked")
            }
            //勾选当前选定状态
            let newCell=table?.cellForRowAtIndexPath(indexPath)
            newCell!.imageView!.image=UIImage(named:"checked")
            //保存
            self.selectedArea=self.areas[indexPath.row] as? String
            self.selectedIndexPath=indexPath
            let msg=self.selectedProvince!+"-"+self.selectedCity!+"-"+self.selectedArea!
            let alert=UIAlertController(title:"地区选择", message:msg, preferredStyle: UIAlertControllerStyle.Alert)
            let ok=UIAlertAction(title:"确定", style: UIAlertActionStyle.Default, handler:{ Void in
                //通知上一页面刷新数据
                NSNotificationCenter.defaultCenter().postNotificationName("postUpdateAddress", object:msg)
                self.dismissViewControllerAnimated(true, completion:nil)
                
            })
            let cancel=UIAlertAction(title:"取消", style: UIAlertActionStyle.Cancel, handler:nil)
            alert.addAction(cancel)
            alert.addAction(ok)
            self.presentViewController(alert, animated:true, completion:nil)
        }
        self.table?.deselectRowAtIndexPath(self.table!.indexPathForSelectedRow!, animated:true)
    }
    func cancel(){
        self.dismissViewControllerAnimated(true, completion:nil)
    }

}