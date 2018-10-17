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

- (IBAction)clickPlayMusic:(id)sender {
}

- (IBAction)clickStopMusic:(id)sender {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _songDataProvider = [MusicDataProvider new];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SoundTableViewCell* cell = (SoundTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"SoundCell" forIndexPath:indexPath];
    
    Song* song = [_songDataProvider songAt:indexPath.row];
    cell.soundLabel.text = [song name];
    
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

@end
