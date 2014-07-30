//
//  PDLViewController.m
//  Example3
//
//  Created by Dinh Luong on 7/22/26 H.
//  Copyright (c) 26 Heisei Dinh Luong. All rights reserved.
//

#import "PDLViewController.h"
#import "PDLPhotos.h"
#import "PDLCustomCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PDLProcessConnection.h"
@interface PDLViewController ()

@property(strong,nonatomic) NSMutableArray *photos;
@end

@implementation PDLViewController

@synthesize tableView =  _tableView;
@synthesize photos = _photos;

- (void)viewDidLoad
{
    _photos = [[NSMutableArray alloc] init];
    PDLProcessConnection *_processor = [[PDLProcessConnection alloc] init];
    _photos = [_processor getDataFromObject:_processor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [_tableView reloadData];
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Delegate Table View

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [self viewDidLoad];
    return _photos.count;

}

-(NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *indentifier = @"myIndentifier";
    PDLCustomCell *cell = (PDLCustomCell *)[tableView dequeueReusableCellWithIdentifier:@"myIndentifier"];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PDLCustomCell" owner:self options:nil];
        cell = (PDLCustomCell *)[nib objectAtIndex:0];
    }
    PDLPhotos *photo = [_photos objectAtIndex:indexPath.row];
    [cell initiallizFromdictAtIndex:photo andIndex:indexPath];
    [cell.indicator startAnimating];
    cell.smallImageView.contentMode = UIViewContentModeScaleAspectFit;
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PDLCustomCell *cell = (PDLCustomCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"witdh : %f height :%f X: %f Y : %f",cell.bigImageView.frame.size.width,cell.bigImageView.frame.size.height,cell.bigImageView.frame.origin.x,cell.bigImageView.frame.origin.y);
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger i = indexPath.row;
    PDLPhotos *photo = [_photos objectAtIndex:i];
    int width = photo.width.intValue;
    int height = photo.height.intValue;
    float factor = (float)width/320.0;
    return (float)((float)(height/factor)+62);
}


- (IBAction)reloadData:(id)sender {
    _photos = nil;
    [_tableView reloadData];
    [_tableView reloadData];
}
@end
