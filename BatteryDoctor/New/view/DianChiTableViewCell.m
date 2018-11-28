//
//  DianChiTableViewCell.m
//  BatteryDoctor
//
//  Created by zhuang chaoxiao on 2018/10/10.
//  Copyright © 2018年 zhuang chaoxiao. All rights reserved.
//

#import "DianChiTableViewCell.h"

@interface DianChiTableViewCell()
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UILabel *valueLab;

@end

@implementation DianChiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)refreshCell:(NSString*)name value:(NSString*)value
{
    self.nameLab.text = name;
    self.valueLab.text = value;
}

@end
