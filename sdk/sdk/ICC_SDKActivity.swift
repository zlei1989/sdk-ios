//
//  ICC_SDKActivity.swift
//  sdk
//
//  Created by 张磊 on 2017/8/28.
//  Copyright © 2017年 游艺春秋网络科技（北京）有限公司. All rights reserved.
//

// 引用类库
import Foundation
import UIKit

///
public class ICC_SDKActivity : ICC_SDKView {

<<<<<<< HEAD
    ///
    private var _core:ICC_Activity?
    
    /// 创建窗口
    func createHtmlActivity () {
        // 对内存机制不是非常了解，为防止回收，重新实例
        // Android 也是如此
        self._core = ICC_Activity()
        let _ = super.bind(window: self._core!)
        self._core?.makeKeyAndVisible()
    }
    
    /// 销毁窗口
    func finishHtmlActivity () {
        if (self._core != nil) {
            let _ = super.unbind(window: self._core!)
            self._core?.resignKey()
        }
        self._core = nil
    }
=======
    let _htmlWindow:ICC_Activity = ICC_Activity()
    
>>>>>>> parent of db0f196... 20170831张磊
    
// end class
}
