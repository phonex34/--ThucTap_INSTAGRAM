//
//  PDLCustomCell.m
//  Example3
//
//  Created by Dinh Luong on 7/22/26 H.
//  Copyright (c) 26 Heisei Dinh Luong. All rights reserved.
//

#import "PDLCustomCell.h"

@implementation PDLCustomCell
@synthesize labelDate;
@synthesize labelTitle;
@synthesize labelUser;
@synthesize bigImageView;
@synthesize smallImageView;
@synthesize indicator;
- (void)awakeFromNib
{
    [bigImageView addSubview:indicator];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
