//
//  SDKAssistiveTouch.swift
//  sdk
//
//  Created by 张磊 on 2017/8/28.
//  Copyright © 2017年 游艺春秋网络科技（北京）有限公司. All rights reserved.
//

// 引用类库
import Foundation
import UIKit

///
public class SDKAssistiveTouch : SDKActivity {

    /// 助手指针
    private var _core:AssistiveTouch? = nil
    
    // 回调对象
    private let _touchListener = Listener()
    
    /// 系构清理
    deinit {
        self.removeAssistiveTouch()
    }
   
    /// 设置浮标
    func setAssistiveTouch (imageData:Data) {
        Logger.debug("SDKAssistiveTouch.setAssistiveTouch(Data)")
        DispatchQueue.main.async {
            self._core?.destroy()
            self._core = AssistiveTouch(imageData:imageData, origin: self.readPosition())
            self._core?.setTouchListener(listener: self._touchListener)
        }
    }
    
    /// 读取浮标位置
    ///
    /// - Returns: 最后拖动停留位置
    func readPosition () -> CGPoint? {
        // 读取文件
        let filename = NSHomeDirectory() + "/Documents/ICCGAME_SDK/AssistiveTouch.pos"
        if let data = try? NSMutableData(contentsOf: URL(fileURLWithPath: filename), options: .uncached) {
            // 重载数据
            var cont = CGPoint()
            data.getBytes(&cont, range: NSMakeRange(0, MemoryLayout.size(ofValue: cont)))
            return cont
        }
        return nil
    }
    
    /// 保存浮标位置
    ///
    /// - Parameter point: 最后拖动停留位置
    func savePosition (point:CGPoint) {
        let dir = NSHomeDirectory() + "/Documents/ICCGAME_SDK"
        if FileManager.default.fileExists(atPath: dir) != true {
            try? FileManager.default.createDirectory(at: URL.init(fileURLWithPath: dir), withIntermediateDirectories: true, attributes: nil)
        }
        // 构造数据
        let data = NSMutableData()
        var cont = point
        data.append(&cont, length: MemoryLayout.size(ofValue: cont))
        // 写入文件
        let filename = dir + "/AssistiveTouch.pos"
        try? data.write(to: URL(fileURLWithPath: filename), options: .atomic)
    }
    
    /// 销毁浮标
    func removeAssistiveTouch () {
        DispatchQueue.main.async {
            self._core?.destroy()
            self._core = nil
        }
    }
    
    /// 监听事件处理器
    private class Listener : AssistiveTouchListener {
        /// 触摸浮标回调
        ///
        /// - Parameter sender: 浮标对象
        func onTouch(sender: AssistiveTouch) {
            SDK.getInstance().evalJavascript(ScriptBuilder.dispatchEvent(type: "assistive_touch"))
        }
        
        /// 拖动结束回调
        ///
        /// - Parameters:
        ///   - sender: 浮标对象
        ///   - origin: 停留位置
        func onMoved(sender: AssistiveTouch, origin: CGPoint) {
            SDK.getInstance().evalJavascript(ScriptBuilder.dispatchEvent(type: "assistive_moved"))
            SDK.getInstance().savePosition(point: origin)
        }
    }
    
    // End class
}
