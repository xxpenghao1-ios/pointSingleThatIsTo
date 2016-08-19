//  PersonalCenterViewContorller.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/1/18.
//  Copyright © 2016年 penghao. All rights reserved.
//
/// 个人中心
import Foundation
import UIKit
import Alamofire
import ObjectMapper
import SVProgressHUD
/// 个人中心
class PersonalCenterViewContorller:UIViewController,UITableViewDataSource,UITableViewDelegate{
    //标题文字
    private var titleArr0=["消息中心","进货订单","购物车","积分记录"]
    private var titleArr1=["积分商城","清除缓存","可兑奖商品","搜一搜"]
    private var titleArr2=["购买记录","扫一扫","我推荐的人","客服电话","当前版本"]
    //标题图标
    private var imgArr0=["preffont","member_orders","member_cart","member_jfjl"]
    private var imgArr1=["exchange","member_clear","canBeTicketView","search_one_search"]
    private var imgArr2=["purchaseRecords","code_img","referrer_manage","member_tell2","version"]
    ///个人中心视图table
    private var table:UITableView?
    /// 图片mb
    private var textMB=""
    /// 电话号码
    private var tel=""
    /// 我的推荐人
    private var myRecommended:String?{
        didSet{//当值被改变刷新table
            if oldValue != nil{
                table?.reloadData()
            }
        }
    }
    private var codePic:UIImageView?
    /// 二维码图片路径
    private var qrcode:String?
    private var headerView:UIView?
    /// 消息提示view
    private var messageBadgeView:UIView?
    /// 分站信息entity
    private var substationEntity:SubstationEntity?
    //每次进页面都会加载
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if myRecommended != nil{
            querySubstationInfo()
        }
    }
    //加载视图
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置页面标题
        self.title="个人中心"
        //设置页面背景色
        self.view.backgroundColor=UIColor.whiteColor()
        initView()
        //监听通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"isHiddenMessageBadgeView:", name:"postIsHiddenMessageBadgeView", object:nil)
        

    }
    //初始化ui控件
    func initView(){
        //获取手机号码
        tel=(userDefaults.objectForKey("subStationPhoneNumber") as? String) ?? "0731-82562729"
        UILayer()
        querySubstationInfo()
    }
    //ui控件及布局
    func UILayer(){
        header()
        //初始化table视图
        table=UITableView(frame:self.view.bounds, style: UITableViewStyle.Plain)
        table?.delegate=self
        table?.dataSource=self
        table?.tableHeaderView=headerView
        table?.tableFooterView=footerView()
        self.view.addSubview(table!)
    }
    /**
     table头部视图
     */
    func header(){
        //初始化头部视图
        headerView=UIView()
        headerView!.frame=CGRectMake(0, 0, boundsWidth, 150)
        //给头部视图添加背景图
        let Img=UIImageView(image: UIImage(named: "member_bg"));
        Img.frame=headerView!.frame
        headerView!.addSubview(Img)
        
        //二维码图片
        codePic=UIImageView(frame: CGRectMake(0, 0, 80, 80))
        codePic!.center=Img.center
        qrcode=userDefaults.objectForKey("qrcode") as? String
        if qrcode != nil{
            codePic!.sd_setImageWithURL(NSURL(string:URLIMG+qrcode!), placeholderImage:UIImage(named:"def_nil"))
        }
        headerView!.addSubview(codePic!)
        //店铺名称
        let lblstoreName=UILabel()
        lblstoreName.frame=CGRectMake(0,150-30, boundsWidth, 20)
        lblstoreName.text=userDefaults.objectForKey("storeName") as? String
        lblstoreName.textColor=UIColor.whiteColor()
        lblstoreName.font=UIFont.systemFontOfSize(14)
        lblstoreName.textAlignment=NSTextAlignment.Center
        headerView!.addSubview(lblstoreName)
        
    }
    
    /**
     //table脚部视图
     */
    func footerView() ->UIView{
        let footView=UIView(frame:CGRectMake(0, 0, boundsWidth,70));
        ///初始化退出登录按钮
        let btnExitLogin=UIButton(frame: CGRectMake(10, 15, footView.frame.width-20,40));
        footView.addSubview(btnExitLogin);
        btnExitLogin.backgroundColor=UIColor.applicationMainColor()
        btnExitLogin.setTitle("退出当前账号", forState: UIControlState.Normal);
        btnExitLogin.layer.cornerRadius=6;
        btnExitLogin.addTarget(self, action: "btnAction:", forControlEvents: UIControlEvents.TouchUpInside);
        return footView
        
    }
    //3.5.1返回头部组视图
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view=UIView(frame:CGRectZero)
        view.backgroundColor=UIColor.viewBackgroundColor()
        return view
    }
    //2.返回几组
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3;
    }
    //1.4每组的头部高度
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    //3.5.1返回底部组视图
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view=UIView(frame:CGRectZero)
        view.backgroundColor=UIColor.viewBackgroundColor()
        return view
    }
    //1.4每组的底部高度
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2{
            return 5
        }else{
            return 0
        }
    }
    //3.返回多少行
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2{
            return 5
        }else{
           return 4
        }
    }
    //4.返回行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
        
        
    }
    //5.数据源
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //定义标示符
        let cells:String="cells";
        var cell=tableView.dequeueReusableCellWithIdentifier(cells);
        if cell==nil{
            cell=UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cells)
        }else{
            cell=UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cells)
        }
        cell!.accessoryType=UITableViewCellAccessoryType.DisclosureIndicator
        cell!.detailTextLabel!.font=UIFont.systemFontOfSize(13)
        //图片
        let img=UIImageView(frame:CGRectMake(14,8.5,32,33))
        cell!.contentView.addSubview(img)
        //文字描述
        let name=UILabel(frame:CGRectMake(CGRectGetMaxX(img.frame)+5,15,100,20))
        name.font=UIFont.systemFontOfSize(14)
        cell!.contentView.addSubview(name)
        switch indexPath.section{
        case 0:
            img.image=UIImage(named:imgArr0[indexPath.row])
            name.text=titleArr0[indexPath.row]
            if indexPath.row == 0{
                messageBadgeView=UIView(frame:CGRectMake(boundsWidth-35,(50-8)/2,8,8))
                messageBadgeView!.backgroundColor=UIColor.redColor()
                messageBadgeView!.layer.cornerRadius=8/2
                messageBadgeView!.hidden=true
                cell!.contentView.addSubview(messageBadgeView!)
            }
            break
        case 1:
            if indexPath.row == 1{//缓存mb
                textMB=toFloatTwo(folderSizeAtPath())+"MB"
                cell!.detailTextLabel!.text=textMB
            }
            img.image=UIImage(named:imgArr1[indexPath.row])
            name.text=titleArr1[indexPath.row]
            break
        case 2:
            if indexPath.row == 2{//我的推荐人
                if myRecommended != nil{
                    cell!.detailTextLabel!.text="我的推荐人:\(myRecommended!)"
                }
            }else if indexPath.row == 3{
                cell!.detailTextLabel!.text=tel
            }else if indexPath.row == 4{
                cell!.detailTextLabel!.text="1.5.6"
                cell!.accessoryType=UITableViewCellAccessoryType.None
            }
            img.image=UIImage(named:imgArr2[indexPath.row])
            name.text=titleArr2[indexPath.row]
            break
        default:break
        }
        ///取消点击效果（如QQ空间）
        cell?.selectionStyle=UITableViewCellSelectionStyle.None;
        return cell!
    }
    //6.表格点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section==0{
            if indexPath.row==0{
                //消息中心   点击事件
                let vc=MessageCenterViewController();
                vc.hidesBottomBarWhenPushed=true;
                //点进消息中心 隐藏红色点
                messageBadgeView?.hidden=true
                //vc.memberId=memberId!
                //通知tab清除个人中心角标
                NSNotificationCenter.defaultCenter().postNotificationName("postPersonalCenter", object:2)
                self.navigationController?.pushViewController(vc, animated:true);
            }else if indexPath.row==1{
                //进货订单   点击事件
                //跳转到进货订单
                let actionVC=StockOrderManage()
                actionVC.hidesBottomBarWhenPushed=true
                self.navigationController?.pushViewController(actionVC, animated: true)
            }else if indexPath.row==2{
                //购物车   点击事件
                //跳转到购物车
                self.tabBarController!.selectedIndex=3;
            }else if indexPath.row==3{
                if self.substationEntity?.subStationBalanceStatu == 1{
                    //积分记录
                    let vc=IntegralRecordViewController();
                    vc.hidesBottomBarWhenPushed=true
                    self.navigationController?.pushViewController(vc, animated:true);
                }else{
                    SVProgressHUD.showInfoWithStatus("暂未开放,请联系业务员申请开通")
                }
            }
        }else if indexPath.section==1{
            if indexPath.row==0{
                if self.substationEntity?.subStationBalanceStatu == 1{
                    /// 跳转到积分商城
                    let vc=PresentExpViewController()
                    vc.hidesBottomBarWhenPushed=true
                    self.navigationController?.pushViewController(vc, animated:true)
                }else{
                    SVProgressHUD.showInfoWithStatus("暂未开放,请联系业务员申请开通")
                }
            }else if indexPath.row==1{
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
            }else if indexPath.row==2{
                SVProgressHUD.showInfoWithStatus("暂未开放")
//                //可兑奖商品   点击事件
//                let vc=CanBeTicketViewController();
//                //vc.memberId=memberId
//                vc.hidesBottomBarWhenPushed=true;
//                self.navigationController?.pushViewController(vc, animated:true)
            }else if indexPath.row==3{
                //搜一搜   点击事件
                let vc=SearchSSearchViewController();
                vc.hidesBottomBarWhenPushed=true;
                self.navigationController?.pushViewController(vc, animated:true);
                
            }
            
            
        }else if indexPath.section==2{
            if indexPath.row==0{
                //购买记录   点击事件
                let vc=PurchaseRecordsViewController();
                //vc.membrId=memberId
                vc.hidesBottomBarWhenPushed=true;
                self.navigationController?.pushViewController(vc, animated:true)
                
            }else if indexPath.row==1{
                //扫一扫   点击事件
                let vc=SweepOutViewController();
                vc.shakeMemberInfoId=1;
                vc.hidesBottomBarWhenPushed=true;
                self.navigationController?.pushViewController(vc, animated:true);
            }else if indexPath.row==2{
                //我推荐的人   点击事件
                let vc=IRecommendViewController();
                //vc.memberId=memberId;
                vc.hidesBottomBarWhenPushed=true;
                self.navigationController?.pushViewController(vc, animated:true);
            }else if indexPath.row==3{
                //客服电话   点击事件
                let alertController = UIAlertController(title: "点单即到",
                    message: "您确定要拨打客服吗？", preferredStyle: UIAlertControllerStyle.Alert)
                let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
                let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default,
                    handler: {
                        action in
                        //延时0.2秒执行  不然会有几率报错_BSMachError: (os/kern) invalid name (15)
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(0.2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                        //拨打电话
                        UIApplication.sharedApplication().openURL(NSURL(string :"tel://\(self.tel)")!)
                    })
                })
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
        //释放选中效果
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
    }
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
// MARK: - 网络请求
extension PersonalCenterViewContorller{
    /**
     请求分站信息和推荐人
     */
    func querySubstationInfo(){
        let storeId=userDefaults.objectForKey("storeId") as! String
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryStoreMember(storeId: storeId, memberId: IS_NIL_MEMBERID()!), successClosure: { (result) -> Void in
            //解析json
            let json=JSON(result)
            self.substationEntity=Mapper<SubstationEntity>().map(json["substationEntity"].object)
            self.myRecommended=json["referralName"].stringValue
            }) { (errorMsg) -> Void in
                SVProgressHUD.showErrorWithStatus(errorMsg)
        }
    }

}
// MARK: - 页面逻辑
extension PersonalCenterViewContorller{
    /**
     是否隐藏消息提示视图
     
     - parameter obj:NSNotification
     */
    func isHiddenMessageBadgeView(obj:NSNotification){
        let count=obj.object as! Int
        if count == 0{
            messageBadgeView?.hidden=true
        }else{
            messageBadgeView?.hidden=false
        }
    }
    /**
     退出当前账号按钮
     
     - parameter sender: UIButton
     */
    func btnAction(sender:UIButton){
        let alert=UIAlertController(title:"点单即到", message:"您确定要退出登录吗?,退出登录后将收不到任何订单", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let ok=UIAlertAction(title:"退出登录", style: UIAlertActionStyle.Default, handler:{
            Void in
            //设置极光推送 别名为空
            JPUSHService.setAlias("",callbackSelector:nil, object:nil)
            JPUSHService.setTags([], callbackSelector:nil, object:nil)
//            PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.outLoginForStore(memberId: IS_NIL_MEMBERID()!), successClosure: { (result) -> Void in
//                
//                }, failClosure: { (errorMsg) -> Void in
//                    
//            })
            request(.GET,URL+"outLoginForStore.xhtml,", parameters:["memebrId":IS_NIL_MEMBERID()!])
            //清除缓存中会员id
            NSUserDefaults.standardUserDefaults().removeObjectForKey("memberId")
            NSUserDefaults.standardUserDefaults().synchronize();
            //切换根视图
            let app=UIApplication.sharedApplication().delegate as! AppDelegate
            app.window?.rootViewController=UINavigationController(rootViewController:storyboardPushView("LoginId") as! LoginViewController);
        })
        let cancel=UIAlertAction(title:"取消", style: UIAlertActionStyle.Cancel, handler:nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        self.presentViewController(alert, animated:true, completion:nil)
        
    }

}
// MARK: - 跳转页面
extension PersonalCenterViewContorller{
    
}

