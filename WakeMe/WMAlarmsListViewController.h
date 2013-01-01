//
//  WMAlarmsListViewController.h
//  WakeMe
//
//  Created by Agustinus Verdy Widyawiradi on 7/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMAlarmsListViewController : UITableViewController {
  NSArray *_alarms;
}

@property (nonatomic, retain) NSArray *alarms;

- (IBAction)showAlarmCreationView:(id)sender;

@end
