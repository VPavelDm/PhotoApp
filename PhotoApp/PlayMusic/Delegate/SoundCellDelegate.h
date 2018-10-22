//
//  SoundCellDelegate.h
//  PhotoApp
//
//  Created by mac-089-71 on 10/17/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class SoundTableViewCell;

@protocol SoundCellDelegate <NSObject>
- (void) clickedPlayButton: (SoundTableViewCell*) cell;
@end

NS_ASSUME_NONNULL_END
