//
//  PurchaseRecordsViewController.swift
//  pointSingleThatIsTo
//
//  Created by nevermore on 16/1/27.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import SVProgressHUD
///购买记录
class PurchaseRecordsViewController:BaseViewController,UITableViewDataSource,UITableViewDelegate {
    /// 打开数据库连接
//    let db=sqlPurchaseRecordsDB()
    /// 数据源
    fileprivate var arr=NSMutableArray()
    fileprivate var table:UITableView?
    fileprivate var nilView:UIView?
    fileprivate let memberId=UserDefaults.standard.object(forKey: "memberId") as! String
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置页面标题
        self.title="购买记录"
        //设置页面背景色
        self.view.backgroundColor=UIColor.white
        self.navigationItem.rightBarButtonItem=self.editButtonItem
//        arr=selectPurchaseRecordsAllGoodList(db, memberId:memberId)
        
        table=UITableView(frame:self.view.bounds, style: UITableViewStyle.plain)
        table!.dataSource=self
        table!.delegate=self
        self.view.addSubview(table!)
        //设置cell下边线全屏
        table?.layoutMargins=UIEdgeInsets.zero
        table?.separatorInset=UIEdgeInsets.zero;
        //移除空单元格
        table!.tableFooterView = UIView(frame:CGRect.zero)
        if self.arr.count < 1{
            self.nilView?.removeFromSuperview()
            self.nilView=nilPromptView("您还木有购买记录")
            self.nilView!.center=self.table!.center
            self.view.addSubview(self.nilView!)
        }
    }
    //展示每个cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell=tableView.dequeueReusableCell(withIdentifier: "GoodSpecialPriceTableCellId") as? OrderGoodTableViewCell
        if cell == nil{
            //加载xib
            cell=Bundle.main.loadNibNamed("OrderGoodTableViewCell", owner:self, options: nil)?.last as? OrderGoodTableViewCell
        }
        //设置cell下边线全屏
        cell?.layoutMargins=UIEdgeInsets.zero
        cell?.separatorInset=UIEdgeInsets.zero;
        if arr.count > 0{
            let entity=arr[indexPath.row] as! GoodDetailEntity
            cell!.updateCell(entity)
            
            /*********临时添加数据*********/
            let str=stringDate(entity.purchaseRecordsDate!)
            cell!.lblName.text=str+"您购买了"+"'"+entity.goodInfoName!+"'";
            let btn=UIButton(frame:CGRect(x: 15,y: 10,width: 80,height: 80))
            btn.tag=indexPath.row
            btn.addTarget(self, action:#selector(pushGoodDetailView), for: UIControlEvents.touchUpInside)
            cell!.addSubview(btn)
        }
        
        return cell!
    }
    /**
     跳转
     
     - parameter sender: UIButton
     */
    @objc func pushGoodDetailView(_ sender:UIButton){
        let entity=arr[sender.tag] as! GoodDetailEntity
        let vc=GoodDetailViewController()
        vc.goodEntity=entity
        vc.storeId=UserDefaults.standard.object(forKey: "storeId") as? String
        self.navigationController!.pushViewController(vc, animated:true)
    }
    //把delete 该成中文
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        
        return "删除"
    }
    
    //删除操作
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arr.count
    }
    //返回tabview的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    
}
