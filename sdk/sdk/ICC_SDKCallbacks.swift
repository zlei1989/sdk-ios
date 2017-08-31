//
//  ICC_SDKCallbacks.swift
//  sdk
//
//  Created by 张磊 on 2017/8/28.
//  Copyright © 2017年 游艺春秋网络科技（北京）有限公司. All rights reserved.
//

// 引用类库
import Foundation

/// Completed
/// 维护回调对象，对象转换为字符串直接与 JAVASCRIPT 进行交互
public class ICC_SDKCallbacks : ICC_SDKAssistiveTouch {

    /// 回调对象列表
    private var _callbacks:Dictionary = Dictionary<String,ICC_Callback>()
    
    /// 注册回调对象
    func registerCallback ( callback:ICC_Callback ) -> String{
        // 生成标识
        let key = NSUUID().uuidString;
        // 暂存队列
        self._callbacks.updateValue(callback, forKey: key)
        ICC_Logger.info("HTML5 register callback %@", key)
        return ICC_ScriptBuilder.callback(key: key)
    }
    
    /// 执行回调对象
    func executeCallback(key:String, resultJSON:String) -> Bool {
        // 验证键名
        if (self._callbacks.index(forKey:key) == nil) {
            ICC_Logger.info("HTML5 callback %@ not found", key)
            return false;
        }
        // 执行回调
        ICC_Logger.info("HTML5 callback %@ %@", key, resultJSON)
        let callback = self._callbacks.removeValue(forKey: key)
        callback?.result(resultJSON: resultJSON)
        ICC_Logger.info("HTML5 callback %@ removed", key)
        return true
    }
    
// end class
}
