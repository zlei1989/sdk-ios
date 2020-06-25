//
//  ViewController.h
//  example-oc
//
//  Created by 张磊 on 2017/10/19.
//  Copyright © 2017年 游艺春秋网络科技（北京）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sdk/SwiftHeader.h>

/**
 演示范例界面控制器
 */
@interface ViewController : UIViewController
/**
 用户唯一标示
 （测试代码）
 */

@end

/**
 登录回调托管对象
 */
@interface LoginCallback:NSObject<ICC_Callback>
@end


/**
 充值回调托管对象
 */
@interface PayCallback:NSObject<ICC_Callback>
@end


/**
 注销回调托管对象
 */
@interface LogoutCallback:NSObject<ICC_Callback>
@end


/**
 退出回调托管对象
 */
@interface ExitCallback:NSObject<ICC_Callback>
@end
