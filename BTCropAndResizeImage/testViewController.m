//
//  testViewController.m
//  CoreImageTest
//
//  Created by phonex on 7/16/14.
//  Copyright (c) 2014 lifetime. All rights reserved.
//

#import "testViewController.h"
#import "UIImage+FiltrrCompositions.h"
#import "resizeImage.h"
#import "ShareViewController.h"
#import "UIImage+Extra.h"
#import "ImageProcessingCore.h"


#define SCREEN_WIDTH 120
#define SCREEN_HEIGHT 72

@interface testViewController ()

@end

@implementation testViewController{
    UIImage *imageToResize;
}
UIImage *beginImage;

//@auhtor phonex
//case edit button(switch bright,sharpness etc.....)
int caseEditButton;
//count effect used 0= no effect
int countEditUsed=0,countEffectUsed=0;
UIImage *beginUIImage,*imgViewAfterEditImage,*imgViewAfterEffectImage;//use to contain the temp imageview image

//@author phonex
//Array for ScrollView
NSArray *imageFilterScroll;
NSArray *titleFilterScroll;
UIButton *btnSingleEffect,*btnEffectImage,*btnEditImage;
//array for edit scroll view
NSArray *imageEditScroll;
UIButton *btnSingleEdit;


@synthesize navigationView,imageSliderView,imageView;
@synthesize imageSlider;
@synthesize effectScrollView,editScrollView;
@synthesize imageToFilter;

@synthesize lkImageToCrop;
@synthesize lkBoundView;
@synthesize lkChooseType;


