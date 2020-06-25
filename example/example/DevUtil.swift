//
//  DevUtil.swift
//  sdk
//
//  Created by 张磊 on 2017/10/19.
//  Copyright © 2017年 游艺春秋网络科技（北京）有限公司. All rights reserved.
//

import Foundation

/// 开发工具
public class DevUtil {

    public class ResultSet {
        public  init(resultJSON:String ) {
            
        }
    }
    
    /// 游戏账号标识（临时变量）
    public static var acctGameUserId = 0
    
    /// 生成结果集
    ///
    /// - Parameter resultJSON: 结果字符串
    /// - Returns: 词典对象
    public static func genResultSet(resultJSON:String) -> [String:Any] {
        var arr = try! JSONSerialization.jsonObject(with: resultJSON.data(using: .utf8)!) as! [String:Any]
        if arr.index(forKey: "sdk_token") != nil {
            let items = (arr["sdk_token"] as! String).components(separatedBy: "&")
            for str in items {
                let idx = str.range(of: "=")
                let key = str.substring(to: idx!.lowerBound)
                arr[key] = str.substring(from: idx!.upperBound)
            }
        }
        return arr
    }
   
    /// 模拟生成交易信息
    ///
    /// - Parameters:
    ///   - service: 业务编号
    ///   - content: 商品明细
    ///   - totalFee: 付费总额
    ///   - acctGameUserId: 账号标识
    /// - Returns: 交易信息
    public static func genTradeInfo (service:Int, content:String, totalFee:Int, acctGameUserId:Int) -> String {
        let allowedCharacters =  NSCharacterSet(charactersIn:"+=\"#%/<>?@\\^`{|} ").inverted
        let content_encoded = content.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
        // 模拟服务端临时接口
        let ifUrl = String(format:"http://debug.sdk.m.iccgame.com/"
            + "?module=GAME.Pays.TradeTest"
            + "&do=Create"
            + "&service=%d"
            + "&content=%@"
            + "&total_fee=%d"
            + "&acct_game_user_id=%d",
                           service, content_encoded!, totalFee, acctGameUserId
        )
        // 通过服务端获取数据
        let jsonStr = try! Data(contentsOf: URL(string: ifUrl)!, options: .uncached)
        let obj = try? JSONSerialization.jsonObject(with: jsonStr) as! [String:Any]
        var p0 = obj?["data"] as! [Any]
        var p1 = p0[0] as! [String:Any]
        var p2 = p1["args"] as! [Any]
        return p2[0] as! String
    }

// end class
}
