//
//  ViewController.m
//  BTCropAndResizeImage
//
//  Created by MAC on 7/16/14.
//  Copyright (c) 2014 DanielDuong. All rights reserved.
//

#import "ViewController.h"
#import "resizeImage.h"
#import "testViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    UIImage *imageToCrop;
    NSInteger chooseType;
}
@synthesize imageView,boundView;
- (void)viewDidLoad
{
    [super viewDidLoad];
    chooseType = 0;
    //imageToCrop =[UIImage imageNamed:@"images1.jpeg"];
    //self.imageView.image = imageToCrop;
	// Do any additional setup after loading the view, typically from a nib.
    
    ImagePicker = [[UIImagePickerController alloc]init];
    ImagePicker.delegate = self;
    @try{
        NSLog(@"You choose Camera");
        ImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        chooseType = 1;
        [self presentViewController:ImagePicker animated:YES completion:NULL];
    }
    @catch(NSException *ex)
    {
        NSString *string = [[NSString alloc]initWithFormat:@"Error %@ \nCó lẽ là không có thiết bị Camera đi kèm",ex];
        UIAlertView *message = [[UIAlertView alloc]initWithTitle:@"Message" message:string delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [message show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Pan gesture recognizer action
- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    switch (recognizer.state) {
            
        case UIGestureRecognizerStateChanged: {
            
            CGPoint translation = [recognizer translationInView:self.view];
            
            //allow dragging only in Y coordinates by only updating the Y coordinate with translation position
            recognizer.view.center = CGPointMake(recognizer.view.center.x, recognizer.view.center.y + translation.y);
            
            [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
            
            
            //get the top edge coordinate for the top left corner of crop frame
            float topEdgePosition = CGRectGetMinY(boundView.frame);
            
            //get the bottom edge coordinate for bottom left corner of crop frame
            float bottomEdgePosition = CGRectGetMaxY(boundView.frame);
            
            //if the top edge coordinate is less than or equal to 53
            if (topEdgePosition <= 0) {
                
                //draw drag view in max top position
                
                boundView.frame = CGRectMake(0, 0, 320, 320);
                
            }
            
            //if bottom edge coordinate is greater than or equal to 480
            
            if (bottomEdgePosition >=430) {
                
                //draw drag view in max bottom position
                boundView.frame = CGRectMake(0, 110, 320, 320);
            }
            
        }
            
        default:
            
            break;
            
            
    }
    
    
}


//receiver image return
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *imageChoose = [info objectForKey:UIImagePickerControllerOriginalImage];
    [imageView setImage:imageChoose];
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}
//click cancel
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

//action click camera
- (IBAction)CameraClicked:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]init];
    actionSheet.delegate = self;
    [actionSheet addButtonWithTitle:@"Camera"];
    [actionSheet addButtonWithTitle:@"PhotoLibrary"];
    [actionSheet addButtonWithTitle:@"Cancel"];
    actionSheet.cancelButtonIndex=actionSheet.numberOfButtons -1;
    [actionSheet showInView:[self.view window]];
    
}


#pragma mark -
#pragma mark UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Save To Camera Roll"]) {
    if (buttonIndex == 0){
        //save photo
        @try{
            NSLog(@"You choose Camera");
            ImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            chooseType =1;
            [self presentViewController:ImagePicker animated:YES completion:NULL];
        }
        @catch(NSException *ex)
        {
            NSString *string = [[NSString alloc]initWithFormat:@"Error %@ \nCó lẽ là không có thiết bị Camera đi kèm",ex];
            UIAlertView *message = [[UIAlertView alloc]initWithTitle:@"Message" message:string delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [message show];
        }
    }
    if (buttonIndex ==1) {
        NSLog(@"You choose go to PhotoLibarary");
        
        ImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        chooseType =0;
        [self presentViewController:ImagePicker animated:YES completion:NULL];
    }
    if (buttonIndex ==2) {
        NSLog(@"Cancel Actionsheet");
        chooseType =0;
    }
}


//action choose image from photoLibrary
- (IBAction)ChooseImageClicked:(id)sender {
    NSLog(@"You choose go to PhotoLibarary");
    
    ImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    chooseType =0;
    [self presentViewController:ImagePicker animated:YES completion:NULL];
}

//truyen du lieu sang view crop image
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"filterView"]) {
        NSLog(@"CroppedView was choose");
        testViewController *destViewController = segue.destinationViewController;
        destViewController.lkBoundView = self.boundView;
        destViewController.lkImageToCrop= self.imageView.image;
        destViewController.lkChooseType = chooseType;
    }
}

@end
