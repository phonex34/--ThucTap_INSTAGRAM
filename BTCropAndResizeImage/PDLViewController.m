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
@synthesize receivedData = _receivedData;
@synthesize token = _token;
@synthesize photos = _photos;
@synthesize conn1 = _conn1;
@synthesize conn2 = _conn2;
@synthesize tableView =  _tableView;

- (void)viewDidLoad
{
    [self startConnection];
    _photos = [[NSMutableArray alloc] init];
    _receivedData = [[NSMutableData alloc] init];
    PDLProcessConnection *_processor = [[PDLProcessConnection alloc] init];
    _photos = [_processor getDataFromObject:_processor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Delegate Connection

-(void) startConnection {
    NSString *postString = [NSString stringWithFormat:@"http://beta.pashadelic.com/api/v1/sessions.json?username=dinhluong92&password=dinhluong92"];
    NSMutableURLRequest *_request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:postString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [_request setHTTPMethod:@"POST"];
    _conn1 = [[NSURLConnection alloc] initWithRequest:_request delegate:self];
    [_conn1 start];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [_receivedData setLength:0.0];
    
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_receivedData appendData:data];
    
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection{
    
    if (connection == _conn1) {
        NSError *er = nil;
        NSMutableDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:_receivedData options:kNilOptions error:&er];
        NSDictionary *secondDict = [dataDictionary objectForKey:@"data"];
        _token= [secondDict objectForKey:@"auth_token"];
        NSString *postString = [NSString stringWithFormat:@"http://beta.pashadelic.com/api/v1/countries/1233/photos.json"];
        NSMutableURLRequest *_request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:postString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        [_request setHTTPMethod:@"GET"];
        [_request setValue:_token  forHTTPHeaderField:@"X-AUTH-TOKEN"];
        _conn2 = [[NSURLConnection alloc] initWithRequest:_request delegate:self];
        [_conn2 start];
    }
    if (connection == _conn2) {
        NSError *er = nil;
        NSMutableDictionary *finalData = [NSJSONSerialization JSONObjectWithData:_receivedData options:kNilOptions error:&er];
        NSMutableDictionary *dataDict = [finalData objectForKey:@"data"];
        NSMutableArray *dataArray = [dataDict objectForKey:@"photos"];
        _photos = [[NSMutableArray alloc] init];
        for (int i = 0; i < dataArray.count; i++) {
            NSMutableDictionary *dictTemp = [dataArray objectAtIndex:i];
            PDLPhotos *newObject = [[PDLPhotos alloc] initFromDictionary: dictTemp];
            [_photos addObject:newObject];
        }
        [_tableView reloadData];
    }
    
}


#pragma mark - Delegate Table View

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _photos.count;

}

-(NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"myIndentifier";
    PDLCustomCell *cell = (PDLCustomCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PDLCustomCell" owner:self options:nil];
        cell = (PDLCustomCell *)[nib objectAtIndex:0];
    }
    PDLPhotos *photo = [_photos objectAtIndex:indexPath.row];
    int width = 0;
    int height = 0;
    width = photo.width.intValue;
    height = [photo height].intValue;
    float factor = (float)width/320.0;
    [cell.bigImageView setFrame:CGRectMake(0, 50, 320, ((CGFloat)height/factor))];
    cell.bigImageView.contentMode = UIViewContentModeScaleAspectFit;
    [cell bringSubviewToFront:cell.smallImageView];
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
    int width = 0;
    int height = 0;
    width = photo.width.intValue;
    height = [photo height].intValue;
    float factor = (float)width/320.0;
    return (float)((float)(height/factor)+55);
}

- (IBAction)reloadData:(id)sender {
    [self DeleteCache:self];
    [self startConnection];
    [_tableView reloadData];
}

- (IBAction)DeleteCache:(id)sender {
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    [imageCache clearDisk];
    [_tableView reloadData];
}
@end
