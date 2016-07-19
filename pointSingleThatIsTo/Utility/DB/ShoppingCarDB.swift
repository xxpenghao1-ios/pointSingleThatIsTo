////
////  ShoppingCarDB.swift
////  pointSingleThatIsTo
////
////  Created by penghao on 16/1/31.
////  Copyright © 2016年 penghao. All rights reserved.
////
//
//import Foundation
//import UIKit
//
///**
// 数据库初始化工作
// 
// - returns:数据库对象
// */
//func sqlShoppingCarDB()->SQLiteDB{
//    //获取数据库实例
//    let db=SQLiteDB.sharedInstance()
//    //如果没有表创建一个
//    db.execute("create table if not exists shoppingCar(id INTEGER primary key,memberId TEXT,goodsbasicinfoId INTEGER,uprice TEXT,goodInfoName TEXT,isDistribution INTEGER,supplierId INTEGER,uitemPrice TEXT,goodPic TEXT,flag INTEGER,carNumber INTEGER,preferentialPrice TEXT,ucode TEXT,goodsStock INTEGER,eachCount INTEGER,subSupplier INTEGER,goodsBaseCount INTEGER,miniCount INTEGER)")
//    return db
//    
//}
///**
// 添加数据
// 
// - parameter db:       数据库对象
// - parameter entity:   商品entity
// - parameter memberId: 会员id
//  - returns: 大于0表示成功
// */
//func insertGood(db:SQLiteDB,entity:GoodDetailEntity,memberId:String) ->CInt{
//    //加入数据前 进行非空处理
//    if entity.preferentialPrice == nil{
//        entity.preferentialPrice="0"
//    }
//    if entity.eachCount == nil{
//        entity.eachCount=0
//    }
//    if entity.uitemPrice == nil{
//        entity.uitemPrice="0"
//    }
//    if entity.uprice == nil{
//        entity.uprice="0"
//    }
//    if entity.isDistribution == nil{
//        entity.isDistribution=1
//    }
//    //sql执行语句
//    let sql="INSERT INTO shoppingCar(memberId,goodsbasicinfoId,uprice,goodInfoName,isDistribution,supplierId,uitemPrice,goodPic,flag,carNumber,preferentialPrice,ucode,goodsStock,eachCount,subSupplier,goodsBaseCount,miniCount) values('\(memberId)','\(entity.goodsbasicinfoId!)','\(entity.uprice!)','\(entity.goodInfoName!)','\(entity.isDistribution!)','\(entity.supplierId!)','\(entity.uitemPrice!)','\(entity.goodPic!)','\(entity.flag!)','\(entity.carNumber!)','\(entity.preferentialPrice!)','\(entity.ucode!)','\(entity.goodsStock!)','\(entity.eachCount!)','\(entity.subSupplier!)','\(entity.goodsBaseCount!)','\(entity.miniCount!)')"
//     //返回结果
//     let result = db.execute(sql)
//     return result
//    
//}
///**
// 根据商品id删除
// 
// - parameter db:       数据库对象
// - parameter goodId:   商品id
// - parameter memberId: 会员id
// - parameter flag:     是否是特价(1no,2yes)
// 
// - returns: 大于0表示成功
// */
//func deleteGoodById(db:SQLiteDB,goodId:Int,memberId:String,flag:Int) ->CInt{
//    //sql执行语句
//    let sql="DELETE FROM shoppingCar WHERE goodsbasicinfoId='\(goodId)' AND memberId='\(memberId)' AND flag='\(flag)'"
//    //返回结果
//    let result = db.execute(sql)
//    return result
//    
//}
//
///**
// 删除所有
// 
// - parameter db:       数据库对象
// - parameter memberId: 会员id
// 
// - returns: 大于0表示成功
// */
//func deleteAll(db:SQLiteDB,memberId:String) ->CInt{
//    let sql="DELETE FROM shoppingCar WHERE memberId='\(memberId)'"
//    //返回结果
//    let result = db.execute(sql)
//    return result
//}
///**
// 查询购物车总数量
// 
// - parameter db:       数据库对象
// - parameter memberId: 会员id
// 
// - returns:返回总数量
// */
//func selectAllGoodCount(db:SQLiteDB,memberId:String) ->Int{
//    let sql="SELECT SUM(carNumber) FROM shoppingCar WHERE memberId='\(memberId)'"
//    let data=db.query(sql)
//    if data.count > 0{//如果大于0表示查询到了数据
//        let count=data[0]["SUM(carNumber)"] as? Int
//        if count != nil{
//            return count!
//        }else{
//            return 0
//        }
//        
//    }else{//没有返回0
//        return 0
//    }
//}
///**
// 根据商品id,会员id,是否是特价更新购物车单个商品数量
// 
// - parameter db:               数据库对象
// - parameter goodsbasicinfoId: 商品对象
// - parameter carNumberCount:   购物车商品数量
// - parameter memebrId:         会员id
// - parameter flag:             是否是特价(1no,2yes)
// 
// - returns: 大于0表示成功
// */
//func updateGoodByIdShoppingCar(db:SQLiteDB,goodsbasicinfoId:Int,carNumberCount:Int,memebrId:String,flag:Int) ->CInt{
//    //sql执行语句
//    let sql="UPDATE shoppingCar SET carNumber='\(carNumberCount)' WHERE goodsbasicinfoId='\(goodsbasicinfoId)' AND memberId='\(memebrId)' AND flag='\(flag)'"
//    //返回结果
//    let result=db.execute(sql)
//    return result
//    
//}
///**
// 更新购物车单个商品数量 根据会员id,商品id,是否是特价
// 
// - parameter db:               数据库对象
// - parameter memberId:         会员id
// - parameter goodsbasicinfoId: 商品id
// - parameter carNumber:        购物车数量
// - parameter flag:             是否是特价(1no,2yes)
//  - returns: 大于0表示成功
// */
//func updateGoodById(db:SQLiteDB,memberId:String,goodsbasicinfoId:Int,carNumber:Int,flag:Int) -> CInt{
//    //拿到当前商品在购物车种商品的数量
//    let goodCarNumberCount=goodByIdCount(db,goodsbasicinfoId: goodsbasicinfoId,memberId: memberId,flag: flag);
//    //把当前加入购物车的商品数量和原来的相加
//    let goodCount=goodCarNumberCount+carNumber;
//    //sql执行语句
//    let sql="UPDATE shoppingCar SET carNumber='\(goodCount)' WHERE goodsbasicinfoId='\(goodsbasicinfoId)' AND memberId='\(memberId)' AND flag='\(flag)'"
//    //返回结果
//    let result=db.execute(sql)
//    return result
//    
//}
///**
// 根据商品id,会员id,是否是特价查询,查询该条记录是否存在
// 
// - parameter db:               数据库对象
// - parameter goodsbasicinfoId: 商品id
// - parameter memberId:         会员id
// - parameter flag:             是否是特价(1no,2yes)
// - returns: 大于0表示存在
// */
//func goodByIdAndFlag(db:SQLiteDB,goodsbasicinfoId:Int,memberId:String,flag:Int) ->Int{
//    //sql执行语句
//    let sql="SELECT COUNT(*) AS count FROM  shoppingCar WHERE goodsbasicinfoId='\(goodsbasicinfoId)' AND memberId='\(memberId)' AND flag='\(flag)'"
//    //返回结果
//    let data=db.query(sql)
//    if data.count > 0{
//        return data[0]["count"] as! Int
//    }else{
//        return 0
//    }
//}
///**
////拿到当前商品在购物车中商品的数量
//
//- parameter db:               数据库对象
//- parameter goodsbasicinfoId: 商品id
//- parameter memberId:         会员id
//- parameter flag:             是否是特价(1no,2yes)
//
//- returns: 商品数量
//*/
//func goodByIdCount(db:SQLiteDB,goodsbasicinfoId:Int,memberId:String,flag:Int) ->Int{
//    //sql执行语句
//    let sql="SELECT SUM(carNumber) FROM shoppingCar WHERE goodsbasicinfoId='\(goodsbasicinfoId)' AND memberId='\(memberId)' AND flag='\(flag)'"
//    //返回结果
//    let data=db.query(sql)
//    if data.count > 0{
//        return data[0]["SUM(carNumber)"] as! Int
//    }else{
//        return 0
//    }
//}
///**
// 根据商品id,会员id,是否是特价查询出该特价商品在购物总数量
// 
// - parameter db:               数据库对象
// - parameter goodsbasicinfoId: 商品id
// - parameter memberId:         会员id
// - parameter flag:             是否是特价(1no,2yes)
// 
// - returns: 返回结果
// */
//func selectSpcialOfferCount(db:SQLiteDB,goodsbasicinfoId:Int,memberId:String,flag:Int) ->Int{
//    //sql执行语句
//    let sql="SELECT SUM(carNumber) AS sumCount FROM shoppingCar WHERE goodsbasicinfoId='\(goodsbasicinfoId)' AND memberId='\(memberId)' AND flag='\(flag)'"
//    //返回结果
//    let data=db.query(sql)
//    if data.count > 0{
//        return data[0]["sumCount"] as! Int
//    }else{
//        return 0
//    }
//}
///**
// 根据会员id查询所有购物车中的数据
// 
// - parameter db:       数据库对象
// - parameter memberId: 会员id
// 
// - returns: 返回数组
// */
//func selectAllGoodList(db:SQLiteDB,memberId:String) ->NSMutableArray{
//    //创建数组 用于保存数据
//    let arr=NSMutableArray()
//    //sql执行语句
//    let sql="SELECT * FROM shoppingCar WHERE memberId='\(memberId)' ORDER BY id DESC"
//    //返回结果
//    let data=db.query(sql)
//    if data.count > 0{//如果大于0 表示有数据
//        for(var i=0;i<data.count;i++){//循环返回结果 保存进数组中
//            let good=GoodDetailEntity()
//            good.memberId=data[i]["memberId"] as? String
//            good.goodsbasicinfoId=data[i]["goodsbasicinfoId"] as? Int
//            good.uprice=data[i]["uprice"] as? String
//            good.goodInfoName=data[i]["goodInfoName"] as? String
//            good.isDistribution=data[i]["isDistribution"] as? Int
//            good.supplierId=data[i]["supplierId"] as? Int
//            good.uitemPrice=data[i]["uitemPrice"] as? String
//            good.goodPic=data[i]["goodPic"] as? String
//            good.flag=data[i]["flag"] as? Int
//            good.carNumber=data[i]["carNumber"] as? Int
//            good.preferentialPrice=data[i]["preferentialPrice"] as? String
//            good.ucode=data[i]["ucode"] as? String
//            good.goodsStock=data[i]["goodsStock"] as? Int
//            good.eachCount=data[i]["eachCount"] as? Int
//            good.subSupplier=data[i]["subSupplier"] as? Int
//            good.goodsBaseCount=data[i]["goodsBaseCount"] as? Int
//            good.miniCount=data[i]["miniCount"] as? Int
//            good.selectedFlag=1
//            arr.addObject(good)
//        }
//        return arr
//    }else{//没有返回空数组
//        return arr
//    }
//}