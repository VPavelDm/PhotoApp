//
//  PlayMusicViewController.m
//  PhotoApp
//
//  Created by mac-089-71 on 10/17/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

#import "PlayMusicViewController.h"
#import "Song.h"
#import "SoundTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@implementation PlayMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _songDataProvider = [MusicDataProvider new];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SoundTableViewCell* cell = (SoundTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"SoundCell" forIndexPath:indexPath];
    
    Song* song = [_songDataProvider songAt:indexPath.row];
    cell.soundLabel.text = [song name];
    cell.delegate = self;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSNumber* count = [NSNumber numberWithInt:[_songDataProvider songsCount]];
    return [count integerValue];
}

+ (PlayMusicViewController *)createViewController {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"PlayMusicViewController" bundle:nil];
    PlayMusicViewController* viewController = (PlayMusicViewController*)[storyboard instantiateInitialViewController];
    return viewController;
}

- (void)clickedPlayButton:(nonnull SoundTableViewCell *)cell {
    NSIndexPath* index = [_soundTableView indexPathForCell:cell];
    Song* song = [_songDataProvider songAt:index.row];
    NSString* songName = [song name];
    NSString* format = [song format];
    NSURL* url = [self songURLByName:songName andFormat:format];
    
    AVPlayer* player = [[AVPlayer alloc] initWithURL:url];
    AVPlayerViewController* audioController = [AVPlayerViewController new];
    [self presentViewController:audioController animated:YES completion:nil];
    [audioController setPlayer:player];
    [player play];
}

- (void)clickedStopButton:(nonnull SoundTableViewCell *)cell {
    
}

- (NSURL*) songURLByName: (NSString*) name andFormat: (NSString*) format {
    NSString* songURL = [NSBundle.mainBundle pathForResource:name ofType:format];
    NSURL* url = [NSURL fileURLWithPath:songURL];
    return url;
}

@end
