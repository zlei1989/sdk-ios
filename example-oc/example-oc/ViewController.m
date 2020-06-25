//
//  ViewController.m
//  example-oc
//
//  Created by 张磊 on 2017/10/19.
//  Copyright © 2017年 游艺春秋网络科技（北京）有限公司. All rights reserved.
//

#import "ViewController.h"
#import "DevUtil.h"

@implementation ViewController

/**
 程序启动后即可初始化
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始内核
    [ICC_SDK getInstance];
    // 初始界面
    [self initUI];
    // 监听屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onOrientationChange:) name:UIDeviceOrientationDidChangeNotification  object:nil];
}

/**
 测试 账号登录
 
 @param sender 按钮对象
 */
- (IBAction)onClickLogin: (id)sender {
    [[ICC_SDK getInstance] login: [LoginCallback new]];
}

/**
 测试 账号登录
 
 @param sender 按钮对象
 */
- (IBAction)onClickLogout: (id)sender {
    [[ICC_SDK getInstance] logout: [LogoutCallback new]];
}

/**
 测试 账号登录
 
 @param sender 按钮对象
 */
- (IBAction)onClickPush: (id)sender {
    ICC_AcctData *acctData = [ICC_AcctData new];
    [acctData setBalance:@"600"]; // 用户余额
    [acctData setCreated:@"2018-05-31 18:00:00"]; // 角色创建时间
    [acctData setId:@"1"]; // 用户标识
    [acctData setLv:@"7"]; // 角色等级
    [acctData setPartyId:@"9"]; // 工会，帮派标识
    [acctData setPartyName:@"码农小组"]; // 工会，帮派名称
    [acctData setRoleId:@"3"]; // 角色标识
    [acctData setRoleName:@"程序猿"]; // 角色名称
    [acctData setServerId:@"5"]; // 所在服务器标识
    [acctData setServerName:@"开发服"]; // 所在服务器名称
    [acctData setVip:@"0"]; // VIP 等级
    // 适应时机调用以下方法
    [[ICC_SDK getInstance] pushAcctData:acctData :TRIGGER_CREATE]; // 账号创建
    [[ICC_SDK getInstance] pushAcctData:acctData :TRIGGER_UPDATE]; // 角色升级
    [[ICC_SDK getInstance] pushAcctData:acctData :TRIGGER_LOGIN]; // 账号登录
    [[ICC_SDK getInstance] pushAcctData:acctData :TRIGGER_TRANSACTION]; // 支付
    [[ICC_SDK getInstance] pushAcctData:acctData :TRIGGER_LOGOUT]; // 注销登录
    [[ICC_SDK getInstance] pushAcctData:acctData :TRIGGER_EXIT]; // 退出游戏
}

/**
 测试 账号登录
 
 @param sender 按钮对象
 */
- (IBAction)onClickPay: (id)sender {
    if (DevUtil.acctGameUserId == 0) {
        return;
    }
    // 整理支付所需参数
    int service = 2193064;
    NSString *content = @"[{\"id\":20,\"name\":\"元宝\",\"count\":1,\"price\":600}]";
    int totalFee = 600;
    // 模拟服务端生成请求
    NSString *tradeInfo = [DevUtil genTradeInfo: service : content : totalFee : DevUtil.acctGameUserId];
    // 唤起支付
    [[ICC_SDK getInstance] transaction: tradeInfo :[PayCallback new]];
}

/**
 测试 账号登录
 
 @param sender 按钮对象
 */
- (IBAction)onClickExit: (id)sender {
    [[ICC_SDK getInstance] exit: [ExitCallback new]];
}

/**
 屏幕旋转后刷新界面
 */
- (void)onOrientationChange: (NSNotification *)notify {
    [self initUI];
}

/**
 初始界面
 */
