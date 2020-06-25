//
//  DevUtil.h
//  example-oc
//
//  Created by 张磊 on 2017/10/26.
//  Copyright © 2017年 游艺春秋网络科技（北京）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 开发工具
 */
@interface DevUtil : NSObject

/**
 游戏账号标识（临时变量）
 */
@property (class, nonatomic, readwrite) int acctGameUserId;

/**
 生成返回值结果集

 @param resultJSON 结果JSON字符串
 @return 参数辞典
 */
+ (NSDictionary<NSString *, id> *)genResultSet: (NSString *)resultJSON;

/**
 模拟生成交易信息

 @param service 业务编号
 @param content 商品明细
 @param totalFee 付费总额
 @param acctGameUserId 账号标识
 @return 交易信息
 */
+ (NSString *)genTradeInfo: (int)service : (NSString *)content : (int)totalFee : (int)acctGameUserId;

@end
