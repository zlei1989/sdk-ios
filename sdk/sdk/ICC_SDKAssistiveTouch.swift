//
//  ICC_SDKAssistiveTouch.swift
//  sdk
//
//  Created by 张磊 on 2017/8/28.
//  Copyright © 2017年 游艺春秋网络科技（北京）有限公司. All rights reserved.
//

// 引用类库
import Foundation

///
public class ICC_SDKAssistiveTouch : ICC_SDKActivity {
    
    
    private var _core:ICC_AssistiveTouch? = nil
   
    
    func setAssistiveTouch (imageData:Data) {
        self._core = ICC_AssistiveTouch(imageData:imageData, origin: self.readPosition())
        self._core?.setTouchListener(listener: Listener())
    }
    
    
    func readPosition () -> CGPoint? {
        return nil
    }
    
    func removeAssistiveTouch () {
        self._core?.destory()
        self._core = nil
    }
    
    private class Listener : ICC_AssistiveTouchListener {
        func onTouch(sender: ICC_AssistiveTouch) {
            ICC_SDK.getInstance().evalJavascript(ICC_ScriptBuilder.dispatchEvent(type: "assistive_touch"))
        }
        
        func onMoved(sender: ICC_AssistiveTouch, origin: CGPoint) {
            ICC_SDK.getInstance().evalJavascript(ICC_ScriptBuilder.dispatchEvent(type: "assistive_moved"))
        }
    }
    
    // end class
}
