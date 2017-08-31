//
//  ViewController.swift
//  example
//
//  Created by 张磊 on 2017/7/28.
//  Copyright © 2017年 游艺春秋网络科技（北京）有限公司. All rights reserved.
//

import UIKit
import sdk

/// 演示范例界面控制器
class ViewController: UIViewController {

    
    /// 测试 账号登录
    @IBAction func onClickLogin(_ sender: Any) {
        ICC_SDK.getInstance().login(callback: LoginCallback())
    }
    
    /// 测试 提交账号数据
    @IBAction func onClickPush(_ sender: Any) {
        let core = ICC_SDK.getInstance()
        let data = ICC_AcctData()
        core.pushAcctData(data:data, trigger: .CREATE)
        core.pushAcctData(data:data, trigger: .UPDATE)
        core.pushAcctData(data:data, trigger: .LOGIN)
        core.pushAcctData(data:data, trigger: .PAY)
        core.pushAcctData(data:data, trigger: .LOGOUT)
        core.pushAcctData(data:data, trigger: .EXIT)
    }
    
    @IBAction func onClickPay(_ sender: Any) {
    }
    
    @IBAction func onClickLogout(_ sender: Any) {
        ICC_SDK.getInstance().logout(callback: LogoutCallback())
    }
    
    @IBAction func onClickQuit(_ sender: Any) {
        exit(0)
    }
    
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初始内核
        let _:ICC_SDK  = ICC_SDK.getInstance()
    }

    ///
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

// end class
}

/// 登录回调托管对象
class LoginCallback: ICC_Callback {
    public func result(resultJSON: String) {
//        JSONSerialization
        NSLog(resultJSON);
    }
}

/// 注销回调托管对象
class LogoutCallback: ICC_Callback {
    public func result(resultJSON: String) {
        NSLog(resultJSON);
    }
}

