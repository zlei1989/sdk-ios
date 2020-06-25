//
//  CallbackManager.swift
//  sdk
//
//  Created by 张磊 on 2017/8/28.
//  Copyright © 2017年 北京远程悦动信息技术有限公司. All rights reserved.
//

// 引用类库
import Foundation

/// 维护回调对象，对象转换为字符串直接与 JAVASCRIPT 进行交互
public class CallbackManager : SDKAssistiveTouch {

    /// 回调对象列表
    private var _callbacks:Dictionary = Dictionary<String,Callback>()

    /// 注册回调对象
    public func register(callback:Callback) -> String {
        // 生成标识
        let key = NSUUID().uuidString
        // 暂存队列
        self._callbacks.updateValue(callback, forKey: key)
        Logger.info("HTML5 register callback %@", key)
        return ScriptBuilder.callback(key: key)
    }

    /// 执行回调对象
    public func execute(key:String, resultJSON:String) -> Bool {
        // 验证键名
        if (self._callbacks.index(forKey:key) == nil) {
            Logger.info("HTML5 callback %@ not found", key)
            return false
        }
        // 执行回调
        Logger.info("HTML5 callback %@ %@", key, resultJSON)
        let callback = self._callbacks.removeValue(forKey: key)
        callback?.result(resultJSON: resultJSON)
        Logger.info("HTML5 callback %@ removed", key)
        return true
    }
    
} // end class
