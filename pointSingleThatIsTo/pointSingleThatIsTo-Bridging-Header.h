//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

///引入 label滚动效果
#import "CBAutoScrollLabel.h"

///引入 导航控制器背景透明效果
#import "UINavigationBar+Awesome.h"

/// 引入 按钮Badge效果
#import "UIButton+Badge.h"

/////操作数据库
//#import "sqlite3.h"
//#import <time.h>

/// 文本默认提示
#import "UITextView+Placeholder.h"

/// 橡皮擦效果
#import "HYScratchCardView.h"
//百度移动统计
#import "BaiduMobStat.h"

#import "MJRefresh.h"
#import "DOPDropDownMenu.h"



