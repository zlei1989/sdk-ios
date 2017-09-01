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

class ICC_Activity : UIWindow {
    
    ///
    class RootViewController : UIViewController {
    }
    
    /// 防止窗口回收
    private let _viewController = RootViewController()

<<<<<<< HEAD
    /// 初始窗口大小
    convenience init () {
        self.init(frame:UIScreen.main.bounds)
        self.windowLevel = UIWindowLevelAlert
        self.screen = UIScreen.main
        // 背景透明
        self.backgroundColor = UIColor.clear
        self.isOpaque = false
        // 防止回收
//        self.rootViewController = self._viewController
    }

// end class
=======
    public init (){
        super.init(frame: UIScreen.main.bounds)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }

    //        self.window .backgroundColor = UIColor.red
    //        self.window .windowLevel = UIWindowLevelAlert
    //        self.window .makeKeyAndVisible()
    //        self.window.isHidden = true;
    
>>>>>>> parent of db0f196... 20170831张磊
}
