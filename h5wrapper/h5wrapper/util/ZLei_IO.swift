//
//  IO.swift
//  sdk
//
//  Created by 张磊 on 2017/9/1.
//  Copyright © 2017年 游艺春秋网络科技（北京）有限公司. All rights reserved.
//

// 引用类库
import Foundation

/// 文件读写
class IO {

    /// 判断文件是否存在
    ///
    /// - Parameter path:
    /// - Returns:
    static func fileExists(path:String) -> Bool {
        let bool = FileManager.default.fileExists(atPath: path)
        return bool
    }

    /// 写入文件
    ///
    /// - Parameters:
    ///   - filename: 文件名
    ///   - contents: 文件文本内容
    /// - Returns: boolean true成功/false失败
    static func writeFile(filename:String, contents:String) -> Bool {
        // 创建目录
        if let idx = filename.range(of: "/", options: .backwards) {
            let dir = filename.substring(to: idx.lowerBound)
            if FileManager.default.fileExists(atPath: dir) != true {
                do {
                    try FileManager.default.createDirectory(atPath: dir, withIntermediateDirectories: true)
                } catch _ {
                    return false
                }
            }
        }
        // 写入文件
        if let dat = contents.data(using: .utf8) {
            do {
                try dat.write(to: URL(fileURLWithPath: filename))
                return true
            } catch _ {
            }
        }
        return false
    }

    /// 追加文件
    ///
    /// - Parameters:
    ///   - filename: 文件名
    ///   - contents: 文本内容
    /// - Returns: boolean true成功/false失败
    static func appendFile(filename:String, contents:String) -> Bool {
        do {
            var dat = try Data(contentsOf: URL(fileURLWithPath: filename), options: .uncached)
            if let str = contents.data(using: .utf8) {
                dat.append(str)
            }
            return true
        } catch _ {
        }
        return false
    }
    
    /// 读取文件
    ///
    /// - Parameter filename: 文件名
    /// - Returns: 文本内容
    static func readFile(filename:String) -> String? {
        do {
            let dat = try Data(contentsOf: URL(fileURLWithPath: filename), options: .uncachedRead)
            return String(data: dat, encoding: String.Encoding.utf8)
        } catch _ {
        }
        return nil
    }

    /// 删除文件
    ///
    /// - Parameter path: 文件路径
    /// - Returns: boolean true成功/false失败
    static func deleteFile(path:String) -> Bool {
        if FileManager.default.fileExists(atPath: path) == false {
            return true
        }
        do {
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch _ {
        }
        return false
    }

    /// 获得文件列表
    ///
    /// - Parameter path: 文件路径
    /// - Returns: 获取文件
    static func getFiles(path:String) -> [String] {
        do {
            return try FileManager.default.subpathsOfDirectory(atPath: path)
        } catch _ {
        }
        return []
    }
    
    // End class
}
