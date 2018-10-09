//
//  EWTBase.h
//  EWTBase
//
//  Created by Tony on 2018/3/16.
//  Copyright © 2018年 Huangbaoyang. All rights reserved.
//

#ifndef EWTBase_h
#define EWTBase_h

#import "PublicMethod.h"
#import "PromptBox.h"
#import "Reachability.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "EWTNotification.h"
#import "EWTBaseViewController.h"
#import "EWTBaseNavigationController.h"
#import "HTTPEngine.h"
#import "MJRefresh.h"
#import "MJBachFooter.h"
#import "MJRefershHeader.h"
#import "YYModel.h"


#define gbk CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000)


//***** ***** ***** ***** ***** other ***** ***** ***** ***** *****/
#define APP_DELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)
//App 版本号
#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

// RGB颜色
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
#define RGB2(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

// 状态栏高度
#define EWTStatusBar_Height ([UIScreen mainScreen].bounds.size.height == 812.0 ? 44.0:20.0)

// 导航栏高度
#define EWTNavigation_Bar_Height 44.0

// 底部安全边界
#define EWTTabbar_SafeBottomMargin ([UIScreen mainScreen].bounds.size.height == 812.0 ?34.0:0)

// 导航栏高度 + 状态栏目高度
#define NAVIGATION_BAR_HEIGHT ([UIScreen mainScreen].bounds.size.height == 812.0 ? 88:64)

// 标签栏高度 + 虚拟home区域高度
#define TAB_BAR_HEIGHT ([UIScreen mainScreen].bounds.size.height == 812.0 ? 83:49)

// 判断iPhoneX
#define KISIphoneX (CGSizeEqualToSize(CGSizeMake(375.f, 812.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(812.f, 375.f), [UIScreen mainScreen].bounds.size))

#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define WIDTH_SCALE [UIScreen mainScreen].bounds.size.width/375.0
#define HEIGHT_SCALE [UIScreen mainScreen].bounds.size.height/667.0

#define fm_list_image_high(width) width/2.67 //2.67//(720.0/306.0)

//#define push_notifity_image_high(width) (178.5*width)/320
#define push_notifity_image_high(width) (width)/2

#define supremacy_image_height(height) (SCREEN_WIDTH*height)/375

// 系统版本
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] doubleValue]
#define DATABASE_ENGINE       [DatabaseEngine sharedEngine]
#define IOS8 ([[[UIDevice currentDevice] systemVersion] doubleValue] >=8.0 ? YES : NO)
#define IOS10OrLater ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 10.0 ? YES : NO)

// 搜索历史记录
#define kHistorySearchPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Searchhistories.plist"]

// 导航栏右按钮(只有文字)
#define NAVIGATION_BAR_RIGHT_BUTTON_ONLYTEXT(x, y, w, h, normal, selected, sel)\
{\
UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];\
button.frame = CGRectMake(x, y, w, h);\
[button setTitle:normal forState:UIControlStateNormal];\
[button setTitle:selected forState:UIControlStateSelected];\
[button.titleLabel setFont:[UIFont systemFontOfSize:16]];\
[button setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];\
[button addTarget:self action:@selector(sel) forControlEvents:UIControlEventTouchUpInside];\
UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];\
self.navigationItem.rightBarButtonItem = buttonItem;\
}


// 导航栏右按钮
#define NAVIGATION_BAR_RIGHT_BUTTON(x, y, w, h, normal, selected, sel)\
{\
UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];\
button.frame = CGRectMake(x, y, w, h);\
[button setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];\
[button setImage:[UIImage imageNamed:selected] forState:UIControlStateHighlighted];\
[button addTarget:self action:@selector(sel) forControlEvents:UIControlEventTouchUpInside];\
UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];\
self.navigationItem.rightBarButtonItem = buttonItem;\
}


// 导航栏右按钮---图片加文字
#define NAVIGATION_BAR_RIGHT_BUTTON_TITLE_AND_IMAGE(x, y, w, h, normal, selected, title ,sel)\
{\
UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];\
button.frame = CGRectMake(x, y, w, h);\
[button setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];\
[button setImage:[UIImage imageNamed:selected] forState:UIControlStateHighlighted];\
[button setTitle:title forState:UIControlStateNormal];\
[button.titleLabel setFont:[UIFont systemFontOfSize:15]];\
button.contentEdgeInsets = UIEdgeInsetsMake(0,30, 0, 0);\
button.imageEdgeInsets = UIEdgeInsetsMake(0,-10, 0, 0);\
[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];\
[button setTitleColor:RGB(61, 105, 150) forState:UIControlStateHighlighted];\
[button addTarget:self action:@selector(sel) forControlEvents:UIControlEventTouchUpInside];\
UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];\
self.navigationItem.rightBarButtonItem = buttonItem;\
}




