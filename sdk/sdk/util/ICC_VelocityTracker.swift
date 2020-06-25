//
//  ICC_VelocityTracker.swift
//  sdk
//
//  Created by 张磊 on 2017/9/19.
//  Copyright © 2017年 游艺春秋网络科技（北京）有限公司. All rights reserved.
//

import Foundation
import UIKit

/// 惯性计算
/// 对比 Android 这个对象执行效率很差，需要参考语言进行特殊优化
final class ICC_VelocityTracker {
    
    /// 预设方向
    ///
    /// - TOP: MinY
    /// - RIGHT: MaxX
    /// - BOTTOM: MaxY
    /// - LEFT: MinX
    enum DIRECTION : Int {
        case TOP = 0
        case RIGHT = 1
        case BOTTOM = 2
        case LEFT = 3
    }
    
    /// 采样数量
    var maxSamples:Int = 5
    
    /// 距离系数
    var distanceFactor:CGFloat = 48
    
    /// 时间系数
    /// 对比 Android 快4倍，猜测是渲染机制不同或代码错误
    var durationFactor:CGFloat = 1
    
    /// 采样队列
    private var _samples:[Sample] = []
    
    /// 计算贴边最短距离
    ///
    /// - Parameters:
    ///   - origin: 当前坐标
    ///   - bound: 边缘范围
    /// - Returns: 最短距离
    static func getShortestDistance (origin:CGPoint, bound:CGRect) -> CGPoint {
        let trbl = [
            origin.y - bound.minY,
            bound.maxX - origin.x,
            bound.maxY - origin.y,
            origin.x - bound.minX
        ]
        // 遍历最短
        var k:DIRECTION = .TOP
        var v = trbl[0]
        for i in 0...3 {
            if trbl[i] > v {
                continue
            }
            k = DIRECTION.init(rawValue: i)!
            v = trbl[i]
        }
        // 设置最短位置
        var target = origin
        switch k {
        case .TOP:
            target.y = bound.minY
        case .RIGHT:
            target.x = bound.maxX
        case .BOTTOM:
            target.y = bound.maxY
        case .LEFT:
            target.x = bound.minX
        }
        // 修正位置越界
        if target.y < bound.minY {
            target.y = bound.minY
        }
        if target.x > bound.maxX {
            target.x = bound.maxX
        }
        if target.y > bound.maxY {
            target.y = bound.maxY
        }
        if target.x < bound.minX {
            target.x = bound.minX
        }
        return target
    }

    /// 计算滚动
    ///
    /// - Returns: 滚动对象
    func computeScroll() -> Scroll {
        // 导出采样
        let end = self.popSample()!
        let begin = self.computeBeginSample(end: end)
        // 结果容器
        let result = Scroll()
        result.radians = begin.radians
        result.x = end.x
        result.y = end.y
        // 返回结果
        if (end.x == begin.x && end.y == begin.y) {
            return result
        }
        let xSpace = end.x - begin.x
        let ySpace = end.y - begin.y
        let distance = sqrt(xSpace * xSpace + ySpace * ySpace)
        let duration = CGFloat(end.timestamp - begin.timestamp)
        // 惯性结果
        let speed = distance / duration
        result.distance = pow(speed, speed / 2) * self.distanceFactor
        result.duration = result.distance / speed * self.durationFactor
        return result
    }

    /// 计算起点采样
    ///
    /// - Parameter end: 采样类型对象
    /// - Returns: 采样类型对象
    private func computeBeginSample(end:Sample) -> Sample {
        var target = end
        // 计算有效采样
        var sample:Sample? = nil
        while (true) {
            sample = self.popSample()
            if (sample == nil) {
                break
            }
            sample!.radians = self.getRadians(center: sample!, target: end)
            if (target.radians > 0) {
                if (abs(target.radians - sample!.radians) > CGFloat.pi * 0.5) { // 方向大于90度改变
                    break
                }
            }
            // 导出采样
            target = sample!
        }
        return target
    }
    
    /// 添加采样
    ///
    /// - Parameter point: 坐标对象
    func addSample(point:CGPoint) {
        self._samples.append(Sample(point))
        self._samples.removeFirst()
    }
    
    
    /// 重置采样
    ///
    /// - Parameter point: 坐标对象
    func resetSample(point:CGPoint) {
        self._samples.removeAll(keepingCapacity:true)
        let val = Sample(point);
        for _ in 0 ... self.maxSamples {
            self._samples.append(val)
        }
    }

