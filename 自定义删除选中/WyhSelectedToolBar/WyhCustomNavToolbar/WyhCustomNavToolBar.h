//
//  WyhCustomNavToolBar.h
//  WyhSelectedToolBar
//
//  Created by wyh on 2017/1/8.
//  Copyright © 2017年 被帅醒的吴宝宝. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import "wyhHeader.h" //查看header,有惊喜

@protocol WyhCustomNavToolBarDelegate <NSObject>

@required
-(void)didClickAllselectBtn:(UIButton *)sender;

@required
-(void)didClickDeleteBtn:(UIButton *)sender;

@end

@interface WyhCustomNavToolBar : NSObject

/**
 全选按钮,可不暴露
 */
@property (nonatomic, strong , readwrite) UIButton *selectBtn;

/**
 暴露外部单例方法(已弃用单例)
 
 @return self
 */
+(instancetype)defaultToolBar;


/**
 设置删除的个数
 
 @param number 删除个数
 */
+(void)setDeleteNum:(NSInteger)number;


/**
 总初始化方法
 
 @param context viewController
 @param delegate
 */
+(void)toolBarWithContext:(UIViewController *)context Delegate:(id<WyhCustomNavToolBarDelegate>)delegate;


/**
 toolbar的显隐
 
 @param isappear  显隐  yes->显  no->隐
 @param animation 是否动画
 */
+(void)showToolBar:(BOOL)isappear Animation:(BOOL)animation;

@end