- (void)initUI {
    // 清空界面
    while (self.view.subviews.count) {
        UIView* child = self.view.subviews.lastObject;
        [child removeFromSuperview];
    }
    
    // 计算初始坐标
    int btnW = 128;
    int btnH = 32;
    int btnS = 8;
    int y = [[UIScreen mainScreen] bounds].size.height / 2 - ((btnH * 5) + (btnS * 4)) / 2;
    int x = [[UIScreen mainScreen] bounds].size.width / 2 - btnW / 2;
    
    // 添加 登录 按钮
    UIButton *loginBtn = [UIButton buttonWithType: UIButtonTypeSystem];
    [loginBtn setFrame: CGRectMake(x, y, btnW, btnH)];
    [loginBtn setTitle: @"账号登录" forState: UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(onClickLogin:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:loginBtn];
    
    // 添加 提交 按钮
    UIButton *pushBtn = [UIButton buttonWithType: UIButtonTypeSystem];
    [pushBtn setFrame: CGRectMake(x, y+=btnH+btnS, btnW, btnH)];
    [pushBtn setTitle: @"提交数据" forState: UIControlStateNormal];
    [pushBtn addTarget:self action:@selector(onClickPush:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:pushBtn];
    
    // 添加 支付 按钮
    UIButton *payBtn = [UIButton buttonWithType: UIButtonTypeSystem];
    [payBtn setFrame: CGRectMake(x, y+=btnH+btnS, btnW, btnH)];
    [payBtn setTitle: @"充值支付" forState: UIControlStateNormal];
    [payBtn addTarget:self action:@selector(onClickPay:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:payBtn];
    
    // 添加 注销 按钮
    UIButton *logoutBtn = [UIButton buttonWithType: UIButtonTypeSystem];
    [logoutBtn setFrame: CGRectMake(x, y+=btnH+btnS, btnW, btnH)];
    [logoutBtn setTitle: @"注销登录" forState: UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(onClickLogout:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:logoutBtn];
    
    // 添加 退出 按钮
    UIButton *exitBtn = [UIButton buttonWithType: UIButtonTypeSystem];
    [exitBtn setFrame: CGRectMake(x, y+=btnH+btnS, btnW, btnH)];
    [exitBtn setTitle: @"退出应用" forState: UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(onClickExit:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:exitBtn];
}

@end


/**
 登录回调托管对象
 */
@implementation LoginCallback
- (void)result :(NSString *)resultJSON {
    @autoreleasepool {
        // 转换 JSON 字符串成对象
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData :[resultJSON dataUsingEncoding :NSUTF8StringEncoding]
                                                            options :0 error :nil];
        DevUtil.acctGameUserId = 0;
        switch([[obj objectForKey :@"sdk_result"] intValue]) {
            case 0: {// 登录成功
                NSLog(@"SDK Login Token %@", [obj objectForKey :@"sdk_token"]);
                NSLog(@"SDK Login From Sub Site %@", [obj objectForKey :@"sdk_from_site_name"]);
                // 这里请编写游戏自己的代码
                // ...
                // 常规流程
                // 1、发送至服务器验证 sdk_token 签名是否正确，时间是否有效；
                // 2、等待接受服务器端发回的角色信息；
                // 3、改变客户端界面。
                NSDictionary *dict = [DevUtil genResultSet: resultJSON];
                if ([(NSNumber*)[dict objectForKey:@"sdk_result"] intValue] == 0) {
                    DevUtil.acctGameUserId = [(NSString*)[dict objectForKey:@"acct_game_user_id"] intValue];
                }
                break;
            }
            case -3102: // 玩家中途取消登录操作
                // 这里请编写游戏自己的代码
                // ...
                // 例如
                // 1、返回游戏界面，提供再次唤起登录的按钮；
                // 2、强制再次唤起登录界面。
                break;
            default:
                NSLog(@"SDK Login Error %@", [obj objectForKey :@"sdk_message"]);
        }
    } // end release pool
} // end method
@end

/**
 充值回调托管对象
 */
@implementation PayCallback
- (void)result :(NSString *)resultJSON {
    @autoreleasepool {
        // 转换 JSON 字符串成对象
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData :[resultJSON dataUsingEncoding :NSUTF8StringEncoding]
                                                            options :0 error :nil];
        switch([[obj objectForKey :@"sdk_result"] intValue]) {
            case 0: // 支付成功
                NSLog(@"SDK Pay ICCGAME Trade No %@", [obj objectForKey :@"sdk_trade_no"]);
                NSLog(@"SDK Pay    GAME Trade No %@", [obj objectForKey :@"sdk_out_trade_no"]);
                // 这里请编写游戏自己的代码
                // ...
                // 特别注意，客户端返回成功并不可靠，请以服务端通知为准
                break;
            case -3102: // 玩家中途取支付录操作
                // 返回玩家中途取消支付操作
                // 这里请编写游戏自己的代码
                // ...
                // 通常忽略
                break;
            default:
                NSLog(@"SDK Pay Error %@", [obj objectForKey :@"sdk_message"]);
        }
    } // end release pool
} // end method
@end

/**
 注销回调托管对象
 */
@implementation LogoutCallback
- (void)result :(NSString *)resultJSON {
    @autoreleasepool {
        // 转换 JSON 字符串成对象
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData :[resultJSON dataUsingEncoding :NSUTF8StringEncoding]
                                                            options :0 error :nil];
        switch([[obj objectForKey :@"sdk_result"] intValue]) {
            case 0: // 注销成功
                // 这里请编写游戏自己的代码
                // ...
                // 例如：重新登录
                break;
            case -3102: // 玩家中途取消登录操作
                // 这里请编写游戏自己的代码
                // ...
                // 通常忽略
                break;
            default:
                NSLog(@"SDK Logout Error %@", [obj objectForKey :@"sdk_message"]);
        }
    } // end release pool
} // end method
@end

/**
 退出回调托管对象
 */
@implementation ExitCallback
- (void)result :(NSString *)resultJSON {
    @autoreleasepool {
        // 转换 JSON 字符串成对象
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData :[resultJSON dataUsingEncoding :NSUTF8StringEncoding]
                                                            options :0 error :nil];
        switch([[obj objectForKey :@"sdk_result"] intValue]) {
            case 0: // 确认退出
                // 这里请编写游戏自己的代码
                // ...
                // 常规流程
                // 1、保存数据、释放资源；
                // 2、结束进程。
                exit(0);
                break;
            case -3102: // 玩家中途取消退出操作
                // 这里请编写游戏自己的代码
                // ...
                // 通常忽略
                break;
            default:
                NSLog(@"SDK Exit Error %@", [obj objectForKey :@"sdk_message"]);
        }
    } // end release pool
} // end method
@end
