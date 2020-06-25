//
//  ICC_AES.swift
//  sdk
//
//  Created by 张磊 on 2017/9/1.
//  Copyright © 2017年 游艺春秋网络科技（北京）有限公司. All rights reserved.
//

// 引用类库
import Foundation

/// 信息加解密
class ICC_AES {

    /// 加密
    ///
    /// - Parameters:
    ///   - seed: 需要加密的文本
    ///   - cleartext: 密文
    /// - Returns: 加密后的文本
    static func encrypt (seed:String, cleartext:String) -> String {
        // 整理秘钥
        let keyArr = self.getRawKey(seed: seed)
        let keyPtr = UnsafeMutablePointer<UInt8>(mutating: keyArr)
        let keyLen = size_t(kCCKeySizeAES128)
        // 整理内容
        let strArr = Array(cleartext.utf8)
        let strPtr = UnsafeMutablePointer<UInt8>(mutating: strArr)
        let strLen = strArr.count
        // 创建容器
        var bufArr = [UInt8](repeating:0, count:strArr.count+kCCBlockSizeAES128)
        let bufPtr = UnsafeMutablePointer<UInt8>(mutating: bufArr)
        let bufLen = size_t(bufArr.count)
        // 加密数据
        var dstLen:size_t = 0
        let res = CCCrypt(CCOperation(kCCEncrypt),
                                  CCAlgorithm(kCCAlgorithmAES128),
                                  CCOptions(kCCOptionECBMode + kCCOptionPKCS7Padding),
                                  keyPtr, keyLen,
                                  nil,
                                  strPtr, strLen,
                                  bufPtr, bufLen,
                                  &dstLen)
        
        if UInt32(res) == UInt32(kCCSuccess) {
            bufArr.removeSubrange(dstLen..<bufArr.count)
        } else {
            ICC_Logger.error("ICC_ASE.encrypt(%@, %@) throw err(%d)", seed, cleartext, res)
            return ""
        }
        return Data(bufArr).base64EncodedString()
    }
    
    /// 解密
    ///
    /// - Parameters:
    ///   - seed: 需要解密的文本
    ///   - ciphertext: 密文
    /// - Returns: 解密后的文本
    static func decrypt (seed:String, ciphertext:String) -> String {
        // 整理秘钥
        let keyArr = self.getRawKey(seed: seed)
        let keyPtr = UnsafeMutablePointer<UInt8>(mutating: keyArr)
        let keyLen = size_t(kCCKeySizeAES128)
        // 整理内容
        
        let strDat = Data(base64Encoded: ciphertext)
        if strDat == nil {
            ICC_Logger.error("ICC_ASE.decrypt(%@, %@) throw base64 decode err", seed, ciphertext)
            return ""
        }
        let strArr = strDat?.withUnsafeBytes {
            [UInt8](UnsafeBufferPointer(start: $0, count: (strDat?.count)!))
        }
        let strPtr = UnsafeMutablePointer<UInt8>(mutating: strArr)
        let strLen = strArr?.count
        // 创建容器
        var bufArr = [UInt8](repeating:0, count:(strArr?.count)!+kCCBlockSizeAES128)
        let bufPtr = UnsafeMutablePointer<UInt8>(mutating: bufArr)
        let bufLen = size_t(bufArr.count)
        // 加密数据
        var dstLen:size_t = 0
        let res = CCCrypt(CCOperation(kCCDecrypt),
                          CCAlgorithm(kCCAlgorithmAES128),
                          CCOptions(kCCOptionECBMode + kCCOptionPKCS7Padding),
                          keyPtr, keyLen,
                          nil,
                          strPtr, strLen!,
                          bufPtr, bufLen,
                          &dstLen)
        
        if UInt32(res) == UInt32(kCCSuccess) {
            bufArr.removeSubrange(dstLen..<bufArr.count)
        } else {
            ICC_Logger.error("ICC_ASE.decrypt(%@, %@) throw err(%d)", seed, ciphertext, res)
            return ""
        }
        return String(data: Data(bufArr), encoding: .utf8) ?? ""
    }
    
    /// 哈希密码
    ///
    /// - Parameter seed: 需要哈希的文本
    /// - Returns: 哈希后的文本
    static func getRawKey (seed:String) -> [UInt8] {
        let str = seed.cString(using: .utf8)
        let buf = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(str!,(CC_LONG)(strlen(str!)), buf)
        var res = [UInt8]()
        for i in 0 ..< 16 {
            res.append(buf[i])
        }
        free(buf)
        return res
    }
    
    // End class
}

