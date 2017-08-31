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

/// 定制窗口
class ICC_Activity : UIWindow {

    /// 初始窗口大小
    convenience init (){
        self.init(frame:UIScreen.main.bounds)
        self.windowLevel = UIWindowLevelAlert
        self.backgroundColor = UIColor.clear
    }
    
    //        self.window .backgroundColor = UIColor.red
    //        self.window .windowLevel = UIWindowLevelAlert
    //        self.window .makeKeyAndVisible()
    //        self.window.isHidden = true;
    
}
