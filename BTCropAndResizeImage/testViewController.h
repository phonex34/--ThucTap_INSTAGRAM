//
//  testViewController.h
//  CoreImageTest
//
//  Created by phonex on 7/16/14.
//  Copyright (c) 2014 lifetime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
@interface testViewController : UIViewController<UINavigationBarDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISlider *imageSlider;
@property (weak, nonatomic) IBOutlet UIScrollView *effectScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *editScrollView;
@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (weak, nonatomic) IBOutlet UIView *imageSliderView;
@property (strong, nonatomic) UIImage *imageToFilter;
@property (strong, nonatomic) NSData *DataResaultFilter;

@property (strong, nonatomic) UIView *lkBoundView;
@property (strong, nonatomic) UIImage *lkImageToCrop;
@property (nonatomic) NSInteger lkChooseType;

- (IBAction)changeSliderValue:(id)sender;

@end