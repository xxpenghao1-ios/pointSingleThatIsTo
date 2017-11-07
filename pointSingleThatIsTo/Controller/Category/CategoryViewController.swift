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
        self.view.backgroundColor=UIColor.white
        creatLeftView()
    }
    //左边Table视图
    func creatLeftView(){
        leftTable=UITableView(frame: CGRect(x: 0, y: 0, width: 100,height: boundsHeight-147), style: UITableViewStyle.plain)
        leftTable?.dataSource=self
        leftTable?.delegate=self
        leftTable?.backgroundColor=UIColor(red: 0.95, green: 0.96, blue: 0.96, alpha: 1.0)
        self.view.addSubview(leftTable!)
        //去掉15px空白
        if(leftTable!.responds(to: #selector(setter: UIView.layoutMargins))){
            leftTable?.layoutMargins=UIEdgeInsets.zero
        }
        if(leftTable!.responds(to: #selector(setter: UITableViewCell.separatorInset))){
            leftTable!.separatorInset=UIEdgeInsets.zero;
        }
        leftTable?.separatorColor=UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1)
    }
    //MARK - Table的代理
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Identifier="MultilevelTableViewCell";
        var cell=tableView.dequeueReusableCell(withIdentifier: Identifier);
        if(cell == nil){
            cell=UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:Identifier)
        }
        cell?.textLabel?.text="\(indexPath.row)行"
        cell?.backgroundColor=UIColor(red: 0.95, green: 0.96, blue: 0.96, alpha: 1.0)
        cell?.selectionStyle=UITableViewCellSelectionStyle.none
        if(cell!.responds(to: #selector(setter: UIView.layoutMargins))){
            cell!.layoutMargins=UIEdgeInsets.zero
        }
        if(cell!.responds(to: #selector(setter: UITableViewCell.separatorInset))){
            cell!.separatorInset=UIEdgeInsets.zero;
        }
        //创建分割线
        rightLine=UILabel(frame: CGRect(x: leftTable!.frame.width-0.5, y: 0, width: 0.5, height: cell!.contentView.frame.height))
        rightLine.backgroundColor=UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1)
        cell!.contentView.addSubview(rightLine)
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell=tableView.cellForRow(at: indexPath)
        tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: true)
        rightLine.backgroundColor=UIColor.white
        cell?.backgroundColor=UIColor.white
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell=tableView.cellForRow(at: indexPath)
        cell?.backgroundColor=UIColor(red: 0.95, green: 0.96, blue: 0.96, alpha: 1.0)
        rightLine.backgroundColor=UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1)
    }
}
