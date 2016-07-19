//
//  CanBeTicketViewController.swift
//  pointSingleThatIsTo
//
//  Created by nevermore on 16/1/27.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import ObjectMapper



class CanBeTicketViewController:UIViewController,UITableViewDataSource,UITableViewDelegate {
    /// 会员ID
    var storeId:String?
    /// table
    var tableView:UITableView?;
    /// 加载的数据条数
    var tablefootCount:Int?;
    /// 数据集合
    var arr=NSMutableArray()
    
    /// 加载的页码
    var currentPage:Int?;
    var nilView:UIView?
    
    //加载页面
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        //从内存拿到ID
//        storeId=storeUserDefaults.objectForKey("storeId") as? String
        //设置页面标题
        self.title="可兑奖的商品"
        //设置页面背景色
        self.view.backgroundColor=UIColor.whiteColor()
        nilView=nilPromptView("没有该信息记录")
        nilView!.center=self.view.center
        self.view.addSubview(nilView!)
//        currentPage=1
//        initView()
        
    }
    //初始化UI
    func initView(){
        setupRefresh1()
        http(self.currentPage!)
        table()
    }
    //创建table
    func table(){
        //初始化table
        tableView=UITableView(frame: CGRectMake(0, 0, boundsWidth,boundsHeight), style: UITableViewStyle.Plain)
        tableView?.dataSource=self
        tableView?.delegate=self
        tableView?.backgroundColor=UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1)
        tableView?.showsVerticalScrollIndicator=false
        tableView?.showsHorizontalScrollIndicator=false
        self.view.addSubview(tableView!)
        //移除空单元格
        tableView!.tableFooterView = UIView(frame:CGRectZero)
        //去15px空白线
        if(tableView!.respondsToSelector("setLayoutMargins:")){
            tableView?.layoutMargins=UIEdgeInsetsZero
        }
        if(tableView!.respondsToSelector("setSeparatorInset:")){
            tableView!.separatorInset=UIEdgeInsetsZero;
        }
        
        
    }
    //2.返回几组
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    //3.返回多少行
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    //4.返回行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    //5.数据源
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //定义标示符
        let cells:String="cells";
        var cell=tableView.dequeueReusableCellWithIdentifier(cells) as? CanBeTicketViewControllerCell;
        if(cell == nil){
            cell=CanBeTicketViewControllerCell(style: UITableViewCellStyle.Default, reuseIdentifier: cells)
        }
        let celldate:CanBeTicketViewControllerEntity=self.arr[indexPath.row] as! CanBeTicketViewControllerEntity
        cell?.dateShow(celldate)
        ///取消点击效果（如QQ空间）
        cell?.selectionStyle=UITableViewCellSelectionStyle.None;
        
        
        //去除15px的空白线
        if(cell!.respondsToSelector("setLayoutMargins:")){
            cell!.layoutMargins=UIEdgeInsetsZero
        }
        if(cell!.respondsToSelector("setSeparatorInset:")){
            cell!.separatorInset=UIEdgeInsetsZero;
        }
        return cell!
    }
    //6.表格点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //释放选中效果
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
    }
    
    //发送请求
    func http(currentPage:Int){
        self.tablefootCount=0;
        let httpurl=URL+"storeQueryMyNews.xhtml"
        Alamofire.request(.GET, httpurl, parameters: ["storeId":self.storeId!,"pageSize":10,"currentPage":currentPage,"flag":2]).responseJSON{res in
            if res.result.error != nil{
                
                
            }
            if res.result.value != nil{
                //解析json
                let resJSON=JSON(res.result.value!)
                
                for (_,value) in resJSON{
                    self.tablefootCount=self.tablefootCount!+1
                    print(value)
                    let entity=Mapper<CanBeTicketViewControllerEntity>().map(value.object)
                    self.arr.addObject(entity!)
                    
                }
                if self.tablefootCount==0{
                    self.arrNilAddView()
                }
                if self.tablefootCount! < 10{
                    
                    self.tableView!.setFooterHidden(true);
                    
                }else{
                    
                    self.tableView!.setFooterHidden(false);
                    
                }
                if self.tablefootCount! < 1{
                    
                    self.tableView!.setHeaderHidden(true)
                    
                }
                self.tableView?.reloadData()
            }
            self.tableView?.headerEndRefreshing()
            self.tableView?.footerEndRefreshing()
        }
    }
    //上拉加载/下拉刷新
    func setupRefresh1(){
        self.tableView?.addHeaderWithCallback({
            self.currentPage!=1;
            self.arr.removeAllObjects()
            let delayInSeconds:Int64 =  1000000000  * 2
            let popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
            dispatch_after(popTime, dispatch_get_main_queue(), {
                self.http(self.currentPage!);
                
            })
            
        })
        
        self.tableView?.addFooterWithCallback({
            //每次上拉都加1
            self.currentPage=self.currentPage!+1;
            let delayInSeconds:Int64 = 1000000000 * 2
            let popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
            dispatch_after(popTime, dispatch_get_main_queue(), {
                self.http(self.currentPage!);
            })
        })
    }
    //如果没有数据加载改方法
    func arrNilAddView(){
        let PromptView=UIView(frame:CGRectMake(0,0,boundsWidth,91.5));
        PromptView.center=self.view.center
        let promptImgView=UIImageView(frame:CGRectMake((PromptView.frame.width-61.5)/2,0, 61.5,65.5))
        promptImgView.image=UIImage(named:"nildd")
        PromptView.addSubview(promptImgView)
        let lblPrompt=UILabel(frame:CGRectMake(0,61.5+10,PromptView.frame.width,20));
        
        lblPrompt.textAlignment=NSTextAlignment.Center;
        lblPrompt.text="没有该信息记录";
        lblPrompt.font=UIFont.boldSystemFontOfSize(16);
        lblPrompt.textColor=UIColor.textColor();
        PromptView.addSubview(lblPrompt);
        self.view.addSubview(PromptView)
    }
    
    
    
}
