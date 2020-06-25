//
//  ICC_AcctData.swift
//  sdk
//
//  Created by 张磊 on 2017/8/28.
//  Copyright © 2017年 游艺春秋网络科技（北京）有限公司. All rights reserved.
//

// 引用类库
import Foundation

/// 用户账号信息类
public class ICC_AcctData {
    
    /// 触发枚举
    public enum TRIGGER:Int {
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
    
    /// 用户标识
    /// 每个用户 id下面可能会有多个角色数据
    var id = "0"
    
    /// 所在服务器标识
    var serverId = "0"
    
    /// 所在服务器名称
    var serverName = ""
    
    /// 角色标识
    var roleId = "0"
    
    /// 角色名称
    var roleName = ""
    
    /// 角色等级
    var lv = "0"
    
    /// VIP 等级
    var vip = ""
    
    /// 工会，帮派标识
    var partyId = "0"
    
    /// 工会，帮派名称
    var partyName = ""
    
    /// 用户余额
    var balance = "0"
    
    /// 扩展数据
    var extra:[String:Any]? = nil
    
    /// 角色创建时间
    var created = ""
    
    /// 构造函数
    public init() {
        
    }
    
    /// 获得用户 id
    ///
    /// - Returns:
    public func getId() -> String {
        return self.id
    }
    
    /// 设置用户 id
    ///
    /// - Parameter str:
    /// - Returns:
    public func setId(str:String) -> ICC_AcctData {
        self.id = str
        return self
    }
    
    /// 获得 所在服务器标识
    ///
    /// - Returns:
    public func getServerId() -> String {
        return self.serverId
    }
    
    /// 设置 所在服务器标识
    ///
    /// - Parameter str:
    /// - Returns:
    public func setServerId(str:String) -> ICC_AcctData {
        self.serverId = str
        return self
    }
    
    /// 获得 所在服务器名称
    ///
    /// - Returns:
    public func getServerName() -> String {
        return self.serverName
    }
    
    /// 设置 所在服务器名称
    ///
    /// - Parameter str:
    /// - Returns:
    public func setServerName(str:String) -> ICC_AcctData {
        self.serverName = str
        return self
    }
    
    /// 获得 角色标识
    ///
    /// - Returns:
    public func getRoleId() -> String {
        return self.roleId
    }
    
    /// 设置 角色标识
    ///
    /// - Parameter str:
    /// - Returns:
    public func setRoleId(str:String) -> ICC_AcctData {
        self.roleId = str
        return self
    }
    
    /// 获得 角色名称
    ///
    /// - Returns:
    public func getRoleName() -> String {
        return self.roleName
    }
    
    /// 设置 角色名称
    ///
    /// - Parameter str:
    /// - Returns:
    public func setRoleName(str:String) -> ICC_AcctData {
        self.roleName = str
        return self
    }
    
    /// 获得 角色等级
    ///
    /// - Returns:
    public func getLv() -> String {
        return self.lv
    }
    
    /// 设置 角色等级
    ///
    /// - Parameter str:
    /// - Returns:
    public func setLv(str:String) -> ICC_AcctData {
        self.lv = str
        return self
    }
    
    /// 获得 VIP 等级
    ///
    /// - Returns:
    public func getVip() -> String {
        return self.vip
    }
    
    /// 设置 VIP 等级
    ///
    /// - Parameter str:
    /// - Returns:
    public func setVip(str:String) -> ICC_AcctData {
        self.vip = str
        return self
    }
    
    /// 获得 工会，帮派标识
    ///
    /// - Returns:
    public func getPartyId() -> String {
        return self.partyId
    }
    
    /// 设置 工会，帮派标识
    ///
    /// - Parameter str:
    /// - Returns:
    public func setPartyId(str:String) -> ICC_AcctData {
        self.partyId = str
        return self
    }
    
    /// 获得 工会，帮派名称
    ///
    /// - Returns:
    public func getPartyName() -> String {
        return self.partyName
    }
    
