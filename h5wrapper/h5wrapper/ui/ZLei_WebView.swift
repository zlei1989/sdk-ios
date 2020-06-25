//
//  WebView.swift
//  sdk
//
//  Created by 张磊 on 2017/8/29.
//  Copyright © 2017年 游艺春秋网络科技（北京）有限公司. All rights reserved.
//

// 引用类库
import Foundation
import UIKit
import JavaScriptCore
import WebKit

/// 定制网页
class WebView : UIWebView {
    
    ///
    class WvDelegate : NSObject, UIWebViewDelegate {
        
        /// JavaScript运行环境类
        var jsContext:JSContext?

        /// avaScript控制台类
        var jsConsole = JsConsole()

        /// 实例HTML5Interface对象
        var jsModelInterface = HTML5Interface()

        /// WebView开始加载
        ///
        /// - Parameter webView:
        func webViewDidStartLoad(_ webView: UIWebView) {
            self.jsContext = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext
            self.jsContext?.exceptionHandler = { (context:JSContext?, exception:JSValue?) in
                Logger.error("WebView.jsContextOnExcption(%@)", (exception?.toString())!)
            }
            #if DEBUG
            self.jsContext?.setObject(self.jsConsole, forKeyedSubscript: "console" as NSCopying & NSObjectProtocol)
            #endif
            self.jsContext?.setObject(self.jsModelInterface, forKeyedSubscript: "ICCGAME_IOS" as NSCopying & NSObjectProtocol)
        }

        /// WebView加载结束
        ///
        /// - Parameter webView:
        func webViewDidFinishLoad(_ webView: UIWebView) {
            // let _ = self.jsContext?.evaluateScript("alert(window.ICCGAME_IOS.tip)")
        }
    
        ///
        
        /// WebView加载中
        ///
        /// - Parameters:
        ///   - webView: 
        ///   - error:
        func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
            Logger.error("WebView.didFailLoadWithError(%@)", error.localizedDescription)
        }

        // End class
    }
    
    /// 托管对象（防止回收）
    let wvDelegate = WvDelegate()
    
    /// 初始对象
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
        self.delegate = self.wvDelegate
        // 执行内置脚本
        self.loadDefultData()
        // 重置代理
        let userAgent = UIWebView().stringByEvaluatingJavaScript(from: "navigator.userAgent")! + " ICCGAME SDK"
        UserDefaults.standard.register(defaults: ["UserAgent" : userAgent])
        // 透明背景
        self.backgroundColor = UIColor.clear
        self.isOpaque = false
        self.isUserInteractionEnabled = true
    }
    
    /// 释放资源
    deinit {
        self.delegate = nil
    }

    /// 载入数据
    func loadDefultData() {
        // 载入本地配置
        let cfg = self.getAssetJSON() as! [String : String]?
        // 映射资源地址
        var remoteUrl:URL?
        if cfg?.index(forKey: "remoteUrl") != nil {
            remoteUrl = URL(string: (cfg?["remoteUrl"]!)!)!
        }
        if remoteUrl == nil {
            remoteUrl = URL(string: Constants.SDK_REMOTE_URL)!;
        }
        // 映射资源内容
        var localCode:String?
        if cfg?.index(forKey: "localCode") != nil {
            let decodedData = NSData(base64Encoded: (cfg?["localCode"]!)!, options: .ignoreUnknownCharacters)
            localCode = NSString(data: decodedData! as Data, encoding: String.Encoding.utf8.rawValue) as String?
        }
        // 执行代码
        if localCode == nil {
            Logger.debug("WebView.loadURL(%@)", (remoteUrl?.absoluteString)!)
            self.loadRequest(URLRequest(url: remoteUrl!))
        } else {
            Logger.debug("WebView.loadHTMLString(String(hash:%@, size:%d), %@)", self.hash(localCode), (localCode?.count)!, (remoteUrl?.absoluteString)!)
            self.loadHTMLString(localCode!, baseURL: remoteUrl)
        }
    }
    
    /// 获得资源对象
    func getAssetJSON() -> Any? {
        guard let path = Bundle.main.path(forResource: Constants.SDK_CONF_PATH, ofType: nil) else {
            Logger.warn("Asset %@ not found", Constants.SDK_CONF_PATH)
            return nil
        }
        guard let str = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            Logger.warn("Asset %@ read error", Constants.SDK_CONF_PATH)
            return nil
        }
        guard let obj = try? JSONSerialization.jsonObject(with: str, options: .mutableContainers) else {
            Logger.warn("Asset %@ parse error", Constants.SDK_CONF_PATH)
            return nil
        }
        return obj
    }

    /// 文本哈希
    func hash(_ val:String?) -> String {
        if val == nil {
            return "NULL"
        }
        let str = val?.cString(using: .utf8)
        let buf = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(str!,(CC_LONG)(strlen(str!)), buf)
        let res = NSMutableString()
        for i in 0 ..< 16 {
            res.appendFormat("%02x", buf[i])
        }
        free(buf)
        return res as String
    }
    
    // End class
}
