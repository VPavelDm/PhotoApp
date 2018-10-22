//
//  SoundTableViewCell.m
//  PhotoApp
//
//  Created by mac-089-71 on 10/17/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

#import "SoundTableViewCell.h"

@implementation SoundTableViewCell

@synthesize soundLabel = soundLabel;

- (IBAction)clickPlayButton:(id)sender {
    if (_delegate) {
        [_delegate clickedPlayButton:self];
    }
}

@end

