//
//  ICC_Device.swift
//  sdk
//
//  Created by 张磊 on 2017/9/19.
//  Copyright © 2017年 游艺春秋网络科技（北京）有限公司. All rights reserved.
//

import Foundation
import Messages
import MessageUI
import NetworkExtension
import CoreTelephony
import SystemConfiguration
import SystemConfiguration.CaptiveNetwork
import AdSupport

/// 输出日志
public class ICC_Device : NSObject {
    
    /// 网络类型
    public enum NETWORK_TYPE : Int {
        case NONE = 0
        case WAP = 1
        case CELLULAR_SLOW = 2
        case CELLULAR = 3
        case WIFI = 4
    }
    
    /// 当前设备信息
    public static let current = ICC_Device()

    /// 设备入网标示
    public var imei:String? {
        get {
            return nil
        }
    }
    
    /// SIM 卡服务商
    public var simOperator:String? {
        get {
            let carrier = CTTelephonyNetworkInfo().subscriberCellularProvider
            if carrier != nil {
                return carrier?.carrierName
            }
            return nil
        }
    }
    
    /// SIM 卡序列号
    public var simSerialNumber:String? {
        get {
            return nil
        }
    }
    
    /// 网卡地址
    public var macAddress:String {
        get {
            return "02-00-00-00-00-00"
        }
    }
    
    // 获得广告标示
    public var idfa:String {
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    
    // 获得设备标示
    public var idfv:String {
        return (UIDevice.current.identifierForVendor?.uuidString)!
    }
    
    /// 网络类型
    public var networkType:NETWORK_TYPE {
        let interfaces = CNCopySupportedInterfaces()
        if interfaces != nil {
            return NETWORK_TYPE.WIFI
        }
        let technology = CTTelephonyNetworkInfo().currentRadioAccessTechnology
        if technology != nil {
            switch technology! {
                case "CTRadioAccessTechnologyCDMA1x",
                     "CTRadioAccessTechnologyCDMAEVDORev0",
                     "CTRadioAccessTechnologyCDMAEVDORevA",
                     "CTRadioAccessTechnologyCDMAEVDORevB",
                     "CTRadioAccessTechnologyEdge",
                     "CTRadioAccessTechnologyGPRS":
                    return NETWORK_TYPE.CELLULAR_SLOW
                case "CTRadioAccessTechnologyHSDPA",
                     "CTRadioAccessTechnologyHSUPA",
                     "CTRadioAccessTechnologyLTE",
                     "CTRadioAccessTechnologyWCDMA",
                     "CTRadioAccessTechnologyeHRPD":
                    fallthrough
                default:
                    return NETWORK_TYPE.CELLULAR
            }
        }
        return NETWORK_TYPE.NONE
    }
    
    // End class
}
