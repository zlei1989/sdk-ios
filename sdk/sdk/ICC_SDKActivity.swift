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

public class ICC_SDKActivity : ICC_SDKView {

    private let _core:ICC_Activity = ICC_Activity()
    
    override init() {
        super.init()
        let _ = super.bind(window: self._core)
    }
    
    func createHtmlActivity () {
        self._core.makeKeyAndVisible()
    }
    
    func finishHtmlActivity () {
        self._core.isHidden = true
    }
    
    
}
