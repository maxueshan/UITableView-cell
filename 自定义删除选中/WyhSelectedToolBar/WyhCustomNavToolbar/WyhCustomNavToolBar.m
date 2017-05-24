//
//  WyhCustomNavToolBar.m
//  WyhSelectedToolBar
//
//  Created by wyh on 2017/1/8.
//  Copyright © 2017年 被帅醒的吴宝宝. All rights reserved.
//


#import "WyhCustomNavToolBar.h"

@interface WyhCustomNavToolBar ()



@property (nonatomic, strong) UIButton *deletBtn;

@property (nonatomic, strong) UIViewController *vc;

@property (nonatomic, weak) id<WyhCustomNavToolBarDelegate> delegate;

@end

@implementation WyhCustomNavToolBar

static WyhCustomNavToolBar *manager = nil;

#pragma mark - 懒加载

-(UIButton *)selectBtn{
    
    if (!_selectBtn) {
        //全选
        UIButton *allSelectbutton = [[UIButton alloc]initWithFrame:CGRectMake(-20, 0, 60, 44)];
        _selectBtn = allSelectbutton;
        allSelectbutton.tag = 100;
        [allSelectbutton setImage:[UIImage imageNamed:@"mine_collect_normal"] forState:UIControlStateNormal];
        [allSelectbutton setImage:[UIImage imageNamed:@"mine_collect_pressed"] forState:UIControlStateSelected];
        [allSelectbutton setTitle:@"全选" forState:UIControlStateNormal];
//        [allSelectbutton setTitleColor:UIColorFromRGB(0x757575) forState:UIControlStateNormal];
        allSelectbutton.titleLabel.font = font(13);
        allSelectbutton.imageEdgeInsets = UIEdgeInsetsMake(0,-10,0,0);
        [allSelectbutton addTarget:self action:@selector(selectAllClick:) forControlEvents:UIControlEventTouchUpInside];
        allSelectbutton.selected = NO;
    }
    return _selectBtn;
}

-(UIButton *)deletBtn{
    
    if (!_deletBtn) {
        //删除
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deletBtn = deleteButton;
        deleteButton.tag = 101;
        deleteButton.frame = CGRectMake(0, 0, 120, 44);
//        deleteButton.width = 120;
//        deleteButton.height = 44;
        [deleteButton setBackgroundImage:[UIImage imageNamed:@"mine_btn_delete"] forState:UIControlStateNormal];
        [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
//        [deleteButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        deleteButton.titleLabel.font = font(16);
        [deleteButton addTarget:self action:@selector(deteleClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deletBtn;
}

+(instancetype)defaultToolBar{ //TODO:单例模式不保证toolbar每次都能保留布局,这个问题大家可以去研究一下
    
    //    static dispatch_once_t onceToken;
    
    //    dispatch_once(&onceToken, ^{
    manager = [[WyhCustomNavToolBar alloc]init];
    //    });
    return manager;
}

+(void)toolBarWithContext:(UIViewController *)context Delegate:(id<WyhCustomNavToolBarDelegate>)delegate{
    
    manager = [WyhCustomNavToolBar defaultToolBar];
    
    manager.vc = context;//传入VC
    
    manager.delegate = delegate;
    
    [manager setToolBarWithVC:context];
}

+(void)showToolBar:(BOOL)isappear Animation:(BOOL)animation{
    
    
    manager.selectBtn.selected = NO;
    
    [self setDeleteNum:0];
    
    [manager.vc.navigationController setToolbarHidden:!isappear animated:animation];
    
}

+(void)setDeleteNum:(NSInteger)number{
    
    if (number == 0) {
        [manager.deletBtn setTitle:[NSString stringWithFormat:@"删除"] forState:(UIControlStateNormal)];
    }else{
        
        [manager.deletBtn setTitle:[NSString stringWithFormat:@"删除(%ld)",number] forState:(UIControlStateNormal)];
    }
}



-(void)setToolBarWithVC:(UIViewController *)vc{
    
    [vc.navigationController setToolbarHidden:YES animated:YES];
    [vc.navigationController.toolbar setBarStyle:UIBarStyleDefault];
    vc.navigationController.toolbar.barTintColor = [UIColor whiteColor];
    vc.navigationController.toolbar.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height-44, [UIScreen mainScreen].bounds.size.width, 44);
    
    
    UIBarButtonItem *customItem1 = [[UIBarButtonItem alloc]initWithCustomView:self.selectBtn];
    
    UIBarButtonItem *customItem2 = [[UIBarButtonItem alloc]initWithCustomView:self.deletBtn];
    
    //间距
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    space.width = Screen_width - 60 - 120 - 25;
    
    NSArray *arr1 = [[NSArray alloc]initWithObjects:customItem1,space,customItem2, nil];
    vc.toolbarItems = arr1;
}

#pragma mark - 回调方法
-(void)selectAllClick:(UIButton *)sender{
    
    if ([self.delegate respondsToSelector:@selector(didClickAllselectBtn:)]) {
        [self.delegate performSelector:@selector(didClickAllselectBtn:) withObject:sender];
    }
    
}
-(void)deteleClick:(UIButton *)sender{
    
    self.selectBtn.selected = NO;
    
    [WyhCustomNavToolBar setDeleteNum:0];
    
    if ([self.delegate respondsToSelector:@selector(didClickDeleteBtn:)]) {
        [self.delegate performSelector:@selector(didClickDeleteBtn:) withObject:sender];
    }
}

-(void)dealloc{
    
    
}

@end

