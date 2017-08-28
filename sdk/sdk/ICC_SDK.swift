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
    private static let instance = ICC_SDK();
    
    /// 获得单件实例
    ///
    /// - Returns: 当前对象实例
    public static func getInstance() -> ICC_SDK {
        return ICC_SDK.instance;
    }
    
    /// 构造函数（禁止外部实例）
    private override init (){};
    
    
    /// 注册账号
    ///
    /// - Parameter callback: 回调对象
    public func register(callback:ICC_Callback) {
    }
    
    /// 登录账号
    ///
    /// - Parameter callback: 回调对象
    public func login(callback:ICC_Callback) {
        ICC_Logger.info("ICC_SDK.login(ICC_Callback)")
        // 唤醒HTML5
        self.evalJavascript(NSString(
            format:"window.ICCGAME_PASSPORT.login(%@)", self.registerCallback(callback: callback)
            ) as String)
    }
    
    
    public func pushAcctData(data:ICC_AcctData, trigger:ICC_AcctData.TRIGGER){
        
    }
    
    
    // end class
}
