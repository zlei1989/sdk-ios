//
//  ICC_AcctData_OC.swift
//  sdk
//
//  Created by 张磊 on 2017/10/25.
//  Copyright © 2017年 游艺春秋网络科技（北京）有限公司. All rights reserved.
//

import Foundation

/// 用户账号信息类
@objc public class ICC_AcctData_OC: NSObject {
    
    /// 触发枚举
    @objc public enum TRIGGER:NSInteger {
        // 账号注册
        case CREATE = 1
        
        // 账号更新
        case UPDATE = 2
        
        // 账号登陆
        case LOGIN = 3
        
        // 账号支付
        case TRANSACTION = 4
        
        // 账号登出
        case LOGOUT = 5
        
        //账号退出
        case EXIT = 6
    }
    
    /// 原始对象
    var rawValue:ICC_AcctData = ICC_AcctData()
    
    /// 获得用户 id
    ///
    /// - Returns:
    public func getId() -> String {
        return self.rawValue.id
    }
    
    /// 设置用户 id
    ///
    /// - Parameter str:
    /// - Returns:
    public func setId(_ str:String) -> ICC_AcctData_OC {
        self.rawValue.id = str
        return self
    }
    
    /// 获得 所在服务器标识
    ///
    /// - Returns:
    public func getServerId() -> String {
        return self.rawValue.serverId
    }
    
    /// 设置 所在服务器标识
    ///
    /// - Parameter str:
    /// - Returns:
    public func setServerId(_ str:String) -> ICC_AcctData_OC {
        self.rawValue.serverId = str
        return self
    }
    
    /// 获得 所在服务器名称
    ///
    /// - Returns:
    public func getServerName() -> String {
        return self.rawValue.serverName
    }
    
    /// 设置 所在服务器名称
    ///
    /// - Parameter str:
    /// - Returns:
    public func setServerName(_ str:String) -> ICC_AcctData_OC {
        self.rawValue.serverName = str
        return self
    }
    
    /// 获得 角色标识
    ///
    /// - Returns:
    public func getRoleId() -> String {
        return self.rawValue.roleId
    }
    
    /// 设置 角色标识
    ///
    /// - Parameter str:
    /// - Returns:
    public func setRoleId(_ str:String) -> ICC_AcctData_OC {
        self.rawValue.roleId = str
        return self
    }
    
    /// 获得 角色名称
    ///
    /// - Returns:
    public func getRoleName() -> String {
        return self.rawValue.roleName
    }
    
    /// 设置 角色名称
    ///
    /// - Parameter str:
    /// - Returns:
    public func setRoleName(_ str:String) -> ICC_AcctData_OC {
        self.rawValue.roleName = str
        return self
    }
    
    /// 获得 角色等级
    ///
    /// - Returns:
    public func getLv() -> String {
        return self.rawValue.lv
    }
    
    /// 设置 角色等级
    ///
    /// - Parameter str:
    /// - Returns:
    public func setLv(_ str:String) -> ICC_AcctData_OC {
        self.rawValue.lv = str
        return self
    }
    
    /// 获得 VIP 等级
    ///
    /// - Returns:
    public func getVip() -> String {
        return self.rawValue.vip
    }
    
    /// 设置 VIP 等级
    ///
    /// - Parameter str:
    /// - Returns:
    public func setVip(_ str:String) -> ICC_AcctData_OC {
        self.rawValue.vip = str
        return self
    }
    
    /// 获得 工会，帮派标识
    ///
    /// - Returns:
    public func getPartyId() -> String {
        return self.rawValue.partyId
    }
    
    /// 设置 工会，帮派标识
    ///
    /// - Parameter str:
    /// - Returns:
    public func setPartyId(_ str:String) -> ICC_AcctData_OC {
        self.rawValue.partyId = str
        return self
    }
    
    /// 获得 工会，帮派名称
    ///
    /// - Returns:
    public func getPartyName() -> String {
        return self.rawValue.partyName
    }
    
    /// 设置 工会，帮派名称
    ///
    /// - Parameter str:
    /// - Returns:
    public func setPartyName(_ str:String) -> ICC_AcctData_OC {
        self.rawValue.partyName = str
        return self
    }
    
    /// 获得 用户余额
    ///
    /// - Returns:
    public func getBalance() -> String {
        return self.rawValue.balance
    }
    
    /// 设置 用户余额
    ///
    /// - Parameter str:
    /// - Returns:
    public func setBalance(_ str:String) -> ICC_AcctData_OC {
        self.rawValue.balance = str
        return self
    }
    
    /// 获得 扩展属性
    ///
    /// - Returns:
    public func getExtra() -> [String:Any]? {
        return self.rawValue.extra
    }
    
    /// 设置 扩展属性
    ///
    /// - Parameter dic:
    /// - Returns:
    public func setExtra(_ dic:[String:Any]?) -> ICC_AcctData_OC {
        self.rawValue.extra = dic
        return self
    }
    
    /// 获得 角色创建时间
    ///
    /// - Returns:
    public func getCreated() -> String {
        return self.rawValue.created
    }
    
    /// 设置 角色创建时间
    ///
    /// - Parameter str:
    /// - Returns:
    public func setCreated(_ str:String) -> ICC_AcctData_OC {
        self.rawValue.created = str
        return self
    }
    
    /// 转换为字符串
    ///
    /// - Returns:
    public func toJSONString() -> String {
        return self.rawValue.toJSONString()
    }
    
    /// 获得json对象
    ///
    /// - Returns:
    public func getJSONObject() -> [String:Any] {
        return self.rawValue.getJSONObject()
    }
    
    /// 合并数据
    ///
    /// - Parameter obj:
    public func merge(_ obj:ICC_AcctData_OC) {
        return self.rawValue.merge(obj: obj.rawValue)
    }
    
    /// 清理数据
    public func clear() {
        self.rawValue.clear()
    }
    
    // End class
}
