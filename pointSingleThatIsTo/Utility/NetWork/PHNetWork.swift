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
typealias SuccessClosure = (result: AnyObject) -> Void
/// 失败
typealias FailClosure = (errorMsg: String?) -> Void

/// 网络请求
public class PHMoyaHttp {
    /// 共享实例
    static let sharedInstance = PHMoyaHttp()
    private init(){}
    let requestProvider = MoyaProvider<RequestAPI>()
    /**
     根据target请求JSON数据
     
     - parameter target:         RequestAPI(先定义好,发送什么请求用什么case)
     - parameter successClosure: 成功结果
     - parameter failClosure:    失败结果
     */
    func requestDataWithTargetJSON(target:RequestAPI,successClosure:SuccessClosure,failClosure: FailClosure) {
        let _=requestProvider.request(target) { (result) -> () in
            switch result{
            case let .Success(response):
               successClosure(result:response.data)
               do {
                let json = try response.mapJSON()
                successClosure(result:json)
               } catch {
                 log.error("网络请求数据解析错误")
               }
            case let .Failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                failClosure(errorMsg:error.description)
            }
        }
    }
    /**
     根据target请求String数据
     
     - parameter target:         RequestAPI(先定义好,发送什么请求用什么case)
     - parameter successClosure: 成功结果
     - parameter failClosure:    失败结果
     */
    func requestDataWithTargetString(target:RequestAPI,successClosure:SuccessClosure,failClosure: FailClosure) {
        let _=requestProvider.request(target) { (result) -> () in
            switch result{
            case let .Success(response):
                successClosure(result:response.data)
                do {
                    let str = try response.mapString()
                    successClosure(result:str)
                } catch {
                    log.error("网络请求数据解析错误")
                }
            case let .Failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                failClosure(errorMsg:error.description)
            }
        }
    }
}
public enum RequestAPI {
    case login(memberName:String,password:String,deviceToken:String,deviceName:String,flag:Int)
    case register(memberName:String,password:String,phone_mob:String,referralName:String)
}
extension RequestAPI:TargetType{
    public var baseURL:NSURL{
        return NSURL(string:URL)!
    }
    public var path:String{
        switch self{
        case .login(_,_,_,_,_):
            return "storeLoginInterface.xhtml"
        case .register(_,_,_,_):
            return "doRegest.xhtml"
        }
        
    }
    public var method:Moya.Method{
        switch self{
        case .login(_,_,_,_,_),.register(_,_,_,_):
            return .POST
        }
    }
    public var parameters: [String: AnyObject]? {
        switch self {
        case let .login(memberName,password,deviceToken,deviceName,flag):
            return ["memberName":memberName,"password":password,"deviceToken":deviceToken,"deviceName":deviceName,"flag":flag]
        case let .register(memberName, password, phone_mob,referralName):
            return ["memberName":memberName,"password":password,"phone_mob":phone_mob,"referralName":referralName]
        }
    }
    //  单元测试用
    public var sampleData: NSData {
        return "{}".dataUsingEncoding(NSUTF8StringEncoding)!
    }
}