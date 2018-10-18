//
//  PlayMusicViewController.m
//  PhotoApp
//
//  Created by mac-089-71 on 10/17/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

#import "PlayMusicViewController.h"

@interface PlayMusicViewController ()
@property (retain) MusicDataProvider* songDataProvider;
@end

@implementation PlayMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _songDataProvider = [MusicDataProvider new];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SoundTableViewCell* cell = (SoundTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"SoundCell" forIndexPath:indexPath];
    
    Song* song = [_songDataProvider songAt:indexPath.row];
    [song retain];
    cell.soundLabel.text = [song name];
    [song release];
    
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
    Song* song = [self getSongByCell:cell];
    NSURL* url = [self getSongURL:song];
    [self playSongWithURL:url];
}

- (NSURL*) getSongURLByName: (NSString*) name andFormat: (NSString*) format {
    NSString* songURL = [NSBundle.mainBundle pathForResource:name ofType:format];
    NSURL* url = [NSURL fileURLWithPath:songURL];
    return url;
}

- (Song*) getSongByCell: (SoundTableViewCell*) cell {
    NSIndexPath* index = [_soundTableView indexPathForCell:cell];
    Song* song = [_songDataProvider songAt:index.row];
    return song;
}

- (NSURL*) getSongURL: (Song*) song {
    NSString* songName = [song name];
    NSString* format = [song format];
    NSURL* url = [self getSongURLByName:songName andFormat:format];
    return url;
}

- (void) playSongWithURL: (NSURL*) url {
    AVPlayer* player = [[AVPlayer alloc] initWithURL:url];
    AVPlayerViewController* audioController = [AVPlayerViewController new];
    [self presentViewController:audioController animated:YES completion:nil];
    [audioController setPlayer:player];
    [player play];
    
    [audioController release];
    [player release];
}

@end
