//
//  SweepersViewController.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/6/30.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import Alamofire
/// 扫街页面
class SweepersViewController:UIViewController,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    /// 业务员Id
    var userId:String?
    /// 经度
    @IBOutlet weak private var lblLong: UILabel!
    /// 纬度
    @IBOutlet weak private var lblLat: UILabel!
    /// 地址
    @IBOutlet weak private var txtAddress: UITextField!
    /// 拍照
    @IBOutlet weak private var imgAdd: UIImageView!
    /// 提交
    @IBOutlet weak private var btnSubmit: UIButton!
    /// 店铺名称
    @IBOutlet weak private var txtStoreName: UITextField!
    /// 手机号码
    @IBOutlet weak private var txtTel: UITextField!
    /// 姓名
    @IBOutlet weak private var txtName: UITextField!
    //定位信息
    private var locService: BMKLocationService!
    //搜索结果
    private var geoCode:BMKGeoCodeSearch!;
    //用经纬度反编译成地址信息。。
    private var option:BMKReverseGeoCodeOption!;
    /// 保存图片路径
    private var imgPath:String?
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated);
        locService.delegate=self;
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="扫街"
        self.view.backgroundColor=UIColor.whiteColor()
        btnSubmit.backgroundColor=UIColor.applicationMainColor()
        btnSubmit.layer.cornerRadius=20
        /// 添加刷新定位按钮
        let refreshLocationItem=UIBarButtonItem(title:"刷新定位", style: UIBarButtonItemStyle.Plain, target:self, action:"refreshLocation")
        self.navigationItem.rightBarButtonItem=refreshLocationItem
        
        /// 默认给tag(1表示图片没有上传)
        imgAdd.tag=1
        imgAdd.userInteractionEnabled=true
        imgAdd.addGestureRecognizer(UITapGestureRecognizer(target:self, action:"openPhoto"))
        
        //初始化BMKLocationService
        locService = BMKLocationService()
        locService.desiredAccuracy=kCLLocationAccuracyBest
        //指定最小距离更新(米)，默认：kCLDistanceFilterNone
        locService.distanceFilter=kCLHeadingFilterNone
        //启动LocationService
        locService.startUserLocationService()
        
    }
    /**
     提交
     
     - parameter sender: UIButton
     */
    @IBAction func submit(sender: UIButton) {
        SVProgressHUD.showWithStatus("正在请求",maskType: SVProgressHUDMaskType.Gradient)
        let long=lblLong.text
        let lat=lblLat.text
        let address=txtAddress.text
        let storeName=txtStoreName.text
        let tel=txtTel.text
        let name=txtName.text
        if isStringNil(long) == false || isStringNil(lat) == false || isStringNil(address) == false{
            SVProgressHUD.showInfoWithStatus("定位信息不全请重新定位")
        }else if isStringNil(imgPath) == false{
            SVProgressHUD.showInfoWithStatus("图片为空")
        }else if isStringNil(storeName) == false{
            SVProgressHUD.showInfoWithStatus("店铺名称为空")
        }else if isStringNil(tel) == false{
            SVProgressHUD.showInfoWithStatus("电话为空")
        }else if isStringNil(name) == false{
            SVProgressHUD.showInfoWithStatus("姓名为空")
        }else{
            request(.POST,URL+"nmoreGlobalPosiUploadStore.xhtml", parameters:["map_coordinate":long!+","+lat!,"storeName":storeName!,"tel":tel!,"address":address!,"ownerName":name!,"savePath":imgPath!,"referralName":userId!,"password":"123456",]).responseJSON{ response in
                if response.result.error != nil{
                    SVProgressHUD.showErrorWithStatus(response.result.error!.localizedDescription)
                }
                if response.result.value != nil{
                    SVProgressHUD.dismiss()
                    let json=JSON(response.result.value!)
                    let success=json["success"].stringValue
                    if success == "success"{
                        SVProgressHUD.showSuccessWithStatus("店铺注册已完成")
                        self.refreshLocation()
                    }else if success == "isrob"{
                        SVProgressHUD.showErrorWithStatus("该账号已注册")
                    }else{
                        SVProgressHUD.showErrorWithStatus("店铺注册失败")
                    }
                }
            }
        }
    }
    /**
     刷新定位
     */
    func refreshLocation(){
        lblLong.text=nil
        lblLat.text=nil
        txtAddress.text=nil
        imgAdd.image=UIImage(named:"addImg")
        txtName.text=nil
        txtStoreName.text=nil
        txtTel.text=nil
        //启动LocationService
        locService.startUserLocationService()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        locService.delegate=nil
    }
}
// MARK: - 定位
extension SweepersViewController{
    //定位失败会调用此方法
    func didFailToLocateUserWithError(error:NSError!){
        log.error("百度地图定位失败")
        SVProgressHUD.showWithStatus("定位失败请刷新定位")
    }
    //实现相关delegate 处理位置信息更新
    //处理方向变更信息
    func didUpdateUserHeading(userLocation: BMKUserLocation!) {//预留在这
        //println(userLocation)
    }
    //处理位置坐标更新
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
        if userLocation.location != nil{//判断地址信息是否获取到  获取到后立即停止定位
            //初始化
            geoCode=BMKGeoCodeSearch();
            geoCode.delegate=self;
            option=BMKReverseGeoCodeOption();
            //把经纬传进来
            option.reverseGeoPoint=userLocation.location.coordinate;
            lblLat.text="\(userLocation.location.coordinate.latitude)"
            lblLong.text="\(userLocation.location.coordinate.longitude)"
            //异步函数，返回结果在BMKGeoCodeSearchDelegate的onGetReverseGeoCodeResult通知
            geoCode.reverseGeoCode(option);
            //立即停止定位
            locService.stopUserLocationService();
        }
    }
    //接收地址信息结果
    func onGetReverseGeoCodeResult(search:BMKGeoCodeSearch!,result:BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode){
        if error.rawValue == BMK_SEARCH_NO_ERROR.rawValue{//检索结果正常返回
            //拿到省市区信息
            txtAddress.text="\(result.addressDetail.province+result.addressDetail.city+result.addressDetail.district+result.addressDetail.streetName)"
            
        }
    }

}
// MARK: - 拍照上传
extension SweepersViewController{
    /**
     打开拍照功能
     */
    func openPhoto(){
        //图片选择控制器
        let imagePickerController=UIImagePickerController()
        imagePickerController.delegate=self
        // 设置是否可以管理已经存在的图片
        imagePickerController.allowsEditing = true
        // 判断是否支持相机
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            let alert:UIAlertController=UIAlertController(title:"上传图片", message:"您可以自己拍照或者从相册中选择", preferredStyle: UIAlertControllerStyle.ActionSheet)
            let photograph=UIAlertAction(title:"拍照", style: UIAlertActionStyle.Default, handler:{
                Void in
                // 设置类型
                imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
                self.presentViewController(imagePickerController, animated: true, completion: nil)
                
                
            })
            let photoAlbum=UIAlertAction(title:"从相册选择", style: UIAlertActionStyle.Default, handler:{
                Void in
                // 设置类型
                imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                //改navigationBar背景色
                imagePickerController.navigationBar.barTintColor = UIColor.applicationMainColor()
                //改navigationBar标题色
                imagePickerController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
                //改navigationBar的button字体色
                imagePickerController.navigationBar.tintColor = UIColor.whiteColor()
                self.presentViewController(imagePickerController, animated: true, completion: nil)
            })
            let cancel=UIAlertAction(title:"取消", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(photograph)
            alert.addAction(photoAlbum)
            alert.addAction(cancel)
            self.presentViewController(alert, animated:true, completion:nil)
            
        }
        
    }
    //保存图片至沙盒
    func saveImage(currentImage: UIImage, newSize: CGSize, percent: CGFloat, imageName: String){
        //压缩图片尺寸
        UIGraphicsBeginImageContext(newSize)
        currentImage.drawInRect(CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //高保真压缩图片质量
        //UIImageJPEGRepresentation此方法可将图片压缩，但是图片质量基本不变，第二个参数即图片质量参数。
        let imageData: NSData = UIImageJPEGRepresentation(newImage, percent)!
        // 获取沙盒目录,这里将图片放在沙盒的documents文件夹中
        let home=NSHomeDirectory() as NSString
        let docPath=home.stringByAppendingPathComponent("Documents") as NSString
        /// 3、获取文本文件路径
        let filePath = docPath.stringByAppendingPathComponent(imageName)
        // 将图片写入文件
        imageData.writeToFile(filePath, atomically: false)
    }
    //实现ImagePicker delegate 事件
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        var image: UIImage!
        // 判断，图片是否允许修改
        if(picker.allowsEditing){
            //裁剪后图片
            image = info[UIImagePickerControllerEditedImage] as! UIImage
        }else{
            //原始图片
            image = info[UIImagePickerControllerOriginalImage] as! UIImage
        }
        // 保存图片至本地，方法见下文
        self.saveImage(image, newSize: CGSize(width: 256, height: 256), percent:1, imageName: "currentImage.png")
        // 获取沙盒目录,这里将图片放在沙盒的documents文件夹中
        let home=NSHomeDirectory() as NSString
        let docPath=home.stringByAppendingPathComponent("Documents") as NSString
        /// 3、获取文本文件路径
        let filePath = docPath.stringByAppendingPathComponent("currentImage.png")
        upload(
            .POST,
            URL+"commUploadImageServlet.do",
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(fileURL:NSURL(fileURLWithPath:filePath), name: "filePath")
                
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON{ response in
                        if response.result.error != nil{
                            SVProgressHUD.showErrorWithStatus("图片上传失败")
                        }
                        if response.result.value != nil{
                            SVProgressHUD.showSuccessWithStatus("图片上传成功")
                            let imgUrl=JSON(response.result.value!)["path"].stringValue
                            self.imgPath=imgUrl
                            self.imgAdd.sd_setImageWithURL(NSURL(string:URLIMG+imgUrl), placeholderImage:UIImage(named: "addImg"))
                        }
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
            }
        )
        
    }
}