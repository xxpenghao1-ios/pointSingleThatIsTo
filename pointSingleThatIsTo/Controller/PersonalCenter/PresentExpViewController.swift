//
//  RememberViewController.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/7/13.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
/// 购物积分
class PresentExpViewController:BaseViewController{
    /// table视图
    private var table:UITableView?
    /// table头部视图
    private var tableHeaderView:UIView?
    override func viewDidLoad(){
        super.viewDidLoad()
        self.title="积分兑换商品"
        self.view.backgroundColor=UIColor.whiteColor()
        
        tableHeaderView=UIView(frame:CGRectMake(0,64,boundsWidth,120))
        self.view.addSubview(tableHeaderView!)
        
        let imgView=UIImageView(frame:tableHeaderView!.bounds)
        imgView.image=UIImage(named: "jf_bj")
        tableHeaderView!.addSubview(imgView)
        
        table=UITableView(frame:CGRectMake(0,CGRectGetMaxY(tableHeaderView!.frame),boundsWidth,boundsHeight-64-120), style: UITableViewStyle.Plain)
        table!.dataSource=self
        table!.delegate=self
        self.view.addSubview(table!)
        //设置cell下边线全屏
        table?.layoutMargins=UIEdgeInsetsZero
        table?.separatorInset=UIEdgeInsetsZero
    }
}
// MARK: - 实现table协议
extension PresentExpViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell=tableView.dequeueReusableCellWithIdentifier("PresentExpId") as? PresentExpTableViewCell
        if cell == nil{
            //加载xib
            cell=NSBundle.mainBundle().loadNibNamed("PresentExpTableViewCell", owner:self, options: nil).last as? PresentExpTableViewCell
        }
        //设置cell下边线全屏
        cell?.layoutMargins=UIEdgeInsetsZero
        cell?.separatorInset=UIEdgeInsetsZero
        cell!.updateCell()
        return cell!
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}