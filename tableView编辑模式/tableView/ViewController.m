//
//  ViewController.m
//  tableView
//
//  Created by xueshan on 17/1/10.
//  Copyright © 2017年 xueshan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,assign)BOOL isAdd;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.dataArray = [NSMutableArray arrayWithArray: @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"]];
    
    [self createView];
    self.view.backgroundColor = [UIColor greenColor];
}

-(void)createView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ce"];
//    self.tableView.bounces = 0;
//    self.tableView.showsVerticalScrollIndicator = 0;
    
    self.tableView.tableFooterView = [[UIView alloc]init];//没有的不展示 line
    
   
    UIBarButtonItem *deleteBar = [[UIBarButtonItem alloc]initWithTitle:@"删除" style: UIBarButtonItemStylePlain target:self action:@selector(deleteBtn)];
    self.navigationItem.rightBarButtonItem = deleteBar;
    

    UIBarButtonItem *addBar1 = [[UIBarButtonItem alloc]initWithTitle:@"添加1  " style: UIBarButtonItemStylePlain target:self action:@selector(addBtn)];
    UIBarButtonItem *addBar2 = [[UIBarButtonItem alloc]initWithTitle:@"  添加2(模式)" style: UIBarButtonItemStylePlain target:self action:@selector(addBtn2)];

    self.navigationItem.leftBarButtonItems = @[addBar1,addBar2];
}

//删除(进入编辑模式)
- (void)deleteBtn{
    self.isAdd = NO;
    
    static int flog = 1;
    flog ^= 1;
    if (flog) {
        [self.tableView setEditing:YES animated:YES];
        
    }else{
        [self.tableView setEditing:NO animated:YES];

    }
    
}
//增加1
- (void)addBtn{
    
    [self.dataArray addObject:@"新增一条"];
    //在 <指定行> 添加
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationRight];
    
}
- (void)addBtn2{
    self.isAdd = YES;
    
    
    static int flog = 1;
    flog ^= 1;
    if (flog) {
        [self.tableView setEditing:YES animated:YES];
        
    }else{
        [self.tableView setEditing:NO animated:YES];
        
    }
    
}
#pragma mark --dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ce"];
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}



#pragma mark -- delegate 编辑模式(增加/删除/移动)

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isAdd) {
        return UITableViewCellEditingStyleInsert; //添加

    }else{
        return UITableViewCellEditingStyleDelete;   //删除
    }
    
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
     NSInteger sourceRow = indexPath.row;
    //删除
    if (editingStyle == UITableViewCellEditingStyleDelete) {
       
        [self.dataArray removeObjectAtIndex:sourceRow];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationLeft];
    }
    //添加(点击+号按钮)
    else if (editingStyle == UITableViewCellEditingStyleInsert){
        
        [self.dataArray insertObject:@"新增" atIndex: sourceRow+1];
        //在指定位置插入
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:sourceRow+1 inSection:indexPath.section];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:newIndexPath, nil] withRowAnimation:UITableViewRowAnimationRight];
        
    }
    
  
}

//移动(只有写了这个方法才能移动,但此时不能左滑)
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    NSInteger sourceRow = sourceIndexPath.row;
    NSInteger destinRow = destinationIndexPath.row;
    
    NSString *moveObject = [self.dataArray objectAtIndex:sourceRow];
    
    [self.dataArray removeObjectAtIndex:sourceRow];
    [self.dataArray insertObject:moveObject atIndex:destinRow];  //改变在<对象>数组中的位置
    
}

#pragma mark --左滑选项(title可自已定义)
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //1.删除
    UITableViewRowAction *deleteRoWAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@" 删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {//title可自已定义
        NSLog(@"点击了-删除");
        
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationLeft];

    }];
    deleteRoWAction.backgroundColor = [UIColor greenColor]; //定义button的颜色，默认是红色的
    
    //test
    UITableViewRowAction *test = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@" 置顶" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {//title可自已定义
        NSLog(@"点击了-test");
    }];
    test.backgroundColor = [UIColor blueColor];
    
    return @[deleteRoWAction,test];//最后返回这俩个RowAction 的数组
}





@end
