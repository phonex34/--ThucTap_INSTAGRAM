//
//  PDLViewController.h
//  Example3
//
//  Created by Dinh Luong on 7/22/26 H.
//  Copyright (c) 26 Heisei Dinh Luong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDLViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)reloadData:(id)sender;
@end
