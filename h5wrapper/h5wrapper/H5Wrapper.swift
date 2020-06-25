//
//  ZLei_Wrapper.swift
//  sdk
//
//  Created by 张磊 on 2017/7/29.
//  Copyright © 2017年 游艺春秋网络科技（北京）有限公司. All rights reserved.
//

// 引用类库
import UIKit
import CoreGraphics
import Foundation

/// HTML5 应用外壳核心对象
public class H5Wrapper : SDKCallbacks {
  
    /// 回调函数管理对象
    private let callbacks:CallbackManager = CallbackManager();
    
    /// 构造函数（禁止外部实例）
    private override init (){
        super.init()
    }

}
