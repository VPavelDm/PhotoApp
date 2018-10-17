//
//  SoundTableViewCell.h
//  PhotoApp
//
//  Created by mac-089-71 on 10/17/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundCellDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface SoundTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* soundLabel;

@property (weak) id <SoundCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
