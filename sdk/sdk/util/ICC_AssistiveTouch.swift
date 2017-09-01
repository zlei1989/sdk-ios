//
//  ICC_AssistiveTouch.swift
//  sdk
//
//  Created by 张磊 on 2017/9/1.
//  Copyright © 2017年 游艺春秋网络科技（北京）有限公司. All rights reserved.
//

// 引用类库
import Foundation
import UIKit

///
public class ICC_AssistiveTouch {
    
    ///
    private let _window = UIWindow()
    
    ///
    private let _image:UIImage
    
    ///
    private let _imageView:UIImageView
    
    ///
    private var _touchListener:ICC_AssistiveTouchListener?

    
    /// 实例对象
    init(imageData:Data, origin:CGPoint?) {
        // 初始图像
        self._image = UIImage(data: imageData)!
        self._imageView = UIImageView(image: self._image)
        // 初始窗口
        self._window.screen = UIScreen.main
        self._window.windowLevel = UIWindowLevelAlert
        self._window.backgroundColor = UIColor.clear
        self._window.isOpaque = true
        self._window.frame = CGRect(origin: origin ?? self.getDefaultOrigin(), size: self._image.size)
        self._window.addSubview(self._imageView)
        // 显示窗口
        self._window.isHidden = false
        
        // 临时乱写，抖动问题，写拖拽时候解决
        self._window.isUserInteractionEnabled = true
        self._window.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(self.onTouch))
        )
    }
    
    ///
    @objc func onTouch (_ sender:UIWindow) {
        if self._touchListener != nil {
            self._touchListener?.onTouch(sender: self)
        }
    }
    
    /// 计算初始位置
    func getDefaultOrigin () -> CGPoint {
        return CGPoint(
            x: UIScreen.main.bounds.width - self._image.size.width,
            y: (UIScreen.main.bounds.height - self._image.size.height) * 0.5
        )
    }
    
    ///
    public func setTouchListener (listener:ICC_AssistiveTouchListener) {
        self._touchListener = listener
    }
    
    /// 销毁资源
    public func destory() {
        self._window.resignKey()
        self._window.isHidden = true;
    }

// end class
}
