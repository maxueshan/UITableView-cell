//
//  wyhHeader.h
//  WyhSelectedToolBar
//
//  Created by wyh on 2017/1/8.
//  Copyright © 2017年 被帅醒的吴宝宝. All rights reserved.
//

#ifndef wyhHeader_h
#define wyhHeader_h


//////////////////送大家个16进制颜色宏/////////////////////

#define Screen_width [UIScreen mainScreen].bounds.size.width

#define Screen_height [UIScreen mainScreen].bounds.size.height

#define Frame(x, y, width, height) CGRectMake((x),(y),(width),(height))

#define kIOSVersion ((float)[[[UIDevice currentDevice] systemVersion] doubleValue])

#define font(size) [UIFont systemFontOfSize:(size)]

/**
 *  使用十六进制的颜色
 *
 *  (iOS 10系统以上新方法 colorWithDisplayP3Red 官方给的解释新方法会使得色彩更绚丽,然而并没有看出来)
 *  (iOS 10系统以上用 colorWithRed)
 */
#define UIColorFromRGB(rgbValue) ((kIOSVersion>=10.0)?[UIColor colorWithDisplayP3Red:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]:[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0])

#endif /* wyhHeader_h */
