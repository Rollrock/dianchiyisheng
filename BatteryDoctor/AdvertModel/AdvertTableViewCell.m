//
//  AdvertTableViewCell.m
//  test
//
//  Created by 停有钱 on 16/11/15.
//  Copyright © 2016年 rock. All rights reserved.
//

#import "AdvertTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "AdvertModel.h"

@interface AdvertTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *appImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *descLab;


@end

@implementation AdvertTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)refresCell:(AdvertModel*)model
{
    [self.appImgView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:nil];
    self.titleLab.text = model.title;
    self.descLab.text = model.desc;
}

@end
