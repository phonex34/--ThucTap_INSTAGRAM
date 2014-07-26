//
//  ShareViewController.m
//  ThucTap_INSTAGRAM
//
//  Created by MAC on 7/23/14.
//  Copyright (c) 2014 DanielDuong. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController
@synthesize lkImage,imageView,textField,textView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    imageView.image = lkImage;
    textField.delegate = self;
    textView.delegate = self;
//    pickerView.delegate = self;
//    pickerView.dataSource = self;
    shareTo = [NSArray arrayWithObjects:@"None",@"Facebook",@"Twitter",@"SinaWeibo", nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


//set keboard and return button
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [textField resignFirstResponder];
    [textView resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField) {
        [textField resignFirstResponder];
    }
    return NO;
}
-(BOOL)textViewShouldReturn:(UITextView *)textView
{
    if (textView) {
        [textView resignFirstResponder];
    }
    return NO;
}

//set location for textField when keyBoard appear
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame =CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y-10), self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame =CGRectMake(self.view.frame.origin.x, (self.view.frame.origin.y+10), self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
}
////handle with picker view
//-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
//{
//    return 1;
//}
//-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
//{
//    return [shareTo count];
//}
//-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    return [shareTo objectAtIndex:row];
//}
//-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    [self shareToInternet:row];
//}
//share to select
#pragma mark share
-(void)shareToInternet:(NSInteger )serviceType
{
    
    NSString *string ;
    switch (serviceType) {
        case 1:{
            
            string = @"Configure an account Facebook in setting";

            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
                composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                [composeViewController addImage:imageView.image];
                //textview
                [composeViewController setInitialText:textView.text];
                //textField
                
                [self presentViewController:composeViewController animated:YES completion:NULL];
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Account Found" message:string delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
                [alert setAlertViewStyle:UIAlertViewStyleDefault];
                [alert show];
            }

        }
            break;
        case 2:
            string = @"Configure an account Twitter in setting";
        {
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
                composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                [composeViewController addImage:imageView.image];
                //textview
                [composeViewController setInitialText:textView.text];

                //textField
                
                [self presentViewController:composeViewController animated:YES completion:NULL];
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Account Found" message:string delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
                [alert setAlertViewStyle:UIAlertViewStyleDefault];
                [alert show];
            }
        }
            break;
        
        case 3:
            string = @"Configure an account SinaWeibo in setting";
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo]) {
                composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
                [composeViewController addImage:imageView.image];
                //textview
                [composeViewController setInitialText:textView.text];

                //textField
                
                [self presentViewController:composeViewController animated:YES completion:NULL];
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Account Found" message:string delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
                [alert setAlertViewStyle:UIAlertViewStyleDefault];
                [alert show];
            }
            break;
            
        case 4:
            NSLog(@"Share to LTTTeam8");
            break;
            
        default:
            NSLog(@"None");
            break;
    }

}

//action save image to camera roll
- (IBAction)saveToCameraRollClicked:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]init];
    actionSheet.delegate = self;
    [actionSheet addButtonWithTitle:@"Save To Camera Roll"];
    //put cancel button the last one
    [actionSheet addButtonWithTitle:@"Cancel"];
    actionSheet.cancelButtonIndex=actionSheet.numberOfButtons -1;
    [actionSheet showInView:[self.view window]];
    
}

#pragma mark UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Save To Camera Roll"]) {
    if (buttonIndex == 0){
        //save photo
        UIImage *image = imageView.image;
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedPhotosAlbum:didFinishSavingWithError: contextInfo:), nil);
    }
}
-(void)imageSavedPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *message;
    NSString *title;
    if (!error) {
        title = @"";
        message = @"Your Photo was saved to the camera Roll.";
        
    }else{
        title = @"";
        message = [error description];
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
- (IBAction)FacebookClicked:(id)sender {
    [self shareToInternet:1];
}
- (IBAction)TwitterClicked:(id)sender {
    [self shareToInternet:2];
}
- (IBAction)SinaWeiboClicked:(id)sender {
    [self shareToInternet:3];
}
- (IBAction)LTTTeam8Clicked:(id)sender {
    [self shareToInternet:4];
}
- (IBAction)switchMapChoose:(id)sender {
    NSLog(@"Change SwitchMap");
}



@end







