//
//  MusicDataProvider.h
//  PhotoApp
//
//  Created by mac-089-71 on 10/17/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Song.h"

NS_ASSUME_NONNULL_BEGIN

@interface MusicDataProvider : NSObject

- (Song*) songAt: (NSInteger) index;

- (int) songsCount;

@end

NS_ASSUME_NONNULL_END
