////
////  SignViewController.swift
////  pointSingleThatIsTo
////
////  Created by hao peng on 2017/8/28.
////  Copyright © 2017年 penghao. All rights reserved.
////
//
//import Foundation
//import UIKit
//import ObjectMapper
//import SVProgressHUD
//import SwiftyJSON
///// 签到
//class SignViewController:UIViewController{
//    fileprivate var table:UITableView!
//    fileprivate var scrollView:UIScrollView!
//    //签到文字
//    fileprivate var lblSignText:UILabel!
//    //签到得到的点单币数量提示
//    fileprivate var lblDDBCount:UILabel!
//    //签到信息提示
//    fileprivate var lblSignInfoPrompt:UILabel!
//    //总共获得多少点单币
//    fileprivate var lblSumDDBCount:UILabel!
//    //活动时间
//    fileprivate var lblTime:UILabel!
//    //活动规则
//    fileprivate var lblRuleText:UILabel!
//    fileprivate var signViewRadius:UIView!
//    fileprivate var arr=[SignEntity]()
//    fileprivate var storeId=userDefaults.object(forKey: "storeId") as! String
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.title="签到有礼"
//        self.view.backgroundColor=UIColor.white
//        scrollView=UIScrollView(frame:self.view.bounds)
//        self.view.addSubview(scrollView)
//        buildView()
//        queryStoreToDaySign()
//    }
//}
//// MARK: - 构建页面
//extension SignViewController:UIGestureRecognizerDelegate{
//    /**
//     构建页面
//     */
//    func buildView(){
//       let signView=UIImageView(frame:CGRect(x: 0,y: 0,width: boundsWidth,height: 250))
//       signView.image=UIImage(named:"sign_bac")
//       scrollView.addSubview(signView)
//       signViewRadius=UIView(frame:CGRect(x: (boundsWidth-120)/2,y: 30,width: 120,height: 120))
//       signViewRadius.layer.cornerRadius=120/2
//       signViewRadius.layer.borderColor=UIColor.white.cgColor
//       signViewRadius.layer.borderWidth=8
//       signViewRadius.isUserInteractionEnabled=true
//       signViewRadius.addGestureRecognizer(UITapGestureRecognizer(target:self, action:"isStoreSign"))
//       signView.addSubview(signViewRadius)
//       lblSignText=buildLabel(UIColor.white, font:0, textAlignment: NSTextAlignment.center)
//       lblSignText.font=UIFont.boldSystemFont(ofSize: 24)
//       lblSignText.frame=CGRect(x: 0,y: 30,width: signViewRadius.frame.width,height: 20)
//       signViewRadius.addSubview(lblSignText)
//       let signViewRadiusCenterBorderView=UIView(frame:CGRect(x: 20,y: 60,width: signViewRadius.frame.width-40,height: 0.5))
//       signViewRadiusCenterBorderView.backgroundColor=UIColor.white
//       signViewRadius.addSubview(signViewRadiusCenterBorderView)
//       lblDDBCount=buildLabel(UIColor.white, font:15, textAlignment: NSTextAlignment.center)
//       lblDDBCount.frame=CGRect(x: 0,y: 70,width: signViewRadius.frame.width,height: 20)
//       signViewRadius.addSubview(lblDDBCount)
//       lblSignInfoPrompt=buildLabel(UIColor.white, font:14, textAlignment: NSTextAlignment.center)
//       lblSignInfoPrompt.frame=CGRect(x: 0,y: signViewRadius.frame.maxY+15,width: boundsWidth,height: 20)
//       signView.addSubview(lblSignInfoPrompt)
//       lblSumDDBCount=buildLabel(UIColor.black, font:13, textAlignment: NSTextAlignment.center)
//       lblSumDDBCount.backgroundColor=UIColor.white
//       lblSumDDBCount.layer.masksToBounds=true
//       lblSumDDBCount.layer.cornerRadius=8
//       signView.addSubview(lblSumDDBCount)
//        
//       let signRule=UIImageView(frame:CGRect(x: 0,y: signView.frame.maxY+10,width: boundsWidth,height: 110))
//       signRule.image=UIImage(named: "sign_rule")
//       scrollView.addSubview(signRule)
//       lblTime=buildLabel(UIColor.white, font:14, textAlignment: NSTextAlignment.left)
//       lblTime.frame=CGRect(x: 15,y: 15,width: boundsWidth-30,height: 20)
//       lblTime.text="活动时间  2017/11/14 - 2017/12/30"
//       signRule.addSubview(lblTime)
//       lblRuleText=buildLabel(UIColor.white, font:14, textAlignment: NSTextAlignment.left)
//       lblRuleText.frame=CGRect(x: 15,y: 45,width: 80,height: 20)
//       lblRuleText.text="活动规则"
//       signRule.addSubview(lblRuleText)
//       let lblRuleValue=buildLabel(UIColor.white, font:13, textAlignment: NSTextAlignment.left)
//       lblRuleValue.numberOfLines=0
//       lblRuleValue.lineBreakMode = .byWordWrapping
//       lblRuleValue.frame=CGRect(x: 85,y: 40,width: boundsWidth-100,height: 60)
//       lblRuleValue.text="· 每天签到获取点单币用来兑换现金券\r· 连续签到可以获取额外的神秘礼包\n· 连续每个月为一个周期，月初开始月底结束"
//       signRule.addSubview(lblRuleValue)
//       let lblSuccessionSign=buildLabel(UIColor.black, font:15, textAlignment: NSTextAlignment.center)
//        lblSuccessionSign.text="连续签到"
//        lblSuccessionSign.frame=CGRect(x: 0,y: signRule.frame.maxY+10,width: boundsWidth,height: 20)
//        scrollView.addSubview(lblSuccessionSign)
//        table=UITableView(frame:CGRect(x: 0,y: lblSuccessionSign.frame.maxY+10,width: boundsWidth,height: 400))
//        table.dataSource=self
//        table.delegate=self
//        table.separatorStyle = .none
//        table.isScrollEnabled=false
//        scrollView.addSubview(table)
//        scrollView.contentSize=CGSize(width: boundsWidth,height: table.frame.maxY+20)
//       
//    }
//}
//// MARK: - table协议
//extension SignViewController:UITableViewDelegate,UITableViewDataSource{
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//       var cell=table.dequeueReusableCell(withIdentifier: "signId") as? SignListTableCell
//        if cell == nil{
//            cell=SignListTableCell(style: UITableViewCellStyle.default, reuseIdentifier:"signId")
//        }
//       return cell!
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 40
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return arr.count
//    }
//}
//// MARK: - 网络请求
//extension SignViewController{
//    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
//    //签到
//    func isStoreSign(){
//        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.storeSign(storeId:storeId), successClosure: { (result) -> Void in
//            let json=JSON(result)
//            let success=json["success"].stringValue
//            if success == "success"{
//                SVProgressHUD.showSuccess(withStatus: "签到成功")
//                self.queryStoreToDaySign()
//            }else{
//                SVProgressHUD.showError(withStatus: "签到失败")
//            }
//            }) { (errorMsg) -> Void in
//                SVProgressHUD.showError(withStatus: errorMsg)
//        }
//    }
//    /**
//     签到记录
//     */
//    func queryStoreSignRecord(_ currentPage:Int){
//        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryStoreSignRecord(storeId:storeId,pageSize:10,currentPage:currentPage), successClosure: { (result) -> Void in
//            let json=JSON(result)
//            for(_,value) in json{
//                let entity=Mapper<SignEntity>().map(value.object)
//                if entity!.storeSignGetBalance == nil{
//                    entity!.storeSignGetBalance=0
//                }
//                self.arr.append(entity!)
//            }
//            }) { (errorMsg) -> Void in
//                SVProgressHUD.showError(withStatus: errorMsg!)
//        }
//    }
//    /**
//     当日是否签到
//     */
//    func queryStoreToDaySign(){
//        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryStoreToDaySign(storeId:storeId), successClosure: { (result) -> Void in
//            let json=JSON(result)
//            let success=json["success"].stringValue
////            //店铺当月签到的总天数
////            let monthSignCount=json["monthSignCount"].intValue
//            //店铺当月签到获得的总积分
//            let monthSignBalanceSum=json["monthSignBalanceSum"].intValue
//            //每天签到默认赠送的点单币数量
//            let siginGiveSum=json["siginGiveSum"].intValue
////            //连续签到额外赠送的点单币数量
////            let siginContinuityGiveSum=json["siginContinuityGiveSum"].intValue
//            //连续签到多少天，额外赠送点单币
//            let signContinuityDays=json["signContinuityDays"].intValue
////            //签到规则
//            let signRule=json["signRule"].stringValue
//            print(signRule)
//            if success == "isexist"{//已签到
//                self.signViewRadius.backgroundColor=UIColor.RGBFromHexColor("#d7d7d7d")
//                self.lblSignText.text="已签到"
//            }else if success == "success"{//未签到
//                self.signViewRadius.backgroundColor=UIColor(red:227/255, green:62/255, blue:104/255, alpha:1)
//                self.lblSignText.text="签到"
//            }
//            self.lblDDBCount.text="+\(siginGiveSum)点单币"
//            self.lblSignInfoPrompt.text="本月已签到\(signContinuityDays)天"
//            self.lblSumDDBCount.text="本月签到获得\(monthSignBalanceSum)点单币"
//            let size=self.lblSumDDBCount.text!.textSizeWithFont(self.lblSumDDBCount.font, constrainedToSize:CGSizeMake(500,20))
//            self.lblSumDDBCount.frame=CGRectMake((boundsWidth-(size.width+30))/2,CGRectGetMaxY(self.lblSignInfoPrompt.frame)+10,size.width+30,20)
//            }) { (errorMsg) -> Void in
//                SVProgressHUD.showErrorWithStatus(errorMsg!)
//        }
//    }
//}

