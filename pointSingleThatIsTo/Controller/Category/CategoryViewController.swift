//
//  CategoryViewController.swift
//  pointSingleThatIsTo
//
//  Created by 卢洋 on 16/1/31.
//  Copyright © 2016年 penghao. All rights reserved.
//
//分类
import Foundation
import UIKit
class CategoryViewController:UIViewController,UITableViewDelegate,UITableViewDataSource{
    //左边Table
    var leftTable:UITableView?;
    //右分割线
    var rightLine:UILabel!;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.whiteColor()
        creatLeftView()
    }
    //左边Table视图
    func creatLeftView(){
        leftTable=UITableView(frame: CGRectMake(0, 0, 100,boundsHeight-147), style: UITableViewStyle.Plain)
        leftTable?.dataSource=self
        leftTable?.delegate=self
        leftTable?.backgroundColor=UIColor(red: 0.95, green: 0.96, blue: 0.96, alpha: 1.0)
        self.view.addSubview(leftTable!)
        //去掉15px空白
        if(leftTable!.respondsToSelector("setLayoutMargins:")){
            leftTable?.layoutMargins=UIEdgeInsetsZero
        }
        if(leftTable!.respondsToSelector("setSeparatorInset:")){
            leftTable!.separatorInset=UIEdgeInsetsZero;
        }
        leftTable?.separatorColor=UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1)
    }
    //MARK - Table的代理
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let Identifier="MultilevelTableViewCell";
        var cell=tableView.dequeueReusableCellWithIdentifier(Identifier);
        if(cell == nil){
            cell=UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier:Identifier)
        }
        cell?.textLabel?.text="\(indexPath.row)行"
        cell?.backgroundColor=UIColor(red: 0.95, green: 0.96, blue: 0.96, alpha: 1.0)
        cell?.selectionStyle=UITableViewCellSelectionStyle.None
        if(cell!.respondsToSelector("setLayoutMargins:")){
            cell!.layoutMargins=UIEdgeInsetsZero
        }
        if(cell!.respondsToSelector("setSeparatorInset:")){
            cell!.separatorInset=UIEdgeInsetsZero;
        }
        //创建分割线
        rightLine=UILabel(frame: CGRectMake(leftTable!.frame.width-0.5, 0, 0.5, cell!.contentView.frame.height))
        rightLine.backgroundColor=UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1)
        cell!.contentView.addSubview(rightLine)
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell=tableView.cellForRowAtIndexPath(indexPath)
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        rightLine.backgroundColor=UIColor.whiteColor()
        cell?.backgroundColor=UIColor.whiteColor()
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell=tableView.cellForRowAtIndexPath(indexPath)
        cell?.backgroundColor=UIColor(red: 0.95, green: 0.96, blue: 0.96, alpha: 1.0)
        rightLine.backgroundColor=UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1)
    }
}