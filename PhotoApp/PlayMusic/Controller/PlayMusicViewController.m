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
    NSLog(@"Clicked %@ cell", cell.soundLabel.text);
}

- (void)clickedStopButton:(nonnull SoundTableViewCell *)cell {
    
}

@end
