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
import SwiftyJSON
/// 个人中心
class PersonalCenterViewContorller:BaseViewController{
    //标题文字
    fileprivate var titleArr=["进货订单","购物车","点单币记录","点单商城","我的收藏","我的消息","代金券","联系客服","投诉与建议"]
    //标题图标
    fileprivate var imgArr=["img1","img2","img3","img4","img5","img6","img7","img8","img9"]
    
    ///个人中心视图table
    fileprivate var collectionView:UICollectionView!
    fileprivate var scrollView:UIScrollView!
    fileprivate var substationEntity:SubstationEntity?
    //每次进页面都会加载
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        querySubstationInfo()
    }
    //加载视图
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置页面标题
        self.title="个人中心"
        //设置页面背景色
        self.view.backgroundColor=UIColor.viewBackgroundColor()
        buildView()
        
    }
    
    
    //6.表格点击事件
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if indexPath.section==0{
//            if indexPath.row==0{
//                //消息中心   点击事件
//                let vc=MessageCenterViewController();
//                vc.hidesBottomBarWhenPushed=true;
//                //点进消息中心 隐藏红色点
//                messageBadgeView?.hidden=true
//                //vc.memberId=memberId!
//                //通知tab清除个人中心角标
//                NSNotificationCenter.defaultCenter().postNotificationName("postPersonalCenter", object:2)
//                self.navigationController?.pushViewController(vc, animated:true);
//            }else if indexPath.row==1{
//                //进货订单   点击事件
//                //跳转到进货订单
//                let actionVC=StockOrderManage()
//                actionVC.hidesBottomBarWhenPushed=true
//                self.navigationController?.pushViewController(actionVC, animated: true)
//            }else if indexPath.row==2{
//                //购物车   点击事件
//                //跳转到购物车
//                self.tabBarController!.selectedIndex=2;
//            }else if indexPath.row==3{
//                if self.substationEntity?.subStationBalanceStatu == 1{
//                    //积分记录
//                    let vc=IntegralRecordViewController();
//                    vc.hidesBottomBarWhenPushed=true
//                    self.navigationController?.pushViewController(vc, animated:true);
//                }else{
//                    SVProgressHUD.showInfoWithStatus("该区域暂未开放,请联系业务员申请开通")
//                }
//            }
//        }else if indexPath.section==1{
//            if indexPath.row==0{
//                pushFeedbackOnProblemsView()
//            }else if indexPath.row==1{
//                //清除缓存   点击事件
//                //添加提示框
//                let alertController = UIAlertController(title: "点单即到",
//                    message: "您确定要清除缓存吗？", preferredStyle: UIAlertControllerStyle.Alert)
//                let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
//                let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default,
//                    handler: {
//                        action in
//                        //清楚缓存
//                        clearCache()
//                        //延时0.2秒执行  不然会有几率报错_BSMachError: (os/kern) invalid name (15)
//                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(0.2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
//                            //更新指定行
//                            self.table?.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
//                        })
//                        
//                })
//                alertController.addAction(cancelAction)
//                alertController.addAction(okAction)
//                self.presentViewController(alertController, animated: true, completion: nil)
//            }else if indexPath.row==2{
//                //搜一搜   点击事件
//                let vc=SearchSSearchViewController();
//                vc.hidesBottomBarWhenPushed=true;
//                self.navigationController?.pushViewController(vc, animated:true);
//                
//            }
//            
//            
//        }else if indexPath.section==2{
//            if indexPath.row==0{
//                SVProgressHUD.showInfoWithStatus("开发中...")
////                //购买记录   点击事件
////                let vc=PurchaseRecordsViewController();
////                //vc.membrId=memberId
////                vc.hidesBottomBarWhenPushed=true;
////                self.navigationController?.pushViewController(vc, animated:true)
//                
//            }else if indexPath.row==1{
//                //客服电话   点击事件
//                let alertController = UIAlertController(title: "点单即到",
//                    message: "您确定要拨打客服吗？", preferredStyle: UIAlertControllerStyle.Alert)
//                let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
//                let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default,
//                    handler: {
//                        action in
//                        //延时0.2秒执行  不然会有几率报错_BSMachError: (os/kern) invalid name (15)
//                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(0.2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
//                        //拨打电话
//                        UIApplication.sharedApplication().openURL(NSURL(string :"tel://\(self.tel)")!)
//                    })
//                })
//                alertController.addAction(cancelAction)
//                alertController.addAction(okAction)
//                self.presentViewController(alertController, animated: true, completion: nil)
//            }
//        }
//        //释放选中效果
//        tableView.deselectRowAtIndexPath(indexPath, animated: true);
//    }
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
}
// MARK: - 构建页面
extension PersonalCenterViewContorller{
    func buildView(){
        
        let imgView=UIImageView(frame:CGRect(x: 0,y: 0,width: 25,height: 25))
        imgView.image=UIImage(named:"settings")?.reSizeImage(reSize:CGSize(width:25, height:25))
        imgView.isUserInteractionEnabled=true
        imgView.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(pushSettings)))
        let item=UIBarButtonItem(customView:imgView)
        self.navigationItem.rightBarButtonItem=item
