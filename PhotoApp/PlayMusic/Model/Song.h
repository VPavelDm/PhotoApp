//
//  Song.h
//  PhotoApp
//
//  Created by mac-089-71 on 10/17/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Song : NSObject

@property (retain) NSString* name;
@property (retain) NSString* format;

- (void) initWithName: (NSString*)name andFormat: (NSString*)format;

@end

NS_ASSUME_NONNULL_END
