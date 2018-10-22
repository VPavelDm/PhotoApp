//
//  MoreRepository.m
//  PhotoApp
//
//  Created by mac-089-71 on 10/17/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

#import "MoreRepository.h"
#import <FirebaseAuth/FirebaseAuth.h>

@implementation MoreRepository

- (void)signOut:(void (^)(NSString* _Nullable))callback {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        FIRAuth* auth = [FIRAuth auth];
        NSError* error;
        [auth signOut:&error];
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            if (error){
                callback(error.localizedDescription);
            } else {
                callback(nil);
            }
        });
        
    });
}

@end
