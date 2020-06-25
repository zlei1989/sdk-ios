//
//  ICC_Activity.swift
//  sdk
//
//  Created by 张磊 on 2017/8/28.
//  Copyright © 2017年 游艺春秋网络科技（北京）有限公司. All rights reserved.
//

// 引用类库
import Foundation
import UIKit

/// 窗口对象
class ICC_Activity : UIWindow {
    
    private var _orientationObserver:Any?
    
    /// 初始窗口大小
    convenience init() {
        self.init(frame:UIScreen.main.bounds)
        self.windowLevel = UIWindowLevelAlert
        self.screen = UIScreen.main
        // 背景透明
        self.backgroundColor = UIColor.clear
        self.isOpaque = false
        self.isUserInteractionEnabled = true
        self.rootViewController = ThatViewController()
        // 监听设备旋转事件
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        self._orientationObserver = NotificationCenter.default.addObserver(self, selector: #selector(self.didDeviceOrientation),
                                               name: NSNotification.Name.UIDeviceOrientationDidChange,
                                               object: nil)
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
    
    /// 释放资源
    deinit {
        if self._orientationObserver != nil {
            UIDevice.current.beginGeneratingDeviceOrientationNotifications()
            NotificationCenter.default.removeObserver(self._orientationObserver!)
            UIDevice.current.endGeneratingDeviceOrientationNotifications()
        }
        self.rootViewController = nil
    }
    
    /// 设备旋转时候触发
    func didDeviceOrientation() {
        self.frame = self.screen.bounds
        switch UIDevice.current.orientation {
        case .portrait:
            ICC_Logger.info("Device Orientation, Home to bottom")
        case .portraitUpsideDown:
            ICC_Logger.info("Device Orientation, Home to top")
        case .landscapeLeft:
            ICC_Logger.info("Device Orientation, Home to left")
        case .landscapeRight:
            ICC_Logger.info("Device Orientation, Home to right")
        case .faceDown:
            ICC_Logger.info("Device Orientation, Screen to down")
        case .faceUp:
            ICC_Logger.info("Device Orientation, Screen to up")
        default:
            NSLog("Device Orientation")
        }
    }
    
    /// 当前对象控制器
    class ThatViewController : UIViewController {
        
        /// 是否自动翻转
        override var shouldAutorotate: Bool {
            return true
        }
        
        /// 反转支持类型
        override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            return UIInterfaceOrientationMask.all
        }
        
        /// 内存不足时候释放
        override func didReceiveMemoryWarning() {
//            super.didReceiveMemoryWarning();
        }
    }
    // End class
}
