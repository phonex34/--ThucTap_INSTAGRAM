//
//  ShareViewController.h
//  ThucTap_INSTAGRAM
//
//  Created by MAC on 7/23/14.
//  Copyright (c) 2014 DanielDuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>

@interface ShareViewController : UIViewController<UIActionSheetDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    SLComposeViewController *composeViewController;
    NSArray *shareTo;
    NSString *selectItem;
}


@property(strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UISwitch *switchMap;

@property(strong, nonatomic) UIImage *lkImage;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIButton *btnFacebook;
@property (weak, nonatomic) IBOutlet UIButton *btnTwitter;
@property (weak, nonatomic) IBOutlet UIButton *btnSinaWeibo;
@property (weak, nonatomic) IBOutlet UIButton *LTTTeam8;

@end
