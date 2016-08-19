//
//  File.swift
//  pointSingleThatIsTo
//
//  Created by nevermore on 16/1/26.
//  Copyright © 2016年 penghao. All rights reserved.
//
//
//  MessageCenterViewController.swift
//  kxkgStore
//
//  Created by hefeiyue on 15/7/17.
//  Copyright (c) 2015年 奈文魔尔. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import SVProgressHUD
/// 消息中心
class  MessageCenterViewController:BaseViewController,UITableViewDelegate,UITableViewDataSource{
    /// 空视图提示
    private var nilView:UIView?
    /// 数据源
    private var arr=NSMutableArray()
    /// cell数据源
    private var cellArr=NSMutableArray()
    /// table
    private var table:UITableView?
    ///
    private var currentPage=0
    override func viewDidLoad() {
        super.viewDidLoad();
        self.title="消息中心"
        self.view.backgroundColor=UIColor.whiteColor()
        table=UITableView(frame:self.view.bounds)
        table!.contentSize=self.view.bounds.size
        table!.dataSource=self
        table!.delegate=self
        //移除空单元格
        table!.tableFooterView = UIView(frame:CGRectZero)
        //设置cell下边线全屏
        if(table!.respondsToSelector("setLayoutMargins:")){
            table?.layoutMargins=UIEdgeInsetsZero
        }
        if(table!.respondsToSelector("setSeparatorInset:")){
            table?.separatorInset=UIEdgeInsetsZero;
        }
        self.view.addSubview(table!)
        table!.addHeaderWithCallback({//刷新
            //从第一页开始
            self.currentPage=1
            //发送网络请求
            self.httpQueryMessageToStore(self.currentPage, isRefresh:true)
            
        })
        table!.addFooterWithCallback({//加载更多
            //每次页面索引加1
            self.currentPage+=1
            //发送网络请求
            self.httpQueryMessageToStore(self.currentPage, isRefresh:false)
        })
        //加载视图
        SVProgressHUD.showWithStatus("数据加载中")
        table!.headerBeginRefreshing()
    }
    //返回tabview每一行显示什么
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        //定义标示符
        let cells:String="messageCells";
        var cell=tableView.dequeueReusableCellWithIdentifier(cells) as? MessageCenterTableViewCell;
        if cell == nil{
            cell=MessageCenterTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier:cells)
        }
        if arr.count > 0{
            let entity=arr[indexPath.row] as! AdMessgInfoEntity
            cell!.updateCell(entity)
        }
        
        
       return cell!
    }
    //返回tabview的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arr.count
    }
    //返回tabview的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if arr.count > 0{
            let cell=cellArr[indexPath.row] as! MessageCenterTableViewCell
            let entity=arr[indexPath.row] as! AdMessgInfoEntity
            cell.updateCell(entity)
            return cell.frame.size.height
        }else{
            return 50
        }
    }
    //6.表格点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let entity=arr[indexPath.row] as! AdMessgInfoEntity
        if entity.pushReason == 1{//跳转促销区
            let vc=GoodCategory3ViewController()
            vc.flag=4
            self.navigationController!.pushViewController(vc, animated:true)
        }else if entity.pushReason == 2{//跳转特价区
            let vc=GoodSpecialPriceViewController()
            self.navigationController!.pushViewController(vc, animated:true)
        }else if entity.pushReason == 3{//跳转新品推荐区
            let vc=GoodCategory3ViewController()
            vc.flag=3
            self.navigationController!.pushViewController(vc, animated:true)

        }
    }
}
// MARK: - 网络请求
extension MessageCenterViewController{
    /**
     查询消息中心
     */
    func httpQueryMessageToStore(currentPage:Int,isRefresh:Bool){
        var count=0
        let substationId=userDefaults.objectForKey("substationId") as! String
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.queryMessageToStore(substationId: substationId, pageSize: 10, currentPage: currentPage), successClosure: { (result) -> Void in
            let json=JSON(result)
            if isRefresh{
                self.arr.removeAllObjects()
            }
            for(_,value) in json{
                count++
                let entity=Mapper<AdMessgInfoEntity>().map(value.object)
                let cell=MessageCenterTableViewCell()
                self.cellArr.addObject(cell)
                self.arr.addObject(entity!)
            }
            if count < 10{//判断count是否小于10  如果小于表示没有可以加载了 隐藏加载状态
                self.table?.setFooterHidden(true)
            }else{//否则显示
                self.table?.setFooterHidden(false)
            }
            if self.arr.count < 1{//表示没有数据加载空
                self.nilView?.removeFromSuperview()
                self.nilView=nilPromptView("木有消息记录...")
                self.nilView!.center=self.table!.center
                self.view.addSubview(self.nilView!)
                
            }else{//如果有数据清除
                self.nilView?.removeFromSuperview()
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
                SVProgressHUD.showErrorWithStatus(errorMsg)
                //关闭刷新状态
                self.table?.headerEndRefreshing()
                //关闭加载状态
                self.table?.footerEndRefreshing()
        }
    }
}

