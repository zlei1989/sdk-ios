//
//  ICC_HTML5Interface.swift
//  sdk
//
//  Created by 张磊 on 2017/8/31.
//  Copyright © 2017年 游艺春秋网络科技（北京）有限公司. All rights reserved.
//

import Foundation
import JavaScriptCore
import UIKit
import AudioToolbox

// 定义标准
@objc protocol ICC_HTML5JsExportProtocol: JSExport {
    
    /// 告知游戏
    /// 初始化完成后调用
    func ready()
    
    /// 弹出窗口
    func tip(_ message:String)
    
    /// AES 加密
    func aesEncrypt(_ seed:String, _ cleartext:String) -> String // string
    
    /// AES 加密
    func aesDecrypt(_ seed:String, _ ciphertext:String) -> String // string
    
    /// 判断文件是否存在
    func fileExists(_ path:String) -> Bool // bool
    
    /// 写入文件
    func writeFile(_ filename:String, _ contents:String) -> Bool // bool
    
    /// 追加文件
    func appendFile(_ filename:String, _ contents:String) -> Bool // bool
    
    /// 读取文件
    func readFile(_ filename:String) -> String // string
    
    /// 删除文件
    func deleteFile(_ path:String) -> Bool // bool
    
    /// 获得文件列表
    func getFiles(_ path:String) -> [String] // array
    
    /// 显示窗口
    func createActivity()
    
    /// 隐藏窗口
    func finishActivity()
    
    /// 显示浮标按钮
    func enableAssistiveTouch(_ imageBase64PNG:String)
    
    /// 隐藏浮标按钮
    func disableAssistiveTouch()
    
    /// 唤起苹果支付
    func payWithApple(_ contextJSON:String)
    
    /// SD存储路径
    func getExternalStoragePath() -> String // string
    
    /// 获得应用地址
    func getPackageDataPath() -> String // string
    
    /// 当前软件名称
    func getPackageName() -> String // string
    
    /// 当前软件版本
    func getPackageVersion() -> String // string
    
    /// 获得设备名称
    func getDevice() -> String // string
    
    /// 获得设备入网标识
    func getIMEI() -> String // string
    
    /// 获得安装软件列表
    func getInstalledPackages() -> [String] // array
    
    /// 获得网卡地址
    func getMACAddress() -> String // string
    
    /// 获得网卡地址
    func getMACAddresses() -> [String] // array
    
    /// 获得网络类型
    func getNetworkType() -> Int // number 0:none, 1:wap, 2:2g, 3:3g, 4:wifi
    
    /// 获得序列号
    func getSerialNumber() -> String // string
    
    /// 获得Sim服务商代码
    func getSimOperator() -> String // string
    
    /// 获得Sim序列号
    func getSimSerialNumber() -> String // string
    
    /// 获得系统名称
    func getSystem() -> String // string
    
    /// 获得系统版本
    func getSystemVersion() -> String // string
    
    /// 获得SDK版本
    func getVersion() -> String // string
    
    /// 获得安装插件
    func getPlugins() -> [String] // array
    
    /// 唤出拨号界面
    func callPhone(_ phoneNumber:String)
    
    /// 唤出短息界面
    func sendMessage(_ phoneNumber:String, _ message:String)
    
    /// 唤出浏览器界面
    func openBrowser(_ url:String)
    
    /// 震动
    func vibrate(_ milliseconds:String)
    
    /// 通知游戏操作完成
    func callback(_ key:String, _ resultJSON:String) -> Bool

}

// 实现代码
@objc public class ICC_HTML5Interface: NSObject, ICC_HTML5JsExportProtocol {
    
    /// 告知游戏
    /// 初始化完成后调用
    func ready() {
        ICC_Logger.debug("API call ready()")
        ICC_SDK.getInstance().setActive(state: true)
    }
    
    /// 弹出窗口
    func tip(_ message:String) {
        ICC_Logger.debug("API call tip(%@)", message)
        Toast.makeText(text: message, duration: Toast.LENGTH_SHORT)
    }
    
    /// AES 加密
    func aesEncrypt(_ seed:String, _ cleartext:String) -> String {
        return ""
    }

    
    /// AES 加密
    func aesDecrypt(_ seed:String, _ ciphertext:String) -> String {
        return ""
    }

    
    /// 判断文件是否存在
    func fileExists(_ path:String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }

    
    /// 写入文件
    func writeFile(_ filename:String, _ contents:String) -> Bool {
        return false
    }

    
    /// 追加文件
    func appendFile(_ filename:String, _ contents:String) -> Bool {
        return false
    }

    
    /// 读取文件
    func readFile(_ filename:String) -> String {
        return ""
    }
    
