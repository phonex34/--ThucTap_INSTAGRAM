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
- (void)awakeFromNib
{
    [bigImageView addSubview:indicator];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) initiallizFromdictAtIndex:(PDLPhotos *) object andIndex:(NSIndexPath *)indexPath{

    labelUser.text = [object username];
    labelTitle.text = [object title];
    labelDate.text = object.dateTaken;
    [smallImageView setImageWithURL:[NSURL URLWithString:[object avatar]] placeholderImage:[UIImage imageNamed: @"placeholder.png"]];
    [bigImageView setImageWithURL:[NSURL URLWithString:[object bigPhoto]] placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:0 progress:^(NSUInteger receivedSize, long long expectedSize) {
        
        float number = (float)receivedSize/(float)expectedSize;
        progressBar.progress = number;
        NSLog(@"data received : %lld",expectedSize);
        [indicator startAnimating];
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
        [indicator stopAnimating];
        indicator.hidden = YES;
        progressBar.hidden = YES;
    }
     ];
    
}

@end
