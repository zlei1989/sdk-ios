//
//  ICC_SDKView.swift
//  sdk
//
//  Created by 张磊 on 2017/8/28.
//  Copyright © 2017年 游艺春秋网络科技（北京）有限公司. All rights reserved.
//

import Foundation

<<<<<<< HEAD
///
=======
>>>>>>> parent of db0f196... 20170831张磊
public class ICC_SDKView {

    func evalJavascript(_ script:String){
<<<<<<< HEAD
        ICC_Logger.debug("ICC_SDKView.evalJavascript(%@)", script);
        // 追加执行队列
        objc_sync_enter(self._evalQueus)
        self._evalQueus.append(script)
        objc_sync_exit(self._evalQueus)
        // 执行队列代码
        self.evalJavascript()
    }
    
    /// 执行队列中的 JavaScript 代码
    func evalJavascript () {
        if (self.isActive() != true){
            ICC_Logger.warn("ICC_SDKView.IsActive() equal to false")
            Toast.makeText(text: ICC_Constants.SDK_TEST_STARTING, duration: Toast.LENGTH_SHORT)
            return
        }
        ICC_Logger.debug("ICC_SDKView.evalJavascript(), Queus:%d", self._evalQueus.count)
        objc_sync_enter(self._evalQueus)
        while self._evalQueus.isEmpty == false {
            self._core.stringByEvaluatingJavaScript(from: self._evalQueus.removeFirst())
        }
        objc_sync_exit(self._evalQueus)
    }
    
    /// 清理队列中的 JavaScript 代码
    func clearJavascript () {
        ICC_Logger.debug("ICC_SDKView.clearJavascript()")
        objc_sync_enter(self._evalQueus)
        self._evalQueus.removeAll()
        objc_sync_exit(self._evalQueus)
    }
    
    /// 队列是否处于活跃状态
    func isActive () -> Bool {
        return self._isActive
    }
    
    /// 设置队列状态
    func setActive (state flag:Bool){
        self._isActive = flag
        if flag {
            self.evalJavascript()
        }
    }
    
    /// 绑定浏览器到窗口
    func bind(window:UIWindow) -> Bool {
        window.addSubview(self._core)
        return true
    }
    
    /// 接触浏览器绑定
    func unbind(window:UIWindow) -> Bool {
        self._core.removeFromSuperview()
        return true
=======
        ICC_Logger.debug(script);
>>>>>>> parent of db0f196... 20170831张磊
    }

}
