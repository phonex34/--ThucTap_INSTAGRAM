//
//  PDLPhotos.m
//  Example3
//
//  Created by Dinh Luong on 7/22/26 H.
//  Copyright (c) 26 Heisei Dinh Luong. All rights reserved.
//

#import "PDLPhotos.h"

@implementation PDLPhotos
@synthesize title = _title;
@synthesize avatar = _avatar;
@synthesize dateTaken = _dateTaken;
@synthesize bigPhoto = _bigPhoto;
@synthesize username = _username;
@synthesize width = width;
@synthesize height = height;

- (id) init {
    
    return self;
}

-(id) initFromDictionary: (NSMutableDictionary *) dictionary {
    _avatar = [dictionary objectForKey:@"owner_avatar_url"];
    _username = [dictionary objectForKey:@"owner_username"];
    _dateTaken = [dictionary objectForKey:@"taken_on"];
    _title = [dictionary objectForKey:@"location"];
    _bigPhoto = [dictionary objectForKey:@"image_list_url"];
    height = (NSNumber*)[dictionary objectForKey:@"height"];
    width = (NSNumber*)[dictionary objectForKey:@"width"];
    return self;
}
@end
