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
    fileprivate var table:UITableView!
    fileprivate var textMB=""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="设置"
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        table=UITableView(frame:self.view.bounds)
        table.dataSource=self
        table.delegate=self
        table.tableFooterView=UIView(frame:CGRect.zero)
        self.view.addSubview(table)
    }
}
// MARK: - table协议
extension SettingsViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell=table?.dequeueReusableCell(withIdentifier: "cell Id")
        if cell == nil{
            cell=UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier:"cell Id")
        }
        cell!.detailTextLabel!.font=UIFont.systemFont(ofSize: 15)
        cell!.textLabel!.font=UIFont.systemFont(ofSize: 16)
        cell!.detailTextLabel!.textColor=UIColor.textColor()
        switch indexPath.row{
        case 0:
            cell!.textLabel!.text="关于我们"
            cell!.accessoryType=UITableViewCellAccessoryType.disclosureIndicator
            break
        case 1:
            cell!.textLabel!.text="清除缓存"
            textMB=toFloatTwo(folderSizeAtPath())+"MB"
            cell!.detailTextLabel!.text=textMB
            cell!.accessoryType=UITableViewCellAccessoryType.disclosureIndicator
            break
        case 2:
            cell!.textLabel!.text="当前版本"
            cell!.detailTextLabel!.text="4.6.1"
            break
        default:break
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //取消选中的样式
        tableView.deselectRow(at: indexPath, animated: true);
        switch indexPath.row{
        case 0:
            break
        case 1:
            //清除缓存   点击事件
            //添加提示框
            let alertController = UIAlertController(title: "点单即到",
                message: "您确定要清除缓存吗？", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
            let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default,
                handler: {
                    action in
                    //清楚缓存
                    clearCache()
                    //延时0.2秒执行  不然会有几率报错_BSMachError: (os/kern) invalid name (15)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: { () -> Void in
                        //更新指定行
                        self.table?.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
                    })
                    
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            break
        default:break
        }
    }
}
