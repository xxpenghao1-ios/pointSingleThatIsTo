////
////  SweepOutViewController.swift
////  kxkg
////
////  Created by hefeiyue on 15/4/14.
////  Copyright (c) 2015年 奈文魔尔. All rights reserved.
////
//
//import Foundation
//import UIKit
//import AVFoundation
//import SVProgressHUD
////定义一个协议
//protocol StoreFlagCodeControllerDelegate : NSObjectProtocol {
//    //该方法用于传参
//    func storeFlagCode(_ code:String);
//}
///**扫一扫*/
//class SweepOutViewController:UIViewController,AVCaptureMetadataOutputObjectsDelegate {
//    var delegate:StoreFlagCodeControllerDelegate?;
//    let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
//    let session = AVCaptureSession()
//    var layer: AVCaptureVideoPreviewLayer?
//    var width=UIScreen.main.bounds.width;
//    var height=UIScreen.main.bounds.height-64;
//    var memberId:String?;
//    var qrCodeline:UIView?;
//    var timer:Timer?;
//    var leftView:UIView?;
//    var topView:UIView?;
//    var shakeMemberInfoId:Int?;
//    var stringValue:String?
//    var input:AVCaptureInput?
//    
//    
//    //视图即将出现的时候
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        let type=AVMediaType.video
//        let authStatus=AVCaptureDevice.authorizationStatus(for: type)
//        if authStatus == AVAuthorizationStatus.restricted ||  authStatus == AVAuthorizationStatus.denied{
//            EZAlertController.alert("点单即到", message: "请在设置-点单即到-打开照相机", acceptMessage: "确定") { () -> () in
//                self.navigationController?.popViewController(animated: true)
//            }
//        }else{
//            self.setupCamera()
//        }
//    }
//    //页面加载
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.title = "二维码扫描"
//        self.view.backgroundColor=UIColor(red:0, green:0, blue:0, alpha:0.5);
//        initview()
//    //        AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: {(granted:Bool) in
////            if (granted) {
////                self.setupCamera()
////            }else{
////                NSLog("=====用户不允许使用相机=====")
////                EZAlertController.alert("点单即到", message: "请在设置-点单即到-打开照相机", acceptMessage: "确定") { () -> () in
////                    self.navigationController?.popViewControllerAnimated(true)
////                }
////            }
////        })
//    }
//    //UI布局
//    func initview(){
//        memberId=userDefaults.object(forKey: "storeId") as? String
//        //self.view.backgroundColor = UIColor(red:0, green:0, blue:0, alpha:0.5);
//        //上部分view
//        topView=UIView(frame:CGRect(x: 0,y: navHeight,width: width,height: (height-250)/2-30));
//        topView!.backgroundColor=UIColor(red:0, green:0, blue:0, alpha:0.5);
//        self.view.addSubview(topView!);
//        let imageView = UIImageView(frame:CGRect(x: (width-250)/2,y: topView!.frame.height+topView!.frame.origin.y,width: 250,height: 250))
//        imageView.image = UIImage(named:"pick_bg")
//        self.view.addSubview(imageView)
//        //下部分view
//        let buttomView=UIView(frame:CGRect(x: 0,y: imageView.frame.height+imageView.frame.origin.y,width: width,height: (height-250)/2+30));
//        buttomView.backgroundColor=UIColor(red:0, green:0, blue:0, alpha:0.5);
//        self.view.addSubview(buttomView);
//        //提示文字
//        let labIntroudction = UILabel(frame:CGRect(x: (width-250)/2,y: 10,width: 250,height: 70))
//        labIntroudction.backgroundColor = UIColor.clear
//        labIntroudction.numberOfLines = 3
//        labIntroudction.textColor = UIColor.white
//        labIntroudction.text = "将二维码图像置于矩形方框内，离手机摄像头10CM左右，系统会自动识别。"
//        buttomView.addSubview(labIntroudction);
//        
//        //左边view
//        leftView=UIView(frame:CGRect(x: 0,y: topView!.frame.height+topView!.frame.origin.y, width: (width-250)/2,height: 250))
//        leftView!.backgroundColor=UIColor(red:0, green:0, blue:0, alpha:0.5);
//        self.view.addSubview(leftView!);
//        //画中间的基准线
//        qrCodeline=UIView(frame:CGRect(x: leftView!.frame.width+leftView!.frame.origin.x+10,y: topView!.frame.height+topView!.frame.origin.y+10,width: 230,height: 2));
//        qrCodeline!.backgroundColor=UIColor.green;
//        self.view.addSubview(qrCodeline!);
//        if timer == nil {
//            timer=Timer.scheduledTimer(timeInterval: 1, target: self, #selector: "updateTimer:", userInfo: nil, repeats: true);
//        }else{
//            self.timer!.invalidate();
//            self.timer = nil;
//            
//        }
//        
//        //右边区域
//        let rightView=UIView(frame:CGRect(x: (width-250)/2+250,y: topView!.frame.height+topView!.frame.origin.y,width: (width-250)/2,height: 250))
//        rightView.backgroundColor=UIColor(red:0, green:0, blue:0, alpha:0.5);
//        self.view.addSubview(rightView)
//    }
//    
//    func updateTimer(_ sender:Timer){
//        let qrCodelineY=qrCodeline!.frame.origin.y;
//        if (topView!.frame.height+topView!.frame.origin.y+10+230) == qrCodelineY{
//            UIView.beginAnimations("asa", context: nil);
//            UIView.setAnimationDuration(1);
//            qrCodeline!.frame=CGRect(x: leftView!.frame.width+leftView!.frame.origin.x+10,y: topView!.frame.height+topView!.frame.origin.y+10,width: 230,height: 1);
//            UIView.commitAnimations();
//        }
//        else if qrCodeline!.frame.origin.y == qrCodelineY{
//            UIView.beginAnimations("asa", context: nil);
//            UIView.setAnimationDuration(1);
//            qrCodeline!.frame=CGRect(x: leftView!.frame.width+leftView!.frame.origin.x+10,y: topView!.frame.height+topView!.frame.origin.y+10+230,width: 230,height: 1);
//            UIView.commitAnimations();
//        }
//    }
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//        
//    }
//    //推出页面
//    override func viewWillDisappear(_ animated: Bool) {
//        self.timer?.invalidate();
//        self.timer = nil;
//        // 不用时，置nil
//    }
//    
//    
//    func setupCamera(){
//        self.session.sessionPreset = AVCaptureSessionPresetHigh
//        
//        input=try!AVCaptureDeviceInput(device: device)
//        
//        //let input = AVCaptureDeviceInput(device: device, error: &error)
//        if session.canAddInput(input) {
//            session.addInput(input)
//        }
//        layer = AVCaptureVideoPreviewLayer(session: session)
//        layer!.videoGravity = AVLayerVideoGravityResizeAspectFill
//        layer!.frame = CGRect(x: 0,y: 0,width: width,height: UIScreen.main.bounds.height);
//        self.view.layer.insertSublayer(self.layer!, at: 0)
//        let output = AVCaptureMetadataOutput()
//        let rect=CGRect(x: (width-250)/2,y: topView!.frame.height+topView!.frame.origin.y,width: 250,height: 250);
//        output.rectOfInterest=CGRect(x: rect.origin.y/height,y: rect.origin.x/width,width: rect.height/height,height: rect.width/width);
//        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//        if session.canAddOutput(output) {
//            session.addOutput(output)
//            output.metadataObjectTypes = [AVMetadataObjectTypeQRCode];
//        }
//        
//        session.startRunning()
//    }
//    //扫描到二维码响应数据
//    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!){
//        self.timer?.invalidate();
//        self.timer = nil;
//        
//        if metadataObjects.count > 0 {
//            let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
//            stringValue = metadataObject.stringValue
//        }
//        self.session.stopRunning()
//        var categoryNmore:Array<String>=stringValue!.components(separatedBy: "-") as Array<String>!;
//        if categoryNmore[0] != "nmore"{
//            let alertController = UIAlertController(title: "点单即到",
//                message: "亲,不支持非本公司二维码", preferredStyle: UIAlertControllerStyle.alert)
//            let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default,
//                handler: {
//                    action in
//                    self.popToView();
//            })
//            alertController.addAction(okAction)
//            self.present(alertController, animated: true, completion: nil)
//            
//            
//        }else{
//            if shakeMemberInfoId == nil{//如果为空表示扫的是推荐人
//                if stringValue == nil{
//                    SVProgressHUD.showErrorWithStatus("扫描失败")
//                    self.popToView();
//                    
//                }else{
//                    var category:Array<String>=stringValue!.components(separatedBy: "-") as Array<String>!;
//                    let alertController = UIAlertController(title: "点单即到",
//                        message: "您扫到的账号是:\(stringValue!)", preferredStyle: UIAlertControllerStyle.alert)
//                    let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default,
//                        handler: {
//                            action in
//                            SVProgressHUD.showErrorWithStatus("扫的是推荐人!")
//                            self.delegate?.storeFlagCode(category[1]);
//                            self.popToView();
//                            
//                    })
//                    alertController.addAction(okAction)
//                    self.present(alertController, animated: true, completion: nil)
//                    
//                    
//                }
//                
//            }else{
//                if stringValue == nil{
//                    SVProgressHUD.showErrorWithStatus("扫描失败")
//                    self.popToView();
//                }else{
//                    EZAlertController.alert("点单即到", message: "您扫到的账号是:\(stringValue!)", acceptMessage: "确定") { () -> () in
//                        //请求绑定二维码
//                        self.httpbinding()
//                    }
//                    
//                }
//            }
//            
//        }
//        
//        
//    }
//    //请求绑定二维码
//    func httpbinding(){
//        PHMoyaHttp.sharedInstance.requestDataWithTargetJSON(RequestAPI.bindingRecommended4Store(recommended: stringValue!, beRecommendedId: self.memberId!), successClosure: { (result) -> Void in
//            //转换成josn
//            let jsonObject=JSON(result);
//            let flag=jsonObject["success"].stringValue;
//            if flag == "success"{
//                SVProgressHUD.showErrorWithStatus("绑定推荐人成功!")
//            }else if flag == "error"{
//                SVProgressHUD.showErrorWithStatus("您已经有推荐人了!")
//            }else if flag == "isexist"{
//                SVProgressHUD.showErrorWithStatus("自己不能推荐自己!")
//            }else{
//                SVProgressHUD.showErrorWithStatus("绑定推荐人失败!")
//            }
//            self.popToView();
//            }) { (errorMsg) -> Void in
//                SVProgressHUD.showErrorWithStatus(errorMsg)
//        }
//        
//    }
//    //返回个人中心
//    func popToView(){
//        self.navigationController?.popViewController(animated: true);
//    }
//    //返回兑奖中心
//    func drawingPopToView(){
//        //        for(var temp) in self.navigationController!.viewControllers{
//        //            var view:UIViewController=temp as UIViewController
//        //            if view.isKindOfClass(DrawingRecordViewController){
//        //                self.navigationController?.popToViewController(view, animated:true);
//        //            }
//        //        }
//    }
//}

