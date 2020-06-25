//
//  ICC_SDK_OC.swift
//  sdk
//
//  Created by 张磊 on 2017/10/19.
//  Copyright © 2017年 游艺春秋网络科技（北京）有限公司. All rights reserved.
//

import Foundation

@objc public class ICC_SDK_OC : NSObject {
    
    /// 缓存单件实例
    private static let instance = ICC_SDK_OC()
    
    /// 获得单件实例
    ///
    /// - Returns: 当前对象实例
    public static func getInstance() -> ICC_SDK_OC {
        return ICC_SDK_OC.instance
    }
    
    /// 构造函数（禁止外部实例）
    private override init (){
        let _ = ICC_SDK.getInstance()
    }
    
    /// 注册账号
    ///
    /// - Parameter callback: 回调对象
    public func register(_ callback:ICC_Callback_OC) {
        ICC_SDK.getInstance().register(callback: ICC_CallbackDelegate_OC(callback))
    }
    
    /// 登录账号
    ///
    /// - Parameter callback: 回调对象
    public func login(_ callback:ICC_Callback_OC) {
        ICC_SDK.getInstance().login(callback: ICC_CallbackDelegate_OC(callback))
    }
    
    /// 支付
    ///
    /// - Parameters:
    ///   - tradeInfo: 由服务端签名序列化后的交易信息
    ///   - callback: 回调对象
    public func transaction(_ tradeInfo:String, _ callback:ICC_Callback_OC) {
        ICC_SDK.getInstance().transaction(tradeInfo: tradeInfo, callback: ICC_CallbackDelegate_OC(callback))
    }
    
    /// 账号中心
    /// 包括账号转正、修改密码、实名认证、等账号管理功能
    ///
    /// - Parameter callback: 回调对象
    public func center(_ callback:ICC_Callback_OC) {
        ICC_SDK.getInstance().center(callback: ICC_CallbackDelegate_OC(callback))
    }
    
    /// 登录账号
    ///
    /// - Parameter callback: 回调对象
    public func logout(_ callback:ICC_Callback_OC) {
        ICC_SDK.getInstance().logout(callback: ICC_CallbackDelegate_OC(callback))
    }
    
    
    /// 退出游戏
    ///
    /// - Parameter callback: 回调对象
    public func exit(_ callback:ICC_Callback_OC) {
        ICC_SDK.getInstance().exit(callback: ICC_CallbackDelegate_OC(callback))
    }
    
    
    /// 设置浮标状态
    ///
    /// - Parameter enabled: 是否显示 true/是 false/否
    public func setAssistiveTouchState(_ enabled: Bool) {
        ICC_SDK.getInstance().setAssistiveTouchState(enabled: enabled)
    }
    
    /// 提交数据
    ///
    /// - Parameters:
    ///   - data: 账号数据
    ///   - trigger: 提交数据类型
    public func pushAcctData(_ data:ICC_AcctData_OC, _ trigger:ICC_AcctData_OC.TRIGGER) {
        ICC_SDK.getInstance().pushAcctData(data: data.rawValue, trigger: ICC_AcctData.TRIGGER(rawValue: trigger.rawValue)!)
    }
    
// end class
}
