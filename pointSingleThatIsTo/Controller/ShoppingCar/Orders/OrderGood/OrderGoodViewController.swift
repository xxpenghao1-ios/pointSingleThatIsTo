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
        self.view.backgroundColor=UIColor.white
        table=UITableView(frame:self.view.bounds, style: UITableViewStyle.plain)
        table!.delegate=self
        table!.dataSource=self
        self.view.addSubview(table!)
        //设置cell下边线全屏
        table?.layoutMargins=UIEdgeInsets.zero
        table?.separatorInset=UIEdgeInsets.zero;
        //移除空单元格
        table!.tableFooterView = UIView(frame:CGRect.zero)
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
        }
    
        return cell!
    }
    //返回tabview的行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arr.count
    }
    //返回tabview的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 100
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
