//
//  Song.m
//  PhotoApp
//
//  Created by mac-089-71 on 10/17/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

#import "Song.h"

@implementation Song
@synthesize name = songName;
@synthesize format = songFormat;

- (void)initWithName:(NSString *)name andFormat:(NSString *)format {
    [songName release];
    songName = name;
    
    [songFormat release];
    songFormat = format;
}

- (void)dealloc
{
    [songName release];
    [songFormat release];
    [super dealloc];
}

@end
