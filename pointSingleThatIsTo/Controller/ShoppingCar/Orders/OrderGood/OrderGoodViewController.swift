//
//  OrderGoodViewController.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/2/25.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
/// 购物清单
class OrderGoodViewController:UIViewController,UITableViewDataSource,UITableViewDelegate{
    /// 接收订单传过来商品字典
    var arr=NSMutableArray();
    /// table
    var table:UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="购物清单"
        self.view.backgroundColor=UIColor.whiteColor()
        table=UITableView(frame:self.view.bounds, style: UITableViewStyle.Plain)
        table!.delegate=self
        table!.dataSource=self
        self.view.addSubview(table!)
        //设置cell下边线全屏
        table?.layoutMargins=UIEdgeInsetsZero
        table?.separatorInset=UIEdgeInsetsZero;
        //移除空单元格
        table!.tableFooterView = UIView(frame:CGRectZero)
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
        }
    
        return cell!
    }
    //返回tabview的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arr.count
    }
    //返回tabview的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 100
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}