- (void)viewDidLoad
{
    [super viewDidLoad];
    imageToResize= lkImageToCrop;
    imageView.image = [self cropImageMethod:[self resizeImage]];
    imageView.contentMode = UIViewContentModeScaleToFill;
    
    
    beginUIImage=imageView.image;
    
    
    
    //@author phonex
    //create matrix filter
    NSArray *editFilterName2= @[@"Brightness", @"Sharpenss",
                                @"Contrast",@"Effect"];
    
    
    //create a effect scrollview
    imageFilterScroll = [NSArray arrayWithObjects:@"e1.png",@"e2.png",@"e3.png",@"e4.png",@"e5.png",@"e6.png",@"e7.png",@"e8.png",@"e9.png",@"e10.png",@"e11.png", nil];
    titleFilterScroll =[NSArray arrayWithObjects:@"Effect1",@"Effect2",@"Effect3",@"Effect4",@"Effect5",@"Effect6",@"Effect7",@"Effect8",@"Effect9",@"Effect10",@"Effect11", nil];
    
    int leftMargin = 0;
    for (int i = 0; i < [imageFilterScroll count]; i++)
    {
        
        btnSingleEffect= [UIButton buttonWithType:UIButtonTypeCustom];
        btnSingleEffect.frame=CGRectMake(leftMargin, 10, SCREEN_WIDTH-10, SCREEN_HEIGHT-10);
        
        NSString *cacheImage = [NSString stringWithFormat:@"%@",[imageFilterScroll objectAtIndex:i]];
        
        UIImage *niceImage = [UIImage imageNamed:cacheImage];
        btnSingleEffect.tag=i+2;
        [btnSingleEffect setBackgroundImage:niceImage forState:UIControlStateNormal];
        [effectScrollView addSubview:btnSingleEffect];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin-2, 82, 120, 28)
                          ];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:[titleFilterScroll objectAtIndex:i]];
        
        
        [label setFont:[UIFont fontWithName:@"Helvetica" size:16]];
        [label setTextColor:[UIColor whiteColor]];
        [effectScrollView addSubview:label];
        leftMargin += SCREEN_WIDTH;
        [btnSingleEffect addTarget:self action:@selector(effectFilterSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    CGSize contentSize = CGSizeMake(leftMargin, SCREEN_HEIGHT+28);
    [self.effectScrollView setContentSize: contentSize];
    
    //create a edit scroll view
    [editScrollView setFrame:CGRectMake(0,365, 320, 100)];
    imageEditScroll = [NSArray arrayWithObjects:@"brightnesstool@2x.png",@"sharpentool@2x.png",@"contrasttool@2x.png", nil];
    leftMargin=0;
    for (int i = 0; i < [editFilterName2 count]-1; i++)
    {
        
        btnSingleEdit= [UIButton buttonWithType:UIButtonTypeCustom];
        btnSingleEdit.frame=CGRectMake(leftMargin, 10, SCREEN_WIDTH-80, SCREEN_HEIGHT-40);
        
        NSString *cacheImage = [NSString stringWithFormat:@"%@",[imageEditScroll objectAtIndex:i]];
        
        UIImage *niceImage = [UIImage imageNamed:cacheImage];
        btnSingleEdit.tag=i+2;
        [btnSingleEdit setBackgroundImage:niceImage forState:UIControlStateNormal];
        [editScrollView addSubview:btnSingleEdit];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin-2, 82, 120, 28)
                          ];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:[editFilterName2 objectAtIndex:i]];
        
        
        [label setFont:[UIFont fontWithName:@"Helvetica" size:16]];
        [label setTextColor:[UIColor whiteColor]];
        [editScrollView addSubview:label];
        leftMargin += SCREEN_WIDTH;
        [btnSingleEdit addTarget:self action:@selector(editFilterSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.editScrollView setContentSize: contentSize];
    effectScrollView.hidden=NO;
    editScrollView.hidden=YES;
    
    
    
    //create navigation view
    btnEffectImage=[UIButton buttonWithType:UIButtonTypeCustom];
    btnEffectImage.frame=CGRectMake(100, 5, 25, 30);
    btnEditImage=[UIButton buttonWithType:UIButtonTypeCustom];
    btnEditImage.frame=CGRectMake(200, 15, 25, 22);
    UIImage *effectImage=[UIImage imageNamed:@"filtertoolactive@2x.png"];
    UIImage *editImage=[UIImage imageNamed:@"edit-enhancetool@2x.png"];
    [btnEffectImage setBackgroundImage:effectImage forState:UIControlStateNormal];
    [btnEffectImage addTarget:self action:@selector(effectImage:) forControlEvents:UIControlEventTouchUpInside];
    [btnEditImage setBackgroundImage:editImage forState:UIControlStateNormal];
    [btnEditImage addTarget:self action:@selector(editImage:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:btnEffectImage];
    [navigationView addSubview:btnEditImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)changeSliderValue:(id)sender {
    //
    countEditUsed=1;
    UIImage *beginImage2;
    float slideValue = imageSlider.value;
    NSLog(@"gia tri slider %f va case edit button %d",slideValue,caseEditButton);
    NSLog(@"gia tri count effect %d",countEffectUsed);
    beginImage2 = beginUIImage;
    
    if(countEffectUsed==0){
        beginImage = beginUIImage;
        
    }
    else{
        beginImage=imgViewAfterEffectImage;
        
    }
    ImageProcessingCore *imageEditProcessing =[[ImageProcessingCore alloc] init];
    
    imageView.image= [imageEditProcessing editImageProcessing:beginImage withAmount:slideValue editTag:caseEditButton];
    
    imgViewAfterEditImage=[imageEditProcessing editImageProcessing:beginImage2 withAmount:slideValue editTag:caseEditButton];//
}

- (void) effectFilterSelected:(id)sender{
    int caseEffectButton=[sender tag];
    countEffectUsed=1;
    UIImage *tempEffectImage,*tempEffectImage2;
    tempEffectImage2=beginUIImage;
    NSLog(@"bien countediused %d",countEditUsed);
    if (countEditUsed==0) {
        tempEffectImage=beginUIImage;
    }
    else{
        
        tempEffectImage=imgViewAfterEditImage;
    }
    
    
    ImageProcessingCore *imageEffectProcessing =[[ImageProcessingCore alloc] init];
    imageView.image=[imageEffectProcessing effectImageProcessing:tempEffectImage editTag:caseEffectButton];
    imgViewAfterEffectImage=[imageEffectProcessing effectImageProcessing:tempEffectImage2 editTag:caseEffectButton];
}

-(void) editFilterSelected:(id)sender{
    [imageSliderView setFrame:CGRectMake(0,280, 320, 100)];
    editScrollView.hidden=YES;
    imageSliderView.hidden=NO;
    
    int btEditFilterTag=[sender tag];
    switch (btEditFilterTag) {
        case 2:
            caseEditButton=2;
            imageSlider.value=0.0;
            imageSlider.maximumValue=0.5;
            imageSlider.minimumValue=-0.5;
            
            break;
        case 3:
            
            caseEditButton=3;
            imageSlider.value=0.0;
            imageSlider.maximumValue=1;
            imageSlider.minimumValue=-1;
            
            break;
            
            
        case 4:
            caseEditButton=4;
            imageSlider.value=1.0;
            imageSlider.maximumValue=0.0;
            imageSlider.maximumValue=2.0;
            
            break;
        default:
            break;
    }
    
}


- (void) editImage:(id)sender{
    UIImage *editImage=[UIImage imageNamed:@"enhancetoolactive@2x.png"];
    UIImage *effectImage=[UIImage imageNamed:@"edit-filtertool@2x.png"];
    [btnEffectImage setBackgroundImage:effectImage forState:UIControlStateNormal];
    [btnEditImage setBackgroundImage:editImage forState:UIControlStateNormal];
    imageSliderView.hidden=YES;
    effectScrollView.hidden=YES;
    editScrollView.hidden=NO;
    
    
}


- (void) effectImage:(id)sender{
    UIImage *editImage=[UIImage imageNamed:@"edit-enhancetool@2x.png"];
    UIImage *effectImage=[UIImage imageNamed:@"filtertoolactive@2x.png"];
    [btnEffectImage setBackgroundImage:effectImage forState:UIControlStateNormal];
    [btnEditImage setBackgroundImage:editImage forState:UIControlStateNormal];
    imageSliderView.hidden=YES;
    effectScrollView.hidden=NO;
    editScrollView.hidden=YES;
}








//-------------------------------------------
//crop image
/*
 dvduongth copyright 2014
 */

- (UIImage *) cropImageMethod:(UIImage *)imageResizedToCrop
{
    UIImage *croppedImage;
    
    float topEdgePosition = CGRectGetMinY(lkBoundView.frame);
    
    CGRect croppedRect;
    
    //   CGFloat variableToCropHeight = (imageResizedToCrop.size.height/410.0);
    
    
    croppedRect = CGRectMake(0, topEdgePosition, 320, 320);
    CGImageRef tmp = CGImageCreateWithImageInRect([imageResizedToCrop CGImage], croppedRect);
    croppedImage = [UIImage imageWithCGImage:tmp];
    CGImageRelease(tmp);
    
    
    NSData *CroppedImageData = UIImageJPEGRepresentation(croppedImage, 1.0);
    NSData *imageData = UIImageJPEGRepresentation(imageResizedToCrop, 1.0);
    
    
    NSInteger imageToCropDataSize = imageData.length;
    
    NSLog(@"original size %d Bytes", imageToCropDataSize);
    NSLog(@"Resault crop size %d Bytes", CroppedImageData.length);
    
    return croppedImage;
}


//resizeImage for storage
- (UIImage *) resizeImage {
    UIImage *imageResault;
    //call resize image class
    resizeImage *imageResize = [[resizeImage alloc]init];
    imageResault = [imageResize resizeImage:imageToResize width:320 height:430];
    NSData *resizedImageData = [imageResize thumbnailImageData];
    
    
    //    imageView.image = [UIImage imageWithData:resizedImageData];
    
    //    if (lkChooseType ==1) {
    //        imageView.center =CGPointMake(imageView.frame.size.width/2, imageView.frame.size.height/2);
    //        imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    //    }
    
    
    // imageView.image = [imageView.image fixOrientation];
    //hien thi kich thuoc sau khi resize
    NSInteger resizedImageDataSize = resizedImageData.length;
    NSLog(@"resized size %d Bytes", resizedImageDataSize);
    NSLog(@"resault resize width %f height %f", imageResault.size.width,imageResault.size.height);
    return imageResault;
    
}

// truyen du lieu sang share view
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShareView"]) {
        ShareViewController *destination = segue.destinationViewController;
        destination.lkImage = imageView.image;
        
        
    }
}

//--------------------------------
//@author dvduongth
-(BOOL)hidesBottomBarWhenPushed
{
    return YES;
}


//---------

@end
