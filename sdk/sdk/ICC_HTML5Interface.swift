//
//  ICC_HTML5Interface.swift
//  sdk
//
//  Created by 张磊 on 2017/8/31.
//  Copyright © 2017年 游艺春秋网络科技（北京）有限公司. All rights reserved.
//

// 引用类库
import Foundation
import JavaScriptCore
import UIKit
import MessageUI
import AudioToolbox

/// 定义标准
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
    func readFile(_ filename:String) -> String? // string
    
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
    func tranWithAppleStore(_ contextJSON:String)
    
    /// 获得应用地址
    func tranWithAppleStoreDataPath() -> String // string
    
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
    func getIMEI() -> String? // string
    
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
    func getSimOperator() -> String? // string
    
    /// 获得Sim序列号
    func getSimSerialNumber() -> String? // string
    
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

/// 实现代码
public class ICC_HTML5Interface: NSObject, ICC_HTML5JsExportProtocol {
    
    /// 告知游戏
    /// 初始化完成后调用
    func ready() {
        ICC_Logger.debug("API call ready()")
        ICC_SDK.getInstance().setActive(state: true)
        // 初始支付自动补单
        let _ = AppleStoreService.default
    }

    /// 弹出窗口
    func tip(_ message:String) {
        ICC_Logger.debug("API call tip(%@)", message)
        Toast.makeText(text: message, duration: Toast.LENGTH_SHORT)
    }
    
    /// AES 加密
    func aesEncrypt(_ seed:String, _ cleartext:String) -> String {
        return ICC_AES.encrypt(seed:seed, cleartext:cleartext)
    }

    /// AES 加密
    func aesDecrypt(_ seed:String, _ ciphertext:String) -> String {
        return ICC_AES.decrypt(seed: seed,ciphertext: ciphertext)
    }

    /// 判断文件是否存在
    func fileExists(_ path:String) -> Bool {
        return ICC_IO.fileExists(path: path)
    }

    /// 写入文件
    func writeFile(_ filename:String, _ contents:String) -> Bool {
        return ICC_IO.writeFile(filename: filename, contents: contents)
    }

    /// 追加文件
    func appendFile(_ filename:String, _ contents:String) -> Bool {
        return ICC_IO.appendFile(filename: filename, contents: contents)
    }

    /// 读取文件
    func readFile(_ filename:String) -> String? {
        return ICC_IO.readFile(filename: filename)
    }
    
    /// 删除文件
    func deleteFile(_ path:String) -> Bool {
        return ICC_IO.deleteFile(path: path)
    }

    /// 获得文件列表
    func getFiles(_ path:String) -> [String] {
        return ICC_IO.getFiles(path: path)
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
        ICC_SDK.getInstance().setAssistiveTouch(
            imageData: Data(base64Encoded: imageBase64PNG)!
        )
    }

    /// 隐藏浮标按钮
    func disableAssistiveTouch() {
        ICC_SDK.getInstance().removeAssistiveTouch()
    }

    /// 唤起苹果支付
    func tranWithAppleStore(_ contextJSON:String) {
        ICC_Transaction.default.doPostAppleStroe(withJson: contextJSON)
    }
    
    /// 错误订单地址
    func tranWithAppleStoreDataPath() -> String {
        return AppleStoreService.default.storageDirectory
    }
    
    /// SD存储路径
    func getExternalStoragePath() -> String {
        return self.getPackageDataPath()
    }

    /// 获得应用地址
    func getPackageDataPath() -> String {
        return NSHomeDirectory() + "/Documents"
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
    func getIMEI() -> String? {
        return ICC_Device.current.imei
    }

    /// 获得安装软件列表
    func getInstalledPackages() -> [String] {
        return []
    }

    /// 获得网卡地址
    func getMACAddress() -> String {
        return ICC_Device.current.macAddress
    }

    /// 获得网卡地址
    func getMACAddresses() -> [String] {
        return [self.getMACAddress()]
    }

    /// 获得网络类型
    func getNetworkType() -> Int {
        return ICC_Device.current.networkType.rawValue
    }

    /// 获得序列号
    func getSerialNumber() -> String {
        return ICC_Device.current.idfa
    }

    /// 获得Sim服务商代码
    func getSimOperator() -> String? {
        return ICC_Device.current.simOperator
    }

    /// 获得Sim序列号
    func getSimSerialNumber() -> String? {
        return ICC_Device.current.simSerialNumber
    }

    /// 获得系统名称
    func getSystem() -> String {
        return UIDevice.current.systemName
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
        return ["apple store"]
    }

    /// 唤出拨号界面
    func callPhone(_ phoneNumber:String) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: String(format:"tel://%@", phoneNumber))!)
        } else {
            // Fallback on earlier versions
        }
    }

    /// 唤出短息界面
    func sendMessage(_ phoneNumber:String, _ message:String) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: String(format:"sms://%@", phoneNumber))!)
        } else {
            // Fallback on earlier versions
        }
    }

    /// 唤出浏览器界面
    func openBrowser(_ url:String) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: url)!)
        } else {
            // Fallback on earlier versions
        }
    }

    /// 震动
    func vibrate(_ milliseconds:String) {
//        AudioServicesPlaySystemSound(.)
    }

    /// 回调
    func callback(_ key:String, _ resultJSON:String) -> Bool {
        var res:Bool = false
        if Thread.isMainThread {
            res = ICC_SDK.getInstance().executeCallback(key: key, resultJSON: resultJSON)
        } else {
            DispatchQueue.main.sync {
                res = ICC_SDK.getInstance().executeCallback(key: key, resultJSON: resultJSON)
            }
        }
        return res
    }

    // End class
}


/// 定义标准
@objc protocol ConsoleJsExportProtocol: JSExport {
    
    /// log信息
    func log(_ msg:String?)
    
    /// 测试
    func debug(_ msg: String?)
   
    /// 标准
    func info(_ msg:String?)
    
    /// 警告
    func warn(_ msg:String?)
    
    /// 错误
    func error(_ msg:String?)
}

/// 实现代码
class JsConsole: NSObject, ConsoleJsExportProtocol {
    
    /// 警告
    func warn(_ msg: String?) {
        ICC_Logger.warn("HTML5 %@", msg!)
    }

    /// 错误
    func error(_ msg: String?) {
        ICC_Logger.error("HTML5 %@", msg!)
    }

    /// log信息
    func log(_ msg: String?) {
        ICC_Logger.info("HTML5 %@", msg!)
    }
    
    /// 标准
    func info(_ msg: String?) {
        ICC_Logger.info("HTML5 %@", msg!)
    }

    /// 测试
    func debug(_ msg: String?) {
        ICC_Logger.debug("HTML5 %@", msg!)
    }
    
    // End class
}
