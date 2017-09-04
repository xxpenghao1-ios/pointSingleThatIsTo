//
//  SignViewController.swift
//  pointSingleThatIsTo
//
//  Created by hao peng on 2017/8/28.
//  Copyright © 2017年 penghao. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import SVProgressHUD
/// 签到
class SignViewController:UIViewController{
    private var table:UITableView!
    private var scrollView:UIScrollView!
    //签到文字
    private var lblSignText:UILabel!
    //签到得到的点单币数量提示
    private var lblDDBCount:UILabel!
    //签到信息提示
    private var lblSignInfoPrompt:UILabel!
    //总共获得多少点单币
    private var lblSumDDBCount:UILabel!
    //活动时间
    private var lblTime:UILabel!
    //活动规则
    private var lblRuleText:UILabel!
    private var signViewRadius:UIView!
    private var arr=[SignEntity]()
    private var storeId=userDefaults.objectForKey("storeId") as! String
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="签到有礼"
        self.view.backgroundColor=UIColor.whiteColor()
        scrollView=UIScrollView(frame:self.view.bounds)
        self.view.addSubview(scrollView)
        buildView()
        queryStoreToDaySign()
    }
}
// MARK: - 构建页面
extension SignViewController:UIGestureRecognizerDelegate{
    /**
     构建页面
     */
    func buildView(){
       let signView=UIImageView(frame:CGRectMake(0,0,boundsWidth,250))
       signView.image=UIImage(named:"sign_bac")
       scrollView.addSubview(signView)
       signViewRadius=UIView(frame:CGRectMake((boundsWidth-120)/2,30,120,120))
       signViewRadius.layer.cornerRadius=120/2
       signViewRadius.layer.borderColor=UIColor.whiteColor().CGColor
       signViewRadius.layer.borderWidth=8
       signViewRadius.userInteractionEnabled=true
       signViewRadius.addGestureRecognizer(UITapGestureRecognizer(target:self, action:"isStoreSign"))
       signView.addSubview(signViewRadius)
       lblSignText=buildLabel(UIColor.whiteColor(), font:0, textAlignment: NSTextAlignment.Center)
       lblSignText.font=UIFont.boldSystemFontOfSize(24)
       lblSignText.frame=CGRectMake(0,30,signViewRadius.frame.width,20)
       signViewRadius.addSubview(lblSignText)
       let signViewRadiusCenterBorderView=UIView(frame:CGRectMake(20,60,signViewRadius.frame.width-40,0.5))
       signViewRadiusCenterBorderView.backgroundColor=UIColor.whiteColor()
       signViewRadius.addSubview(signViewRadiusCenterBorderView)
       lblDDBCount=buildLabel(UIColor.whiteColor(), font:15, textAlignment: NSTextAlignment.Center)
       lblDDBCount.frame=CGRectMake(0,70,signViewRadius.frame.width,20)
       signViewRadius.addSubview(lblDDBCount)
       lblSignInfoPrompt=buildLabel(UIColor.whiteColor(), font:14, textAlignment: NSTextAlignment.Center)
       lblSignInfoPrompt.frame=CGRectMake(0,CGRectGetMaxY(signViewRadius.frame)+15,boundsWidth,20)
       signView.addSubview(lblSignInfoPrompt)
       lblSumDDBCount=buildLabel(UIColor.blackColor(), font:13, textAlignment: NSTextAlignment.Center)
       lblSumDDBCount.backgroundColor=UIColor.whiteColor()
       lblSumDDBCount.layer.masksToBounds=true
       lblSumDDBCount.layer.cornerRadius=8
       signView.addSubview(lblSumDDBCount)
        
       let signRule=UIImageView(frame:CGRectMake(0,CGRectGetMaxY(signView.frame)+10,boundsWidth,110))
       signRule.image=UIImage(named: "sign_rule")
       scrollView.addSubview(signRule)
       lblTime=buildLabel(UIColor.whiteColor(), font:14, textAlignment: NSTextAlignment.Left)
       lblTime.frame=CGRectMake(15,15,boundsWidth-30,20)
       lblTime.text="活动时间  2017/11/14 - 2017/12/30"
       signRule.addSubview(lblTime)
       lblRuleText=buildLabel(UIColor.whiteColor(), font:14, textAlignment: NSTextAlignment.Left)
       lblRuleText.frame=CGRectMake(15,45,80,20)
       lblRuleText.text="活动规则"
       signRule.addSubview(lblRuleText)
       let lblRuleValue=buildLabel(UIColor.whiteColor(), font:13, textAlignment: NSTextAlignment.Left)
       lblRuleValue.numberOfLines=0
       lblRuleValue.lineBreakMode = .ByWordWrapping
       lblRuleValue.frame=CGRectMake(85,40,boundsWidth-100,60)
       lblRuleValue.text="· 每天签到获取点单币用来兑换现金券\r· 连续签到可以获取额外的神秘礼包\n· 连续每个月为一个周期，月初开始月底结束"
       signRule.addSubview(lblRuleValue)
       let lblSuccessionSign=buildLabel(UIColor.blackColor(), font:15, textAlignment: NSTextAlignment.Center)
        lblSuccessionSign.text="连续签到"
        lblSuccessionSign.frame=CGRectMake(0,CGRectGetMaxY(signRule.frame)+10,boundsWidth,20)
        scrollView.addSubview(lblSuccessionSign)
        table=UITableView(frame:CGRectMake(0,CGRectGetMaxY(lblSuccessionSign.frame)+10,boundsWidth,400))
        table.dataSource=self
        table.delegate=self
        table.separatorStyle = .None
        table.scrollEnabled=false
        scrollView.addSubview(table)
        scrollView.contentSize=CGSizeMake(boundsWidth,CGRectGetMaxY(table.frame)+20)
       
    }
}
// MARK: - table协议
extension SignViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       var cell=table.dequeueReusableCellWithIdentifier("signId") as? SignListTableCell
        if cell == nil{
            cell=SignListTableCell(style: UITableViewCellStyle.Default, reuseIdentifier:"signId")
        }
       return cell!
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
}
// MARK: - 网络请求
extension SignViewController{
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    //签到
    func isStoreSign(){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.storeSign(storeId:storeId), successClosure: { (result) -> Void in
            let json=JSON(result)
            let success=json["success"].stringValue
            if success == "success"{
                SVProgressHUD.showSuccessWithStatus("签到成功")
                self.queryStoreToDaySign()
            }else{
               SVProgressHUD.showErrorWithStatus("签到失败")
            }
            }) { (errorMsg) -> Void in
                SVProgressHUD.showErrorWithStatus(errorMsg!)
        }
    }
    /**
     签到记录
     */
    func queryStoreSignRecord(currentPage:Int){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryStoreSignRecord(storeId:storeId,pageSize:10,currentPage:currentPage), successClosure: { (result) -> Void in
            let json=JSON(result)
            for(_,value) in json{
                let entity=Mapper<SignEntity>().map(value.object)
                if entity!.storeSignGetBalance == nil{
                    entity!.storeSignGetBalance=0
                }
                self.arr.append(entity!)
            }
            }) { (errorMsg) -> Void in
                SVProgressHUD.showErrorWithStatus(errorMsg!)
        }
    }
    /**
     当日是否签到
     */
    func queryStoreToDaySign(){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryStoreToDaySign(storeId:storeId), successClosure: { (result) -> Void in
            let json=JSON(result)
            let success=json["success"].stringValue
//            //店铺当月签到的总天数
//            let monthSignCount=json["monthSignCount"].intValue
            //店铺当月签到获得的总积分
            let monthSignBalanceSum=json["monthSignBalanceSum"].intValue
            //每天签到默认赠送的点单币数量
            let siginGiveSum=json["siginGiveSum"].intValue
//            //连续签到额外赠送的点单币数量
//            let siginContinuityGiveSum=json["siginContinuityGiveSum"].intValue
            //连续签到多少天，额外赠送点单币
            let signContinuityDays=json["signContinuityDays"].intValue
//            //签到规则
            let signRule=json["signRule"].stringValue
            print(signRule)
            if success == "isexist"{//已签到
                self.signViewRadius.backgroundColor=UIColor.RGBFromHexColor("#d7d7d7d")
                self.lblSignText.text="已签到"
            }else if success == "success"{//未签到
                self.signViewRadius.backgroundColor=UIColor(red:227/255, green:62/255, blue:104/255, alpha:1)
                self.lblSignText.text="签到"
            }
            self.lblDDBCount.text="+\(siginGiveSum)点单币"
            self.lblSignInfoPrompt.text="本月已签到\(signContinuityDays)天"
            self.lblSumDDBCount.text="本月签到获得\(monthSignBalanceSum)点单币"
            let size=self.lblSumDDBCount.text!.textSizeWithFont(self.lblSumDDBCount.font, constrainedToSize:CGSizeMake(500,20))
            self.lblSumDDBCount.frame=CGRectMake((boundsWidth-(size.width+30))/2,CGRectGetMaxY(self.lblSignInfoPrompt.frame)+10,size.width+30,20)
            }) { (errorMsg) -> Void in
                SVProgressHUD.showErrorWithStatus(errorMsg!)
        }
    }
}