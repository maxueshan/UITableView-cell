//
//  WyhTestCell.m
//  WyhSelectedToolBar
//
//  Created by wyh on 2017/1/8.
//  Copyright © 2017年 被帅醒的吴宝宝. All rights reserved.
//

#import "WyhTestCell.h"

@interface WyhTestCell ()

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation WyhTestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.icon.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = 23.f/2.;
    
    // Initialization code
}

#pragma mark - set data
-(void)setDataWithDict:(NSDictionary *)dict{
    
    self.icon.image = [UIImage imageNamed:dict[@"icon"]];
    self.nicknameLabel.text = dict[@"name"];
    self.timeLabel.text = dict[@"time"];
    self.contentLabel.text = dict[@"text"];
    
}

#pragma mark - selectBtn action
- (IBAction)selectAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
}

#pragma mark - set frame (重写frame方法)
-(void)setFrame:(CGRect)frame{
    
    frame.size.width = Screen_width + 37;
    
    if (self.isEditting) {
        frame.origin.x = 0;
    }else{
        
        frame.origin.x = - 37;
    }
    [super setFrame:frame];
}



#pragma mark - 重写get和set方法

-(void)setIsEditting:(BOOL)isEditting{
    _isEditting = isEditting;
    
    if (!isEditting) {
        self.isSelected = NO;
    }
}


-(void)setIsSelected:(BOOL)isSelected{
    
    self.selectBtn.selected = isSelected;
    
}

-(BOOL)isSelected{
    return self.selectBtn.selected;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
