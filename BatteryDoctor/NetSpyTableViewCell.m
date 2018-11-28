//
//  NetSpyTableViewCell.m
//  NewiPhoneADV
//
//  Created by zhuang chaoxiao on 15/8/18.
//  Copyright (c) 2015年 zhuang chaoxiao. All rights reserved.
//

#import "NetSpyTableViewCell.h"


@interface NetSpyTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *ipAddrLab;
@property (weak, nonatomic) IBOutlet UILabel *macAddrLab;

@end

@implementation NetSpyTableViewCell


-(void)refreshCell:(DeviceInfo*)info
{
    _ipAddrLab.text = info.ipAddr;
    _macAddrLab.text = [info.macAddr uppercaseString];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
