//
//  ICC_ScriptBuilder.swift
//  sdk
//
//  Created by 张磊 on 2017/8/28.
//  Copyright © 2017年 游艺春秋网络科技（北京）有限公司. All rights reserved.
//

import Foundation


class ICC_ScriptBuilder {
    
    
    static func dispatchEvent(type:String, data:String ){
    }
    
    
    static func dispatchEvent(type:String, data:Any){
        let jsonDat = try? JSONSerialization.data(withJSONObject: data)
        return self.dispatchEvent(
            type: type,
            data: String(data:jsonDat!, encoding: String.Encoding.utf8) ?? ""
        )
    }
    
// end class
}
