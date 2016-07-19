////
////  PurchaseRecordsDB.swift
////  pointSingleThatIsTo
////
////  Created by penghao on 16/2/27.
////  Copyright © 2016年 penghao. All rights reserved.
////
//
//import Foundation
//import UIKit
///**
// 数据库初始化工作
// 
// - returns:数据库对象
// */
//func sqlPurchaseRecordsDB()->SQLiteDB{
//    //获取数据库实例
//    let db=SQLiteDB.sharedInstance()
//    //如果没有表创建一个
//    db.execute("CREATE TABLE IF NOT EXISTS goodPurchaseRecordss(id INTEGER PRIMARY KEY,memberId TEXT,goodsbasicinfoId INTEGER,goodInfoName TEXT,supplierId INTEGER,purchaseRecordsDate TEXT,goodPic TEXT,uprice TEXT,carNumber INTEGER,subSupplier INTEGER)")
//    return db
//    
//}
////添加商品到购买记录
//func goodPurchaseRecordsInsertGood(db:SQLiteDB,good:GoodDetailEntity,memberId:String,date:String) ->CInt{
//    let sql="INSERT INTO goodPurchaseRecordss(memberId,goodsbasicinfoId,goodInfoName,supplierId,purchaseRecordsDate,goodPic,uprice,carNumber,subSupplier) values('\(memberId)','\(good.goodsbasicinfoId!)','\(good.goodInfoName!)','\(good.supplierId!)','\(date)','\(good.goodPic!)','\(good.uprice!)','\(good.carNumber!)','\(good.subSupplier!)')"
//    //返回结果
//    let result = db.execute(sql)
//    return result
//}
////删除所有数据
//func deleteGoodPurchaseRecordsAll(db:SQLiteDB,memberId:String) ->CInt{
//    let sql="DELETE  FROM goodPurchaseRecordss WHERE memberId = '\(memberId)'";
//    //返回结果
//    let result = db.execute(sql)
//    return result
//}
////删除对应的商品根据Id
//func deleteGoodPurchaseRecordsById(db:SQLiteDB,memberId:String,goodsbasicinfoId:Int) ->CInt{
//    let sql="DELETE  FROM goodPurchaseRecordss WHERE memberId = '\(memberId)' AND goodsbasicinfoId = '\(goodsbasicinfoId)'"
//    //返回结果
//    let result = db.execute(sql)
//    return result
//    
//}
////返回当前商品在表中是否存在
//func goodPurchaseRecordsById(db:SQLiteDB,goodsbasicinfoId:Int,memberId:String) ->Int{
//    let sql="SELECT COUNT(*) FROM goodPurchaseRecordss WHERE goodsbasicinfoId = '\(goodsbasicinfoId)' AND memberId = '\(memberId)'"
//    let data=db.query(sql)
//    if data.count > 0{//如果大于0表示查询到了数据
//        return data[0]["COUNT(*)"] as! Int
//    }else{//没有返回0
//        return 0
//    }
//
//    
//}
////查询购物车所有商品保存到数组中
//func selectPurchaseRecordsAllGoodList(db:SQLiteDB,memberId:String) ->NSMutableArray{
//    let arr=NSMutableArray();
//    let sql="SELECT id,memberId,goodsbasicinfoId,goodInfoName,supplierId,purchaseRecordsDate,goodPic,uprice,carNumber,subSupplier FROM goodPurchaseRecordss WHERE memberId = '\(memberId)' ORDER BY id DESC"
//    let data=db.query(sql)
//    if data.count > 0{
//        for(var i=0;i<data.count;i++){
//            let good=GoodDetailEntity()
//            good.memberId=data[i]["memberId"] as? String
//            good.goodsbasicinfoId=data[i]["goodsbasicinfoId"] as? Int
//            good.goodInfoName=data[i]["goodInfoName"] as? String
//            good.supplierId=data[i]["supplierId"] as? Int
//            good.purchaseRecordsDate=data[i]["purchaseRecordsDate"] as? String
//            good.goodPic=data[i]["goodPic"] as? String
//            good.uprice=data[i]["uprice"] as? String
//            good.carNumber=data[i]["carNumber"] as? Int
//            good.subSupplier=data[i]["subSupplier"] as? Int
//            arr.addObject(good);
//        }
//        return arr
//    }else{
//        return arr
//    }
//}
