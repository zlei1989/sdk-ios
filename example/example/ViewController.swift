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
    
    /// 程序启动后即可初始化
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初始内核
        let _:ICC_SDK = ICC_SDK.getInstance()
        // 初始界面
        self.initUI()
        // 屏幕旋转
        let _ = NotificationCenter.default.addObserver(self, selector: #selector(self.onOrientationChange),
                                                                 name: NSNotification.Name.UIDeviceOrientationDidChange,
                                                               object: nil)
    }
    
    /// 测试 账号登录
    ///
    /// - Parameter sender: 按钮对象
    @IBAction func onClickLogin(_ sender: Any) {
        ICC_SDK.getInstance().login(callback: LoginCallback())
    }
    
    /// 测试 注销登录
    ///
    /// - Parameter sender: 按钮对象
    @IBAction func onClickLogout(_ sender: Any) {
        ICC_SDK.getInstance().logout(callback: LogoutCallback())
    }
    
    /// 测试 提交账号数据
    ///
    /// - Parameter sender: 按钮对象
    @IBAction func onClickPush(_ sender: Any) {
        let core = ICC_SDK.getInstance()
        let data = ICC_AcctData()
            .setBalance(str:"600") // 用户余额
            .setCreated(str:"2018-05-31 18:00:00") // 角色创建时间
            .setId(str:"1") // 用户标识
            .setLv(str:"7") // 角色等级
            .setPartyId(str:"9") // 工会，帮派标识
            .setPartyName(str:"码农小组") // 工会，帮派名称
            .setRoleId(str:"3") // 角色标识
            .setRoleName(str:"程序猿") // 角色名称
            .setServerId(str:"5") // 所在服务器标识
            .setServerName(str:"开发服") // 所在服务器名称
            .setVip(str:"0") // VIP 等级
        // 适应时机调用以下方法
        core.pushAcctData(data:data, trigger: .CREATE) // 账号创建
        core.pushAcctData(data:data, trigger: .UPDATE) // 角色升级
        core.pushAcctData(data:data, trigger: .LOGIN) // 账号登录
        core.pushAcctData(data:data, trigger: .TRANSACTION) // 支付
        core.pushAcctData(data:data, trigger: .LOGOUT) // 注销登录
        core.pushAcctData(data:data, trigger: .EXIT) // 退出游戏
    }
    
    /// 测试 支付
    ///
    /// - Parameter sender: 按钮对象
    @IBAction func onClickPay(_ sender: Any) {
        if DevUtil.acctGameUserId == 0 {
            return
        }
        // 模拟服务端临时接口
        let tradeInfo = DevUtil.genTradeInfo(service: 2193064, content: "[{\"id\":20,\"name\":\"元宝\",\"count\":1,\"price\":600}]", totalFee: 600, acctGameUserId: DevUtil.acctGameUserId)
        // 唤醒支付界面
        ICC_SDK.getInstance().transaction(tradeInfo: tradeInfo, callback: PayCallback())
    }
    
    
    /// 退出游戏
    ///
    /// - Parameter sender: 按钮对象
    @IBAction func onClickExit(_ sender: Any) {
        ICC_SDK.getInstance().exit(callback: ExitCallback())
    }
    
    
    /// 初始界面
    func initUI () {
        // 清空界面
        while (self.view.subviews.count > 0) {
            self.view.subviews.last?.removeFromSuperview()
        }
        
        // 计算初始坐标
        let btnW:CGFloat = 128
        let btnH:CGFloat = 32
        let btnS:CGFloat = 8
        let x:CGFloat = UIScreen.main.bounds.size.width / 2 - btnW / 2
        var y:CGFloat = UIScreen.main.bounds.size.height / 2 - ((btnH * 5) + (btnS * 4)) / 2
        
        // 添加 登录 按钮
        let loginBtn = UIButton(type: .system)
        loginBtn.frame = CGRect(x:x, y:y, width:btnW, height:btnH)
        loginBtn.setTitle("账号登录", for: .normal)
        loginBtn.addTarget(self, action:#selector(self.onClickLogin), for:.touchUpInside)
        self.view.addSubview(loginBtn)
        
        // 添加 提交 按钮
        let pushBtn = UIButton(type: .system)
        y += btnH + btnS
        pushBtn.frame = CGRect(x:x, y:y, width:btnW, height:btnH)
        pushBtn.setTitle("提交数据", for: .normal)
        pushBtn.addTarget(self, action:#selector(self.onClickPush), for:.touchUpInside)
        self.view.addSubview(pushBtn)
        
        // 添加 支付 按钮
        let payBtn = UIButton(type: .system)
        y += btnH + btnS
        payBtn.frame = CGRect(x:x, y:y, width:btnW, height:btnH)
        payBtn.setTitle("充值支付", for: .normal)
        payBtn.addTarget(self, action:#selector(self.onClickPay), for:.touchUpInside)
        self.view.addSubview(payBtn)
        
        // 添加 注销 按钮
        let logoutBtn = UIButton(type: .system)
        y += btnH + btnS
        logoutBtn.frame = CGRect(x:x, y:y, width:btnW, height:btnH)
        logoutBtn.setTitle("注销登录", for: .normal)
        logoutBtn.addTarget(self, action:#selector(self.onClickLogout), for:.touchUpInside)
        self.view.addSubview(logoutBtn)
        
        // 添加 退出 按钮
        let exitBtn = UIButton(type: .system)
        y += btnH + btnS
        exitBtn.frame = CGRect(x:x, y:y, width:btnW, height:btnH)
        exitBtn.setTitle("注销登录", for: .normal)
        exitBtn.addTarget(self, action:#selector(self.onClickExit), for:.touchUpInside)
        self.view.addSubview(exitBtn)
    }
    
    
    /// 屏幕旋转后刷新界面
    ///
    /// - Parameter notify:
    @objc func onOrientationChange (_ notify: NSNotification) {
        self.initUI()
    }
    
    // end class
}


/// 登录回调托管对象
class LoginCallback: ICC_Callback {
    func result(resultJSON:String) {
        // 转换 JSON 字符串成对象
        let obj = try! JSONSerialization.jsonObject(with: resultJSON.data(using: .utf8)!) as! [String:Any]
        switch obj["sdk_result"] as! Int32 {
        case 0: // 登录成功
            NSLog("SDK Login Token %@", obj["sdk_token"] as! String)
            NSLog("SDK Login From Sub Site %@", obj["sdk_from_site_name"] as! String)
            // 这里请编写游戏自己的代码
            // ...
            // 常规流程
            // 1、发送至服务器验证 sdk_token 签名是否正确，时间是否有效；
            // 2、等待接受服务器端发回的角色信息；
            // 3、改变客户端界面。
            let dict = DevUtil.genResultSet(resultJSON: resultJSON)
            DevUtil.acctGameUserId = Int(dict["acct_game_user_id"] as! String)!;
        case -3102: break // 玩家中途取消登录操作
            // 这里请编写游戏自己的代码
            // ...
            // 例如
            // 1、返回游戏界面，提供再次唤起登录的按钮；
        // 2、强制再次唤起登录界面。
        default:
            NSLog("SDK Login Error %@", obj["sdk_message"] as! String)
        }
    } // end method
}


/// 充值回调托管对象
class PayCallback: ICC_Callback {
    func result(resultJSON:String) {
        // 转换 JSON 字符串成对象
        let obj = try! JSONSerialization.jsonObject(with: resultJSON.data(using: .utf8)!) as! [String:Any]
        switch obj["sdk_result"] as! Int32 {
        case 0: // 支付成功
            NSLog("SDK Pay ICCGAME Trade No", obj["sdk_trade_no"] as! String)
            NSLog("SDK Pay    GAME Trade No", obj["sdk_out_trade_no"] as! String)
            // 这里请编写游戏自己的代码
            // ...
        // 特别注意，客户端返回成功并不可靠，请以服务端通知为准
        case -3102: break // 玩家中途取消支付操作
            // 这里请编写游戏自己的代码
            // ...
        // 通常忽略
        default:
            NSLog("SDK Pay Error %@", obj["sdk_message"] as! String)
        }
    } // end method
}

/// 注销回调托管对象
class LogoutCallback: ICC_Callback {
    func result(resultJSON:String) {
        // 转换 JSON 字符串成对象
        let obj = try! JSONSerialization.jsonObject(with: resultJSON.data(using: .utf8)!) as! [String:Any]
        switch obj["sdk_result"] as! Int32 {
        case 0: break // 注销成功
            // 这里请编写游戏自己的代码
            // ...
            // 例如：重新登录
        // ICC_SDK.getInstance().login(callback: LoginCallback(context: self.context))
        case -3102: break // 玩家中途取消注销操作
            // 这里请编写游戏自己的代码
            // ...
        // 通常忽略
        default:
            NSLog("SDK Logout Error %@", obj["sdk_message"] as! String)
        }
    } // end method
}

/// 退出回调托管对象
class ExitCallback: ICC_Callback {
    public func result(resultJSON:String) {
        // 转换 JSON 字符串成对象
        let obj = try! JSONSerialization.jsonObject(with: resultJSON.data(using: .utf8)!) as! [String:Any]
        switch obj["sdk_result"] as! Int32 {
        case 0: // 确认退出
            // 这里请编写游戏自己的代码
            // ...
            // 常规流程
            // 1、保存数据、释放资源；
            // 2、结束进程。
            exit(0)
        case -3102: break // 玩家中途取消退出操作
            // 这里请编写游戏自己的代码
            // ...
        // 通常忽略
        default:
            NSLog("SDK Exit Error %@", obj["sdk_message"] as! String)
        }
    } // end method
}
