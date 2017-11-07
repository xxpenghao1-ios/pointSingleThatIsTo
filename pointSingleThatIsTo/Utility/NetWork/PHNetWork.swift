//
//  PHNetWork.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/8/8.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
import Moya
/// 成功
typealias SuccessClosure = (_ result: Any) -> Void
/// 失败
typealias FailClosure = (_ errorMsg: String?) -> Void

/// 网络请求
open class PHMoyaHttp {
    /// 共享实例
    static let sharedInstance = PHMoyaHttp()
    fileprivate init(){}
    let requestProvider = MoyaProvider<RequestAPI>()
    /**
     根据target请求JSON数据
     
     - parameter target:         RequestAPI(先定义好,发送什么请求用什么case)
     - parameter successClosure: 成功结果
     - parameter failClosure:    失败结果
     */
    func requestDataWithTargetJSON(_ target:RequestAPI,successClosure:@escaping SuccessClosure,failClosure: @escaping FailClosure) {
//        let requestClosure = { (endpoint: Endpoint<RequestAPI>, done: (NSURLRequest) -> Void) in
//            //可以在这里修改request
//            let request: NSMutableURLRequest = endpoint.urlRequest.mutableCopy() as NSMutableURLRequest
//            request.httpShouldHandleCookies = false
//            request.timeoutInterval = 20
//
//            done(request)
//        }
//         let _=requestProvider<target>(
        let _=requestProvider.request(target) { (result) -> () in
            switch result{
               
            case let .success(response):
                do {
                    let arr = try response.mapJSON()
                    successClosure(arr)
                } catch {
                    
                }
            case let .failure(error):
                failClosure(error.errorDescription)
            }
        }
    }
    /**
     根据target请求String数据
     
     - parameter target:         RequestAPI(先定义好,发送什么请求用什么case)
     - parameter successClosure: 成功结果
     - parameter failClosure:    失败结果
     */
    func requestDataWithTargetString(_ target:RequestAPI,successClosure:@escaping SuccessClosure,failClosure: @escaping FailClosure) {
        let _=requestProvider.request(target) { (result) -> () in
            switch result{
            case let .success(response):
                do {
                    let str = try response.mapString()
                    successClosure(str as AnyObject)
                } catch {
                    
                }
            case let .failure(error):
                failClosure(error.errorDescription)
            }
        }
    }
    
}
/**
 接口后缀
 
 - XHTML:.xhtml
 - DO:   .do
 */
