//
//  VouchersViewController.swift
//  pointSingleThatIsTo
//
//  Created by hao peng on 2017/8/10.
//  Copyright © 2017年 penghao. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SVProgressHUD
import ObjectMapper
//定义闭包类型
typealias closureVouchersEntity = (VouchersEntity) -> Void
/// 代金券
class VouchersViewController:UIViewController{
    //如果不等于空 表示用户正在选择代金券消费
    var flag:Int?
    var vouchersEntity:closureVouchersEntity?
    private let storeId=userDefaults.objectForKey("storeId") as! String
    private var arr=[VouchersEntity]()
    private var table:UITableView!
    private var currentPage=1
    /// 没有数据加载该视图
    private var nilView:UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="代金券"
        self.view.backgroundColor=UIColor.whiteColor()
        let textTitleBorderView=UIView(frame:CGRectMake(10,84,boundsWidth-20,1))
        textTitleBorderView.backgroundColor=UIColor.borderColor()
        self.view.addSubview(textTitleBorderView)
        let textTitle=buildLabel(UIColor.RGBFromHexColor("#999999"), font:13, textAlignment: NSTextAlignment.Center)
        textTitle.text="全部代金券"
        textTitle.frame=CGRectMake((boundsWidth-100)/2,74,100,20)
        textTitle.backgroundColor=UIColor.whiteColor()
        self.view.addSubview(textTitle)
        table=UITableView(frame:CGRectMake(0,CGRectGetMaxY(textTitle.frame)+10,boundsWidth,boundsHeight-104))
        table.dataSource=self
        table.delegate=self
        table.tableFooterView=UIView(frame:CGRectZero)
        table.separatorStyle = .None
        self.view.addSubview(table)
        table.addHeaderWithCallback { () -> Void in
            self.currentPage=1
            self.requestVouchersList(self.currentPage,isRefresh:true)
        }
        table.addFooterWithCallback { () -> Void in
            self.currentPage+=1
            self.requestVouchersList(self.currentPage,isRefresh:false)
        }
        self.table.headerBeginRefreshing()
        SVProgressHUD.showWithStatus("正在加载")
    }
}
// MARK: - table协议
extension VouchersViewController:UITableViewDelegate,UITableViewDataSource{
    //返回tabview每一行显示什么
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        //定义标示符
        let cells:String="cellid";
        var cell=tableView.dequeueReusableCellWithIdentifier(cells);
        if cell == nil{
            cell=UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier:cells)
        }
        cell!.selectionStyle = .None
        if arr.count > 0{
            let entity=arr[indexPath.row]
            let img=UIImageView(frame:CGRectMake(10,0,boundsWidth-20,90))
            img.image=UIImage(named:"vouchers")
            let name=buildLabel(UIColor.RGBFromHexColor("#ff3399"), font:18, textAlignment: NSTextAlignment.Left)
            name.frame=CGRectMake(100,35,100,20)
            name.text="\(entity.cashCouponAmountOfMoney!)元"
            let date=buildLabel(UIColor.RGBFromHexColor("#666666"), font:14, textAlignment: NSTextAlignment.Right)
            date.frame=CGRectMake(boundsWidth-150,35,110,20)
            date.numberOfLines=2
            date.lineBreakMode = .ByWordWrapping
            if entity.cashCouponExpirationDateInt <= 0{
                date.text="已过期"
            }else{
                date.text="\(entity.cashCouponExpirationDate!)到期"
            }
            cell!.contentView.addSubview(img)
            cell!.contentView.addSubview(name)
            cell!.contentView.addSubview(date)
        }
        return cell!
    }
    //返回tabview的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arr.count
    }
    //返回tabview的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 92
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //取消选中的样式
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
        let entity=arr[indexPath.row]
        if flag != nil{
            if entity.cashCouponExpirationDateInt > 0{
                self.vouchersEntity?(entity)
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
}
// MARK: - 网络请求
extension VouchersViewController{
    func requestVouchersList(currentPage:Int,isRefresh:Bool){
        var count=0
        request(.GET,URLIMG+"/cc/queryStoreCashCoupon", parameters:["storeId":storeId,"pageSize":10,"currentPage":currentPage]).responseJSON{ response in
            if response.result.error != nil{
                SVProgressHUD.showErrorWithStatus(response.result.error!.localizedDescription)
                //关闭刷新状态
                self.table.headerEndRefreshing()
                //关闭加载状态
                self.table.footerEndRefreshing()
            }
            if response.result.value != nil{
                if isRefresh{
                    self.arr.removeAll()
                }
                let json=JSON(response.result.value!)
                for(_,value) in json{
                    count++
                    let entity=Mapper<VouchersEntity>().map(value.object)
                    entity!.cashCouponExpirationDateInt=value["cashCouponExpirationDateInt"].intValue
                    self.arr.append(entity!)
                }
                if count < 10{//判断count是否小于10  如果小于表示没有可以加载了 隐藏加载状态
                    self.table.setFooterHidden(true)
                }else{//否则显示
                    self.table.setFooterHidden(false)
                }
                if(self.arr.count < 1){//如果数据为空，显示默认视图
                    self.nilView?.removeFromSuperview()
                    self.nilView=nilPromptView("暂时木有代金券")
                    self.nilView!.center=self.table.center
                    self.view.addSubview(self.nilView!)
                }else{//如果有数据清除
                    self.nilView?.removeFromSuperview()
                }
                //关闭加载等待视图
                SVProgressHUD.dismiss()
                //关闭刷新状态
                self.table.headerEndRefreshing()
                //关闭加载状态
                self.table.footerEndRefreshing()
                self.table.reloadData()
            }
        }
    }
}