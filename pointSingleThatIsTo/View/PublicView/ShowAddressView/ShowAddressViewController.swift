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
    var selectedIndexPath:IndexPath?
    var selectedStr:UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="地区选择"
        self.view.backgroundColor=UIColor.white
        configureData()
        configureViews()

    }
    func configureData(){
        if (self.displayType == 0) {
            //从文件读取地址字典
            let addressPath=Bundle.main.path(forResource: "address", ofType:"plist")
            let dict=NSMutableDictionary(contentsOfFile:addressPath!)
            self.provinces=dict!.object(forKey: "address") as! NSArray
        }
    }
    func configureViews(){
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target:self, action:Selector("cancel"))
        self.table = UITableView(frame:self.view.bounds)
        self.table!.delegate = self;
        self.table!.dataSource = self;
        self.view.addSubview(self.table!)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.displayType == 0{
            return self.provinces.count
        }else if self.displayType == 1{
            return self.citys.count
        }else{
            return self.areas.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellid="cityCell"
        var cell=tableView.dequeueReusableCell(withIdentifier: cellid)
        if cell == nil{
            cell=UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:cellid)
            if self.displayType == 2{
                cell!.accessoryType=UITableViewCellAccessoryType.none
            }else{
                cell!.accessoryType=UITableViewCellAccessoryType.disclosureIndicator
            }
        }
        if self.displayType == 0{
            let province:NSDictionary=self.provinces[indexPath.row] as! NSDictionary
            let provinceName=province.object(forKey: "name") as! String
            cell!.textLabel!.text=provinceName
            
        }else if self.displayType == 1{
            let city=self.citys[indexPath.row] as! NSDictionary
            let cityName=city.object(forKey: "name") as! String
            cell!.textLabel!.text=cityName
        }else{
           cell!.textLabel!.text=self.areas[indexPath.row] as? String
           cell!.imageView!.image=UIImage(named:"unchecked")
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.displayType == 0{
            let province=self.provinces[indexPath.row] as! NSDictionary
            let citys=province.object(forKey: "sub") as! NSArray
            self.selectedProvince=province.object(forKey: "name") as? String
            //构建下一级视图控制器
            let cityVC=ShowAddressViewController()
            cityVC.displayType=1//显示模式为城市
            cityVC.citys=citys
            cityVC.selectedProvince=self.selectedProvince
            self.navigationController!.pushViewController(cityVC, animated:true)
        }else if self.displayType == 1{
            let city=self.citys[indexPath.row] as! NSDictionary
            self.selectedCity=city.object(forKey: "name") as? String
            let areas=city.object(forKey: "sub") as! NSArray
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
                let oldCell=table?.cellForRow(at: self.selectedIndexPath!)
                oldCell?.imageView?.image=UIImage(named:"unchecked")
            }
            //勾选当前选定状态
            let newCell=table?.cellForRow(at: indexPath)
            newCell!.imageView!.image=UIImage(named:"checked")
            //保存
            self.selectedArea=self.areas[indexPath.row] as? String
            self.selectedIndexPath=indexPath
            let msg=self.selectedProvince!+"-"+self.selectedCity!+"-"+self.selectedArea!
            let alert=UIAlertController(title:"地区选择", message:msg, preferredStyle: UIAlertControllerStyle.alert)
            let ok=UIAlertAction(title:"确定", style: UIAlertActionStyle.default, handler:{ Void in
                //通知上一页面刷新数据
                NotificationCenter.default.post(name: Notification.Name(rawValue: "postUpdateAddress"), object:msg)
                self.dismiss(animated: true, completion:nil)
                
            })
            let cancel=UIAlertAction(title:"取消", style: UIAlertActionStyle.cancel, handler:nil)
            alert.addAction(cancel)
            alert.addAction(ok)
            self.present(alert, animated:true, completion:nil)
        }
        self.table?.deselectRow(at: self.table!.indexPathForSelectedRow!, animated:true)
    }
    func cancel(){
        self.dismiss(animated: true, completion:nil)
    }

}
