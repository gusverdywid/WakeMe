//
//  WMAlarmAddViewController.m
//  WakeMe
//
//  Created by Agustinus Verdy Widyawiradi on 8/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WMAlarmAddViewController.h"

@interface WMAlarmAddViewController ()

@end

@implementation WMAlarmAddViewController


@synthesize alarmNameCell = _alarmNameCell;
@synthesize alarmSnoozeCell = _alarmSnoozeCell;
@synthesize alarmSoundCell = _alarmSoundCell;
@synthesize alarmChallengeCell = _alarmChallengeCell;

@synthesize nameTextField = _nameTextField;
@synthesize challengeLabel = _challengeLabel;
@synthesize soundLabel = _soundLabel;


- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  
  
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){    
        // HACK (to deal with initialization delay):
        // Initial setup of audio player
        // Pass the Silent.caf (blank audio file) just to help the with the
        // setup (acts as dummy)
        NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"Silent" 
                                                              ofType:@"caf"];
        // Play and stop the player straight away
        if ([self setupAudioPlayerWithAudioPath:audioPath]) {
          [_audioPlayer play];
          [_audioPlayer stop];
        }
    });
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([[segue identifier] isEqualToString:@"selectSound"]) {
    WMSoundsListViewController *soundSelection = 
      (WMSoundsListViewController *) [segue destinationViewController];
    
    [soundSelection setSoundSelectionDelegate:self];
    
    if ([_selectedSound length] != 0)
      [soundSelection selectSoundWithName:_selectedSound];
  } else if ([[segue identifier] isEqualToString:@"selectChallenge"]) {
    
    // Set the challenge selection delegate
    WMChallengesListViewController *challengeSelection = 
      (WMChallengesListViewController *) [segue destinationViewController];
    [challengeSelection setChallengeSelectionDelegate:self];
    
    // If challenge is already selected, tell challenge selection to mark down
    // the row
    if ([_selectedChallenge length] != 0)
      [challengeSelection selectChallengeWithName:_selectedChallenge];
  }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
  switch (section) {
    case 0:
      return 1;
      break;
    case 1:
      return 3;
      break;
    default:
      return 0;
      break;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    // Configure the cell...
  if ([indexPath section] == 0 && [indexPath row] == 0) {
    return [self alarmNameCell];
  } else if ([indexPath section] == 1) {
    if ([indexPath row] == 0) return [self alarmSnoozeCell];
    else if ([indexPath row] == 1) return [self alarmChallengeCell];
    else if ([indexPath row] == 2) return [self alarmSoundCell];
  }
    
  return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


#pragma mark - Sound selection delegate

- (void)soundSelectionPlaySound:(NSString *)audioPath {
  if ([self setupAudioPlayerWithAudioPath:audioPath])
    [_audioPlayer play];
}

- (void)soundSelectionSelectSound:(NSString *)selectedSound {
  _selectedSound = selectedSound;
  _soundLabel.text = _selectedSound;
}

- (void)soundSelectionStopSound {
  if (_audioPlayer != nil && [_audioPlayer isPlaying])
    [_audioPlayer stop];
}


#pragma mark - Challenge selection delegate

- (void)challengeSelectionSelectChallengeWithName:(NSString *)selectedChallenge {
  _selectedChallenge = selectedChallenge;
  _challengeLabel.text = _selectedChallenge;
}


#pragma mark - IBAction

- (IBAction)cancelAlarmAddition:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Private methods

/**
 * Setup and prepare the audio player for playback for
 * the supplied audio file's path
 */
- (BOOL)setupAudioPlayerWithAudioPath:(NSString *)audioPath {
  
  if (_audioPlayer != nil && _audioPlayer.playing) {
    [_audioPlayer stop];
  }
  
  NSError *playbackError;
  
  NSURL *audioUrl = [NSURL fileURLWithPath:audioPath];
  _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioUrl
                                               error:&playbackError];
  
  if (_audioPlayer != nil && !playbackError) {
    [_audioPlayer prepareToPlay];
    [_audioPlayer setNumberOfLoops:4];
  } else {
    NSLog(@"%@", playbackError);
  }
  
  return (_audioPlayer != nil && !playbackError);
}

@end
