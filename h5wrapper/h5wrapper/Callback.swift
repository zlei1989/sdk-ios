//
//  Callback.swift
//  sdk
//
//  Created by 张磊 on 2017/7/29.
//  Copyright © 2017年 游艺春秋网络科技（北京）有限公司. All rights reserved.
//

// 引用类库
import Foundation

/// 完成回调协议
public protocol Callback {

    /// 操作结束后调用此方法
    ///
    /// - Parameter resultJSON: 操作结果JSON格式字符串
    func result(resultJSON:String)
    
    // End protocol
}
