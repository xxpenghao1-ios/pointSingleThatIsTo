//
//  BaseViewController.swift
//  pointSingleThatIsTo
//
//  Created by 卢洋 on 16/3/14.
//  Copyright © 2016年 penghao. All rights reserved.
//

import UIKit
import SVProgressHUD
/// 基本UIViewController视图
class BaseViewController: UIViewController {
//    private weak var _loadView:V2LoadingView?
//    
//     /**
//     显示小型加载菊花图 显示在当前传入的UIView中）
//     
//     - parameter view: 需要显示的UIView
//     */
//    func showLoadingView(view:UIView){
//        self.hideLoadingView()
//        let aloadView = V2LoadingView()
//        aloadView.backgroundColor = self.view.backgroundColor
//        view.addSubview(aloadView)
//        aloadView.snp_makeConstraints{ (make) -> Void in
//            make.top.right.bottom.left.equalTo(view)
//        }
//        self._loadView = aloadView
//    }
//    /**
//    默认显示在当前类视图控制器中间
//    */
//    func showLoadingView(){
//        showLoadingView(self.view)
//    }
//    /**
//    移除小型加载菊花视图
//    */
//    func hideLoadingView() {
//        self._loadView?.removeFromSuperview()
//    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if SVProgressHUD.isVisible(){
            SVProgressHUD.dismiss()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
