//
//  DiYuListViewController.m
//  IYLM
//
//  Created by Jian-Ye on 12-10-30.
//  Copyright (c) 2012年 Jian-Ye. All rights reserved.
//

#import "GOPMovieCommonQuestionVC.h"
#import "Cell1.h"
#import "Cell2.h"
@interface GOPMovieCommonQuestionVC()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataList;
    
}
@property (assign)BOOL isOpen;
@property (nonatomic,retain)NSIndexPath *selectIndex;  //记录所点击的那个 cell

@property (nonatomic,retain)UITableView *expansionTableView;

@end

@implementation GOPMovieCommonQuestionVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"CommonQuestion" ofType:@"plist"];
    _dataList = [[NSMutableArray alloc] initWithContentsOfFile:path];
    NSLog(@"%@",_dataList);
    
    self.expansionTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.expansionTableView.delegate = self;
    self.expansionTableView.dataSource = self;
    
    self.expansionTableView.sectionFooterHeight = 0;
    self.expansionTableView.sectionHeaderHeight = 0;
    self.expansionTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
    self.expansionTableView.tableFooterView = [[UIView alloc]init];
    self.isOpen = 0;//默认不打开
    
    [self.view addSubview:self.expansionTableView];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isOpen) {
        if (self.selectIndex.section == section) {
            return 2;
        }
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 40.0;
    }
    return 110.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isOpen&&self.selectIndex.section == indexPath.section&&indexPath.row!=0) {
        //打开时,展开的 cell
        static NSString *CellIdentifier = @"Cell2";
        Cell2 *cell = (Cell2*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
        }
        cell.titleLabel.numberOfLines = 0;
//        [cell.titleLabel sizeToFit];
        
        NSString *answer = [[_dataList objectAtIndex:indexPath.section] objectForKey:@"answer"];
        cell.titleLabel.text = answer;
        return cell;
    }else{
        //row = 0 使用这个
        static NSString *CellIdentifier = @"Cell1";
        Cell1 *cell = (Cell1*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
        }
        NSString *question = [[_dataList objectAtIndex:indexPath.section] objectForKey:@"question"];
        cell.titleLabel.text = question;
        [cell changeArrowWithUp:([self.selectIndex isEqual:indexPath]?YES:NO)];
        return cell;
    }
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {//点击 sectiong
        if ([indexPath isEqual:self.selectIndex]) {
            self.isOpen = NO;
            [self didSelectCellRowFirstDo:NO nextDo:NO];//打开只有关闭
            self.selectIndex = nil;
            
        }else{
            if (!self.selectIndex) {// 还没打开过
                self.selectIndex = indexPath;
                [self didSelectCellRowFirstDo:YES nextDo:NO];//第一次打开
                
            }else{
                
                [self didSelectCellRowFirstDo:NO nextDo:YES];//已经有打开的,再次点击其他的 section
            }
        }
        
    }else{
        NSDictionary *dic = [_dataList objectAtIndex:indexPath.section];
        NSArray *list = [dic objectForKey:@"list"];
        NSString *item = [list objectAtIndex:indexPath.row-1];
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:nil message:item delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil] autorelease];
        [alert show];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert
{
    self.isOpen = firstDoInsert;
    
    Cell1 *cell = (Cell1 *)[self.expansionTableView cellForRowAtIndexPath:self.selectIndex];
    [cell changeArrowWithUp:firstDoInsert];
    
    [self.expansionTableView beginUpdates];
    
    NSInteger section = self.selectIndex.section;
    NSInteger contentCount = 1;
    NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
    for (NSUInteger i = 1; i < contentCount + 1; i++) {
        NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:section];
        [rowToInsert addObject:indexPathToInsert];
    }
    
    if (firstDoInsert)
    {   [self.expansionTableView insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }else{
        [self.expansionTableView deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    
    [rowToInsert release];
    
    [self.expansionTableView endUpdates];
    if (nextDoInsert) {
        self.isOpen = YES;
        self.selectIndex = [self.expansionTableView indexPathForSelectedRow];
        [self didSelectCellRowFirstDo:YES nextDo:NO];
    }
    if (self.isOpen) [self.expansionTableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
}







- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

@end