// 导航栏左按钮，使用CustomView来自定义返回图标
#define NAVIGATION_BAR_LEFT_BUTTON(x, y, w, h, normal, selected, sel)\
{\
UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];\
button.frame = CGRectMake(x, y, w, h);\
[button setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];\
[button setImage:[UIImage imageNamed:selected] forState:UIControlStateSelected];\
[button addTarget:self action:@selector(sel) forControlEvents:UIControlEventTouchUpInside];\
UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];\
self.navigationItem.leftBarButtonItem = buttonItem;\
}

// 导航栏左按钮，自定义返回图标，这种可以通过修改leftBarButtonItem的tintColor来改变返回图标颜色
#define EWTModifyNavigationBarLeftBarButtonItemWithImage(imageName, sel)\
{\
UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName] style:UIBarButtonItemStylePlain target:self action:sel];\
self.navigationItem.leftBarButtonItem = backBarButtonItem;\
}

// 导航栏左按钮
#define NAVIGATION_BAR_LEFT_BUTTON_ADJUST(x, y, w, h, normal, selected, sel)\
{\
UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];\
button.frame = CGRectMake(x, y, w, h);\
button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 28);\
[button setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];\
[button setImage:[UIImage imageNamed:selected] forState:UIControlStateSelected];\
[button addTarget:self action:@selector(sel) forControlEvents:UIControlEventTouchUpInside];\
UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];\
self.navigationItem.leftBarButtonItem = buttonItem;\
}

// 导航栏左按钮(消息)
#define NAVIGATION_BAR_LEFT_BUTTON_MSGCOUNT(x, y, w, h, normal, selected, sel)\
{\
MsgCountButton *button = [MsgCountButton buttonWithType:UIButtonTypeCustom];\
button.frame = CGRectMake(x, y, w, h);\
[button setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];\
[button setImage:[UIImage imageNamed:selected] forState:UIControlStateSelected];\
button.tag = 101;\
[button addTarget:self action:@selector(sel) forControlEvents:UIControlEventTouchUpInside];\
UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];\
self.navigationItem.leftBarButtonItem = buttonItem;\
}


// 导航栏右按钮  只用于心理右边按钮的动画
#define NAVIGATION_BAR_LEFT_BUTTON_spirit(sel,btn)\
{\
UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];\
[btn addTarget:self action:@selector(sel) forControlEvents:UIControlEventTouchUpInside];\
}






#define EWT_ALERT(title,msg)\
{\
UIAlertView *_alert=[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]; \
_alert.transform=CGAffineTransformMakeTranslation(0, 80); \
[_alert show]; \
}


// 完美解决Xcode NSLog打印不全的宏
#ifdef DEBUG

#define NSLog(...) printf("%f %s\n",[[NSDate date]timeIntervalSince1970],[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);

#else

#define NSLog(format, ...)

#endif


// 参照iPhone6尺寸适配

#define StandardBy6(x)( MIN(SCREEN_HEIGHT, SCREEN_WIDTH) / 375 * x)

//十六进制颜色值
#define kUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define HEXACOLOR(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define CREATE_HEX_COLOR(hex) [UIColor colorWithHexString:hex]

//字体
#define KFont(i)  [UIFont systemFontOfSize:i]




#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

#define EWTWeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;

//输出整型
#define strInteger(integer) [NSString stringWithFormat:@"%zi",integer]

#define VW(view) (view.frame.size.width)
#define VH(view) (view.frame.size.height)
#define VX(view) (view.frame.origin.x)
#define VY(view) (view.frame.origin.y)
#define FW(view) (VW(view)+VX(view))
#define FH(view) (VH(view)+VY(view))

// 确保src非空； 如果为空，则返回@""
//
static inline NSString *ENSURE_NOT_NULL(id src) {
    return src ? src : @"";
}

// 确保src不是string，因为我们在传值的时候有时候需要保证不再Dictionary中加入nil，使用ENSURE_NOT_NULL，那么取出的时候就做一个反的操作
static inline id ENSURE_NOT_STRING(id src) {
    return [src isKindOfClass: [NSString class]] ? nil : src;
}

static NSString * const reloadDoingHomwWork = @"reloadDoingHomwWork";
static NSString * const reloadDoneHomwWork = @"reloadDoneHomwWork";

static const NSInteger signKey3 = 30205014;



#endif /* EWTBase_h */
