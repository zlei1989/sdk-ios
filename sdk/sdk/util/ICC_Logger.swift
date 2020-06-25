//
//  ICC_Logger.swift
//  sdk
//
//  Created by 张磊 on 2017/8/28.
//  Copyright © 2017年 游艺春秋网络科技（北京）有限公司. All rights reserved.
//

// 引用类库
import Foundation

/// 输出日志
public class ICC_Logger {

    /// 提供给开发者查看的调试信息
    ///
    /// - Parameters:
    ///   - format: 内容或内容格式
    ///   - args: 格式内变量参数
    public static func debug (_ format: String, _ args: CVarArg...){
        #if DEBUG
        NSLog("%@", String(format:format, arguments:args))
        #endif
    }

    /// 常规信息
    ///
    /// - Parameters:
    ///   - format: 内容或内容格式
    ///   - args: 格式内变量参数
    public static func info (_ format: String, _ args: CVarArg...) {
        NSLog("%@", String(format:format, arguments:args))
    }
    
    /// 警告信息
    ///
    /// - Parameters:
    ///   - format: 内容或内容格式
    ///   - args: 格式内变量参数
    public static func warn (_ format: String, _ args: CVarArg...) {
        NSLog("%@", String(format:format, arguments:args))
    }
    
    /// 错误信息
    ///
    /// - Parameters:
    ///   - format: 内容或内容格式
    ///   - args: 格式内变量参数
    public static func error (_ format: String, _ args: CVarArg...) {
        NSLog("%@", String(format:format, arguments:args))
    }
    
    
    /// 显示一段代码运行时间
    ///
    /// - Parameters:
    ///   - title: 即时标签
    ///   - call: 代码区块
    public static func measure (_ label:String!, call:()->Void) {
        let startTime = CFAbsoluteTimeGetCurrent()
        call()
        self.debug("%s run time %.8f", label, CFAbsoluteTimeGetCurrent()-startTime)
    }
    
    // End class
}
//func example () {
//    ICC_Logger.measure("Example") {
//        NSLog("%@", "Hello World")
//    }
//}
