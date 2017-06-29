//
//  SettingsViewController.swift
//  CXH
//
//  Created by hao peng on 2017/5/18.
//  Copyright © 2017年 zltx. All rights reserved.
//

import Foundation
import UIKit
/// 设置
class SettingsViewController:BaseViewController{
    private var table:UITableView!
    private var textMB=""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="设置"
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        table=UITableView(frame:self.view.bounds)
        table.dataSource=self
        table.delegate=self
        table.tableFooterView=UIView(frame:CGRectZero)
        self.view.addSubview(table)
    }
}
// MARK: - table协议
extension SettingsViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell=table?.dequeueReusableCellWithIdentifier("cell Id")
        if cell == nil{
            cell=UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier:"cell Id")
        }
        cell!.detailTextLabel!.font=UIFont.systemFontOfSize(15)
        cell!.textLabel!.font=UIFont.systemFontOfSize(16)
        cell!.detailTextLabel!.textColor=UIColor.textColor()
        switch indexPath.row{
        case 0:
            cell!.textLabel!.text="关于我们"
            cell!.accessoryType=UITableViewCellAccessoryType.DisclosureIndicator
            break
        case 1:
            cell!.textLabel!.text="清除缓存"
            textMB=toFloatTwo(folderSizeAtPath())+"MB"
            cell!.detailTextLabel!.text=textMB
            cell!.accessoryType=UITableViewCellAccessoryType.DisclosureIndicator
            break
        case 2:
            cell!.textLabel!.text="当前版本"
            cell!.detailTextLabel!.text="4.1"
            break
        default:break
        }
        return cell!
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 50
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //取消选中的样式
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
        switch indexPath.row{
        case 0:
            break
        case 1:
            //清除缓存   点击事件
            //添加提示框
            let alertController = UIAlertController(title: "点单即到",
                message: "您确定要清除缓存吗？", preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
            let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default,
                handler: {
                    action in
                    //清楚缓存
                    clearCache()
                    //延时0.2秒执行  不然会有几率报错_BSMachError: (os/kern) invalid name (15)
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(0.2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                        //更新指定行
                        self.table?.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
                    })
                    
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            break
        default:break
        }
    }
}