//
//  DevUtil.m
//  example-oc
//
//  Created by 张磊 on 2017/10/26.
//  Copyright © 2017年 游艺春秋网络科技（北京）有限公司. All rights reserved.
//

#import "DevUtil.h"
#import <Foundation/Foundation.h>

// 实现对象
@implementation DevUtil;

// 全局变量
static int _acctGameUserId = 0;

/**
 获得游戏账号标识（临时变量）

 @return 值
 */
+ (int)acctGameUserId {
    return _acctGameUserId;
}

/**
 设置游戏账号标识（临时变量）

 @param num 值
 */
+ (void)setAcctGameUserId:(int)num {
    _acctGameUserId = num;
}

/**
 生成返回值结果集

 @param resultJSON 结果JSON字符串
 @return 参数辞典
 */
+ (NSDictionary<NSString *, id> *)genResultSet: (NSString *)resultJSON {
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[resultJSON dataUsingEncoding:NSUTF8StringEncoding]
                                                        options:0 error:nil];
    NSMutableDictionary *res = [NSMutableDictionary new];
    [res addEntriesFromDictionary:dic];
    NSString *str = [dic objectForKey:@"sdk_token"];
    if (str != nil) {
        NSArray *arr = [str componentsSeparatedByString:@"&"];
        for (NSString *pair in arr) {
            NSRange idx = [pair rangeOfString:@"="];
            if (idx.location == NSNotFound) {
                continue;
            }
            [res setValue:[pair substringFromIndex:idx.location+1]
                   forKey:[pair substringToIndex:idx.location]];
        }
    }
    return res;
}

/**
 模拟生成交易信息
 
 @param service 业务编号
 @param content 商品明细
 @param totalFee 付费总额
 @param acctGameUserId 账号标识
 @return 交易信息
 */
+ (NSString *)genTradeInfo: (int)service : (NSString *)content : (int)totalFee : (int)acctGameUserId {
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"+=\"#%/<>?@\\^`{|} "] invertedSet];
    NSString *content_encoded = [content stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    // 模拟服务端临时接口
    NSString *ifUrl = [NSString stringWithFormat:@"http://debug.sdk.m.iccgame.com/?module=GAME.Pays.TradeTest&do=Create&service=%d&content=%@&total_fee=%d&acct_game_user_id=%d",
                       service, content_encoded, totalFee, acctGameUserId];
    // 通过服务端获取数据
    NSData *jsonStr = [NSData dataWithContentsOfURL:[NSURL URLWithString:ifUrl] options:NSDataReadingUncached error:nil];
    NSDictionary<NSString *, id> *obj = [NSJSONSerialization JSONObjectWithData:jsonStr options:0 error:nil];
    NSArray *p0 = [obj objectForKey:@"data"];
    NSDictionary<NSString *, id> *p1 = p0[0];
    NSArray *p2 = [p1 objectForKey:@"args"];
    return p2[0];
}

@end

