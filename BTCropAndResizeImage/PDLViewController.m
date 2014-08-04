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
@property(strong,nonatomic) NSMutableArray *temPhotos;
@property(nonatomic) int indexFlag;
@end

@implementation PDLViewController
@synthesize receivedData = _receivedData;
@synthesize token = _token;
@synthesize photos = _photos;
@synthesize conn1 = _conn1;
@synthesize conn2 = _conn2;
@synthesize tableView =  _tableView;
@synthesize onLoadIndicator = _onLoadIndicator;
@synthesize indexFlag = _indexFlag;
@synthesize temPhotos = _temPhotos;
- (void)viewDidLoad
{
    [_onLoadIndicator startAnimating];
    
    [self startConnection];
    
    _photos = [[NSMutableArray alloc] init];
    
    _receivedData = [[NSMutableData alloc] init];
    
    // number of photos loaded in a time
    _indexFlag = 4;
    
    PDLProcessConnection *_processor = [[PDLProcessConnection alloc] init];
    
    _photos = [_processor getDataFromObject:_processor];
    
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Delegate Connection

-(void) startConnection
{
    
    NSString *postString =
    [NSString stringWithFormat:@"http://beta.pashadelic.com/api/v1/sessions.json?username=dinhluong92&password=dinhluong92"];
    
    NSMutableURLRequest *_request =
    [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:postString]
                                 cachePolicy:NSURLRequestUseProtocolCachePolicy
                             timeoutInterval:60.0];
    
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
        NSMutableDictionary *dataDictionary =
        [NSJSONSerialization JSONObjectWithData:_receivedData
                                        options:kNilOptions
                                          error:&er];
        
        NSDictionary *secondDict = [dataDictionary objectForKey:@"data"];
        
        // get token string from dictionary
        
        _token= [secondDict objectForKey:@"auth_token"];
        
        NSString *postString = [NSString stringWithFormat:@"http://beta.pashadelic.com/api/v1/users/2765.json"];
        
        // start sent request 2 to get data

        NSMutableURLRequest *_request =
        [NSMutableURLRequest requestWithURL:[NSURL URLWithString:postString]
                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                            timeoutInterval:60.0];
        
        [_request setHTTPMethod:@"GET"];
        
        [_request setValue:_token  forHTTPHeaderField:@"X-AUTH-TOKEN"];
        
        _conn2 = [[NSURLConnection alloc] initWithRequest:_request delegate:self];
        
        [_conn2 start];
    }
    if (connection == _conn2) {
        NSError *er = nil;
        // get data from json

        NSMutableDictionary *finalData =
        [NSJSONSerialization JSONObjectWithData:_receivedData
                                        options:kNilOptions
                                          error:&er];
        
        NSMutableDictionary *dataDict = [finalData objectForKey:@"data"];
        
        NSMutableDictionary *dataDict2 = [dataDict objectForKey:@"user"];
        
        NSMutableArray *dataArray = [dataDict2 objectForKey:@"photos"];
        
        _photos = [[NSMutableArray alloc] init];
        for (int i = 0; i < dataArray.count; i++)
            {
                NSMutableDictionary *dictTemp = [dataArray objectAtIndex:i];
                
                PDLPhotos *newObject = [[PDLPhotos alloc] initFromDictionary: dictTemp];
                
                [_photos addObject:newObject];
            }
        
        _temPhotos = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < 5; i++)
            {
                
                [_temPhotos addObject:[_photos objectAtIndex:i]];
            }
        
        [_onLoadIndicator stopAnimating];
        
        [_onLoadIndicator setHidden:YES];
        
        [_tableView reloadData];
    }
    
}


#pragma mark - Delegate Table View

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _temPhotos.count;

}

-(NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return 1;
}



- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
// creating cell at possition : index
    
    static NSString *indentifier = @"myIndentifier";
    PDLCustomCell *cell = (PDLCustomCell *)[tableView dequeueReusableCellWithIdentifier:indentifier];
    
    if(cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PDLCustomCell" owner:self options:nil];
            cell = (PDLCustomCell *)[nib objectAtIndex:0];
        }
    
    if ((indexPath.row == _temPhotos.count-1) && !(indexPath.row == _photos.count -1))
    {
        
        [self loadMore];
        
    }
    PDLPhotos *photo = [_temPhotos objectAtIndex:indexPath.row];
    
    [cell.avatarIndicator startAnimating];
    
    [cell initiallizFromdictAtIndex:photo andIndex:indexPath];
    
    int width = 0;
    int height = 0;
    
    width = [photo width].intValue;
    
    height = [photo height].intValue;
    
    
    float factor = (float)height/(float)width;
        if (width < 320)
            {
                cell.bigImageView.contentMode = UIViewContentModeScaleAspectFit;
                [cell.bigImageView setFrame:CGRectMake(0, 50, 320,height)];
            }
        else
            {
                cell.bigImageView.contentMode = UIViewContentModeScaleAspectFill;
                [cell.bigImageView setFrame:CGRectMake(0, 50, 320,320*factor)];
            }
    [cell bringSubviewToFront:cell.smallImageView];
    
    [cell.indicator startAnimating];
    
    cell.smallImageView.contentMode = UIViewContentModeScaleAspectFill;
    
        return cell;
}

// get height for row in here


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger i = indexPath.row;
    
    PDLPhotos *photo = [_temPhotos objectAtIndex:i];
    
    int width = 0;
    int height = 0;
    
    width = [photo width].intValue;
    height = [photo height].intValue;
    
    if (width < 320)
        {
            return height+50;
        }
    
    float factor = (float)height/(float)width;
    
        return (float)((float)(320.0*factor)+50);
}

- (IBAction)reloadData:(id)sender {
 
    [self startConnection];
    
    [_tableView reloadData];
}

- (IBAction)DeleteCache:(id)sender {
    
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    
    [imageCache clearMemory];
    
    [imageCache clearDisk];
    
    [_tableView reloadData];
}
- (void)loadMore{
    if(_indexFlag > _photos.count-5)
    {
    
        int x = _photos.count - _indexFlag;
        _indexFlag +=x;
    }
    else
    _indexFlag = _indexFlag + 5;
    
    for (int i = _temPhotos.count; i < _indexFlag; i++) {
        [_temPhotos addObject:[_photos objectAtIndex:i]];
    }
    [_tableView reloadData];
}
@end
