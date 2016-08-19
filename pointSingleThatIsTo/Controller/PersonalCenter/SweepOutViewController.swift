//
//  SweepOutViewController.swift
//  kxkg
//
//  Created by hefeiyue on 15/4/14.
//  Copyright (c) 2015年 奈文魔尔. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import SVProgressHUD
//定义一个协议
protocol StoreFlagCodeControllerDelegate : NSObjectProtocol {
    //该方法用于传参
    func storeFlagCode(code:String);
}
/**扫一扫*/
class SweepOutViewController:UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    var delegate:StoreFlagCodeControllerDelegate?;
    let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    let session = AVCaptureSession()
    var layer: AVCaptureVideoPreviewLayer?
    var width=UIScreen.mainScreen().bounds.width;
    var height=UIScreen.mainScreen().bounds.height-64;
    var memberId:String?;
    var qrCodeline:UIView?;
    var timer:NSTimer?;
    var leftView:UIView?;
    var topView:UIView?;
    var shakeMemberInfoId:Int?;
    var stringValue:String?
    var input:AVCaptureInput?
    
    
    //视图即将出现的时候
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let type=AVMediaTypeVideo
        let authStatus=AVCaptureDevice.authorizationStatusForMediaType(type)
        if authStatus == AVAuthorizationStatus.Restricted ||  authStatus == AVAuthorizationStatus.Denied{
            EZAlertController.alert("点单即到", message: "请在设置-点单即到-打开照相机", acceptMessage: "确定") { () -> () in
                self.navigationController?.popViewControllerAnimated(true)
            }
        }else{
            self.setupCamera()
        }
    }
    //页面加载
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "二维码扫描"
        self.view.backgroundColor=UIColor(red:0, green:0, blue:0, alpha:0.5);
        initview()
    //        AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: {(granted:Bool) in
