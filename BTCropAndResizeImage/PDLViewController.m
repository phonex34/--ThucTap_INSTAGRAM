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
@interface PDLViewController ()
@property(strong,nonatomic) NSMutableArray *photos;


@end

@implementation PDLViewController
@synthesize receivedData = _receivedData;
@synthesize tableView =  _tableView;
@synthesize token = _token;
@synthesize connection = _connection;
@synthesize connection1 = _connection1;
@synthesize request;
@synthesize request1;
@synthesize photos = _photos;

- (void)viewDidLoad
{
    
    _receivedData = [[NSMutableData alloc] init];
    [self startSentRequest];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) startSentRequest{
    
    request = [[NSMutableURLRequest alloc]init];
    
    NSString *postString = [NSString stringWithFormat:@"http://beta.pashadelic.com/api/v1/sessions.json?username=dinhluong92&password=dinhluong92"];
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:postString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    _connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [_connection start];
}

#pragma mark - Delegate Table View

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _photos.count;
//    return 1;
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
    cell.labelUser.text = photo.username;
    cell.labelTitle.text = photo.title;
    cell.labelDate.text = photo.dateTaken;

    [cell.smallImageView setImageWithURL:[NSURL URLWithString:[photo avatar]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    cell.smallImageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.bigImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://static.mp3.zdn.vn/skins/mp3_version3_05/images/singer_banner.jpg"]]];
    [cell.bigImageView setImageWithURL:[NSURL URLWithString:[photo bigPhoto]] placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (!image) {
            [cell.indicator startAnimating];
        }
        else{
            [cell.indicator stopAnimating];
            cell.indicator.hidden = YES;
        }
    }];

    cell.smallImageView.layer.cornerRadius=2;
    NSLog(@"getting data for cell : %d",indexPath.row);
//     cell.smallImageView.layer.borderWidth=1.0;
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"You are selected row %d",indexPath.row);
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 320.0;
}

#pragma mark - NSURLConnection delegate

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"can not connect to internet" delegate:self cancelButtonTitle:@"Got it !" otherButtonTitles:nil, nil];
    [av show];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    if(connection == _connection)
    {
        [_receivedData setLength:0];
        NSLog(@"received response of connection 1");
    }
    if(connection == _connection1)
    {
        [_receivedData setLength:0];
        NSLog(@"received response of connection 2");
    }
    
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    if(connection == _connection)
    {
        [_receivedData appendData:data];
        NSLog(@"receive data of connection 1");
    }
    if(connection == _connection1)
    {
        [_receivedData appendData:data];
        NSLog(@"receive data of connection 2");
    }
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection{
    NSError *er = nil;
    if(connection == _connection)
    {
        NSLog(@"received data of connection 1!");
        NSMutableDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:_receivedData options:kNilOptions error:&er];
        NSDictionary *secondDict = [dataDictionary objectForKey:@"data"];
        _token= [secondDict objectForKey:@"auth_token"];
        NSString *postString = [NSString stringWithFormat:@"http://beta.pashadelic.com/api/v1/countries/1233/photos.json"];
        request1 = [[NSMutableURLRequest alloc]init];
        request1 = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:postString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        [request1 setHTTPMethod:@"GET"];
        [request1 setValue:_token forHTTPHeaderField:@"X-AUTH-TOKEN"];
        _connection1 = [NSURLConnection connectionWithRequest:request1 delegate:self];
        [_connection1 start];
    }
    if(connection == _connection1)
    {
        NSLog(@"received data of connection 2");
        NSMutableDictionary *finalData = [NSJSONSerialization JSONObjectWithData:_receivedData options:kNilOptions error:&er];
        NSMutableDictionary *dataDict = [finalData objectForKey:@"data"];
        NSMutableArray *dataArray = [dataDict objectForKey:@"photos"];
        _photos = [[NSMutableArray alloc] init];
        for (int i = 0; i < dataArray.count; i++) {
            NSMutableDictionary *dictTemp = [dataArray objectAtIndex:i];
            PDLPhotos *newObject = [[PDLPhotos alloc] initFromDictionary: dictTemp];
            [_photos addObject:newObject];
        }
        [self.tableView reloadData];
    }
}

//tao Thread with NSOperation
//- (void) usingNSOperationQueueToLoadImage:(NSArray*) imageURLs
//{
//    NSOperationQueue *operationQueue = [NSOperationQueue new];
//    [operationQueue setMaxConcurrentOperationCount:20];
//    for( id imageURL in imageURLs)
//    {
//        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
//                                                                                selector:@selector(processLoadingImageInNewThread:)
//                                                                                  object:imageURL];
//       
//        [operationQueue addOperation:operation];
//        //[operation release];
//    }
//}

#pragma mark -TaoThread
//// 1. Tao thread moi de load image
//- (void) createThreadToLoadImage
//{
//    NSString *imageURL = @&quot;http://www.abc.com/example.png&quot;;
//    NSThread* myThread = [[NSThread alloc] initWithTarget:self
//                                                 selector:@selector(processLoadingImageInNewThread:)
//                                                   object:imageURL];
//    [myThread start];
//}
//
// 2. Ham xu ly load image
//- (void) processLoadingImageInNewThread:(NSString*) imageURL
//{
//    NSURL *url = [NSURL urlWithString:imageURL];
//    NSData *imageData = [ [NSData alloc] initWithContentsOfURL: url ];
//    [self performSelectorOnMainThread:@selector(imageDownloadDidFinish:) withObject:imageData waitUntilDone:NO];
//}

//// 3. Ham xu ly hien thi image da duoc load xong
//- (void) imageDownloadDidFinish:(NSData*) imageData
//{
//    UIImage *downloadedImage = [UIImage imageWithData:imageData];
//    // Hien thi image len image view
//    self.imageView.image = downloadedImage;
//}
//
//// 1A. Tao thread moi de load image
//- (void) createThreadToLoadImage:(NSArray*) imageURLs
//{
//    for( id imageURL in imageURLs)
//    {
//        NSThread* myThread = [[NSThread alloc] initWithTarget:self
//                                                     selector:@selector(processLoadingImageInNewThread:)
//                                                       object:imageURL];
//        [myThread start];
//    }
//}

@end






