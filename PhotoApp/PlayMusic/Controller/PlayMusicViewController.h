//
//  PlayMusicViewController.h
//  PhotoApp
//
//  Created by mac-089-71 on 10/17/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicDataProvider.h"
#import "SoundCellDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlayMusicViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, SoundCellDelegate>

@property (retain) MusicDataProvider* songDataProvider;
@property (weak, nonatomic) IBOutlet UITableView *soundTableView;

+ (PlayMusicViewController*) createViewController;

@end

NS_ASSUME_NONNULL_END
