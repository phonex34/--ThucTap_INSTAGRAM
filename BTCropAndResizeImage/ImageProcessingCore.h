//
//  ImageProcessingCore.h
//  ArtCameraPro
//
//  Created by phonex on 7/27/14.
//  Copyright (c) 2014 DanielDuong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageProcessingCore : UIImage
-(UIImage *)editImageProcessing:(UIImage *)imageViewController withAmount:(float)intensity editTag:(int ) tag;
-(UIImage *)effectImageProcessing:(UIImage *)imageViewController editTag:(int ) tag;
@end