//            if (granted) {
//                self.setupCamera()
//            }else{
//                NSLog("=====用户不允许使用相机=====")
//                EZAlertController.alert("点单即到", message: "请在设置-点单即到-打开照相机", acceptMessage: "确定") { () -> () in
//                    self.navigationController?.popViewControllerAnimated(true)
//                }
//            }
//        })
    }
    //UI布局
    func initview(){
        memberId=userDefaults.objectForKey("storeId") as? String
        //self.view.backgroundColor = UIColor(red:0, green:0, blue:0, alpha:0.5);
        //上部分view
        topView=UIView(frame:CGRectMake(0,64,width,(height-250)/2-30));
        topView!.backgroundColor=UIColor(red:0, green:0, blue:0, alpha:0.5);
        self.view.addSubview(topView!);
        let imageView = UIImageView(frame:CGRectMake((width-250)/2,topView!.frame.height+topView!.frame.origin.y,250,250))
        imageView.image = UIImage(named:"pick_bg")
        self.view.addSubview(imageView)
        //下部分view
        let buttomView=UIView(frame:CGRectMake(0,imageView.frame.height+imageView.frame.origin.y,width,(height-250)/2+30));
        buttomView.backgroundColor=UIColor(red:0, green:0, blue:0, alpha:0.5);
        self.view.addSubview(buttomView);
        //提示文字
        let labIntroudction = UILabel(frame:CGRectMake((width-250)/2,10,250,70))
        labIntroudction.backgroundColor = UIColor.clearColor()
        labIntroudction.numberOfLines = 3
        labIntroudction.textColor = UIColor.whiteColor()
        labIntroudction.text = "将二维码图像置于矩形方框内，离手机摄像头10CM左右，系统会自动识别。"
        buttomView.addSubview(labIntroudction);
        
        //左边view
        leftView=UIView(frame:CGRectMake(0,topView!.frame.height+topView!.frame.origin.y, (width-250)/2,250))
        leftView!.backgroundColor=UIColor(red:0, green:0, blue:0, alpha:0.5);
        self.view.addSubview(leftView!);
        //画中间的基准线
        qrCodeline=UIView(frame:CGRectMake(leftView!.frame.width+leftView!.frame.origin.x+10,topView!.frame.height+topView!.frame.origin.y+10,230,2));
        qrCodeline!.backgroundColor=UIColor.greenColor();
        self.view.addSubview(qrCodeline!);
        if timer == nil {
            timer=NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTimer:", userInfo: nil, repeats: true);
        }else{
            self.timer!.invalidate();
            self.timer = nil;
            
        }
        
        //右边区域
        let rightView=UIView(frame:CGRectMake((width-250)/2+250,topView!.frame.height+topView!.frame.origin.y,(width-250)/2,250))
        rightView.backgroundColor=UIColor(red:0, green:0, blue:0, alpha:0.5);
        self.view.addSubview(rightView)
    }
    
    func updateTimer(sender:NSTimer){
        let qrCodelineY=qrCodeline!.frame.origin.y;
        if (topView!.frame.height+topView!.frame.origin.y+10+230) == qrCodelineY{
            UIView.beginAnimations("asa", context: nil);
            UIView.setAnimationDuration(1);
            qrCodeline!.frame=CGRectMake(leftView!.frame.width+leftView!.frame.origin.x+10,topView!.frame.height+topView!.frame.origin.y+10,230,1);
            UIView.commitAnimations();
        }
        else if qrCodeline!.frame.origin.y == qrCodelineY{
            UIView.beginAnimations("asa", context: nil);
            UIView.setAnimationDuration(1);
            qrCodeline!.frame=CGRectMake(leftView!.frame.width+leftView!.frame.origin.x+10,topView!.frame.height+topView!.frame.origin.y+10+230,230,1);
            UIView.commitAnimations();
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    //推出页面
    override func viewWillDisappear(animated: Bool) {
        self.timer?.invalidate();
        self.timer = nil;
        // 不用时，置nil
    }
    
    
    func setupCamera(){
        self.session.sessionPreset = AVCaptureSessionPresetHigh
        
        input=try!AVCaptureDeviceInput(device: device)
        
        //let input = AVCaptureDeviceInput(device: device, error: &error)
        if session.canAddInput(input) {
            session.addInput(input)
        }
        layer = AVCaptureVideoPreviewLayer(session: session)
        layer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        layer!.frame = CGRectMake(0,0,width,UIScreen.mainScreen().bounds.height);
        self.view.layer.insertSublayer(self.layer!, atIndex: 0)
        let output = AVCaptureMetadataOutput()
        let rect=CGRectMake((width-250)/2,topView!.frame.height+topView!.frame.origin.y,250,250);
        output.rectOfInterest=CGRectMake(rect.origin.y/height,rect.origin.x/width,rect.height/height,rect.width/width);
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        if session.canAddOutput(output) {
            session.addOutput(output)
            output.metadataObjectTypes = [AVMetadataObjectTypeQRCode];
        }
        
        session.startRunning()
    }
    //扫描到二维码响应数据
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!){
        self.timer?.invalidate();
        self.timer = nil;
        
        if metadataObjects.count > 0 {
            let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            stringValue = metadataObject.stringValue
        }
        self.session.stopRunning()
        var categoryNmore:Array<String>=stringValue!.componentsSeparatedByString("-") as Array<String>!;
        if categoryNmore[0] != "nmore"{
            let alertController = UIAlertController(title: "点单即到",
                message: "亲,不支持非本公司二维码", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default,
                handler: {
                    action in
                    self.popToView();
            })
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            
            
        }else{
            if shakeMemberInfoId == nil{//如果为空表示扫的是推荐人
                if stringValue == nil{
                    SVProgressHUD.showErrorWithStatus("扫描失败")
                    self.popToView();
                    
                }else{
                    var category:Array<String>=stringValue!.componentsSeparatedByString("-") as Array<String>!;
                    let alertController = UIAlertController(title: "点单即到",
                        message: "您扫到的账号是:\(stringValue!)", preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default,
                        handler: {
                            action in
                            SVProgressHUD.showErrorWithStatus("扫的是推荐人!")
                            self.delegate?.storeFlagCode(category[1]);
                            self.popToView();
                            
                    })
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                    
                }
                
            }else{
                if stringValue == nil{
                    SVProgressHUD.showErrorWithStatus("扫描失败")
                    self.popToView();
                }else{
                    EZAlertController.alert("点单即到", message: "您扫到的账号是:\(stringValue!)", acceptMessage: "确定") { () -> () in
                        //请求绑定二维码
                        self.httpbinding()
                    }
                    
                }
            }
            
        }
        
        
    }
    //请求绑定二维码
    func httpbinding(){
        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.bindingRecommended4Store(recommended: stringValue!, beRecommendedId: self.memberId!), successClosure: { (result) -> Void in
            //转换成josn
            let jsonObject=JSON(result);
            let flag=jsonObject["success"].stringValue;
            if flag == "success"{
                SVProgressHUD.showErrorWithStatus("绑定推荐人成功!")
            }else if flag == "error"{
                SVProgressHUD.showErrorWithStatus("您已经有推荐人了!")
            }else if flag == "isexist"{
                SVProgressHUD.showErrorWithStatus("自己不能推荐自己!")
            }else{
                SVProgressHUD.showErrorWithStatus("绑定推荐人失败!")
            }
            self.popToView();
            }) { (errorMsg) -> Void in
                SVProgressHUD.showErrorWithStatus(errorMsg)
        }
        
    }
    //返回个人中心
    func popToView(){
        self.navigationController?.popViewControllerAnimated(true);
    }
    //返回兑奖中心
    func drawingPopToView(){
        //        for(var temp) in self.navigationController!.viewControllers{
        //            var view:UIViewController=temp as UIViewController
        //            if view.isKindOfClass(DrawingRecordViewController){
        //                self.navigationController?.popToViewController(view, animated:true);
        //            }
        //        }
    }
}