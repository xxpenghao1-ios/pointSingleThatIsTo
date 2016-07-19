//
//  ScratchMusicViewController.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/5/6.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
/// 刮刮乐
class ScratchMusicViewController:BaseViewController{
    /// 可滑动容器
    private var scrollView:UIScrollView?
    /// 刮奖标题img
    private var laTombolaTitleImg:UIImageView?
    /// 刮奖view
    private var laTombolaView:UIView?
    /// 刮奖机会view
    private var laTombolaChanceView:UIView?
    /// 刮奖机会文本
    private var lblLaTombolaChance:UILabel?
    /// 刮一刮白色view
    private var aShaveView:UIView?
    /// 刮一刮灰色view
    private var scratchCardView:HYScratchCardView?
    /// 领奖view
    private var awardView:UIView?
    /// 领奖按钮
    private var btnAward:UIButton?
    /// 活动规则view
    private var activeRuleView:UIView?
    /// 活动规则文本
    private var lblActiveRule:UILabel?
    /// 查看中奖记录
    private var btnTheWinningRecord:UIButton?
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //设置当前页面导航控制器背景色为0透明度
        self.navigationController!.navigationBar.lt_setBackgroundColor(UIColor.applicationMainColor().colorWithAlphaComponent(0))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //隐藏导航栏下边线
        self.navigationController?.navigationBar.shadowImage=UIImage()
        self.view.backgroundColor=UIColor(patternImage:UIImage(named: "scratch_Music")!)
        buildView()
        
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        //重新设置导航栏的背景颜色
        self.navigationController!.navigationBar.lt_setBackgroundColor(UIColor.applicationMainColor())
    }
    
    /**
     构建页面
     */
    func buildView(){
        //刮奖标题img
        laTombolaTitleImg=UIImageView(frame:CGRectMake((boundsWidth-548/2)/2+20,23,548/2,50.5))
        laTombolaTitleImg!.image=UIImage(named: "la_tombola_title")
        self.view.addSubview(laTombolaTitleImg!)
        scrollView=UIScrollView(frame:CGRectMake(0,73.5,boundsWidth,boundsHeight-73.5))
        self.view.addSubview(scrollView!)
        //刮奖view
        laTombolaView=UIView(frame:CGRectMake(27,19,boundsWidth-54,172))
        laTombolaView!.backgroundColor=UIColor(patternImage:UIImage(named: "la_tombola_background")!)
        self.scrollView!.addSubview(laTombolaView!)
        //刮奖机会view
        laTombolaChanceView=UIView(frame:CGRectMake(25,laTombolaView!.frame.origin.y+10,148,38))
        laTombolaChanceView!.backgroundColor=UIColor(patternImage:UIImage(named: "la_tombola_chance")!)
        self.scrollView!.addSubview(laTombolaChanceView!)
        //刮奖机会文本
        lblLaTombolaChance=UILabel(frame:CGRectMake(5,11,laTombolaChanceView!.frame.width-10,20))
        lblLaTombolaChance!.textColor=UIColor.whiteColor()
        lblLaTombolaChance!.font=UIFont.systemFontOfSize(13)
        lblLaTombolaChance!.text="您还有100次机会"
        laTombolaChanceView!.addSubview(lblLaTombolaChance!)
        //刮一刮view
        aShaveView=UIView(frame:CGRectMake(30,(laTombolaView!.frame.height-67)/2,laTombolaView!.frame.width-60,67))
        aShaveView!.backgroundColor=UIColor.whiteColor()
        aShaveView!.layer.cornerRadius=5
        laTombolaView!.addSubview(aShaveView!)
        //刮奖灰色图层
        scratchCardView=HYScratchCardView(frame:CGRectMake(3,3,aShaveView!.frame.width-6,aShaveView!.frame.height-6))
        scratchCardView!.image=UIImage(named:"la_tombola_gw")
        scratchCardView!.surfaceImage=UIImage(named: "la_tombola_g")
        aShaveView!.addSubview(scratchCardView!)
        //领奖view
        awardView=UIView(frame:CGRectMake((boundsWidth-79)/2,CGRectGetMaxY(laTombolaView!.frame)-8,79,34))
        awardView!.backgroundColor=UIColor(red:1, green:102/255, blue:51/255, alpha: 1)
        awardView!.layer.cornerRadius=5
        //领奖按钮
        btnAward=UIButton(frame:CGRectMake(3,2,awardView!.frame.width-6,awardView!.frame.height-4))
        btnAward!.backgroundColor=UIColor.whiteColor()
        btnAward!.layer.cornerRadius=3
        btnAward!.setTitle("领奖", forState: UIControlState.Normal)
        btnAward!.setTitleColor(UIColor(red:1, green:102/255, blue:51/255, alpha: 1), forState: UIControlState.Normal)
        btnAward!.titleLabel!.font=UIFont.systemFontOfSize(14)
        awardView!.addSubview(btnAward!)
        //活动规则
        activeRuleView=UIView(frame:CGRectMake(laTombolaView!.frame.origin.x,CGRectGetMaxY(laTombolaView!.frame)+15,laTombolaView!.frame.width,200))
        activeRuleView!.backgroundColor=UIColor(red:0, green:0, blue:0, alpha:0.16)
        activeRuleView!.layer.cornerRadius=5
        self.scrollView!.addSubview(activeRuleView!)
        self.scrollView!.addSubview(awardView!)
        
        //活动规则标题图片
        let titleImg=UIImageView(frame:CGRectMake(0,15,14,30.5))
        titleImg.image=UIImage(named: "la_tombola_gz")
        activeRuleView!.addSubview(titleImg)
        //标题文字
        let titleName=UILabel(frame:CGRectMake(CGRectGetMaxX(titleImg.frame)+5,15,100,30.5))
        titleName.text="活动规则"
        titleName.textColor=UIColor.whiteColor()
        titleName.font=UIFont.boldSystemFontOfSize(16)
        activeRuleView!.addSubview(titleName)
        
        //分割线
        let cuttingLineImg=UIImageView(frame:CGRectMake(0,CGRectGetMaxY(titleImg.frame)+10,activeRuleView!.frame.width,2.5))
        cuttingLineImg.image=UIImage(named: "la_tombola_fgx")
        activeRuleView!.addSubview(cuttingLineImg)
        
        //活动规则文本
        lblActiveRule=UILabel()
        lblActiveRule!.textColor=UIColor.whiteColor()
        lblActiveRule!.lineBreakMode=NSLineBreakMode.ByWordWrapping
        lblActiveRule!.numberOfLines=0
        lblActiveRule!.font=UIFont.systemFontOfSize(14)
        lblActiveRule!.text="1、活动期间，单个手机支付用户在点单即到平台可获得参加一次刮奖机会 。活动期间 ，单个手机支付用户在点单即到平台可获得一次刮奖\n\n2、刮到奖品将在活动结束后30个工作日内可领取 ，请在规定时间内领取，刮到奖品将在活动结束后30个工作日内可领取，请在规定时间\n\n3、用户如退货 、拒收，该笔订单将无法获得刮刮乐奖品，用户如退货、拒收，该笔订单将无法获得刮刮乐奖品。"
        activeRuleView!.addSubview(lblActiveRule!)
        let size=lblActiveRule!.text!.textSizeWithFont(lblActiveRule!.font, constrainedToSize:CGSizeMake(activeRuleView!.frame.width-28,500))
        lblActiveRule!.frame=CGRectMake(14,CGRectGetMaxY(cuttingLineImg.frame)+10,activeRuleView!.frame.width-28,size.height)
        activeRuleView!.frame=CGRectMake(laTombolaView!.frame.origin.x,CGRectGetMaxY(laTombolaView!.frame)+15,laTombolaView!.frame.width,CGRectGetMaxY(lblActiveRule!.frame)+20)
        //查看中奖记录
        btnTheWinningRecord=UIButton(frame:CGRectMake((boundsWidth-180)/2,CGRectGetMaxY(activeRuleView!.frame)+20,180,47))
        btnTheWinningRecord!.setTitle("查看中奖记录", forState: UIControlState.Normal)
        btnTheWinningRecord!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btnTheWinningRecord!.titleLabel!.font=UIFont.systemFontOfSize(16)
        btnTheWinningRecord!.layer.cornerRadius=5
        btnTheWinningRecord!.backgroundColor=UIColor(red:255/255, green:102/255, blue:0, alpha: 1)
        btnTheWinningRecord!.layer.borderWidth=1
        btnTheWinningRecord!.layer.borderColor=UIColor.whiteColor().CGColor
        self.scrollView!.addSubview(btnTheWinningRecord!)
        
        self.scrollView!.contentSize=CGSizeMake(boundsWidth,CGRectGetMaxY(btnTheWinningRecord!.frame)+30)
    }
}