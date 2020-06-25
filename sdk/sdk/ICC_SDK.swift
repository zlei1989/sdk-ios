//
//  ICC_SDK.swift
//  sdk
//
//  Created by 张磊 on 2017/7/29.
//  Copyright © 2017年 游艺春秋网络科技（北京）有限公司. All rights reserved.
//

// 引用类库
import UIKit
import CoreGraphics
import Foundation

/// ICCGAME SDK 核心对象
public class ICC_SDK : ICC_SDKCallbacks {
    
    /// 缓存单件实例
    private static let instance = ICC_SDK()
    
    /// 获得单件实例
    ///
    /// - Returns: 当前对象实例
    public static func getInstance() -> ICC_SDK {
        return ICC_SDK.instance
    }
    
    /// 构造函数（禁止外部实例）
    private override init (){super.init()}
    
    /// 注册账号
    ///
    /// - Parameter callback: 回调对象
    public func register(callback:ICC_Callback) {
        ICC_Logger.info("ICC_SDK.register(ICC_Callback)")
        // 唤醒HTML5
        self.evalJavascript(String(
            format: "window.ICCGAME_PASSPORT.register(%@)", self.registerCallback(callback: callback)
        ))
    }

    /// 登录账号
    ///
    /// - Parameter callback: 回调对象
    public func login(callback:ICC_Callback) {
        ICC_Logger.info("ICC_SDK.login(ICC_Callback)")
        // 唤醒HTML5
        self.evalJavascript(String(
            format: "window.ICCGAME_PASSPORT.login(%@)", self.registerCallback(callback: callback)
        ))
    }
    
    /// 支付
    ///
    /// - Parameters:
    ///   - tradeInfo: 由服务端签名序列化后的交易信息
    ///   - callback: 回调对象
    public func transaction(tradeInfo:String, callback:ICC_Callback) {
        ICC_Logger.info("ICC_SDK.transaction(String, ICC_Callback)")
        // 编码参数
        let encoded = tradeInfo.replacingOccurrences(of: "\"", with: "\\\"")
        // 唤醒HTML5
        self.evalJavascript(String(
            format: "window.ICCGAME_PASSPORT.transaction(\"%@\", %@)", encoded, self.registerCallback(callback: callback)
        ))
    }
    
    /// 账号中心
    /// 包括账号转正、修改密码、实名认证、等账号管理功能
    ///
    /// - Parameter callback: 回调对象
    public func center(callback:ICC_Callback) {
        ICC_Logger.info("ICC_SDK.center(ICC_Callback)")
        // 唤醒HTML5
        self.evalJavascript(String(
            format: "window.ICCGAME_PASSPORT.center(%@)", self.registerCallback(callback: callback)
        ))
    }

    /// 登录账号
    ///
    /// - Parameter callback: 回调对象
    public func logout(callback:ICC_Callback) {
        ICC_Logger.info("ICC_SDK.logout(ICC_Callback)")
        // 唤醒HTML5
        self.evalJavascript(String(
            format: "window.ICCGAME_PASSPORT.logout(%@)", self.registerCallback(callback: callback)
        ))
    }
    
    /// 退出游戏
    ///
    /// - Parameter callback: 回调对象
    public func exit(callback:ICC_Callback) {
        ICC_Logger.info("ICC_SDK.exit(ICC_Callback)")
        // 唤醒HTML5
        self.evalJavascript(String(
            format: "window.ICCGAME_PASSPORT.exit(%@)", self.registerCallback(callback: callback)
        ))
    }
    
    /// 设置浮标状态
    ///
    /// - Parameter enabled: 是否显示 true/是 false/否
    public func setAssistiveTouchState(enabled: Bool) {
        ICC_Logger.info("ICC_SDK.setAssistiveTouchState(%@)", enabled ? "true" : "false")
        // 抛出事件
        self.evalJavascript(
            ICC_ScriptBuilder.dispatchEvent(type: "assistive_touch_state", data: enabled ? "true" : "false")
        )
    }
    
    /// 提交数据
    ///
    /// - Parameters:
    ///   - data: 账号数据
    ///   - trigger: 提交数据类型
    public func pushAcctData(data:ICC_AcctData, trigger:ICC_AcctData.TRIGGER){
        ICC_Logger.info("ICC_SDK.pushAcctData(ICC_AcctData, %d)", trigger.rawValue)
        // 整理数据
        let obj:Any = [
            "trigger": trigger.rawValue,
               "data": data.getJSONObject()
        ]
        // 抛出事件
        self.evalJavascript(
            ICC_ScriptBuilder.dispatchEvent(type: "receive_acct_data", data: obj)
        )
    }
    
    // End class
}

// lipo -create Release-iphonesimulator/sdk.framework/sdk Release-iphoneos/sdk.framework/sdk -output Release-iphoneos/sdk
// 拷贝合并后的最终文件替换真机类库包里面的文件
