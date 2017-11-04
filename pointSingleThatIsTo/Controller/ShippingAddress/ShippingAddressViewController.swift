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
import SwiftyJSON
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
        self.view.backgroundColor=UIColor.white
        table=UITableView(frame:CGRect(x: 0,y: 0,width: boundsWidth,height: boundsHeight-80), style: UITableViewStyle.plain)
        table!.delegate=self
        table!.dataSource=self
        self.view.addSubview(table!)
        //设置cell下边线全屏
        table?.layoutMargins=UIEdgeInsets.zero
        table?.separatorInset=UIEdgeInsets.zero;
        //移除空单元格
        table!.tableFooterView = UIView(frame:CGRect.zero)
        
        let btnSubmit=UIButton(frame:CGRect(x: 30,y: boundsHeight-60,width: boundsWidth-60,height: 40))
        btnSubmit.backgroundColor=UIColor.applicationMainColor()
        btnSubmit.layer.cornerRadius=20
        btnSubmit.setTitle("添加收货地址", for: UIControlState())
        btnSubmit.addTarget(self, action:Selector("addShippingAddress:"), for: UIControlEvents.touchUpInside)
        btnSubmit.titleLabel!.font=UIFont.systemFont(ofSize: 16)
        btnSubmit.setTitleColor(UIColor.white, for: UIControlState())
        self.view.addSubview(btnSubmit)
        //发送网络请求
        httpAddress()
        
        //监听通知刷新页面
        NotificationCenter.default.addObserver(self, selector:"updateTable:", name:NSNotification.Name(rawValue: "updateViewNotification"), object:nil)
    }
    /**
     跳转添加地址页面
     
     - parameter sender: UIButton
     */
    func addShippingAddress(_ sender:UIButton){
        let vc=UpdateAndAddShippingAddressViewController()
        vc.addressFlag=2
        self.navigationController!.pushViewController(vc, animated:true)
    }
    /**
     接收通知刷新页面
     
     - parameter obj:NSNotification
     */
    func updateTable(_ obj:Notification){
        arr.removeAllObjects()
        //发送网络请求
        httpAddress()
    }
    /**
     请求地址信息
     */
    func httpAddress(){
        SVProgressHUD.show(withStatus: "数据加载中")
        let storeId=UserDefaults.standard.object(forKey: "storeId") as! String
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryStoreShippAddressforAndroid(storeId: storeId), successClosure: { (result) -> Void in
            SVProgressHUD.dismiss()
            let json=JSON(result)
            for(_,value) in json{
                let entity=Mapper<AddressEntity>().map(JSONObject:value.object)
                self.arr.add(entity!)
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
                SVProgressHUD.showError(withStatus: errorMsg)
        }
    }

    //展示每个cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell=tableView.dequeueReusableCell(withIdentifier: "ShippingAddressTableViewCellId") as? ShippingAddressTableViewCell
        if cell == nil{
            //加载xib
            cell=Bundle.main.loadNibNamed("ShippingAddressTableViewCell", owner:self, options: nil)?.last as? ShippingAddressTableViewCell
        }
        //设置cell下边线全屏
        cell?.layoutMargins=UIEdgeInsets.zero
        cell?.separatorInset=UIEdgeInsets.zero;
        if arr.count > 0{
            let entity=arr[indexPath.row] as! AddressEntity
            cell!.updateCell(entity)
        }
        
        return cell!
    }
    //把delete 该成中文
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        
        return "删除"
    }

    //删除操作
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        let entity=arr[indexPath.row] as! AddressEntity
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.deleteStoreShippAddressforAndroid(shippAddressId:entity.shippAddressId!), successClosure: { (result) -> Void in
            let json=JSON(result)
            let success=json["success"].stringValue
            if success == "success"{
                self.arr.removeObject(at: indexPath.row);
                //删除对应的cell
                self.table?.deleteRows(at: [indexPath], with: UITableViewRowAnimation.top)
                if self.arr.count < 1{
                    //不管加没有加载直接先删除视图
                    self.lblNilNewProduct?.removeFromSuperview()
                    self.lblNilNewProduct=nilTitle("您的收货地址为空")
                    self.lblNilNewProduct!.center=self.view.center
                    self.view.addSubview(self.lblNilNewProduct!)
                }
            }else{
                SVProgressHUD.showError(withStatus: "删除失败")
            }

            }) { (errorMsg) -> Void in
                SVProgressHUD.showError(withStatus: errorMsg)
        }
    }
    //返回tabview的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arr.count
    }
    //返回tabview的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //取消选中的样式
        tableView.deselectRow(at: indexPath, animated: true);
        let entity=arr[indexPath.row] as! AddressEntity
        let vc=UpdateAndAddShippingAddressViewController()
        vc.addressFlag=1
        vc.entity=entity
        self.navigationController!.pushViewController(vc, animated:true)
    }
}
