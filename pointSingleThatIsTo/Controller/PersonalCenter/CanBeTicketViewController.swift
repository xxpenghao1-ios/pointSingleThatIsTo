//
//  CanBeTicketViewController.swift
//  pointSingleThatIsTo
//
//  Created by nevermore on 16/1/27.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import SwiftyJSON

/// 可兑奖的商品
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
        self.view.backgroundColor=UIColor.white
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
        tableView=UITableView(frame: CGRect(x: 0, y: 0, width: boundsWidth,height: boundsHeight), style: UITableViewStyle.plain)
        tableView?.dataSource=self
        tableView?.delegate=self
        tableView?.backgroundColor=UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1)
        tableView?.showsVerticalScrollIndicator=false
        tableView?.showsHorizontalScrollIndicator=false
        self.view.addSubview(tableView!)
        //移除空单元格
        tableView!.tableFooterView = UIView(frame:CGRect.zero)
        //去15px空白线
        if(tableView!.responds(to: #selector(setter: UIView.layoutMargins))){
            tableView?.layoutMargins=UIEdgeInsets.zero
        }
        if(tableView!.responds(to: #selector(setter: UITableViewCell.separatorInset))){
            tableView!.separatorInset=UIEdgeInsets.zero;
        }
        
        
    }
    //2.返回几组
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    //3.返回多少行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    //4.返回行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    //5.数据源
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //定义标示符
        let cells:String="cells";
        var cell=tableView.dequeueReusableCell(withIdentifier: cells) as? CanBeTicketViewControllerCell;
        if(cell == nil){
            cell=CanBeTicketViewControllerCell(style: UITableViewCellStyle.default, reuseIdentifier: cells)
        }
        let celldate:CanBeTicketViewControllerEntity=self.arr[indexPath.row] as! CanBeTicketViewControllerEntity
        cell?.dateShow(celldate)
        ///取消点击效果（如QQ空间）
        cell?.selectionStyle=UITableViewCellSelectionStyle.none;
        
        
        //去除15px的空白线
        if(cell!.responds(to: #selector(setter: UIView.layoutMargins))){
            cell!.layoutMargins=UIEdgeInsets.zero
        }
        if(cell!.responds(to: #selector(setter: UITableViewCell.separatorInset))){
            cell!.separatorInset=UIEdgeInsets.zero;
        }
        return cell!
    }
    //6.表格点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //释放选中效果
        tableView.deselectRow(at: indexPath, animated: true);
    }
    
    //发送请求
    func http(_ currentPage:Int){
        self.tablefootCount=0;
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.storeQueryMyNews(storeId: self.storeId!, pageSize: 10, currentPage: currentPage, flag: 2), successClosure: { (result) -> Void in
            //解析json
            let resJSON=JSON(result)
            
            for (_,value) in resJSON{
                self.tablefootCount=self.tablefootCount!+1
                let entity=Mapper<CanBeTicketViewControllerEntity>().map(JSONObject:value.object)
                self.arr.add(entity!)
                
            }
            if self.tablefootCount==0{
                self.arrNilAddView()
            }
            if self.tablefootCount! < 10{
                
                self.tableView!.mj_footer.isHidden=true;
                
            }else{
                
                self.tableView!.mj_footer.isHidden=false;
                
            }
            self.tableView?.reloadData()
            self.tableView?.mj_header.endRefreshing()
            self.tableView?.mj_footer.endRefreshing()

            }) { (errorMsg) -> Void in
    
        }
    }
    //上拉加载/下拉刷新
    func setupRefresh1(){
        self.tableView?.mj_header=MJRefreshNormalHeader(refreshingBlock: {
            self.currentPage!=1;
            self.arr.removeAllObjects()
            let delayInSeconds:Int64 =  1000000000  * 2
            let popTime:DispatchTime = DispatchTime.now() + Double(delayInSeconds) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: popTime, execute: {
                self.http(self.currentPage!);
                
            })
            
        })
        
        self.tableView?.mj_footer=MJRefreshAutoNormalFooter(refreshingBlock: {
            //每次上拉都加1
            self.currentPage=self.currentPage!+1;
            let delayInSeconds:Int64 = 1000000000 * 2
            let popTime:DispatchTime = DispatchTime.now() + Double(delayInSeconds) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: popTime, execute: {
                self.http(self.currentPage!);
            })
        })
    }
    //如果没有数据加载改方法
    func arrNilAddView(){
        let PromptView=UIView(frame:CGRect(x: 0,y: 0,width: boundsWidth,height: 91.5));
        PromptView.center=self.view.center
        let promptImgView=UIImageView(frame:CGRect(x: (PromptView.frame.width-61.5)/2,y: 0, width: 61.5,height: 65.5))
        promptImgView.image=UIImage(named:"nildd")
        PromptView.addSubview(promptImgView)
        let lblPrompt=UILabel(frame:CGRect(x: 0,y: 61.5+10,width: PromptView.frame.width,height: 20));
        
        lblPrompt.textAlignment=NSTextAlignment.center;
        lblPrompt.text="没有该信息记录";
        lblPrompt.font=UIFont.boldSystemFont(ofSize: 16);
        lblPrompt.textColor=UIColor.textColor();
        PromptView.addSubview(lblPrompt);
        self.view.addSubview(PromptView)
    }
    
    
    
}
