//
//  WMAlarmAddViewController.h
//  WakeMe
//
//  Created by Agustinus Verdy Widyawiradi on 8/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "WMSoundsListViewController.h"
#import "WMChallengesListViewController.h"

@interface WMAlarmAddViewController : UITableViewController<WMSoundsListViewControllerDelegate, WMChallengeSelectionViewControllerDelegate> {
  UITableViewCell *_alarmNameCell;
  UITableViewCell *_alarmSnoozeCell;
  UITableViewCell *_alarmChallengeCell;
  UITableViewCell *_alarmSoundCell;
  
  UITextField *_nameTextField;
  UISwitch *_snoozeSwitch;
  UILabel *_challengeLabel;
  UILabel *_soundLabel;
  
  NSString *_selectedChallenge;
  NSString *_selectedSound;
  
  AVAudioPlayer *_audioPlayer;
}

@property (nonatomic, retain) IBOutlet UITableViewCell *alarmNameCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *alarmSnoozeCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *alarmChallengeCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *alarmSoundCell;

@property(nonatomic, retain) IBOutlet UITextField *nameTextField;
@property(nonatomic, retain) IBOutlet UISwitch *snoozeSwitch;
@property (nonatomic, retain) IBOutlet UILabel *challengeLabel;
@property (nonatomic, retain) IBOutlet UILabel *soundLabel;

- (IBAction)saveNewAlarm:(id)sender;
- (IBAction)cancelAlarmAddition:(id)sender;

@end