public enum InterfaceSuffix:String{
    case XHTML = ".xhtml"
    case DO = ".do"
}
public enum RequestAPI {
    case login(memberName:String,password:String,deviceToken:String,deviceName:String,flag:Int)
    case register(memberName:String,password:String,phone_mob:String,referralName:String)
    case returnRandCode(memberName:String,flag:String)
    case updatePassWord(memberName:String,newPassWord:String)
    case doRegest(memberName:String,password:String,phone_mob:String,referralName:String)
    case doMemberTheOnly(memberName:String)
    case queryCategory4AndroidAll(goodsCategoryId:Int)
    case queryCategory4Android(goodsCategoryId:Int)
    case queryBrandList4Android(goodscategoryId:Int,substationId:String)
    //查看我要抢单 2.查询已抢订单
    case queryStoreAllRobOrderForList(robflag:Int,sellerId:String,pageSize:Int,currentPage:Int)
    case queryRobFor1OrderForList(storeFlagCode:String)
    //查询进货订单商品详情
    case queryOrderInfo4AndroidByorderId(orderinfoId:Int)
    //我要抢单请求
    case robOrderByStore4Android(orderId:Int,storeId:String)
    //店铺发货
    case storeConfirmDelivergoods(orderinfoId:Int,postscript:String)
    //加入购物车  flag1特价，2非特价，3促销
    case insertShoppingCar(memberId:String,goodId:Int,supplierId:Int,subSupplierId:Int,goodsCount:Int,flag:Int,goodsStock:Int,storeId:String,promotionNumber:Int?)
    //新品推荐
    case queryGoodsForAndroidIndexForStoreNew(countyId:String,storeId:String,isDisplayFlag:Int,currentPage:Int,pageSize:Int,order:String)
    //查询3级分类
    case queryGoodsInfoByCategoryForAndroidForStore(goodsCategoryId:Int,countyId:String,IPhonePenghao:Int,isDisplayFlag:Int,pageSize:Int,currentPage:Int,storeId:String,order:String,tag:Int)
    //字母查询3级分类
    case letterQueryGoodsInfoByCategoryForAndroidForStore(goodsCategoryId:Int,countyId:String,IPhonePenghao:Int,isDisplayFlag:Int,pageSize:Int,currentPage:Int,storeId:String,order:String,seachLetterValue:String)
    //根据搜索条件查询商品数据
    case searchGoodsInterfaceForStore(searchCondition:String,countyId:String,IPhonePenghao:Int,isDisplayFlag:Int,pageSize:Int,currentPage:Int,storeId:String,order:String,tag:Int,goodsCategoryId:Int?)
    //查询促销商品
    case queryStorePromotionGoodsList(storeId:String,order:String,pageSize:Int,currentPage:Int)
    //发送商品详情请求
    case queryGoodsDetailsForAndroid(goodsbasicinfoId:Int,supplierId:Int,flag:Int?,storeId:String,aaaa:Int,subSupplier:Int,memberId:String,promotionFlag:Int?)
    //查询特价商品集合
    case queryPreferentialAndGoods4Store(countyId:String,categoryId:Int,storeId:String,pageSize:Int,currentPage:Int,order:String)
    //促销图片请求
    case mobileAdvertisingPromotion()
    //促销图片和特价
    case mobileAdvertisingPromotionAndPreferential()
    //发送公告栏请求
    case queryAdMessgInfo(substationId:String)
    //热门商品请求
    case queryGoodsForAndroidIndexForStore(countyId:String,isDisplayFlag:Int,storeId:String)
    //首页大分类查询
    case queryOneCategory(isDisplayFlag:Int)
    //幻灯片请求
    case mobileAdvertising(countyId:String)
    //查询可兑奖商品
    case storeQueryMyNews(storeId:String,pageSize:Int,currentPage:Int,flag:Int)
    //查询我的推荐人
    case queryRecommended(storeId:String)
    //查询消息中心
    case queryMessageToStore(substationId:String,pageSize:Int,currentPage:Int)
    //请求分站信息和推荐人
    case queryStoreMember(storeId:String,memberId:String)
    //退出登录
    case outLoginForStore(memberId:String)
    //根据条形码查询供应商
    case suoYuan(countyId:String,goodInfoCode:String)
    //查询店铺订单状态 3已完成 2已发货 1未发货
    case queryOrderInfo4AndroidStoreByOrderStatus(orderStatus:Int,storeId:String,pageSize:Int,currentPage:Int)
    //取消订单
    case storeCancelOrder(orderId:Int)
    //确认收货
    case updataOrderStatus4Store(orderinfoId:Int)
    //绑定二维码
    case bindingRecommended4Store(recommended:String,beRecommendedId:String)
    //积分兑换
    case integralMallExchange(integralMallId:Int,memberId:String,exchangeCount:Int)
    //查看剩余积分
    case queryMemberIntegral(memberId:String)
    //积分商品请求
    case queryIntegralMallForSubStation(subStationId:String,currentPage:Int,pageSize:Int)
    //积分记录
    case storeQueryMemberIntegralV1(memberId:String,currentPage:Int,pageSize:Int)
    //兑换记录
    case queryIntegralMallExchangeRecord(memberId:String,pageSize:Int,currentPage:Int)
    //业务员登录
    case nmoreGlobalPosiUploadStoreLogin(userAccount:String,userPassword:String)
    //扫街提交店铺信息
    case nmoreGlobalPosiUploadStore(map_coordinate:String,storeName:String,tel:String,address:String,ownerName:String,savePath:String,referralName:String,password:String)
    //查询收货地址信息
    case queryStoreShippAddressforAndroid(storeId:String)
    //删除收货地址
    case deleteStoreShippAddressforAndroid(shippAddressId:Int)
    //修改收货地址
    case updateStoreShippAddressforAndroid(flag:Int,storeId:String,county:String,city:String,province:String,shippName:String,detailAddress:String,phoneNumber:String,IPhonePenghao:Int,shippAddressId:Int)
    //添加收货地址
    case addStoreShippAddressforAndroid(flag:Int,storeId:String,county:String,city:String,province:String,shippName:String,detailAddress:String,phoneNumber:String,IPhonePenghao:Int)
    //下单
    case storeOrderForAndroid(goodsList:String,detailAddress:String,phoneNumber:String,shippName:String,storeId:String,pay_message:String,tag:Int,cashCouponId:Int?)
    //问题反馈
    case complaintsAndSuggestions(complaint:String,storeId:String)
    //查询所有的2,3级分类
    case queryTwoCategoryForMob(goodsCategoryId:Int,substationId:String)
    //加入收藏
    case goodsAddCollection(goodId:Int,supplierId:Int,subSupplierId:Int,memberId:String)
    //查询收藏区
    case queryStoreCollectionList(memebrId:String,pageSize:Int,currentPage:Int)
    //删除收藏商品
    case goodsCancelCollection(memberId:String,goodId:Int)
    //购物车中查询配送商的更多商品（凑单）
    case queryShoppingCarMoreGoodsForSubSupplier(storeId:Int,subSupplierId:Int,pageSize:Int,currentPage:Int,order:String,seachLetterValue:String,tag:Int)
    //签到记录
    case queryStoreSignRecord(storeId:String,pageSize:Int,currentPage:Int)
    //签到
    case storeSign(storeId:String)
    //当日是否签到
    case queryStoreToDaySign(storeId:String)
}
extension RequestAPI:TargetType{
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    public var headers: [String : String]? {
        return nil
    }
    public var baseURL:Foundation.URL{
        return Foundation.URL(string:URL)!
    }
    public var path:String{
        switch self{
        case .login(_,_,_,_,_):
            return "storeLoginInterface"+InterfaceSuffix.XHTML.rawValue
        case .register(_,_,_,_):
            return "doRegest"+InterfaceSuffix.XHTML.rawValue
        case .returnRandCode(_,_):
            return "returnRandCode"+InterfaceSuffix.XHTML.rawValue
        case .updatePassWord(_,_):
            return "updatePassWord"+InterfaceSuffix.XHTML.rawValue
        case .doRegest(_,_,_,_):
            return "doRegest"+InterfaceSuffix.XHTML.rawValue
        case .doMemberTheOnly(_):
            return "doMemberTheOnly"+InterfaceSuffix.XHTML.rawValue
        case .queryCategory4AndroidAll(_):
            return "queryCategory4AndroidAll"+InterfaceSuffix.XHTML.rawValue
        case .queryCategory4Android(_):
            return "queryCategory4Android"+InterfaceSuffix.XHTML.rawValue
        case .queryBrandList4Android(_,_):
            return "queryBrandList4Android"+InterfaceSuffix.XHTML.rawValue
        case .queryStoreAllRobOrderForList(_,_,_,_):
            return "queryStoreAllRobOrderForList"+InterfaceSuffix.XHTML.rawValue
        case .queryRobFor1OrderForList(_):
            return "queryRobFor1OrderForList"+InterfaceSuffix.XHTML.rawValue
        case .queryOrderInfo4AndroidByorderId(_):
            return "queryOrderInfo4AndroidByorderId"+InterfaceSuffix.XHTML.rawValue
        case .robOrderByStore4Android(_,_):
            return "robOrderByStore4Android"+InterfaceSuffix.XHTML.rawValue
        case .storeConfirmDelivergoods(_,_):
            return "storeConfirmDelivergoods"+InterfaceSuffix.XHTML.rawValue
        case .insertShoppingCar(_,_,_,_,_,_,_,_,_):
            return "insertShoppingCar"+InterfaceSuffix.XHTML.rawValue
        case .queryGoodsForAndroidIndexForStoreNew(_,_,_,_,_,_):
            return "queryGoodsForAndroidIndexForStoreNew"+InterfaceSuffix.XHTML.rawValue
        case .queryGoodsInfoByCategoryForAndroidForStore(_,_,_,_,_,_,_,_,_):
            return "queryGoodsInfoByCategoryForAndroidForStore"+InterfaceSuffix.XHTML.rawValue
        case .letterQueryGoodsInfoByCategoryForAndroidForStore(_,_,_,_,_,_,_,_,_):
            return "queryGoodsInfoByCategoryForAndroidForStore"+InterfaceSuffix.XHTML.rawValue
        case .searchGoodsInterfaceForStore(_,_,_,_,_,_,_,_,_,_):
            return "searchGoodsInterfaceForStore"+InterfaceSuffix.XHTML.rawValue
        case .queryStorePromotionGoodsList(_,_,_,_):
            return "queryStorePromotionGoodsList"+InterfaceSuffix.XHTML.rawValue
        case .queryGoodsDetailsForAndroid(_,_,_,_,_,_,_,_):
            return "queryGoodsDetailsForAndroid"+InterfaceSuffix.XHTML.rawValue
        case .queryPreferentialAndGoods4Store(_,_,_,_,_,_):
            return "queryPreferentialAndGoods4Store"+InterfaceSuffix.XHTML.rawValue
        case .mobileAdvertisingPromotion():
            return "mobileAdvertisingPromotion"+InterfaceSuffix.XHTML.rawValue
        case .queryAdMessgInfo(_):
            return "queryAdMessgInfo"+InterfaceSuffix.XHTML.rawValue
        case .queryGoodsForAndroidIndexForStore(_,_,_):
            return "queryGoodsForAndroidIndexForStore"+InterfaceSuffix.XHTML.rawValue
        case .queryOneCategory(_):
            return "queryOneCategory"+InterfaceSuffix.XHTML.rawValue
        case .mobileAdvertising(_):
            return "mobileAdvertising"+InterfaceSuffix.XHTML.rawValue
        case .storeQueryMyNews(_,_,_,_):
            return "storeQueryMyNews"+InterfaceSuffix.XHTML.rawValue
        case .queryRecommended(_):
            return "queryRecommended"+InterfaceSuffix.XHTML.rawValue
        case .queryMessageToStore(_,_,_):
            return "queryMessageToStore"+InterfaceSuffix.XHTML.rawValue
        case .queryStoreMember(_,_):
            return "queryStoreMember"+InterfaceSuffix.XHTML.rawValue
        case .outLoginForStore(_):
            return "outLoginForStore"+InterfaceSuffix.XHTML.rawValue
        case .suoYuan(_,_):
            return "SuoYuan"+InterfaceSuffix.XHTML.rawValue
        case .queryOrderInfo4AndroidStoreByOrderStatus(_,_,_,_):
            return "queryOrderInfo4AndroidStoreByOrderStatus"+InterfaceSuffix.XHTML.rawValue
        case .storeCancelOrder(_):
            return "storeCancelOrder"+InterfaceSuffix.XHTML.rawValue
        case .updataOrderStatus4Store(_):
            return "updataOrderStatus4Store"+InterfaceSuffix.XHTML.rawValue
        case .bindingRecommended4Store(_,_):
            return "bindingRecommended4Store"+InterfaceSuffix.XHTML.rawValue
        case .integralMallExchange(_,_,_):
            return "integralMallExchange"+InterfaceSuffix.XHTML.rawValue
        case .queryMemberIntegral(_):
            return "queryMemberIntegral"+InterfaceSuffix.XHTML.rawValue
        case .queryIntegralMallForSubStation(_,_,_):
            return "queryIntegralMallForSubStation"+InterfaceSuffix.XHTML.rawValue
        case .storeQueryMemberIntegralV1(_,_,_):
            return "storeQueryMemberIntegralV1"+InterfaceSuffix.XHTML.rawValue
        case .queryIntegralMallExchangeRecord(_,_,_):
            return "queryIntegralMallExchangeRecord"+InterfaceSuffix.XHTML.rawValue
        case .nmoreGlobalPosiUploadStoreLogin(_,_):
            return "nmoreGlobalPosiUploadStoreLogin"+InterfaceSuffix.XHTML.rawValue
        case .nmoreGlobalPosiUploadStore(_,_,_,_,_,_,_,_):
            return "nmoreGlobalPosiUploadStore"+InterfaceSuffix.XHTML.rawValue
        case .queryStoreShippAddressforAndroid(_):
            return "queryStoreShippAddressforAndroid"+InterfaceSuffix.XHTML.rawValue
        case .deleteStoreShippAddressforAndroid(_):
            return "deleteStoreShippAddressforAndroid"+InterfaceSuffix.XHTML.rawValue
        case .updateStoreShippAddressforAndroid(_,_,_,_,_,_,_,_,_,_):
            return "updateStoreShippAddressforAndroid"+InterfaceSuffix.XHTML.rawValue
        case .addStoreShippAddressforAndroid(_,_,_,_,_,_,_,_,_):
            return "addStoreShippAddressforAndroid"+InterfaceSuffix.XHTML.rawValue
        case .storeOrderForAndroid(_,_,_,_,_,_,_,_):
            return "storeOrderForAndroid"+InterfaceSuffix.XHTML.rawValue
        case .complaintsAndSuggestions(_,_):
            return "complaintsAndSuggestions"+InterfaceSuffix.XHTML.rawValue
        case .queryTwoCategoryForMob(_,_):
            return "queryTwoCategoryForMob"+InterfaceSuffix.XHTML.rawValue
        case .goodsAddCollection(_,_,_,_):
            return "goodsAddCollection.sc"
        case .queryStoreCollectionList(_,_,_):
            return "queryStoreCollectionList.sc"
        case .goodsCancelCollection(_,_):
            return "goodsCancelCollection.sc"
        case .mobileAdvertisingPromotionAndPreferential():
            return "mobileAdvertisingPromotionAndPreferential"+InterfaceSuffix.XHTML.rawValue
        case .queryShoppingCarMoreGoodsForSubSupplier(_,_,_,_,_,_,_):
            return "queryShoppingCarMoreGoodsForSubSupplier.xhtml"
        case .queryStoreSignRecord(_,_,_):
            return "queryStoreSignRecord"
        case .storeSign(_):
            return "storeSign"
        case .queryStoreToDaySign(_):
            return "queryStoreToDaySign"
        }
        
    }
    public var method:Moya.Method{
        switch self{
        case .login(_,_,_,_,_),.register(_,_,_,_),.doRegest(_,_,_,_),.storeConfirmDelivergoods(_,_),.nmoreGlobalPosiUploadStoreLogin(_,_),.nmoreGlobalPosiUploadStore(_,_,_,_,_,_,_,_),.storeOrderForAndroid(_,_,_,_,_,_,_,_),.complaintsAndSuggestions(_,_),.storeSign(_):
            return .post
        case .returnRandCode(_,_),.updatePassWord(_,_),.doMemberTheOnly(_),.queryCategory4AndroidAll(_),.queryCategory4Android(_),.queryBrandList4Android(_,_),.queryStoreAllRobOrderForList(_,_,_,_),.queryRobFor1OrderForList(_),.queryOrderInfo4AndroidByorderId(_),.robOrderByStore4Android(_,_),.insertShoppingCar(_,_,_,_,_,_,_,_,_),.queryGoodsForAndroidIndexForStoreNew(_,_,_,_,_,_),.queryGoodsInfoByCategoryForAndroidForStore(_,_,_,_,_,_,_,_,_),.searchGoodsInterfaceForStore(_,_,_,_,_,_,_,_,_,_),.queryStorePromotionGoodsList(_,_,_,_),.queryGoodsDetailsForAndroid(_,_,_,_,_,_,_,_),.queryPreferentialAndGoods4Store(_,_,_,_,_,_),.mobileAdvertisingPromotion(),.queryAdMessgInfo(_),.queryGoodsForAndroidIndexForStore(_,_,_),.queryOneCategory(_),.mobileAdvertising(_),.storeQueryMyNews(_,_,_,_),.queryRecommended(_),.queryMessageToStore(_,_,_),.queryStoreMember(_,_),.outLoginForStore(_),.suoYuan(_,_),.queryOrderInfo4AndroidStoreByOrderStatus(_,_,_,_),.storeCancelOrder(_),.updataOrderStatus4Store(_),.bindingRecommended4Store(_,_),.integralMallExchange(_,_,_),.queryMemberIntegral(_),.queryIntegralMallForSubStation(_,_,_),.storeQueryMemberIntegralV1(_,_,_),.queryIntegralMallExchangeRecord(_,_,_),.queryStoreShippAddressforAndroid(_),.deleteStoreShippAddressforAndroid(_),.updateStoreShippAddressforAndroid(_,_,_,_,_,_,_,_,_,_),.addStoreShippAddressforAndroid(_,_,_,_,_,_,_,_,_),.letterQueryGoodsInfoByCategoryForAndroidForStore(_,_,_,_,_,_,_,_,_),.queryTwoCategoryForMob(_,_),.goodsAddCollection(_,_,_,_),.queryStoreCollectionList(_,_,_),.goodsCancelCollection(_,_),.mobileAdvertisingPromotionAndPreferential(),.queryShoppingCarMoreGoodsForSubSupplier(_,_,_,_,_,_,_),.queryStoreSignRecord(_),.queryStoreToDaySign(_):
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        case let .login(memberName,password,deviceToken,deviceName,flag):
            return .requestParameters(parameters: ["memberName":memberName,"password":password,"deviceToken":deviceToken,"deviceName":deviceName,"flag":flag], encoding:URLEncoding.default)
        case let .register(memberName, password, phone_mob,referralName):
            return .requestParameters(parameters: ["memberName":memberName,"password":password,"phone_mob":phone_mob,"referralName":referralName], encoding: URLEncoding.default)
        case let .returnRandCode(memberName,flag):
            return .requestParameters(parameters: ["memberName":memberName,"flag":flag], encoding:  URLEncoding.default)
        case let .updatePassWord(memberName,newPassWord):
            return .requestParameters(parameters: ["memberName":memberName,"newPassWord":newPassWord], encoding:  URLEncoding.default)
        case let .doRegest(memberName, password, phone_mob,referralName):
            return .requestParameters(parameters:["memberName":memberName,"password":password,"phone_mob":phone_mob,"referralName":referralName], encoding:  URLEncoding.default)
        case let .doMemberTheOnly(memberName):
            return .requestParameters(parameters:["memberName":memberName], encoding:  URLEncoding.default)
        case let .queryCategory4AndroidAll(goodsCategoryId):
            return .requestParameters(parameters:["goodsCategoryId":goodsCategoryId], encoding:  URLEncoding.default)
        case let .queryCategory4Android(goodsCategoryId):
            return .requestParameters(parameters:["goodsCategoryId":goodsCategoryId], encoding:  URLEncoding.default)
        case let .queryBrandList4Android(goodscategoryId,substationId):
            return .requestParameters(parameters:["goodscategoryId":goodscategoryId,"substationId":substationId], encoding:  URLEncoding.default)
        case let .queryStoreAllRobOrderForList(robflag, sellerId, pageSize, currentPage):
            return .requestParameters(parameters:["robflag":robflag,"sellerId":sellerId,"pageSize":pageSize,"currentPage":currentPage], encoding:  URLEncoding.default)
        case let .queryRobFor1OrderForList(storeFlagCode):
            return .requestParameters(parameters:["storeFlagCode":storeFlagCode], encoding:  URLEncoding.default)
        case let .queryOrderInfo4AndroidByorderId(orderinfoId):
            return .requestParameters(parameters:["orderinfoId":orderinfoId], encoding:  URLEncoding.default)
        case let .robOrderByStore4Android(orderId,storeId):
            return .requestParameters(parameters:["orderId":orderId,"storeId":storeId], encoding:  URLEncoding.default)
        case let .storeConfirmDelivergoods(orderinfoId, postscript):
            return .requestParameters(parameters:["orderinfoId":orderinfoId,"postscript":postscript], encoding:  URLEncoding.default)
        case let .insertShoppingCar(memberId,goodId,supplierId,subSupplierId,goodsCount,flag, goodsStock,storeId,promotionNumber):
            if promotionNumber != nil{
                return .requestParameters(parameters:["memberId":memberId,"goodId":goodId,"supplierId":supplierId,"subSupplierId":subSupplierId,"goodsCount":goodsCount,"flag":flag,"goodsStock":goodsStock,"storeId":storeId,"promotionNumber":promotionNumber!], encoding:  URLEncoding.default)
            }else{
                return .requestParameters(parameters:["memberId":memberId,"goodId":goodId,"supplierId":supplierId,"subSupplierId":subSupplierId,"goodsCount":goodsCount,"flag":flag,"goodsStock":goodsStock,"storeId":storeId], encoding:  URLEncoding.default)
            }
        case let .queryGoodsForAndroidIndexForStoreNew(countyId, storeId, isDisplayFlag, currentPage, pageSize, order):
            return .requestParameters(parameters:["countyId":countyId,"storeId":storeId,"isDisplayFlag":isDisplayFlag,"currentPage":currentPage,"pageSize":pageSize,"order":order], encoding:  URLEncoding.default)
        case let .queryGoodsInfoByCategoryForAndroidForStore(goodsCategoryId, countyId, IPhonePenghao, isDisplayFlag, pageSize, currentPage, storeId, order,tag):
            return .requestParameters(parameters:["goodsCategoryId":goodsCategoryId,"countyId":countyId,"IPhonePenghao":IPhonePenghao,"isDisplayFlag":isDisplayFlag,"pageSize":pageSize,"currentPage":currentPage,"storeId":storeId,"order":order,"tag":tag], encoding:  URLEncoding.default)
        case let .letterQueryGoodsInfoByCategoryForAndroidForStore(goodsCategoryId, countyId, IPhonePenghao, isDisplayFlag, pageSize, currentPage, storeId, order,seachLetterValue):
            return .requestParameters(parameters:["goodsCategoryId":goodsCategoryId,"countyId":countyId,"IPhonePenghao":IPhonePenghao,"isDisplayFlag":isDisplayFlag,"pageSize":pageSize,"currentPage":currentPage,"storeId":storeId,"order":order,"seachLetterValue":seachLetterValue], encoding:  URLEncoding.default)
        case let .searchGoodsInterfaceForStore(searchCondition, countyId, IPhonePenghao, isDisplayFlag, pageSize, currentPage, storeId, order,tag,goodsCategoryId):
            if goodsCategoryId == nil{
                return .requestParameters(parameters:["searchCondition":searchCondition,"countyId":countyId,"IPhonePenghao":IPhonePenghao,"isDisplayFlag":isDisplayFlag,"pageSize":pageSize,"currentPage":currentPage,"storeId":storeId,"order":order,"tag":tag], encoding:  URLEncoding.default)
            }else{
                return .requestParameters(parameters:["searchCondition":searchCondition,"countyId":countyId,"IPhonePenghao":IPhonePenghao,"isDisplayFlag":isDisplayFlag,"pageSize":pageSize,"currentPage":currentPage,"storeId":storeId,"order":order,"tag":tag,"goodsCategoryId":goodsCategoryId!], encoding:  URLEncoding.default)
            }
        case let .queryStorePromotionGoodsList(storeId, order, pageSize, currentPage):
            return .requestParameters(parameters:["storeId":storeId,"order":order,"pageSize":pageSize,"currentPage":currentPage], encoding:  URLEncoding.default)
        case let .queryGoodsDetailsForAndroid(goodsbasicinfoId, supplierId, flag, storeId, aaaa, subSupplier,memberId,promotionFlag):
            if flag != nil{//查询特价商品详情
                return .requestParameters(parameters:["goodsbasicinfoId":goodsbasicinfoId,"supplierId":supplierId,"flag":flag!,"storeId":storeId,"aaaa":aaaa,"subSupplier":subSupplier,"memberId":memberId], encoding:  URLEncoding.default)
            }else if promotionFlag != nil{
                return .requestParameters(parameters:["goodsbasicinfoId":goodsbasicinfoId,"supplierId":supplierId,"storeId":storeId,"aaaa":aaaa,"subSupplier":subSupplier,"memberId":memberId,"promotionFlag":promotionFlag!], encoding:  URLEncoding.default)
            }else if promotionFlag == nil && flag == nil{
                return .requestParameters(parameters:["goodsbasicinfoId":goodsbasicinfoId,"supplierId":supplierId,"storeId":storeId,"aaaa":aaaa,"subSupplier":subSupplier,"memberId":memberId], encoding:  URLEncoding.default)
            }else{
                return .requestPlain
            }
            
        case let .queryPreferentialAndGoods4Store(countyId, categoryId, storeId, pageSize, currentPage, order):
            return .requestParameters(parameters:["countyId":countyId,"categoryId":categoryId,"storeId":storeId,"pageSize":pageSize,"currentPage":currentPage,"order":order], encoding:  URLEncoding.default)
        case .mobileAdvertisingPromotion():
            return .requestPlain
        case let .queryAdMessgInfo(substationId):
            return .requestParameters(parameters:["substationId":substationId], encoding:  URLEncoding.default)
        case let .queryGoodsForAndroidIndexForStore(countyId, isDisplayFlag, storeId):
            return .requestParameters(parameters:["countyId":countyId,"isDisplayFlag":isDisplayFlag,"storeId":storeId], encoding:  URLEncoding.default)
        case let .queryOneCategory(isDisplayFlag):
            return .requestParameters(parameters:["isDisplayFlag":isDisplayFlag], encoding:  URLEncoding.default)
        case let .mobileAdvertising(countyId):
            return .requestParameters(parameters:["countyId":countyId], encoding:  URLEncoding.default)
        case let .storeQueryMyNews(storeId, pageSize, currentPage, flag):
            return .requestParameters(parameters:["storeId":storeId,"pageSize":pageSize,"currentPage":currentPage,"flag":flag], encoding:  URLEncoding.default)
        case let .queryRecommended(storeId):
            return .requestParameters(parameters:["storeId":storeId], encoding:  URLEncoding.default)
        case let .queryMessageToStore(substationId, pageSize, currentPage):
            return .requestParameters(parameters:["substationId":substationId,"pageSize":pageSize,"currentPage":currentPage], encoding:  URLEncoding.default)
        case let .queryStoreMember(storeId, memberId):
            return .requestParameters(parameters:["storeId":storeId,"memberId":memberId], encoding:  URLEncoding.default)
        case let .outLoginForStore(memberId):
            return .requestParameters(parameters:["memberId":memberId], encoding:  URLEncoding.default)
        case let .suoYuan(countyId, goodInfoCode):
            return .requestParameters(parameters:["countyId":countyId,"goodInfoCode":goodInfoCode], encoding:  URLEncoding.default)
        case let .queryOrderInfo4AndroidStoreByOrderStatus(orderStatus, storeId, pageSize, currentPage):
            return .requestParameters(parameters:["orderStatus":orderStatus,"storeId":storeId,"pageSize":pageSize,"currentPage":currentPage], encoding:  URLEncoding.default)
        case let .storeCancelOrder(orderId):
            return .requestParameters(parameters:["orderId":orderId], encoding:  URLEncoding.default)
        case let .updataOrderStatus4Store(orderinfoId):
            return .requestParameters(parameters:["orderinfoId":orderinfoId], encoding:  URLEncoding.default)
        case let .bindingRecommended4Store(recommended, beRecommendedId):
            return .requestParameters(parameters:["recommended":recommended,"beRecommendedId":beRecommendedId], encoding:  URLEncoding.default)
        case let .integralMallExchange(integralMallId, memberId, exchangeCount):
            return .requestParameters(parameters:["integralMallId":integralMallId,"memberId":memberId,"exchangeCount":exchangeCount], encoding:  URLEncoding.default)
        case let .queryMemberIntegral(memberId):
            return .requestParameters(parameters:["memberId":memberId], encoding:  URLEncoding.default)
        case let .queryIntegralMallForSubStation(subStationId, currentPage, pageSize):
            return .requestParameters(parameters:["subStationId":subStationId,"currentPage":currentPage,"pageSize":pageSize], encoding:  URLEncoding.default)
        case let .storeQueryMemberIntegralV1(memberId, currentPage, pageSize):
            return .requestParameters(parameters:["memberId":memberId,"currentPage":currentPage,"pageSize":pageSize], encoding:  URLEncoding.default)
        case let .queryIntegralMallExchangeRecord(memberId, pageSize, currentPage):
            return .requestParameters(parameters:["memberId":memberId,"pageSize":pageSize,"currentPage":currentPage], encoding:  URLEncoding.default)
        case let .nmoreGlobalPosiUploadStoreLogin(userAccount, userPassword):
            return .requestParameters(parameters:["userAccount":userAccount,"userPassword":userPassword], encoding:  URLEncoding.default)
        case let .nmoreGlobalPosiUploadStore(map_coordinate, storeName, tel, address, ownerName, savePath, referralName, password):
            return .requestParameters(parameters:["map_coordinate":map_coordinate,"storeName":storeName,"tel":tel,"address":address,"ownerName":ownerName,"savePath":savePath,"referralName":referralName,"password":password], encoding:  URLEncoding.default)
        case let .queryStoreShippAddressforAndroid(storeId):
            return .requestParameters(parameters:["storeId":storeId], encoding:  URLEncoding.default)
        case let .deleteStoreShippAddressforAndroid(shippAddressId):
            return .requestParameters(parameters:["shippAddressId":shippAddressId], encoding:  URLEncoding.default)
        case let .updateStoreShippAddressforAndroid(flag, storeId, county, city, province, shippName, detailAddress, phoneNumber, IPhonePenghao, shippAddressId):
            return .requestParameters(parameters:["flag":flag,"storeId":storeId,"county":county,"city":city,"province":province,"shippName":shippName,"detailAddress":detailAddress,"phoneNumber":phoneNumber,"IPhonePenghao":IPhonePenghao,"shippAddressId":shippAddressId], encoding:  URLEncoding.default)
        case let .addStoreShippAddressforAndroid(flag, storeId, county, city, province, shippName, detailAddress, phoneNumber, IPhonePenghao):
            return .requestParameters(parameters:["flag":flag,"storeId":storeId,"county":county,"city":city,"province":province,"shippName":shippName,"detailAddress":detailAddress,"phoneNumber":phoneNumber,"IPhonePenghao":IPhonePenghao], encoding:  URLEncoding.default)
        case let .storeOrderForAndroid(goodsList, detailAddress, phoneNumber, shippName, storeId, pay_message, tag,cashCouponId):
            if cashCouponId == nil{
                return .requestParameters(parameters:["goodsList":goodsList,"detailAddress":detailAddress,"phoneNumber":phoneNumber,"shippName":shippName,"storeId":storeId,"pay_message":pay_message,"tag":tag], encoding:  URLEncoding.default)
            }else{
                return .requestParameters(parameters:["goodsList":goodsList,"detailAddress":detailAddress,"phoneNumber":phoneNumber,"shippName":shippName,"storeId":storeId,"pay_message":pay_message,"tag":tag,"cashCouponId":cashCouponId!], encoding:  URLEncoding.default)
            }
        case let .complaintsAndSuggestions(complaint, storeId):
            return .requestParameters(parameters:["complaint":complaint,"storeId":storeId], encoding:  URLEncoding.default)
        case let .queryTwoCategoryForMob(goodsCategoryId,substationId):
            return .requestParameters(parameters:["goodsCategoryId":goodsCategoryId,"substationId":substationId], encoding:  URLEncoding.default)
        case let .goodsAddCollection(goodId, supplierId, subSupplierId, memberId):
            return .requestParameters(parameters:["goodId":goodId,"supplierId":supplierId,"subSupplierId":subSupplierId,"memberId":memberId], encoding:  URLEncoding.default)
        case let .queryStoreCollectionList(memberId,pageSize,currentPage):
            return .requestParameters(parameters:["memberId":memberId,"pageSize":pageSize,"currentPage":currentPage], encoding:  URLEncoding.default)
        case let .goodsCancelCollection(memberId, goodId):
            return .requestParameters(parameters:["memberId":memberId,"goodId":goodId], encoding:  URLEncoding.default)
        case .mobileAdvertisingPromotionAndPreferential():
            return .requestPlain
        case let .queryShoppingCarMoreGoodsForSubSupplier(storeId, subSupplierId, pageSize, currentPage, order,seachLetterValue,tag):
            if order == "count" || order == "price"{
                return .requestParameters(parameters:["storeId":storeId,"subSupplierId":subSupplierId,"pageSize":pageSize,"currentPage":currentPage,"order":order,"tag":tag], encoding:  URLEncoding.default)
            }else if order == "letter"{
                return .requestParameters(parameters:["storeId":storeId,"subSupplierId":subSupplierId,"pageSize":pageSize,"currentPage":currentPage,"order":order], encoding:  URLEncoding.default)
            }else if order == "seachLetter"{
                return .requestParameters(parameters:["storeId":storeId,"subSupplierId":subSupplierId,"pageSize":pageSize,"currentPage":currentPage,"order":order,"seachLetterValue":seachLetterValue], encoding:  URLEncoding.default)
            }else{
                return .requestPlain
            }
        case let .queryStoreSignRecord(storeId,pageSize,currentPage):
            return .requestParameters(parameters:["storeId":storeId,"pageSize":pageSize,"currentPage":currentPage], encoding:  URLEncoding.default)
        case let .storeSign(storeId):
            return .requestParameters(parameters:["storeId":storeId], encoding:  URLEncoding.default)
        case let .queryStoreToDaySign(storeId):
            return .requestParameters(parameters:["storeId":storeId], encoding:  URLEncoding.default)
            
        }
    }
    //  单元测试用
    public var sampleData: Data{
        return "{}".data(using: String.Encoding.utf8)!
    }
}
