//
//  ICC_AcctData.swift
//  sdk
//
//  Created by 张磊 on 2017/8/28.
//  Copyright © 2017年 游艺春秋网络科技（北京）有限公司. All rights reserved.
//

// 引用类库
import Foundation

public class ICC_AcctData {
    
    public enum TRIGGER : Int {
        
        case CREATE = 1
        case UPDATE = 2
        case LOGIN = 3
        case PAY = 4
        case LOGOUT = 5
        case EXIT = 6
    }
    
    /// 构造函数（禁止外部实例）
    public init (){};
    
}