//        let signImg=UIImageView(frame:CGRectMake(0,0,25,25))
//        signImg.image=UIImage(named: "sign")
//        signImg.userInteractionEnabled=true
//        signImg.addGestureRecognizer(UITapGestureRecognizer(target:self, action:"pushSign"))
//        
//        self.navigationItem.leftBarButtonItem=UIBarButtonItem(customView:signImg)
        scrollView=UIScrollView(frame:self.view.bounds)
        self.view.addSubview(scrollView)
        //初始化头部视图
        let headerView=UIView()
        headerView.frame=CGRect(x: 0,y: 0,width: boundsWidth,height: 150)
        scrollView.addSubview(headerView)
        //给头部视图添加背景图
        let Img=UIImageView(image: UIImage(named: "member_bg"));
        Img.frame=headerView.frame
        headerView.addSubview(Img)
        
        //二维码图片
        let codePic=UIImageView(frame: CGRect(x: 0,y: 0,width: 80,height: 80))
        codePic.center=Img.center
        let qrcode=userDefaults.object(forKey: "qrcode") as? String
        if qrcode != nil{
            codePic.sd_setImage(with: Foundation.URL(string:URLIMG+qrcode!), placeholderImage:UIImage(named:"def_nil"))
        }
        headerView.addSubview(codePic)
        
        //店铺名称
        let lblstoreName=UILabel()
        lblstoreName.frame=CGRect(x: 0,y: 150-30, width: boundsWidth, height: 20)
        lblstoreName.text=userDefaults.object(forKey: "storeName") as? String
        lblstoreName.textColor=UIColor.white
        lblstoreName.font=UIFont.systemFont(ofSize: 14)
        lblstoreName.textAlignment=NSTextAlignment.center
        headerView.addSubview(lblstoreName)
        
        let layout=UICollectionViewFlowLayout()
        let cellWidth=boundsWidth/3
        layout.itemSize=CGSize(width:cellWidth,height:cellWidth)
        layout.scrollDirection = UICollectionViewScrollDirection.vertical//设置垂直显示
        layout.minimumLineSpacing = 0;//每个相邻layout的上下
        layout.minimumInteritemSpacing = 0;//每个相邻layout的左右
        collectionView=UICollectionView(frame:CGRect(x: 0,y: headerView.frame.maxY+15,width: boundsWidth,height: boundsWidth), collectionViewLayout:layout)
        collectionView.dataSource=self
        collectionView.delegate=self
        collectionView.isScrollEnabled=false
        collectionView.backgroundColor=UIColor.clear
        collectionView.register(PersonalCenterCollectionViewCell.self,forCellWithReuseIdentifier:"PersonalCenterCollectionViewCell")
        self.scrollView.addSubview(collectionView)

        ///初始化退出登录按钮
        let btnExitLogin=UIButton(frame: CGRect(x: 0,y: collectionView.frame.maxY+30,width: boundsWidth,height: 50));
        btnExitLogin.backgroundColor=UIColor.applicationMainColor()
        btnExitLogin.setTitle("退出当前账号", for: UIControlState());
        btnExitLogin.addTarget(self, action: #selector(btnAction), for: UIControlEvents.touchUpInside);
        self.scrollView.addSubview(btnExitLogin)
        
        self.scrollView.contentSize=CGSize(width: boundsWidth,height: btnExitLogin.frame.maxY+30)
    }
}
// MARK: - 实现协议
extension PersonalCenterViewContorller:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "PersonalCenterCollectionViewCell", for:indexPath) as! PersonalCenterCollectionViewCell
        let imgStr=imgArr[indexPath.row]
        let str=titleArr[indexPath.row]
        switch indexPath.item / 3 {
        case 0:
            cell.linwSeparatorOptions = [.top, .right]
        case 1:
            cell.linwSeparatorOptions = [.top, .right]
        case 2:
            cell.linwSeparatorOptions = [.top, .right, .bottom]
        default:
            {}()
        }
        cell.updateCell(imgStr, str:str)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0{//订单
            let actionVC=StockOrderManage()
            actionVC.hidesBottomBarWhenPushed=true
            self.navigationController?.pushViewController(actionVC, animated: true)
        }else if indexPath.row == 1{
            //跳转到购物车
            self.tabBarController!.selectedIndex=2;

        }else if indexPath.row == 2{//积分记录
            if self.substationEntity?.subStationBalanceStatu == 1{
                let vc=IntegralRecordViewController();
                vc.hidesBottomBarWhenPushed=true
                self.navigationController?.pushViewController(vc, animated:true);
            }else{
                SVProgressHUD.showInfo(withStatus: "该区域暂未开放,请联系业务员申请开通")
            }
            
        }else if indexPath.row == 3{
            if self.substationEntity?.subStationBalanceStatu == 1{
                /// 跳转到积分商城
                let vc=PresentExpViewController()
                vc.hidesBottomBarWhenPushed=true
                self.navigationController?.pushViewController(vc, animated:true)
            }else{
                SVProgressHUD.showInfo(withStatus: "该区域暂未开放,请联系业务员申请开通")
            }
        }else if indexPath.row == 4{
            let vc=CollectListViewController()
            vc.hidesBottomBarWhenPushed=true
            self.navigationController?.pushViewController(vc, animated:true)
        }else if indexPath.row == 5{
            let vc=MessageCenterViewController();
            vc.hidesBottomBarWhenPushed=true;
            self.navigationController?.pushViewController(vc, animated:true)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:"postPersonalCenter"), object:2)
        }else if indexPath.row == 6{
            // 搜一搜   点击事件
            let vc=VouchersViewController();
            vc.hidesBottomBarWhenPushed=true;
            self.navigationController?.pushViewController(vc, animated:true);
            
        }else if indexPath.row == 7{
            //客服电话   点击事件
            UIAlertController.showAlertYesNo(self, title:"点单即到", message:"您确定要拨打客服吗？", cancelButtonTitle:"取消", okButtonTitle:"确定", okHandler: {  Void in
                    //拨打电话
                    var tel=userDefaults.object(forKey: "subStationPhoneNumber") as? String
                    tel=tel ?? "0731-82562729"
                    UIApplication.shared.openURL(Foundation.URL(string :"tel://\(tel!)")!)
            })
        }else if indexPath.row == 8{
            let vc=FeedbackOnProblemsViewController()
            vc.hidesBottomBarWhenPushed=true
            self.navigationController!.pushViewController(vc, animated:true)
        }
    }
}
// MARK: - 网络请求
extension PersonalCenterViewContorller{
    /**
     请求分站信息和推荐人
     */
    func querySubstationInfo(){
        let storeId=userDefaults.object(forKey: "storeId") as! String
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryStoreMember(storeId: storeId, memberId: IS_NIL_MEMBERID()!), successClosure: { (result) -> Void in
            //解析json
            let json=JSON(result)
            self.substationEntity=Mapper<SubstationEntity>().map(JSONObject: json["substationEntity"].object)
            }) { (errorMsg) -> Void in
                SVProgressHUD.showError(withStatus: errorMsg)
        }
    }

}
// MARK: - 页面逻辑
extension PersonalCenterViewContorller{
    /**
     退出当前账号按钮
     
     - parameter sender: UIButton
     */
    @objc func btnAction(_ sender:UIButton){
        let alert=UIAlertController(title:"点单即到", message:"您确定要退出登录吗?,退出登录后将收不到任何订单", preferredStyle: UIAlertControllerStyle.actionSheet)
        let ok=UIAlertAction(title:"退出登录", style: UIAlertActionStyle.default, handler:{
            Void in
            //设置极光推送 别名为空
            JPUSHService.deleteAlias(nil, seq:11)
            JPUSHService.setTags([],completion: nil,seq:22)
            request(URL+"outLoginForStore.xhtml",method:.get, parameters:["memebrId":IS_NIL_MEMBERID()!])
            //清除缓存中会员id
            userDefaults.removeObject(forKey: "memberId")
            userDefaults.synchronize();
            //切换根视图
            let app=UIApplication.shared.delegate as! AppDelegate
            app.window?.rootViewController=UINavigationController(rootViewController:LoginViewController());
        })
        let cancel=UIAlertAction(title:"取消", style: UIAlertActionStyle.cancel, handler:nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated:true, completion:nil)
        
    }

}
// MARK: - 跳转页面
extension PersonalCenterViewContorller{
    @objc func pushSettings(){
        let vc=SettingsViewController()
        vc.hidesBottomBarWhenPushed=true
        self.navigationController?.pushViewController(vc, animated:true)
    }
    /**
     跳转到签到页面
     */
    func pushSign(){
        
        SVProgressHUD.showInfo(withStatus:"当前区域暂未开通签到功能")
        
    }
}

