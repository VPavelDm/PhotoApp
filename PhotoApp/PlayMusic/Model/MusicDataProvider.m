//
//  MusicDataProvider.m
//  PhotoApp
//
//  Created by mac-089-71 on 10/17/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

#import "MusicDataProvider.h"

@implementation MusicDataProvider

- (instancetype)init
{
    self = [super init];
    if (self) {
        Song* songOne = [[Song alloc] init];
        [songOne initWithName:@"song1" andFormat:@"mp3"];
        Song* songTwo = [[Song alloc] init];
        [songTwo initWithName:@"song2" andFormat:@"mp3"];
        Song* songThree = [[Song alloc] init];
        [songThree initWithName:@"song3" andFormat:@"mp3"];
        
        songs = [NSArray arrayWithObjects:songOne, songTwo, songThree, nil];
    }
    return self;
}

- (int)songsCount {
    return (int)[songs count];
}

- (Song *)songAt:(NSInteger)index {
    return [songs objectAtIndex:index];
}

@end
