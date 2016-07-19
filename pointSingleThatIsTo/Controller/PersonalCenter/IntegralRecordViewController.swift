//
//  IntegralRecordViewController.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/7/19.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
/// 积分记录
class IntegralRecordViewController:BaseViewController{
    /// table
    private var table:UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="积分记录"
        self.view.backgroundColor=UIColor.whiteColor()
    }
}
// MARK: - 实现table协议
extension IntegralRecordViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
}