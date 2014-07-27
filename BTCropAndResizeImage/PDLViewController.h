//
//  PDLViewController.h
//  Example3
//
//  Created by Dinh Luong on 7/22/26 H.
//  Copyright (c) 26 Heisei Dinh Luong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDLViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,NSURLConnectionDataDelegate,NSURLConnectionDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,assign) NSString *token;
@property (nonatomic,strong)  NSURLConnection *connection;
@property (nonatomic,strong)  NSURLConnection *connection1;
@property (nonatomic, strong) NSMutableURLRequest *request1;
@property (nonatomic, strong) NSMutableURLRequest *request;
@property (nonatomic, retain) NSMutableData *receivedData;
@end
