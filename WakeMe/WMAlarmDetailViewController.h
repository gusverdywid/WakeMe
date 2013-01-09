//
//  WMAlarmDetailViewController.h
//  WakeMe
//
//  Created by Agustinus Verdy Widyawiradi on 1/1/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WMAlarm.h"
#import "WMSoundSelectionViewController.h"
#import "WMChallengeSelectionViewController.h"

@interface WMAlarmDetailViewController : UITableViewController<WMSoundSelectionViewControllerDelegate, WMChallengeSelectionViewControllerDelegate, UITextFieldDelegate> {
  WMAlarm *_alarm;
  
  UITableViewCell *_alarmNameCell;
  UITableViewCell *_alarmSnoozeCell;
  UITableViewCell *_alarmChallengeCell;
  UITableViewCell *_alarmSoundCell;
  
  UITextField *_nameTextField;
  UISwitch *_snoozeSwitch;
  UILabel *_challengeLabel;
  UILabel *_soundLabel;
  UIDatePicker *_timePicker;
  
  NSString *_selectedChallenge;
  NSString *_selectedSound;
}

@property (nonatomic, strong) WMAlarm *alarm;

@property (nonatomic, retain) IBOutlet UITableViewCell *alarmNameCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *alarmSnoozeCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *alarmChallengeCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *alarmSoundCell;

@property(nonatomic, retain) IBOutlet UITextField *nameTextField;
@property(nonatomic, retain) IBOutlet UISwitch *snoozeSwitch;
@property (nonatomic, retain) IBOutlet UILabel *challengeLabel;
@property (nonatomic, retain) IBOutlet UILabel *soundLabel;
@property(nonatomic, retain) IBOutlet UIDatePicker *timePicker;

- (IBAction)saveAlarm:(id)sender;
- (IBAction)cancelCreatingOrEditingAlarm:(id)sender;

@end
