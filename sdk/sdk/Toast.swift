//
//  Test.swift
//  sdk
//
//  Created by 张磊 on 2017/8/30.
//  Copyright © 2017年 游艺春秋网络科技（北京）有限公司. All rights reserved.
//

import Foundation
import CoreGraphics


import UIKit



/// 临时，后期细化
class Toast: NSObject {
    
    ///
    public static let LENGTH_SHORT = CFTimeInterval(2)
    
    ///
    public static let LENGTH_LONG = CFTimeInterval(3.5)
    
    ///
    public static func makeText(text:String, duration:CFTimeInterval){
        ToastView.instance.showToast(content: text, duration: duration)
    }
    
    
}


//弹窗工具
class ToastView : NSObject{
    
    
    class AnimDelegate: NSObject, CAAnimationDelegate {
        
        /// weak
        private var _element:UIWindow
        
        ///
        init(element:UIWindow) {
            self._element = element
            
        }
        
        //／ 动画开始回调
        func animationDidStart(_ anim: CAAnimation) {
        }
        
        //／ 动画结束回调
        func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
            self._element.resignKey()
            self._element.isHidden = true
            // 此处不确定会不会产生内存泄漏
        }
    }
    
    static var instance : ToastView = ToastView()
    
    private let rv = UIApplication.shared.keyWindow?.subviews.first as UIView!
    
    //显示加载圈圈
    //    func showLoadingView() {
    //        clear()
    //        let frame = CGRect(x:0, y:0, width:78, height:78)
    //
    //        let loadingContainerView = UIView()
    //        loadingContainerView.layer.cornerRadius = 12
    //        loadingContainerView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.8)
    //
    //        let indicatorWidthHeight :CGFloat = 36
    //        let loadingIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    //        loadingIndicatorView.frame = CGRect(x:frame.width/2 - indicatorWidthHeight/2, y:frame.height/2 - indicatorWidthHeight/2, width:indicatorWidthHeight, height:indicatorWidthHeight)
    //        loadingIndicatorView.startAnimating()
    //        loadingContainerView.addSubview(loadingIndicatorView)
    //
    //        let window = UIWindow()
    //        window.backgroundColor = UIColor.clear
    //        window.frame = frame
    //        loadingContainerView.frame = frame
    //
    //        window.windowLevel = UIWindowLevelAlert
    //        window.center = CGPoint(x: (rv?.center.x)!, y: (rv?.center.y)!)
    //        window.isHidden = false
    //        window.addSubview(loadingContainerView)
    //    }
    
    //弹窗图片文字
    func showToast(content:String, duration:CFTimeInterval=1.5) {
        
        let txt = UILabel()
        txt.textColor = UIColor.white
        txt.text = content
        txt.adjustsFontSizeToFitWidth = true
        txt.sizeToFit();
        txt.frame = CGRect(
            origin: CGPoint(
                x: Double(UIFont.labelFontSize),
                y: (Double(UIFont.labelFontSize) * 2 - Double(txt.bounds.height)) * 0.5
            ),
            size: txt.bounds.size
        )
        
        let box = UIView()
        box.layer.cornerRadius = UIFont.labelFontSize * 0.382
        box.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.7)
        box.frame = CGRect(
            x: 0.0,
            y: 0.0,
            width: Double(txt.bounds.width) + (Double(UIFont.labelFontSize) * 2),
            height: Double(UIFont.labelFontSize) * 2
        )
        box.addSubview(txt)
        
        let win = UIWindow()
        win.backgroundColor = UIColor.clear
        win.windowLevel = UIWindowLevelAlert
        win.frame = box.frame
        win.center = CGPoint(x: (rv?.center.x)!, y: (rv?.center.y)! * 16/10)
        win.isHidden = false
        win.addSubview(box)
        
        let ani = self.getToastAnimation(duration)
        ani.delegate = AnimDelegate(element: win)
        box.layer.add(ani, forKey: "animation")
        
        // 显示通知
        win.isHidden = false
    }
    
    
    //弹窗动画
    func getToastAnimation(_ duration:CFTimeInterval) -> CAAnimation{
        // 大小变化动画
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimation.keyTimes = [0, 0.1, 0.9, 1]
        scaleAnimation.values = [0.5, 1, 1, 0.5]
        scaleAnimation.duration = duration
        
        // 透明度变化动画
        let opacityAnimaton = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimaton.keyTimes = [0, 0.8, 1]
        opacityAnimaton.values = [0.5, 1, 0]
        opacityAnimaton.duration = duration
        
        // 组动画
        let group = CAAnimationGroup()
        group.animations = [scaleAnimation, opacityAnimaton]
        group.duration = duration
        group.repeatCount = 0
        
        return group
    }
    
}
