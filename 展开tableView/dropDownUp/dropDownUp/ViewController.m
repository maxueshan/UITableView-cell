//
//  ViewController.m
//  dropDownUp
//
//  Created by xueshan on 16/12/30.
//  Copyright © 2016年 xueshan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *_btn;
    UITableView *_tableView;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 200, 40)];
    label.backgroundColor = [UIColor redColor];
    
    
    _btn = [[UIButton alloc]initWithFrame:CGRectMake(200, 100, 40, 40)];
    [_btn setBackgroundImage:[UIImage imageNamed:@"dropdown"] forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 140-1, 240, 0)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.layer.borderWidth = 1;
    _tableView.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:_tableView];
    
    [self.view addSubview:label];
    
}

- (void)btnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    
    if (btn.selected) {
      [UIView animateWithDuration:1 animations:^{
          _tableView.frame = CGRectMake(0, 140-1, 240, 40*5);
          [_btn setBackgroundImage:[UIImage imageNamed:@"dropdown"] forState:UIControlStateNormal];
          
      } completion:^(BOOL finished) {
          
          
          
      }];
        
        
    }else{
        
        [UIView animateWithDuration:1 animations:^{
            _tableView.frame = CGRectMake(0, 140-1, 240, 0);
            [_btn setBackgroundImage:[UIImage imageNamed:@"dropup"] forState:UIControlStateNormal];
            
            
        } completion:^(BOOL finished) {
            
            
            
        }];
        
        
    }
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ce"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ce"];
    }
    cell.textLabel.text = @"下拉列表";
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
