//
//  PDLCustomCell.m
//  Example3
//
//  Created by Dinh Luong on 7/22/26 H.
//  Copyright (c) 26 Heisei Dinh Luong. All rights reserved.
//

#import "PDLCustomCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation PDLCustomCell
@synthesize labelDate;
@synthesize labelTitle;
@synthesize labelUser;
@synthesize bigImageView;
@synthesize smallImageView;
@synthesize indicator;
@synthesize progressBar;
@synthesize avatarIndicator;
- (void)awakeFromNib
{
    [bigImageView addSubview:indicator];
    [self addSubview:smallImageView];
    [smallImageView addSubview:avatarIndicator];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    
}

-(void) initiallizFromdictAtIndex:(PDLPhotos *) object andIndex:(NSIndexPath *)indexPath{

    labelUser.text = [object username];
    labelTitle.text = [object title];
    labelDate.text = object.dateTaken;
    smallImageView.layer.cornerRadius = 5;
    smallImageView.layer.masksToBounds = YES;
    [smallImageView setImageWithURL:[NSURL URLWithString:[object avatar]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        [avatarIndicator stopAnimating];
        [avatarIndicator setHidden:YES];
    }];
    [bigImageView setImageWithURL:[NSURL URLWithString:[object bigPhoto]] placeholderImage:[UIImage imageNamed:@""] options:0 progress:^(NSUInteger receivedSize, long long expectedSize) {
        
        float number = (float)receivedSize/(float)expectedSize;
        progressBar.progress = number;
        [indicator startAnimating];
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        [indicator stopAnimating];
        indicator.hidden = YES;
        progressBar.hidden = YES;
    }
     ];
    
}

@end
