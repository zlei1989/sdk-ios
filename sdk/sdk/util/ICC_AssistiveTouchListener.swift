//
//  ICC_AssistiveTouchListener.swift
//  sdk
//
//  Created by 张磊 on 2017/9/1.
//  Copyright © 2017年 游艺春秋网络科技（北京）有限公司. All rights reserved.
//

// 引用类库
import Foundation
import UIKit

/// 浮标事件处理接口
public protocol ICC_AssistiveTouchListener {

    /// 发生触击事件
    ///
    /// - Parameter sender: 浮标对象
    func onTouch(sender:ICC_AssistiveTouch)

    /// 发生位置移动
    ///
    /// - Parameters:
    ///   - sender: 浮标对象
    ///   - origin: 停留位置
    func onMoved(sender:ICC_AssistiveTouch, origin:CGPoint)
    
    // End class
}
