//
//  WyhTestCell.h
//  WyhSelectedToolBar
//
//  Created by wyh on 2017/1/8.
//  Copyright © 2017年 被帅醒的吴宝宝. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "wyhHeader.h"

static NSString *testCellReuseIdentifier = @"WyhTestCell";

@interface WyhTestCell : UITableViewCell


/**
 是否是编辑模式
 */
@property (nonatomic, assign) BOOL isEditting;

/**
 cell是否是选中状态
 */
@property (nonatomic, assign) BOOL isSelected;



/**
 针对字典进行赋值

 @param dict 字典
 */
-(void)setDataWithDict:(NSDictionary *)dict;

@end
