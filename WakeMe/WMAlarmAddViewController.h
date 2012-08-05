//
//  WMAlarmAddViewController.h
//  WakeMe
//
//  Created by Agustinus Verdy Widyawiradi on 8/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMAlarmAddViewController : UITableViewController {
  UITableViewCell *alarmNameCell;
  UITableViewCell *alarmSnoozeCell;
  UITableViewCell *alarmChallengeCell;
  UITableViewCell *alarmSoundCell;
}

@property (nonatomic, retain) IBOutlet UITableViewCell *alarmNameCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *alarmSnoozeCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *alarmChallengeCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *alarmSoundCell;

@end
