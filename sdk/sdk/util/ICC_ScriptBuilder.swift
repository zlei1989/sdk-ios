//
//  ICC_ScriptBuilder.swift
//  sdk
//
//  Created by 张磊 on 2017/8/28.
//  Copyright © 2017年 游艺春秋网络科技（北京）有限公司. All rights reserved.
//

// 引用类库
import Foundation


class ICC_ScriptBuilder {
    
    /// 分发事件
    ///
    /// - Parameter type: 类型
    /// - Returns: dispatchEvent函数调用
    static func dispatchEvent (type:String) -> String {
        return self.dispatchEvent(type: type, data: "null")
    }

    /// 分发事件
    ///
    /// - Parameters:
    ///   - type: 类型
    ///   - data: 数据
    /// - Returns: dispatchEvent函数调用
    static func dispatchEvent(type:String, data:Any) -> String {
        var dataStr:String?
        if let jsonDat = try? JSONSerialization.data(withJSONObject:data) {
            dataStr = String(data:jsonDat, encoding:.utf8)
        }
        return self.dispatchEvent(
            type: type,
            data: dataStr ?? ""
        )
    }
    
    /// 分发事件
    ///
    /// - Parameters:
    ///   - type: 类型
    ///   - data: 数据
    /// - Returns: JavaScript文本
    static func dispatchEvent(type:String, data:String) -> String {
        return String(format: "(function(){"
            + "var evnt=document.createEvent(\"HTMLEvents\");"
            + "evnt.initEvent(\"%@\", true, true);"
            + "evnt.data=%@;"
            + "document.body.dispatchEvent(evnt);"
            + "})()", type, data)
    }


    /// 回调
    ///
    /// - Parameter key:
    /// - Returns:
    static func callback (key:String) -> String {
        return String(format:"function(res){window.ICCGAME_IOS.callback(\"%@\", res);}", key)
    }
    
    // End class
}
