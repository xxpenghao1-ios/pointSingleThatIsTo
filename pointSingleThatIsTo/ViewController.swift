//
//  ViewController.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/1/14.
//  Copyright © 2016年 penghao. All rights reserved.
import Foundation
import UIKit
import EAIntroView

/// 引导页
class ViewController: UIViewController,EAIntroDelegate{
    var page1:EAIntroPage!
    var page2:EAIntroPage!
    var page3:EAIntroPage!
    var intro:EAIntroView!
    //登录成功跳转到首页
    var app=UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.white
        //隐藏导航栏
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        // Do any additional setup after loading the view, typically from a nib
        creatHelpPage()
    }
    /**
    创建引导页
    */
    func creatHelpPage(){
        page1=EAIntroPage()
        page1.bgImage=UIImage(named: "guide1")
        
        page2=EAIntroPage()
        page2.bgImage=UIImage(named: "guide2")
        
        page3=EAIntroPage()
        page3.bgImage=UIImage(named: "guide3")
        
        intro=EAIntroView(frame: self.view.bounds, andPages: [page1,page2,page3])
        intro.delegate=self
        intro.show(in: self.view, animateDuration: 0.3)
        intro.tapToNext = true
        intro.skipButton.alpha=0
    }

    // -------------pragma mark---------- EAIntroView delegate
    func introDidFinish(_ introView: EAIntroView!) {
        app.window?.rootViewController=app.navLogin
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

