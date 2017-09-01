//
//  ICC_ScriptBuilder.swift
//  sdk
//
//  Created by 张磊 on 2017/8/28.
//  Copyright © 2017年 游艺春秋网络科技（北京）有限公司. All rights reserved.
//

import Foundation


class ICC_ScriptBuilder {
    
    ///
    static func dispatchEvent (type:String) -> String {
        return self.dispatchEvent(type: type, data: "null")
    }
    
    ///
    static func dispatchEvent(type:String, data:String ) -> String {
        return String(format: "(function(){"
            + "var evnt=document.createEvent(\"HTMLEvents\");"
            + "evnt.initEvent(\"%@\", true, true);"
            + "evnt.data=%@;"
            + "document.body.dispatchEvent(evnt);"
            + "})()", type, data)
    }
    
    ///
    static func dispatchEvent(type:String, data:Any) -> String {
        let jsonDat = try? JSONSerialization.data(withJSONObject: data)
        return self.dispatchEvent(
            type: type,
            data: String(data:jsonDat!, encoding: String.Encoding.utf8) ?? ""
        )
    }
    
<<<<<<< HEAD
    ///
    static func callback (key:String) -> String {
        return String(format:"function(res){window.ICCGAME_IOS.callback(\"%@\", res);}", key)
    }
    
=======
>>>>>>> parent of db0f196... 20170831张磊
// end class
}
