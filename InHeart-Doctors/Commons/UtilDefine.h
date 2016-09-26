//
//  UtilDefine.h
//  DongDong
//
//  Created by 项小盆友 on 16/7/15.
//  Copyright © 2016年 项小盆友. All rights reserved.
//
#import "Util.h"

/**
 *  屏幕宽和高
 */
#define SCREEN_WIDTH CGRectGetWidth(UIScreen.mainScreen.bounds)
#define SCREEN_HEIGHT CGRectGetHeight(UIScreen.mainScreen.bounds)
//推荐内容高度和宽度
#define kCollectionCellItemWidth (SCREEN_WIDTH - 30.0) / 2.0
#define kCollectionCellItemHeight kCollectionCellItemWidth / 2.0

/**
 *  常用颜色
 */
#define NAVIGATIONBAR_COLOR [UIColor colorWithRed:82/255.0 green:184/255.0 blue:255/255.0 alpha:1.0]
#define TABBAR_TITLE_COLOR [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0]
#define MAIN_BACKGROUND_COLOR [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0]
#define BREAK_LINE_COLOR [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0]
#define MAIN_TEXT_COLOR [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0]

/**
 *  RGB颜色
 */
#define kRGBColor(r,g,b,a)	[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

/**
 *  Hex颜色转RGB颜色
 */
#define kHexRGBColorWithAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

/**
 *  系统字体
 */
#define kSystemFont(x) [UIFont systemFontOfSize:x]
#define kBoldSystemFont(x) [UIFont boldSystemFontOfSize:x]


#pragma mark - System
/**
 *  照相机是否可用
 */
#define XLIsCameraAvailable [Util cameraAvailable]

/**
 *  是否支持发短信
 */
#define XLCanSendSMS [Util canSendSMS]

/**
 *  是否支持打电话
 */
#define XLCanMakePhoneCall [Util canMakePhoneCall]

/**
 *  是否有权限访问相机
 */
#define XLIsAppCameraAccessAuthorized [Util isAppCameraAccessAuthorized]

///**
// *  是否有权限访问相册
// */
//#define XLIsAppPhotoLibraryAccessAuthorized [Util isAppPhotoLibraryAccessAuthorized]

#pragma mark - Cache
/**
 *  判空
 */
#define XLIsNullObject [Util isNullObject:object]



/**
 *  string转url
 */
#define XLURLFromString(aString) [Util urlWithString:aString]

/**
 *  数字转string，小数点后最多两位
 */
#define XLStringFromFloat(aFloat) [Util numberString:aFloat]

/**
 *  计算文字大小
 */
#define XLSizeOfText(aText, aWidth, aFont) [Util sizeOfText:aText width:aWidth font:aFont]

