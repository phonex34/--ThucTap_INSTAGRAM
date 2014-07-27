//
//  ImageProcessingCore.m
//  ArtCameraPro
//
//  Created by phonex on 7/27/14.
//  Copyright (c) 2014 DanielDuong. All rights reserved.
//

#import "ImageProcessingCore.h"
#import "UIImage+FiltrrCompositions.h"
@implementation ImageProcessingCore



NSMutableDictionary *allEditFilter;
CIFilter *lighten,*sharpen,*contrast;
UIImageOrientation orientation; // New!




-(UIImage *)editImageProcessing:(UIImage *)imageViewController withAmount:(float)intensity editTag:(int ) tag{
    NSArray *editFilterName = @[@"Brightness", @"Sharpenss",
                                @"Contrast",@"Effect"];
    NSArray *filterValue = @[[NSNumber numberWithFloat:0.0],
                             [NSNumber numberWithFloat:0.0],
                             [NSNumber numberWithFloat:1.0],
                             [NSNumber numberWithInt:0]];
    allEditFilter = [NSMutableDictionary dictionaryWithObjects:filterValue forKeys:editFilterName];

    CIContext *context;
    context = [CIContext contextWithOptions:nil];
    CIImage *imageCIEditProcessing,*outputCIImage;
    lighten = [CIFilter filterWithName:@"CIColorControls"];
    sharpen =  [CIFilter filterWithName:@"CISharpenLuminance"];
    contrast = [CIFilter filterWithName:@"CIColorControls"];
    UIImage *outputUIImage;
    imageCIEditProcessing = [CIImage imageWithCGImage:imageViewController.CGImage];
    switch (tag) {
        case 2:
            [allEditFilter setObject: [NSNumber numberWithFloat:intensity] forKey:@"Brightness"];
            NSLog(@"%@",allEditFilter);
            [lighten setValue:imageCIEditProcessing forKey:kCIInputImageKey];
            [lighten setValue:[allEditFilter objectForKey:@"Brightness"] forKey:@"inputBrightness"];
            [sharpen setValue:lighten.outputImage forKey:kCIInputImageKey];
            [sharpen setValue:[allEditFilter objectForKey:@"Sharpenss"] forKey:@"inputSharpness"];
            [contrast setValue:sharpen.outputImage forKey:kCIInputImageKey];
            [contrast setValue:[allEditFilter objectForKey:@"Contrast"] forKey:@"inputContrast"];
            break;
        case 3:
            [allEditFilter setObject: [NSNumber numberWithFloat:intensity] forKey:@"Sharpenss"];
            NSLog(@"%@",allEditFilter);
            [lighten setValue:imageCIEditProcessing forKey:kCIInputImageKey];
            [lighten setValue:[allEditFilter objectForKey:@"Brightness"] forKey:@"inputBrightness"];
            [sharpen setValue:lighten.outputImage forKey:kCIInputImageKey];
            [sharpen setValue:[allEditFilter objectForKey:@"Sharpenss"] forKey:@"inputSharpness"];
            [contrast setValue:sharpen.outputImage forKey:kCIInputImageKey];
            [contrast setValue:[allEditFilter objectForKey:@"Contrast"] forKey:@"inputContrast"];
            break;
        case 4:
            [allEditFilter setObject: [NSNumber numberWithFloat:intensity] forKey:@"Contrast"];
            NSLog(@"%@",allEditFilter);
            [lighten setValue:imageCIEditProcessing forKey:kCIInputImageKey];
            [lighten setValue:[allEditFilter objectForKey:@"Brightness"] forKey:@"inputBrightness"];
            [sharpen setValue:lighten.outputImage forKey:kCIInputImageKey];
            [sharpen setValue:[allEditFilter objectForKey:@"Sharpenss"] forKey:@"inputSharpness"];
            [contrast setValue:sharpen.outputImage forKey:kCIInputImageKey];
            [contrast setValue:[allEditFilter objectForKey:@"Contrast"] forKey:@"inputContrast"];
            
            break;
        default:
            break;
    }

    
    outputCIImage=contrast.outputImage;
    
    CGImageRef cgimg = [context createCGImage:outputCIImage
                                     fromRect:[outputCIImage extent]];
    
    outputUIImage = [UIImage imageWithCGImage:cgimg scale:1.0 orientation:orientation];
    
    CGImageRelease(cgimg);
    
    
    return outputUIImage;
}


-(UIImage *)effectImageProcessing:(UIImage *)imageViewController editTag:(int ) tag{
    switch (tag) {
            
        case 2:
            imageViewController=[imageViewController e1];
          
            [allEditFilter setObject:[NSNumber numberWithInt:1] forKey:@"Effect"];
            break;
        case 3:
            imageViewController=[imageViewController  e2];
       
            [allEditFilter setObject: [NSNumber numberWithInt:2] forKey:@"Effect"];
            break;
        case 4:
            [allEditFilter setObject: [NSNumber numberWithInt:3] forKey:@"Effect"];
            imageViewController=[imageViewController e3];

  
            break;
        case 5:
            [allEditFilter setObject: [NSNumber numberWithInt:4] forKey:@"Effect"];
            imageViewController=[imageViewController e4];
     
            break;
        case 6:
            [allEditFilter setObject: [NSNumber numberWithInt:5] forKey:@"Effect"];
            imageViewController=[imageViewController  e5];
       
            break;
        case 7:
            [allEditFilter setObject: [NSNumber numberWithInt:6] forKey:@"Effect"];
            imageViewController=[imageViewController  e6];
     
            break;
        case 8:
            [allEditFilter setObject: [NSNumber numberWithInt:7] forKey:@"Effect"];
            imageViewController=[imageViewController  e7];
            //            imageView.image=imageViewController;
            break;
        case 9:
            [allEditFilter setObject: [NSNumber numberWithInt:8] forKey:@"Effect"];
            imageViewController=[imageViewController  e8];
            //            imageView.image=imageViewController;
            break;
        case 10:
            [allEditFilter setObject: [NSNumber numberWithInt:9] forKey:@"Effect"];
            imageViewController=[imageViewController  e9];
            //            imageView.image=imageViewController;
            break;
        case 11:
            [allEditFilter setObject: [NSNumber numberWithInt:10] forKey:@"Effect"];
            imageViewController=[imageViewController e10];
            //            imageView.image=imageViewController;
            break;
        case 12:
            [allEditFilter setObject: [NSNumber numberWithInt:11] forKey:@"Effect"];
            imageViewController=[imageViewController e11];
            //            imageView.image=imageViewController;
            break;
            
        default:
            break;
            
    }
    return imageViewController;

}
@end
