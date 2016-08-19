//
//  ShippingAddressViewController.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/2/25.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import SVProgressHUD

/// 收货地址管理
class  ShippingAddressViewController:BaseViewController,UITableViewDataSource,UITableViewDelegate{
    /// 数据源
    var arr=NSMutableArray()
    /// table
    var table:UITableView?
    /// 为空提示
    var lblNilNewProduct:UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="收货地址管理"
        self.view.backgroundColor=UIColor.whiteColor()
        table=UITableView(frame:CGRectMake(0,0,boundsWidth,boundsHeight-80), style: UITableViewStyle.Plain)
        table!.delegate=self
        table!.dataSource=self
        self.view.addSubview(table!)
        //设置cell下边线全屏
        table?.layoutMargins=UIEdgeInsetsZero
        table?.separatorInset=UIEdgeInsetsZero;
        //移除空单元格
        table!.tableFooterView = UIView(frame:CGRectZero)
        
        let btnSubmit=UIButton(frame:CGRectMake(30,boundsHeight-60,boundsWidth-60,40))
        btnSubmit.backgroundColor=UIColor.applicationMainColor()
        btnSubmit.layer.cornerRadius=20
        btnSubmit.setTitle("添加收货地址", forState: UIControlState.Normal)
        btnSubmit.addTarget(self, action:"addShippingAddress:", forControlEvents: UIControlEvents.TouchUpInside)
        btnSubmit.titleLabel!.font=UIFont.systemFontOfSize(16)
        btnSubmit.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.view.addSubview(btnSubmit)
        //发送网络请求
        httpAddress()
        
        //监听通知刷新页面
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"updateTable:", name:"updateViewNotification", object:nil)
    }
    /**
     跳转添加地址页面
     
     - parameter sender: UIButton
     */
    func addShippingAddress(sender:UIButton){
        let vc=UpdateAndAddShippingAddressViewController()
        vc.addressFlag=2
        self.navigationController!.pushViewController(vc, animated:true)
    }
    /**
     接收通知刷新页面
     
     - parameter obj:NSNotification
     */
    func updateTable(obj:NSNotification){
        arr.removeAllObjects()
        //发送网络请求
        httpAddress()
    }
    /**
     请求地址信息
     */
    func httpAddress(){
        SVProgressHUD.showWithStatus("数据加载中")
        let storeId=NSUserDefaults.standardUserDefaults().objectForKey("storeId") as! String
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryStoreShippAddressforAndroid(storeId: storeId), successClosure: { (result) -> Void in
            SVProgressHUD.dismiss()
            let json=JSON(result)
            for(_,value) in json{
                let entity=Mapper<AddressEntity>().map(value.object)
                self.arr.addObject(entity!)
            }
            if self.arr.count > 0{
                self.lblNilNewProduct?.removeFromSuperview()
                self.table?.reloadData()
            }else{
                //不管加没有加载直接先删除视图
                self.lblNilNewProduct?.removeFromSuperview()
                self.lblNilNewProduct=nilTitle("您的收货地址为空")
                self.lblNilNewProduct!.center=self.view.center
                self.view.addSubview(self.lblNilNewProduct!)
            }
            }) { (errorMsg) -> Void in
                SVProgressHUD.showErrorWithStatus(errorMsg)
        }
    }

    //展示每个cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell=tableView.dequeueReusableCellWithIdentifier("ShippingAddressTableViewCellId") as? ShippingAddressTableViewCell
        if cell == nil{
            //加载xib
            cell=NSBundle.mainBundle().loadNibNamed("ShippingAddressTableViewCell", owner:self, options: nil).last as? ShippingAddressTableViewCell
        }
        //设置cell下边线全屏
        cell?.layoutMargins=UIEdgeInsetsZero
        cell?.separatorInset=UIEdgeInsetsZero;
        if arr.count > 0{
            let entity=arr[indexPath.row] as! AddressEntity
            cell!.updateCell(entity)
        }
        
        return cell!
    }
    //把delete 该成中文
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        
        return "删除"
    }

    //删除操作
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        let entity=arr[indexPath.row] as! AddressEntity
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.deleteStoreShippAddressforAndroid(shippAddressId:entity.shippAddressId!), successClosure: { (result) -> Void in
            let json=JSON(result)
            let success=json["success"].stringValue
            if success == "success"{
                self.arr.removeObjectAtIndex(indexPath.row);
                //删除对应的cell
                self.table?.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
                if self.arr.count < 1{
                    //不管加没有加载直接先删除视图
                    self.lblNilNewProduct?.removeFromSuperview()
                    self.lblNilNewProduct=nilTitle("您的收货地址为空")
                    self.lblNilNewProduct!.center=self.view.center
                    self.view.addSubview(self.lblNilNewProduct!)
                }
            }else{
                SVProgressHUD.showErrorWithStatus("删除失败")
            }

            }) { (errorMsg) -> Void in
                SVProgressHUD.showErrorWithStatus(errorMsg)
        }
    }
    //返回tabview的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arr.count
    }
    //返回tabview的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 100
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //取消选中的样式
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
        let entity=arr[indexPath.row] as! AddressEntity
        let vc=UpdateAndAddShippingAddressViewController()
        vc.addressFlag=1
        vc.entity=entity
        self.navigationController!.pushViewController(vc, animated:true)
    }
}