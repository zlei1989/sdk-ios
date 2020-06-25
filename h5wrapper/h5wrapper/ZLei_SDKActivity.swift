//
//  SDKActivity.swift
//  sdk
//
//  Created by 张磊 on 2017/8/28.
//  Copyright © 2017年 游艺春秋网络科技（北京）有限公司. All rights reserved.
//

// 引用类库
import Foundation
import UIKit

///
public class SDKActivity : SDKView {

    /// 当前活动窗口
    private var _core:Activity?
    
    private let _lock = NSObject()

    /// 创建窗口
    func createHtmlActivity () {
        // 对内存机制不是非常了解，为防止回收，重新实例
        // Android 也是如此
        objc_sync_enter(self._lock)
        DispatchQueue.main.async {
            self._core = Activity()
            let _ = super.bind(window: self._core!)
            self._core?.makeKeyAndVisible()
        }
        objc_sync_exit(self._lock)
    }

    /// 销毁窗口
    func finishHtmlActivity () {
        objc_sync_enter(self._lock)
        DispatchQueue.main.async {
            if (self._core != nil) {
                let _ = super.unbind(window: self._core!)
            }
            self._core?.resignKey()
            self._core = nil
        }
        objc_sync_exit(self._lock)
    }
    
    // End class
}
