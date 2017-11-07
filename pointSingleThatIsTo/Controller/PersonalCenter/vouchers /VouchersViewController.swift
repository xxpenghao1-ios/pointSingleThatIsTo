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
import SwiftyJSON
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

//定义闭包类型
typealias closureVouchersEntity = (VouchersEntity) -> Void
/// 代金券
class VouchersViewController:UIViewController{
    //如果不等于空 表示用户正在选择代金券消费
    var flag:Int?
    var vouchersEntity:closureVouchersEntity?
    fileprivate let storeId=userDefaults.object(forKey: "storeId") as! String
    fileprivate var arr=[VouchersEntity]()
    fileprivate var table:UITableView!
    fileprivate var currentPage=1
    /// 没有数据加载该视图
    fileprivate var nilView:UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="代金券"
        self.view.backgroundColor=UIColor.white
        let textTitleBorderView=UIView(frame:CGRect(x: 10,y:navHeight+20,width: boundsWidth-20,height: 1))
        textTitleBorderView.backgroundColor=UIColor.borderColor()
        self.view.addSubview(textTitleBorderView)
        let textTitle=buildLabel(UIColor.RGBFromHexColor("#999999"), font:13, textAlignment: NSTextAlignment.center)
        textTitle.text="全部代金券"
        textTitle.frame=CGRect(x: (boundsWidth-100)/2,y:navHeight+10,width: 100,height: 20)
        textTitle.backgroundColor=UIColor.white
        self.view.addSubview(textTitle)
        table=UITableView(frame:CGRect(x: 0,y: textTitle.frame.maxY+10,width: boundsWidth,height:boundsHeight-(textTitle.frame.maxY+10)-bottomSafetyDistanceHeight))
        table.dataSource=self
        table.delegate=self
        table.tableFooterView=UIView(frame:CGRect.zero)
        table.separatorStyle = .none
        self.view.addSubview(table)
        table.mj_header=MJRefreshNormalHeader(refreshingBlock: {
            self.currentPage=1
            self.requestVouchersList(self.currentPage,isRefresh:true)
        })
        table.mj_footer=MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in
            self.currentPage+=1
            self.requestVouchersList(self.currentPage,isRefresh:false)
        })
        self.table.mj_header.beginRefreshing()
        SVProgressHUD.show(withStatus: "正在加载")
    }
}
// MARK: - table协议
extension VouchersViewController:UITableViewDelegate,UITableViewDataSource{
    //返回tabview每一行显示什么
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        //定义标示符
        let cells:String="cellid";
        var cell=tableView.dequeueReusableCell(withIdentifier: cells);
        if cell == nil{
            cell=UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:cells)
        }
        cell!.selectionStyle = .none
        if arr.count > 0{
            let entity=arr[indexPath.row]
            let img=UIImageView(frame:CGRect(x: 10,y: 0,width: boundsWidth-20,height: 90))
            img.image=UIImage(named:"vouchers")
            let name=buildLabel(UIColor.RGBFromHexColor("#ff3399"), font:18, textAlignment: NSTextAlignment.left)
            name.frame=CGRect(x: 100,y: 35,width: 100,height: 20)
            name.text="\(entity.cashCouponAmountOfMoney!)元"
            let date=buildLabel(UIColor.RGBFromHexColor("#666666"), font:14, textAlignment: NSTextAlignment.right)
            date.frame=CGRect(x: boundsWidth-150,y: 35,width: 110,height: 20)
            date.numberOfLines=2
            date.lineBreakMode = .byWordWrapping
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arr.count
    }
    //返回tabview的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 92
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //取消选中的样式
        tableView.deselectRow(at: indexPath, animated: true);
        let entity=arr[indexPath.row]
        if flag != nil{
            if entity.cashCouponExpirationDateInt > 0{
                self.vouchersEntity?(entity)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
// MARK: - 网络请求
extension VouchersViewController{
    func requestVouchersList(_ currentPage:Int,isRefresh:Bool){
        var count=0
        request(URLIMG+"/cc/queryStoreCashCoupon",method:.get,parameters:["storeId":storeId,"pageSize":10,"currentPage":currentPage]).responseJSON{ response in
            if response.result.error != nil{
                SVProgressHUD.showError(withStatus: response.result.error!.localizedDescription)
                //关闭刷新状态
                self.table.mj_header.endRefreshing()
                //关闭加载状态
                self.table.mj_footer.endRefreshing()
            }
            if response.result.value != nil{
                if isRefresh{
                    self.arr.removeAll()
                }
                let json=JSON(response.result.value!)
                for(_,value) in json{
                    count+=1
                    let entity=Mapper<VouchersEntity>().map(JSONObject:value.object)
                    entity!.cashCouponExpirationDateInt=value["cashCouponExpirationDateInt"].intValue
                    self.arr.append(entity!)
                }
                if count < 10{//判断count是否小于10  如果小于表示没有可以加载了 隐藏加载状态
                    self.table.mj_footer.isHidden=true
                }else{//否则显示
                    self.table.mj_footer.isHidden=false
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
                self.table.mj_header.endRefreshing()
                //关闭加载状态
                self.table.mj_footer.endRefreshing()
                self.table.reloadData()
            }
        }
    }
}
