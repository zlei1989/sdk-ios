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
    
    /// window对象
    private let _window:UIWindow
    
    /// 显示图像
    private let _image:UIImage
    
    /// 图像View
    private let _imageView:UIImageView

    /// 触摸事件监听
    private var _touchListener:ICC_AssistiveTouchListener?
    
    /// 静止位置范围
    private var stopBound:CGRect = CGRect()
    
    /// 移动最大范围
    private var dragBound:CGRect = CGRect()
    
    /// 消息绑定具柄
    private var _orientationObserver:Any? = nil

    /// 实例对象
    ///
    /// - Parameters:
    ///   - imageData: 图像数据
    ///   - origin: 显示位置
    init(imageData:Data, origin:CGPoint?) {
        // 初始图像
        self._image = UIImage(data: imageData)!
        self._imageView = UIImageView(image: self._image)
        // 调整尺寸（默认iOS像网页一样，自动进行缩放，使用下行代码归一）
        self._imageView.bounds.size = CGSize(
             width: self._image.size.width  * (self._image.scale / UIScreen.main.scale),
            height: self._image.size.height * (self._image.scale / UIScreen.main.scale)
        )
        self._imageView.frame.origin = CGPoint(x:0, y:0)
        self._imageView.layer.shouldRasterize = true
        self._imageView.layer.rasterizationScale = UIScreen.main.scale
        self._imageView.translatesAutoresizingMaskIntoConstraints = false
        self._imageView.backgroundColor = UIColor.clear
        self._imageView.isUserInteractionEnabled = false
        // 初始窗口
        self._window = UIWindow()
        self._window.clipsToBounds = true
        self._window.screen = UIScreen.main
        self._window.windowLevel = UIWindowLevelAlert
        self._window.backgroundColor = UIColor.clear
        self._window.isOpaque = true
        self._window.layer.shouldRasterize = true
        self._window.layer.rasterizationScale = UIScreen.main.scale
        self._window.translatesAutoresizingMaskIntoConstraints = false
//        self._window.isUserInteractionEnabled = true
        self._window.addSubview(self._imageView)
        // 显示与拖动范围
        self.updateBound()
        // 初始显示位置
        self._window.frame = CGRect(
            origin: CGPoint(x:0, y:0),
              size: self._imageView.bounds.size
        )
        self._window.layer.position = origin ?? self.getDefaultOrigin(size: self._imageView.bounds.size)
        // 显示窗口
        self._window.isHidden = false
        // 监视用户行为
        self._window.rootViewController = TouchMoveListener(assistiveTouch:self)
        // 淡出效果
        self.fadeOut()
        // 监听设备旋转事件
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        self._orientationObserver = NotificationCenter.default.addObserver(self, selector: #selector(self.didDeviceOrientation),
                                               name: NSNotification.Name.UIDeviceOrientationDidChange,
                                               object: nil)
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
    
    /// 设备旋转时候触发
    @objc private func didDeviceOrientation() {
        // 更新显示与拖动范围
        self.updateBound()
        // 淡出效果
        self.fadeOut()
    }
    
    /// 更新所有
    private func updateBound() {
        // 显示范围
        self.stopBound = CGRect(
            x: self._imageView.bounds.size.width * 0.5,
            y: self._imageView.bounds.size.height * 0.5,
            width: self._window.screen.bounds.width - self._imageView.bounds.size.width,
            height: self._window.screen.bounds.height - self._imageView.bounds.size.height
        )
        // 拖动范围
        self.dragBound = CGRect(
            x: self._imageView.bounds.size.width * 0.118,
            y: self._imageView.bounds.size.height * 0.118,
            width: self._window.screen.bounds.width + self._imageView.bounds.size.width * -0.118 * 2,
            height: self._window.screen.bounds.height + self._imageView.bounds.size.height * -0.118 * 2
        )
    }
    
    private func getBound(size:CGSize) -> CGRect {
        return CGRect(origin:CGPoint(x: 0, y: 0), size: size)
    }
    
    /// 设置回调处理监听
    ///
    /// - Parameter listener: 监听对象
    func setTouchListener (listener:ICC_AssistiveTouchListener) {
        self._touchListener = listener
    }
    
    /// 浮标淡出
    func fadeOut () {
        ICC_Logger.debug("ICC_AssistiveTouch.fadeOut()")
        // 贴边动画
        dragPropsStop()
        // 淡化效果
        let anim = CABasicAnimation(keyPath: "opacity")
        anim.toValue = 0.382
        anim.duration = 0.4
        anim.isRemovedOnCompletion = false
        anim.fillMode = kCAFillModeForwards
        anim.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
        anim.beginTime = CACurrentMediaTime() + 4
        // 播放动画
        self._imageView.layer.removeAllAnimations()
        self._imageView.layer.add(anim, forKey: "alpha")
    }
    
    /// 浮标淡入
    func fadeIn () {
        ICC_Logger.debug("ICC_AssistiveTouch.fadeIn()")
        // 淡化效果
        let anim = CABasicAnimation(keyPath: "opacity")
        anim.toValue = 1
        anim.duration = 0.2
        anim.isRemovedOnCompletion = false
        anim.fillMode = kCAFillModeForwards
        anim.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
        // 播放动画
        self._imageView.layer.removeAllAnimations()
        self._imageView.layer.add(anim, forKey: "alpha")
    }
    
    /// 浮标移动到屏幕边缘
    func dragPropsStop () {
        ICC_Logger.debug("ICC_AssistiveTouch.dragPropsStop()")
        // 计算最小距离
        let endOrigin = self.getOrigin()
        let origin = ICC_VelocityTracker.getShortestDistance(origin: endOrigin, bound: self.stopBound)
        // 计算动画时长
        var duration:CGFloat = 0.15
        if endOrigin.x > self.stopBound.minX && endOrigin.x < self.stopBound.maxX
            && endOrigin.y > self.stopBound.minY && endOrigin.y < self.stopBound.maxY {
            // 越界延长
            let dx = origin.x - endOrigin.x
            let dy = origin.y - endOrigin.y
            let distance = sqrt(dx * dx + dy * dy)
            let length = min(self.stopBound.width, self.stopBound.height) / 2
            let offset = cos(distance / length * CGFloat.pi / 2) * length / 2
            duration = (distance + offset) / (length / 150)
        }
        // 创建动画
        let anim = CABasicAnimation(keyPath: "position")
        anim.fromValue = endOrigin
        anim.toValue = origin
        anim.duration = CFTimeInterval(duration / 1000)
        anim.isRemovedOnCompletion = false
        anim.fillMode = kCAFillModeBoth
        anim.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
        self.startAnimation(anim: anim)
        // 打印日志
        ICC_Logger.debug("dragPropsStop - startX: %.2f, startY: %.2f, targetX: %.2f, targetX: %.2f, duration:%.2f", endOrigin.x, endOrigin.y, origin.x, origin.y, duration)
        // 通知监听
        self._touchListener?.onMoved(sender: self, origin: origin)
    }
    
    /// 浮标继续惯性移动
    ///
    /// - Parameter scroll: 惯性系数
    func dragThrowProps (scroll:ICC_VelocityTracker.Scroll?) {
        ICC_Logger.debug("ICC_AssistiveTouch.dragThrowProps(ICC_VelocityTracker.Scroll?)")
        if scroll == nil {
            self.fadeOut()
            return
        }
        // 修正边界
        scroll?.crop(bound: self.dragBound)
        let endOrigin = CGPoint(x: scroll!.x, y:scroll!.y)
        let origin = CGPoint(x:scroll!.targetX, y:scroll!.targetY)
        // 播放动画
        let anim = CABasicAnimation(keyPath: "position")
        anim.fromValue = endOrigin
        anim.toValue = origin
        anim.isRemovedOnCompletion = false
        anim.fillMode = kCAFillModeBoth
        anim.duration = CFTimeInterval(scroll!.duration / 1000)
        anim.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
        anim.delegate = DragThrowPropsUpdateListener(assistiveTouch: self)
        self.startAnimation(anim: anim)
        // 输出日志
        ICC_Logger.debug("dragThrowProps - radians: %.4f, distance: %.2f, duration: %.2f", scroll!.radians, scroll!.distance, scroll!.duration)
        ICC_Logger.debug("dragThrowProps - startX: %.2f, startY: %.2f, targetX: %.2f, targetY: %.2f", scroll!.x, scroll!.y, scroll!.targetX, scroll!.targetY)
    }
    
    /// 清空动画列表
    func clearAnimation () {
        objc_sync_enter(self._window)
        self._window.layer.removeAllAnimations()
        objc_sync_exit(self._window)
    }
    
    /// 播放动画
    ///
    /// - Parameter anim: 动画对象
    func startAnimation (anim:CABasicAnimation) {
        objc_sync_enter(self._window)
        if anim.isRemovedOnCompletion != true {
            switch anim.keyPath! {
            case "position":
                self._window.layer.position = anim.toValue as! CGPoint
            default:
                break
            }
        }
        ICC_Logger.debug("ICC_AssistiveTouch.startAnimation %d", anim.hash)
        self._window.layer.removeAllAnimations()
        self._window.layer.add(anim, forKey: "default")
        objc_sync_exit(self._window)
    }
    
    /// 获得浮标位置
    ///
    /// - Returns: 浮标位置
    public func getOrigin () -> CGPoint {
        return self._window.layer.position
    }
    
    /// 计算初始位置
    ///
    /// - Parameter size: 屏幕尺寸
    /// - Returns: 初始位置
    func getDefaultOrigin (size:CGSize) -> CGPoint {
        // return CGPoint(x:0, y:0)
        return CGPoint(
            x: UIScreen.main.bounds.width - size.width * 0.5,
            y: UIScreen.main.bounds.height * 0.5
        )
    }
    
    /// 释放资源
    public func destroy() {
        if self._orientationObserver != nil {
            UIDevice.current.beginGeneratingDeviceOrientationNotifications()
            NotificationCenter.default.removeObserver(self._orientationObserver!)
            UIDevice.current.endGeneratingDeviceOrientationNotifications()
        }
        self._window.layer.removeAllAnimations()
        self._window.layer.removeFromSuperlayer()
        self._window.isHidden = true
        self._window.removeFromSuperview()
        self._window.rootViewController = nil
        self._imageView.image = nil
        self._imageView.removeFromSuperview()
        self._touchListener = nil
    }
    
    /// 触摸操作处理
    /// 相比 UIPanGestureRecognizer 使用 UIViewController 效率更高
    class TouchMoveListener : UIViewController {
        
        /// 浮标句柄
        var assistiveTouch:ICC_AssistiveTouch
        
        /// 触摸点与图标偏移
        var offsetX:CGFloat = 0, offsetY:CGFloat = 0
        
        /// 拖动开始位置
        var startX:CGFloat = 0, startY:CGFloat = 0
        
        /// 最小拖动距离
        var threshold:CGFloat = 0
        
        /// 回弹惯性计算
        var velocityTracker:ICC_VelocityTracker? = ICC_VelocityTracker()
//        var velocityTracker:ICC_VelocityTracker? = nil
        
        /// 是否满足最小移动范围
        var isMoved = false
        
        /// 协议要求
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        /// 构造方法
        ///
        /// - Parameter assistiveTouch: 浮标对象
        init(assistiveTouch:ICC_AssistiveTouch) {
            self.assistiveTouch = assistiveTouch
            super.init(nibName:nil, bundle:nil)
        }
        
        /// 初始回调
        override func viewDidLoad() {
            super.viewDidLoad()
            super.view.isMultipleTouchEnabled = false
        }
        
        /// 拖动开始
        ///
        /// - Parameters:
        ///   - touches: 触点列表
        ///   - event: 事件对象
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            if touches.first == nil {
                return
            }
            let target = self.assistiveTouch._window
            let origin = touches.first!.location(in: nil)
            // 计算居中偏移
            self.offsetX = origin.x
            self.offsetY = origin.y
            // 设置起点
            self.isMoved = false
            self.startX = target.layer.position.x
            self.startY = target.layer.position.y
            // 最小移动阀值
            self.threshold = min(target.frame.width, target.frame.height) * 0.25
            //
            ICC_Logger.debug("ICC_AssistiveTouch drag start, x:%.2f, y:%.2f, offsetX:%.2f, offsetY:%.2f", self.startX, self.startY, self.offsetX, self.offsetY)
            // 停止动画
            self.assistiveTouch.clearAnimation()
            // 播放动画
            self.assistiveTouch.fadeIn()
            // 惯性处理
            self.velocityTracker?.distanceFactor = min(target.frame.width, target.frame.height) * 0.000618
            self.velocityTracker?.resetSample(point: target.layer.position)
        }
        
        /// 拖动事件
        ///
        /// - Parameters:
        ///   - touches: 触点列表
        ///   - event: 触摸事件
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            if touches.first == nil {
                return
            }
            let target = self.assistiveTouch._window
            let origin = touches.first!.location(in: nil)
            // 移动位置
            var toX:CGFloat = floor(target.layer.position.x + origin.x - self.offsetX)
            var toY:CGFloat = floor(target.layer.position.y + origin.y - self.offsetY)
            // 限制出屏
            if toX < self.assistiveTouch.dragBound.minX {
                toX = self.assistiveTouch.dragBound.minX
            } else if toX > self.assistiveTouch.dragBound.maxX {
                toX = self.assistiveTouch.dragBound.maxX
            }
            if toY < self.assistiveTouch.dragBound.minY {
                toY = self.assistiveTouch.dragBound.minY
            } else if toY > self.assistiveTouch.dragBound.maxY {
                toY = self.assistiveTouch.dragBound.maxY
            }
            // 刷新显示
            target.layer.position = CGPoint(x:toX, y:toY)
            // 忽略微动
            if self.isMoved == false {
                if max(abs(toX - self.startX), abs(toY - self.startY)) > self.threshold {
                    self.isMoved = true
                }
            }
            // 惯性处理
            self.velocityTracker?.addSample(point: target.layer.position)
        }
        
        /// 拖动结束
        ///
        /// - Parameters:
        ///   - touches: 触点列表
        ///   - event: 事件对象
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            let target = self.assistiveTouch._window
            ICC_Logger.debug("ICC_AssistiveTouch drag stop, x:%.2f, y:%.2f", target.layer.position.x, target.layer.position.y)
            // 打开浮标
            if self.isMoved != true {
                ICC_Logger.debug("ICC_AssistiveTouch touch(pin)")
                self.assistiveTouch._touchListener?.onTouch(sender: self.assistiveTouch)
            }
            // 惯性处理
            self.assistiveTouch.dragThrowProps(scroll: self.velocityTracker?.computeScroll())
        }
        
        /// 拖动打断
        ///
        /// - Parameters:
        ///   - touches: 触点列表
        ///   - event: 事件对象
        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.touchesEnded(touches, with: event)
        }
        
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
    
    // End sub class

    /// 惯性动画回调
    class DragThrowPropsUpdateListener : NSObject, CAAnimationDelegate {
    
        /// 浮标句柄
        var assistiveTouch:ICC_AssistiveTouch
        
        /// 构造方法
        ///
        /// - Parameter assistiveTouch: 浮标对象
        init(assistiveTouch:ICC_AssistiveTouch) {
            self.assistiveTouch = assistiveTouch
        }
        
        /// 动画结束回调
        ///
        /// - Parameters:
        ///   - anim:
        ///   - flag:
        func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
            self.assistiveTouch.fadeOut()
        }
        
        /// 动画开始回调
        ///
        /// - Parameter anim:
        func animationDidStart(_ anim: CAAnimation) {
        }
        
    }
    
    // End sub class
    
    // End class
}
