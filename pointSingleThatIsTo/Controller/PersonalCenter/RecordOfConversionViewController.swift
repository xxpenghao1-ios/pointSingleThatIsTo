//
//  RecordOfConversionViewController.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/7/29.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import ObjectMapper
import SwiftyJSON
/// 兑换记录
class RecordOfConversionViewController:BaseViewController{
    /// table视图
    fileprivate var table:UITableView?
    /// 空视图提示
    fileprivate var lblNilTitle:UILabel?
    /// 数据源
    fileprivate var arr=NSMutableArray()
    /// 第几页
    fileprivate var currentPage:Int=0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="兑换记录"
        self.view.backgroundColor=UIColor.white
        table=UITableView(frame:self.view.bounds, style: UITableViewStyle.plain)
        table!.dataSource=self
        table!.delegate=self
        self.view.addSubview(table!)
        //设置cell下边线全屏
        table?.layoutMargins=UIEdgeInsets.zero
        table?.separatorInset=UIEdgeInsets.zero
        //移除空单元格
        table!.tableFooterView = UIView(frame:CGRect.zero)
        table!.addHeaderWithCallback{
            self.currentPage=1
            self.httpQueryIntegralMallExchangeRecord(self.currentPage,isRefresh:true)
        }
        table!.addFooterWithCallback{
            self.currentPage+=1
            self.httpQueryIntegralMallExchangeRecord(self.currentPage,isRefresh:false)
        }
        //加载等待视图
        SVProgressHUD.show(withStatus: "数据加载中")
        table!.headerBeginRefreshing()
    }
}
// MARK: - 实现table协议
extension RecordOfConversionViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell=tableView.dequeueReusableCell(withIdentifier: "ExchangeRecordId") as? ExchangeRecordTableViewCell
        if cell == nil{
            //加载xib
            cell=Bundle.main.loadNibNamed("ExchangeRecordTableViewCell", owner:self, options: nil)?.last as? ExchangeRecordTableViewCell
        }
        //设置cell下边线全屏
        cell?.layoutMargins=UIEdgeInsets.zero
        cell?.separatorInset=UIEdgeInsets.zero
        if arr.count > 0{
            let entity=arr[indexPath.row] as! ExchangeRecordEntity
            cell!.updateCell(entity)
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
}

// MARK: - 网络请求
extension RecordOfConversionViewController{
    func httpQueryIntegralMallExchangeRecord(_ currentPage:Int,isRefresh:Bool){
        var count=0
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryIntegralMallExchangeRecord(memberId: IS_NIL_MEMBERID()!, pageSize: 10, currentPage: currentPage), successClosure: { (result) -> Void in
            let json=JSON(result)
            if isRefresh{//如果是刷新先删除数据
                self.arr.removeAllObjects()
            }
            for(_,value) in json{
                count+=1
                let entity=Mapper<ExchangeRecordEntity>().map(JSONObject:value.object)
                self.arr.add(entity!)
            }
            if count < 10{//判断count是否小于10  如果小于表示没有可以加载了 隐藏加载状态
                self.table?.setFooterHidden(true)
            }else{//否则显示
                self.table?.setFooterHidden(false)
            }
            if self.arr.count < 1{//表示没有数据加载空
                self.lblNilTitle?.removeFromSuperview()
                self.lblNilTitle=nilTitle("还没有点单币商品")
                self.lblNilTitle!.center=self.table!.center
                self.view.addSubview(self.lblNilTitle!)
            }else{//如果有数据清除
                self.lblNilTitle?.removeFromSuperview()
            }
            //关闭刷新状态
            self.table?.headerEndRefreshing()
            //关闭加载状态
            self.table?.footerEndRefreshing()
            //关闭加载等待视图
            SVProgressHUD.dismiss()
            //刷新table
            self.table?.reloadData()
            }) { (errorMsg) -> Void in
                //关闭刷新状态
                self.table?.headerEndRefreshing()
                //关闭加载状态
                self.table?.footerEndRefreshing()
                SVProgressHUD.showError(withStatus: errorMsg)
        }
    }
}
