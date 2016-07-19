//
//  PurchaseRecordsViewController.swift
//  pointSingleThatIsTo
//
//  Created by nevermore on 16/1/27.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import ObjectMapper
import SVProgressHUD
///购买记录
class PurchaseRecordsViewController:BaseViewController,UITableViewDataSource,UITableViewDelegate {
    /// 打开数据库连接
//    let db=sqlPurchaseRecordsDB()
    /// 数据源
    private var arr=NSMutableArray()
    private var table:UITableView?
    private var nilView:UIView?
    private let memberId=NSUserDefaults.standardUserDefaults().objectForKey("memberId") as! String
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置页面标题
        self.title="购买记录"
        //设置页面背景色
        self.view.backgroundColor=UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem=self.editButtonItem()
//        arr=selectPurchaseRecordsAllGoodList(db, memberId:memberId)
        
        table=UITableView(frame:self.view.bounds, style: UITableViewStyle.Plain)
        table!.dataSource=self
        table!.delegate=self
        self.view.addSubview(table!)
        //设置cell下边线全屏
        table?.layoutMargins=UIEdgeInsetsZero
        table?.separatorInset=UIEdgeInsetsZero;
        //移除空单元格
        table!.tableFooterView = UIView(frame:CGRectZero)
        if self.arr.count < 1{
            self.nilView?.removeFromSuperview()
            self.nilView=nilPromptView("您还木有购买记录")
            self.nilView!.center=self.table!.center
            self.view.addSubview(self.nilView!)
        }
    }
    //展示每个cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell=tableView.dequeueReusableCellWithIdentifier("GoodSpecialPriceTableCellId") as? OrderGoodTableViewCell
        if cell == nil{
            //加载xib
            cell=NSBundle.mainBundle().loadNibNamed("OrderGoodTableViewCell", owner:self, options: nil).last as? OrderGoodTableViewCell
        }
        //设置cell下边线全屏
        cell?.layoutMargins=UIEdgeInsetsZero
        cell?.separatorInset=UIEdgeInsetsZero;
        if arr.count > 0{
            let entity=arr[indexPath.row] as! GoodDetailEntity
            cell!.updateCell(entity)
            
            /*********临时添加数据*********/
            let str=stringDate(entity.purchaseRecordsDate!)
            cell!.lblName.text=str+"您购买了"+"'"+entity.goodInfoName!+"'";
            let btn=UIButton(frame:CGRectMake(15,10,80,80))
            btn.tag=indexPath.row
            btn.addTarget(self, action:"pushGoodDetailView:", forControlEvents: UIControlEvents.TouchUpInside)
            cell!.addSubview(btn)
        }
        
        return cell!
    }
    /**
     跳转
     
     - parameter sender: UIButton
     */
    func pushGoodDetailView(sender:UIButton){
        let entity=arr[sender.tag] as! GoodDetailEntity
        let vc=GoodDetailViewController()
        vc.goodEntity=entity
        vc.storeId=NSUserDefaults.standardUserDefaults().objectForKey("storeId") as? String
        self.navigationController!.pushViewController(vc, animated:true)
    }
    //把delete 该成中文
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        
        return "删除"
    }
    
    //删除操作
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
//        let entity=arr[indexPath.row] as! GoodDetailEntity
//        let flag=deleteGoodPurchaseRecordsById(db, memberId:self.memberId, goodsbasicinfoId:entity.goodsbasicinfoId!)
//        if flag > 0{
//            self.arr.removeObjectAtIndex(indexPath.row);
//            //删除对应的cell
//            self.table?.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
//            if self.arr.count < 1{
//                self.nilView?.removeFromSuperview()
//                self.nilView=nilPromptView("您还木有购买记录")
//                self.nilView!.center=self.table!.center
//                self.view.addSubview(self.nilView!)
//            }
//            
//        }else{
//            SVProgressHUD.showErrorWithStatus("删除失败")
//        }
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
        
    }

    
}