    /// 删除文件
    func deleteFile(_ path:String) -> Bool {
        return false
    }

    
    /// 获得文件列表
    func getFiles(_ path:String) -> [String] {
        return [""]
    }

    
    /// 显示窗口
    func createActivity() {
        ICC_SDK.getInstance().createHtmlActivity()
    }

    
    /// 隐藏窗口
    func finishActivity() {
        ICC_SDK.getInstance().finishHtmlActivity()
    }

    
    /// 显示浮标按钮
    func enableAssistiveTouch(_ imageBase64PNG:String) {
    }

    
    /// 隐藏浮标按钮
    func disableAssistiveTouch() {
    }

    
    /// 唤起苹果支付
    func payWithApple(_ contextJSON:String) {
    }

    
    /// SD存储路径
    func getExternalStoragePath() -> String {
        return self.getPackageDataPath()
    }

    
    /// 获得应用地址
    func getPackageDataPath() -> String {
        return NSHomeDirectory()
    }

    
    /// 当前软件名称
    func getPackageName() -> String {
        return Bundle.main.bundleIdentifier!
    }

    
    /// 当前软件版本
    func getPackageVersion() -> String {
        return Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    }

    
    /// 获得设备名称
    func getDevice() -> String {
        return UIDevice.current.localizedModel
    }
    
    /// 获得设备入网标识
    func getIMEI() -> String {
        return ""
    }

    
    /// 获得安装软件列表
    func getInstalledPackages() -> [String] {
        return []
    }

    
    /// 获得网卡地址
    func getMACAddress() -> String {
        return "00-00-00-00-00-00"
    }

    
    /// 获得网卡地址
    func getMACAddresses() -> [String] {
        return [self.getMACAddress()]
    }

    
    /// 获得网络类型
    /// 0:none, 1:wap, 2:2g, 3:3g, 4:wifi
    func getNetworkType() -> Int {
        return 1
    }

    
    /// 获得序列号
    func getSerialNumber() -> String {
        return (UIDevice.current.identifierForVendor?.uuidString)!
    }
    
    /// 获得Sim服务商代码
    func getSimOperator() -> String {
        return ""
//        return CTTelephonyNetworkInfo().mobileNetworkCode
    }
    
    /// 获得Sim序列号
    func getSimSerialNumber() -> String {
        return ""
//        return CTTelephonyNetworkInfo().mobileNetworkCode
    }
    
    /// 获得系统名称
    func getSystem() -> String {
        return UIDevice.current.systemVersion
    }
    
    /// 获得系统版本
    func getSystemVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    /// 获得SDK版本
    func getVersion() -> String {
        return ICC_Constants.SDK_VERSION
    }
    
    /// 获得安装插件
    func getPlugins() -> [String] {
        return ["Apple Pay"]
    }
    
    /// 唤出拨号界面
    func callPhone(_ phoneNumber:String) {
    }
    
    /// 唤出短息界面
    func sendMessage(_ phoneNumber:String, _ message:String) {
    }
    
    /// 唤出浏览器界面
    func openBrowser(_ url:String) {
    }
    
    /// 震动
    func vibrate(_ milliseconds:String) {
//        AudioServicesPlaySystemSound(.)
    }
    
    func callback(_ key:String, _ resultJSON:String) -> Bool {
        return ICC_SDK.getInstance().executeCallback(key: key, resultJSON: resultJSON)
    }
    
// end class
}


// 定义标准
@objc protocol ConsoleJsExportProtocol: JSExport {
    
    ///
    func log(_ msg:String?)
   
    ///
    func info(_ msg:String?)
    
    ///
    func error(_ msg:String?)
    
    ///
    func warn(_ msg:String?)
    
    ///
    func debug(_ msg: String?)
}

// 实现代码
class JsConsole: NSObject, ConsoleJsExportProtocol {
    
    ///
    func warn(_ msg: String?) {
        ICC_Logger.warn("HTML5 %@", msg!)
    }

    ///
    func error(_ msg: String?) {
        ICC_Logger.error("HTML5 %@", msg!)
    }

    ///
    func log(_ msg: String?) {
        ICC_Logger.info("HTML5 %@", msg!)
    }
    
    ///
    func info(_ msg: String?) {
        ICC_Logger.info("HTML5 %@", msg!)
    }

    ///
    func debug(_ msg: String?) {
        ICC_Logger.debug("HTML5 %@", msg!)
    }
    
    // end class
}