    /// 设置 工会，帮派名称
    ///
    /// - Parameter str:
    /// - Returns:
    public func setPartyName(str:String) -> ICC_AcctData {
        self.partyName = str
        return self
    }
    
    /// 获得 用户余额
    ///
    /// - Returns:
    public func getBalance() -> String {
        return self.balance
    }
    
    /// 设置 用户余额
    ///
    /// - Parameter str:
    /// - Returns:
    public func setBalance(str:String) -> ICC_AcctData {
        self.balance = str
        return self
    }
    
    /// 获得 扩展属性
    ///
    /// - Returns:
    public func getExtra() -> [String:Any]? {
        return self.extra
    }
    
    /// 设置 扩展属性
    ///
    /// - Parameter dic:
    /// - Returns:
    public func setExtra(dic:[String:Any]?) -> ICC_AcctData {
        self.extra = dic
        return self
    }
    
    /// 获得 角色创建时间
    ///
    /// - Returns:
    public func getCreated() -> String {
        return self.created
    }
    
    /// 设置 角色创建时间
    ///
    /// - Parameter str:
    /// - Returns:
    public func setCreated(str:String) -> ICC_AcctData {
        self.created = str
        return self
    }
    
    /// 转换为字符串
    ///
    /// - Returns:
    public func toJSONString() -> String {
        return String(data: try! JSONSerialization.data(withJSONObject: self.getJSONObject()), encoding: .utf8)!
    }
    
    /// 获得json对象
    ///
    /// - Returns:
    public func getJSONObject() -> [String:Any] {
        var dic:[String:Any] = [:]
        dic["balance"] = self.getBalance()
        dic["created"] = self.getCreated()
        dic["extra"] = self.getExtra()
        dic["id"] = self.getId()
        dic["lv"] = self.getLv()
        dic["party_id"] = self.getPartyId()
        dic["party_name"] = self.getPartyName()
        dic["role_id"] = self.getRoleId()
        dic["role_name"] = self.getRoleName()
        dic["server_id"] = self.getServerId()
        dic["server_name"] = self.getServerName()
        dic["vip"] = self.getVip()
        return dic
    }
    
    /// 合并数据
    ///
    /// - Parameter obj:
    public func merge(obj:ICC_AcctData) {
        /*
         if (TextUtils.isEmpty(obj.balance) == false && false == obj.balance.equals("0")) {
         self.balance = obj.balance
         }
         if (TextUtils.isEmpty(obj.created) == false) {
         self.created = obj.created
         }
         if (var.extra != null) {
         self.extra = obj.extra
         }
         if (TextUtils.isEmpty(obj.id) == false && false == obj.id.equals("0")) {
         self.id = obj.id
         }
         if (TextUtils.isEmpty(obj.lv) == false && false == obj.lv.equals("0")) {
         self.lv = obj.lv
         }
         if (TextUtils.isEmpty(obj.partyId) == false && false == obj.partyId.equals("0")) {
         self.partyId = obj.partyId
         }
         if (TextUtils.isEmpty(obj.partyName) == false) {
         self.partyName = obj.partyName
         }
         if (TextUtils.isEmpty(obj.roleId) == false && false == obj.roleId.equals("0")) {
         self.roleId = obj.roleId
         }
         if (TextUtils.isEmpty(obj.roleName) == false) {
         self.roleName = obj.roleName
         }
         if (TextUtils.isEmpty(obj.serverId) == false && false == var.serverId.equals("0")) {
         self.serverId = obj.serverId
         }
         if (TextUtils.isEmpty(obj.serverName) == false) {
         self.serverName = obj.serverName
         }
         if (TextUtils.isEmpty(obj.vip) == false) {
         self.vip = obj.vip
         }*/
    }
    
    /// 清理数据
    public func clear() {
        self.id = "0"
        self.serverId = "0"
        self.serverName = ""
        self.roleId = "0"
        self.roleName = ""
        self.lv = "0"
        self.vip = ""
        self.partyId = "0"
        self.partyName = ""
        self.balance = "0"
        self.extra = nil
        self.created = ""
    }
    
    // End class
}
