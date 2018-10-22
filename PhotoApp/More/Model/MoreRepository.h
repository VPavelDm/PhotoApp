//
//  MoreRepository.h
//  PhotoApp
//
//  Created by mac-089-71 on 10/17/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MoreRepository : NSObject

- (void) signOut: (void (^)(NSString* _Nullable))callback;

@end

NS_ASSUME_NONNULL_END
