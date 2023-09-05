//
//  InternetConnection.swift
//  ServiceManager
//
//  Created by Bogdan Filippov on 03.06.2018.
//  Copyright © 2018 Bogdan Filippov. All rights reserved.
//

import SystemConfiguration

/// A utility class to check the network connectivity status.
class RKConnectivity {
    
    /// Determines whether Internet connection is available.
    ///
    /// - Returns: A Boolean value indicating whether Internet connection is available.
    static var isAvailable: Bool {
        return currentReachabilityStatus() != .notReachable
    }
    
    /// Get the current network reachability status.
    ///
    /// - Returns: The current reachability status.
    private static func currentReachabilityStatus() -> RKNetworkStatus {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return .notReachable
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return .notReachable
        }
        
        if flags.contains(.reachable) {
            if !flags.contains(.connectionRequired) {
                return .reachable
            }
            
            if flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic) {
                if !flags.contains(.interventionRequired) {
                    return .reachable
                }
            }
        }
        
        return .notReachable
    }
    
}
