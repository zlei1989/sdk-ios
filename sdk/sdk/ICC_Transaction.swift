//
//  ICC_Transaction.swift
//  sdk
//
//  Created by 张磊 on 2017/8/30.
//  Copyright © 2017年 游艺春秋网络科技（北京）有限公司. All rights reserved.
//

// 引用类库
import Foundation
import StoreKit

/// 支付对象
public class ICC_Transaction {
    
    // 单件对象
    public static let `default` = ICC_Transaction()
    

    /// 提交应用商店支付
    ///
    /// - Parameter str: 支付参数
    func doPostAppleStroe (withJson str:String) {
        ICC_Logger.debug( "ICC_Transaction.doPostAppleStroe(%@)", str)
        do {
            // 解析请求
            let obj = try? JSONSerialization.jsonObject(with: str.data(using: .utf8)!)
            let req:[String:Any]? = obj as? [String:Any]
            if req == nil {
                throw AppleStoreService.Error(description: String(format:"post parameters invalid", str), code: 101)
            }
            // 导出参数
            let productIdentifier:String? = req?.index(forKey: "productIdentifier") == nil ? nil : req?["productIdentifier"] as? String
            if productIdentifier == nil {
                throw AppleStoreService.Error(description: "parameter productIdentifier invalid", code: 102)
            }
            let tradeNo:String? = req?.index(forKey: "tradeNo") == nil ? nil : req?["tradeNo"] as? String
            if tradeNo == nil {
                throw AppleStoreService.Error(description: "parameter tradeNo invalid", code: 103)
            }
            let amount:Int? = req?.index(forKey: "amount") == nil ? nil : req?["amount"] as? Int
            if amount == nil {
                throw AppleStoreService.Error(description: "parameter amount invalid", code: 104)
            }
            let notifyUrl:String? = req?.index(forKey: "notifyUrl") == nil ? nil : req?["notifyUrl"] as? String
            if notifyUrl == nil {
                throw AppleStoreService.Error(description: "parameter notifyUrl invalid", code: 105)
            }
            // 请求支付
            try AppleStoreService.default.request(productIdentifier: productIdentifier!, amount: amount!, tradeNo: tradeNo!, notifyUrl: notifyUrl!, observer: { (_ code:Int, _ message:String,  _ transactionIdentifier:String?) -> Void in
                ICC_SDK.getInstance().evalJavascript(ICC_ScriptBuilder.dispatchEvent(type: "apple_store_result", data: [
                    "code": code,
                    "message": message,
                    "transactionIdentifier": transactionIdentifier as Any
                    ]))
            }) // end closures and request
        } catch let err as AppleStoreService.Error {
            ICC_Logger.error("ICC_Transaction.doPostAppleStroe error(%d), %@", err.code, err.description)
            DispatchQueue.main.async {
                ICC_SDK.getInstance().evalJavascript(ICC_ScriptBuilder.dispatchEvent(type: "apple_store_result", data: [
                    "code": err.code,
                    "message": err.description
                    ]))
            }
        } catch {
        }// end do try
    }
    
    // End calss
}
