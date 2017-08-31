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
public class ICC_Logger  {
    
    ///
    public static func debug (_ format: String, _ args: CVarArg...){
        NSLog(String(format:format, arguments:args))
    }
    
    ///
    public static func info (_ format: String, _ args: CVarArg...) {
        NSLog(String(format:format, arguments:args))
    }
    
    ///
    public static func warn (_ format: String, _ args: CVarArg...){
        NSLog(String(format:format, arguments:args))
    }

    ///
    public static func error (_ format: String, _ args: CVarArg...) {
        NSLog(String(format:format, arguments:args))
    }

// end class
}
