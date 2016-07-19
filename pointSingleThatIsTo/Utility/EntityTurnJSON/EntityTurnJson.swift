//
//  EntityTurnJson.swift
//  pointSingleThatIsTo
//
//  Created by penghao on 16/2/27.
//  Copyright © 2016年 penghao. All rights reserved.
//

import Foundation
/**
 根据字典生成josn数组
 
 - parameter dict:字典
 
 - returns:json字符串
 */
func toJSONString(dict:Dictionary<String,GoodDetailEntity>)->String{
    
    //1. 初始化可变字符串，存放最终生成json字串
    let josnString:NSMutableString=NSMutableString();
    josnString.appendString("[");
    //2. 遍历数组，取出键值对并按json格式存放
    for(_,value) in dict{
        if value.flag == 1{
            value.goodsSumMoney="\(Float(value.carNumber!)*Float(value.prefertialPrice!)!)"
        }else{
            value.goodsSumMoney="\(Float(value.carNumber!)*Float(value.uprice!)!)"
        }
        josnString.appendString(value.toJSONString(true)!+",");
        print(josnString as String)
        
    }
    //3. 获取末尾逗号所在位置
    let location=josnString.length-1;
    let range=NSMakeRange(location,1);
    // 4. 将末尾逗号换成结束的]
    josnString.replaceCharactersInRange(range, withString:"]");
    return josnString as String;
}
/**
 根据entity生成json数组
 
 - parameter entity:商品entity
 
 - returns: json字符串
 */
func toJSONString(entity:GoodDetailEntity) -> String{
    //1. 初始化可变字符串，存放最终生成json字串
    let josnString:NSMutableString=NSMutableString();
    josnString.appendString("[");
    josnString.appendString(entity.toJSONString(true)!)
    josnString.appendString("]")
    return josnString as String
}
/**
 更新数组生成json数组
 
 - parameter arr: 数组
 
 - returns: json字符串
 */
func toJSONString(arr:NSMutableArray) ->String{
    //1. 初始化可变字符串，存放最终生成json字串
    let josnString:NSMutableString=NSMutableString();
    josnString.appendString("[");
    //2. 遍历数组，取出键值对并按json格式存放
    for(value) in arr{
        let str=value as! GoodDetailEntity
        if str.flag == 1{
            str.goodsSumMoney="\(Float(str.carNumber!)*Float(str.prefertialPrice!)!)"
        }else{
            str.goodsSumMoney="\(Float(str.carNumber!)*Float(str.uprice!)!)"
        }
        josnString.appendString(str.toJSONString(true)!+",");
        
    }
    //3. 获取末尾逗号所在位置
    let location=josnString.length-1;
    let range=NSMakeRange(location,1);
    // 4. 将末尾逗号换成结束的]
    josnString.replaceCharactersInRange(range, withString:"]");
    return josnString as String;

}

