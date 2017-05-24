//
//  ViewController.m
//  WyhSelectedToolBar
//
//  Created by wyh on 2017/1/8.
//  Copyright © 2017年 被帅醒的吴宝宝. All rights reserved.
//

#import "ViewController.h"

#import "WyhTestCell.h"

#import "wyhHeader.h"

#import "WyhCustomNavToolBar.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,WyhCustomNavToolBarDelegate>

/**
 数据源
 */
@property (nonatomic, strong) NSMutableArray *dataSource;

/**
 tableView
 */
@property (nonatomic, strong) UITableView *tableView;

/**
 editBtn右侧编辑按钮
 */
@property (nonatomic, strong) UIButton *editButton;

/**
 当前是否是编辑模式
 */
@property (nonatomic, assign) BOOL isEditting;

/**
 当前选中的indexPath
 */
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *selectArr;

@end

@implementation ViewController



-(NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"wyhPlist" ofType:@"plist"];
        
        _dataSource = [NSArray arrayWithContentsOfFile:path].mutableCopy;
    }
    
    return _dataSource;
}

-(NSMutableArray<NSIndexPath *> *)selectArr{
    if (!_selectArr) {
        _selectArr = [NSMutableArray new];
    }
    return _selectArr;
}

-(UITableView *)tableView{
    if (!_tableView) {
        UITableView *tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height) style:(UITableViewStyleGrouped)];
        _tableView = tab;
        tab.delegate = self;
        tab.dataSource = self;
        tab.backgroundColor = [UIColor whiteColor];
        [tab registerNib:[UINib nibWithNibName:@"WyhTestCell" bundle:nil] forCellReuseIdentifier:testCellReuseIdentifier];
        tab.separatorStyle = 0;
        tab.estimatedRowHeight = 150;
        tab.rowHeight = UITableViewAutomaticDimension;//这个常量表示自动计算高度,我会在另一篇文章单独做说明
        [self.view addSubview:tab];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self leftItem];
    
    [self rightItem];
    
    [self tableView];
    
}

/**
 左侧item
 */
-(void)leftItem{
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"恢复数据" style:(UIBarButtonItemStyleDone) target:self action:@selector(resumeData:)];
    
//    [item setTitleTextAttributes:@{NSFontAttributeName:font(16),NSForegroundColorAttributeName:UIColorFromRGB(0x999999)} forState:(UIControlStateNormal)];
    
    self.navigationItem.leftBarButtonItem = item;
    
}

-(void)resumeData:(id)barItem{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"wyhPlist" ofType:@"plist"];
    
    NSArray *newdata = [NSArray arrayWithContentsOfFile:path].mutableCopy;
    
    self.dataSource = [NSArray arrayWithArray:newdata].mutableCopy;
    
//    [self.dataSource addObjectsFromArray:newdata];
    
    [self.tableView reloadData];
    
}

/**
 右侧item
 */
-(void)rightItem{

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = Frame(0, 0, 45, 25);
    [button setImage:[UIImage imageNamed:@"btn_delete"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"btn_delete_chinese"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.selected = NO;
    self.editButton = button;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.editButton];
    
    [WyhCustomNavToolBar toolBarWithContext:self Delegate:self];//初始化toolbar
    
}

#pragma mark - editBtn Action

-(void)editButtonClick:(UIButton *)sender{
    
    [self.selectArr removeAllObjects];
    
    if (!sender.selected) {
        //        NSLog(@"编辑模式");
        self.isEditting = YES;
        [WyhCustomNavToolBar showToolBar:YES Animation:YES];
    }else{
        //        NSLog(@"非编辑模式");
        self.isEditting = NO;
        [WyhCustomNavToolBar showToolBar:NO Animation:YES];
    }
    
    [self.tableView beginUpdates];
    
    for (WyhTestCell *cell in self.tableView.visibleCells) {
        cell.isEditting = self.isEditting;
        cell.selected = !sender.selected;
    }
    
    [self.tableView endUpdates];
    
    //    [self.tableView reloadData];//refresh(弃用,无动画,太生硬)
    
    sender.selected = !sender.selected;
}



#pragma mark - tableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WyhTestCell *cell = [tableView dequeueReusableCellWithIdentifier:testCellReuseIdentifier forIndexPath:indexPath];
    
    cell.isEditting = self.isEditting;
    cell.selectionStyle = 0;
    
    [cell setDataWithDict:self.dataSource[indexPath.row]];
    
    if ([self.selectArr containsObject:indexPath]) {
        cell.isSelected = YES;
    }else{
        cell.isSelected = NO;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WyhTestCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (self.isEditting) {  //若为编辑模式
        
        if (![self.selectArr containsObject:indexPath]) {
            cell.isSelected = YES;
            [self.selectArr addObject:indexPath];
        }else{
            cell.isSelected = NO;
            [self.selectArr removeObject:indexPath];
        }
        
    }else{
        
        NSLog(@"您点击了第%ld个cell",indexPath.row + 1);
    }
    
    [WyhCustomNavToolBar setDeleteNum:self.selectArr.count];//变化删除个数
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

#pragma mark - HWCustomNavigationToolBar Delegate
-(void)didClickAllselectBtn:(UIButton *)sender{
    
    [self.selectArr removeAllObjects];//先移除数据源
    
    [self.tableView beginUpdates];
    for (WyhTestCell *cell in self.tableView.visibleCells) {
        cell.isSelected = !sender.selected;
    }
    
    if (NO == sender.selected) { //全选
        
        for (int i = 0; i < self.dataSource.count; i++) {
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
            
            [self.selectArr addObject:indexpath];
        }
    }
    sender.selected = ! sender.selected;
    [self.tableView endUpdates];
}

-(void)didClickDeleteBtn:(UIButton *)sender{
    
    
    NSMutableArray *copyArr = [NSMutableArray new];//镜像数组,存放需删除的数据源
    for (NSIndexPath *indexpath in self.selectArr) {
        [copyArr addObject:self.dataSource[indexpath.row]];
    }
    
    [self.dataSource removeObjectsInArray:copyArr];//根据镜像去删除数据
    
    [self.tableView deleteRowsAtIndexPaths:self.selectArr withRowAnimation:0];
    
    [self.selectArr removeAllObjects];
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
