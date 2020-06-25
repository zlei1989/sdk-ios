//
//  ICC_Callback_OC.swift
//  sdk
//
//  Created by 张磊 on 2017/10/19.
//  Copyright © 2017年 游艺春秋网络科技（北京）有限公司. All rights reserved.
//

// 引用类库
import Foundation

/// 完成回调协议
@objc public protocol ICC_Callback_OC : NSObjectProtocol {
    
    /// 操作结束后调用此方法
    ///
    /// - Parameter resultJSON: 操作结果JSON格式字符串
    func result(_ resultJSON:String)
    
    // End protocol
}


/// 完成回调协议转变对象
/// 保证 Objective-C 与 Swift 语法基本一致
class ICC_CallbackDelegate_OC : ICC_Callback {

    
    /// oc回调对象
    let rawValue:ICC_Callback_OC
    
    
    /// 初始对象
    ///
    /// - Parameter callback: oc回调对象
    public init (_ callback:ICC_Callback_OC) {
        self.rawValue = callback
    }
    
    
    /// 结果映射
    ///
    /// - Parameter resultJSON: 执行结果
    public func result(resultJSON:String) {
        self.rawValue.result(resultJSON)
    }

// end class
}