    /// 返回并移除最后测采样
    ///
    /// - Returns: @return
    private func popSample() -> Sample? {
        if self._samples.count > 0 {
            return self._samples.removeLast()
        }
        return nil
    }
    
    /// 计算两点之间弧度
    ///
    /// - Parameters:
    ///   - center: center description
    ///   - target: target description
    /// - Returns: return value description
    private func getRadians (center:Sample, target:Sample) -> CGFloat {
        if (center.x == target.x && center.y == target.y) {
            return 255;
        }
        let x = target.x - center.x;
        let y = target.y - center.y;
        let radius = sqrt(x * x + y * y)
        var radians = acos(x / radius)
        if (y < 0) {
            radians = 2 * CGFloat.pi - radians
        }
        return radians
        
    }
    
    /// 采样类型
    /// 网上非官方资料说明 struct 比 class 性能更好
    private struct Sample {
        
        /// 时间
        let timestamp:UInt64
        
        /// 坐标
        let x:CGFloat
        
        /// 坐标
        let y:CGFloat
        
        /// 惯性弧度
        var radians:CGFloat = -1
        
        /// 构造函数
        ///
        /// - Parameters:
        ///   - x: 横向坐标
        ///   - y: 纵向坐标
        init(_ point:CGPoint) {
            self.x = point.x
            self.y = point.y
            self.timestamp = UInt64(NSDate().timeIntervalSince1970 * 1000)
        }
        
    }
    // End sub class
    
    ///
    final class Scroll {
        
        /// 惯性起点坐标
        var x:CGFloat = 0
        
        /// 惯性起点坐标
        var y:CGFloat = 0

        /// 惯性弧度
        var radians:CGFloat = 0

        // 惯性移动距离
        var distance:CGFloat = 0
        
        /// 惯性持续时间
        var duration:CGFloat = 0
        
        /// 最终停留位置
        var targetX:CGFloat = 0
        
        /// 最终停留位置
        var targetY:CGFloat = 0
        
        /// 获得边界裁切后的目标位置
        ///
        /// - Parameter bound:
        /// - Returns:
        func crop(bound:CGRect) {
            // 相对目标位置
            var offset = CGPoint()
            offset.x = self.distance * cos(self.radians)
            offset.y = self.distance * sin(self.radians)
            // 绝对目标位置
            self.targetX = self.x + offset.x
            self.targetY = self.y + offset.y
            // 双向边界触点
            var offsetV = CGPoint(x: offset.x, y: offset.y)
            var offsetH = CGPoint(x: offset.x, y: offset.y)
            // Vertical
            if self.targetY < bound.minY {
                let propTop = self.y - bound.minY
                offsetV.y = -propTop
                offsetV.x = offsetV.y / tan(self.radians)
            } else if self.targetY > bound.maxY {
                let propBottom = bound.maxY - self.y
                offsetV.y = propBottom
                offsetV.x = offsetV.y / tan(self.radians)
            }
            // Horizontal
            if (self.targetX > bound.maxX) {
                let propRight = bound.maxX - self.x
                offsetH.x = propRight
                offsetH.y = offsetH.x * tan(self.radians)
            } else if (self.targetX < bound.minX) {
                let propLeft = self.x - bound.minX
                offsetH.x = -propLeft
                offsetH.y = offsetH.x * tan(self.radians)
            }
            // 计算最远边界
            let distanceV = sqrt(offsetV.x * offsetV.x + offsetV.y * offsetV.y)
            let distanceH = sqrt(offsetH.x * offsetH.x + offsetH.y * offsetH.y)
            // 最先碰触的边
            if distanceV > distanceH {
                self.targetX = self.x + offsetH.x
                self.targetY = self.y + offsetH.y
                self.duration = distanceH / self.distance * self.duration//持续时间
                self.distance = distanceH
            } else {
                self.targetX = self.x + offsetV.x
                self.targetY = self.y + offsetV.y
                self.duration = distanceV / self.distance * self.duration//持续时间
                self.distance = distanceV
            }
        }
        
    }
    // End sub class
    
    // End class
}
