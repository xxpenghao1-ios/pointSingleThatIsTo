//
//  IJReachability.swift
//  IJReachability
//
//  Created by Isuru Nanayakkara on 1/14/15.
//  Copyright (c) 2015 Appex. All rights reserved.
//

import Foundation
import SystemConfiguration

public enum IJReachabilityType {
    case wwan,
    wiFi,
    notConnected
}
///**验证是否有网络*/
//open class IJReachability {
//    
//    /**
//    :see: Original post - http://www.chrisdanielson.com/2009/07/22/iphone-network-connectivity-test-example/
//    */
//    open class func isConnectedToNetwork() -> Bool {
//        
//        var zeroAddress = sockaddr_in()
//        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
//        zeroAddress.sin_family = sa_family_t(AF_INET)
//        
//        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
//            SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, $0)
//        }) else {
//            return false
//        }
//        
//        var flags : SCNetworkReachabilityFlags = []
//        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
//            return false
//        }
//        
//        let isReachable = flags.contains(.reachable)
//        let needsConnection = flags.contains(.connectionRequired)
//        return (isReachable && !needsConnection)
//    }
//    
//    open class func isConnectedToNetworkOfType() -> IJReachabilityType {
//        
//        var zeroAddress = sockaddr_in()
//        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
//        zeroAddress.sin_family = sa_family_t(AF_INET)
//        
//        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
//           SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, $0)
//        }
//        
//        var flags: SCNetworkReachabilityFlags = []
//        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
//            return .notConnected
//        }
//        
//        let isReachable = flags.contains(.reachable)
//        let isWWAN = flags.contains(.connectionRequired)
//        //let isWifI = (flags & UInt32(kSCNetworkReachabilityFlagsReachable)) != 0
//        
//        if(isReachable && isWWAN){
//            return .wwan
//        }
//        if(isReachable && !isWWAN){
//            return .wiFi
//        }
//        
//        return .notConnected
//        //let needsConnection = (flags & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
//        
//        //return (isReachable && !needsConnection) ? true : false
//    }
//    
//}

