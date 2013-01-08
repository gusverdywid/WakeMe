//
//  WMAlarmsListViewController.m
//  WakeMe
//
//  Created by Agustinus Verdy Widyawiradi on 7/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WMAlarmsListViewController.h"

#import "WakeMeAppDelegate.h"
#import "WMAlarm.h"
#import "WMAlarmDetailViewController.h"

@interface WMAlarmsListViewController ()

@end


@implementation WMAlarmsListViewController


@synthesize alarms = _alarms;


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
  
  self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  // Reset editing mode, especially after returning from new alarm screen
  [self setEditing:NO animated:NO];
  
  /**
   * ViewDidLoad is not always called when view changes,
   * only when it gets loaded into memory.
   * So it being done here to reload the alarms everytime view changes
   */
  [self reloadAlarms];
  [self.tableView reloadData];
}

- (void)viewDidUnload {
  [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Return rows as many as number of alarms
  return _alarms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"AlarmTableCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
  
  /**
   * Set all views state of table cell
   * Tag: 1 - Time label
   *      2 - Alarm name label
   *      3 - Active/Inactive label
   */
  WMAlarm *alarm = [_alarms objectAtIndex:indexPath.row];
  // Set time label
  UILabel *timeLabel = (UILabel *) [cell viewWithTag:1];
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  formatter.dateFormat = @"hh:mm a";
  timeLabel.text = [formatter stringFromDate:alarm.time];
  // Set alarm name
  UILabel *nameLabel = (UILabel *) [cell viewWithTag:2];
  nameLabel.text = alarm.name;
  // Set alarm switch
  UISwitch *activeSwitch = (UISwitch *) [cell viewWithTag:3];
  activeSwitch.on = [alarm.active boolValue];
  if (self.editing)
    activeSwitch.hidden = YES;
  else
    activeSwitch.hidden = NO;
    
    return cell;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
  [super setEditing:editing animated:animated];
  [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] 
                withRowAnimation:UITableViewRowAnimationFade];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    /**
     * Delete the alarm associated with the selected row
     */
    WakeMeAppDelegate *app = (WakeMeAppDelegate *) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = app.managedObjectContext;
    WMAlarm *alarm = (WMAlarm *) [_alarms objectAtIndex:indexPath.row];
    // Delete alarm from database
    [context deleteObject:alarm];
    // Reload array of alarms
    [self reloadAlarms];
    NSError *error;
    [context save:&error];
    // Show alert box in case any error occured
    if (error) {
      NSLog(@"Could not delete the alarm: %@", [error localizedDescription]);
      UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Core Data Error" 
                                                           message:@"Could not delete alarm." 
                                                          delegate:nil 
                                                 cancelButtonTitle:@"OK" 
                                                 otherButtonTitles:nil];
      [errorAlert show];
    } else {
      // Delete the associated local notification
      [app deleteNotificationOfAlarm:alarm];
      // Delete the row from the data source
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                       withRowAnimation:UITableViewRowAnimationFade];
    }
  }  
}

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
  
  if (self.editing) {
    UIStoryboard *alarmDetailStoryboard = [UIStoryboard storyboardWithName:@"WMAlarmDetailStoryboard_iPhone"
                                                                    bundle:nil];
    UINavigationController *alarmDetailNavigationController = (UINavigationController *) [alarmDetailStoryboard instantiateInitialViewController];
    WMAlarmDetailViewController *alarmDetailViewController = (WMAlarmDetailViewController *) alarmDetailNavigationController.topViewController;
    // Set the alarm
    alarmDetailViewController.alarm = [_alarms objectAtIndex:indexPath.row];
    alarmDetailNavigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:alarmDetailNavigationController animated:YES];
  }
}


#pragma mark - IBAction

/**
 * Show new alarm page
 */
- (IBAction)showAlarmCreationView:(id)sender {
  UIStoryboard *alarmDetailStoryboard = [UIStoryboard storyboardWithName:@"WMAlarmDetailStoryboard_iPhone" 
                                                                  bundle:nil];
  UIViewController *alarmDetailNavigationController = [alarmDetailStoryboard instantiateInitialViewController];
  alarmDetailNavigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
  [self presentModalViewController:alarmDetailNavigationController animated:YES];
}

/**
 * Used to handle alarm activation/disactivation
 */
- (IBAction)switchAlarmStatus:(id)sender {
  UISwitch *activeSwitch = (UISwitch *)sender;
  UITableViewCell *alarmCell = nil;
  // Sometimes the superview of the switch is UITableViewCellContentView
  // so need to get its superview, that is the UITableViewCell looked for
  if ([activeSwitch.superview isKindOfClass:[UITableViewCell class]])
    alarmCell = (UITableViewCell *)activeSwitch.superview;
  else if ([activeSwitch.superview.superview isKindOfClass:[UITableViewCell class]])
    alarmCell = (UITableViewCell *)activeSwitch.superview.superview;
  else {
    NSLog(@"Could not get UITableViewCell");
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"UITableView Error" 
                                                         message:@"Could not update the alarm.\nReverting..." 
                                                        delegate:nil 
                                               cancelButtonTitle:@"OK" 
                                               otherButtonTitles:nil];
    [errorAlert show];
    // Revert the change
    [activeSwitch setOn:!activeSwitch.on animated:YES];
    return;
  }
  NSIndexPath *alarmIndex = [self.tableView indexPathForCell:alarmCell];
  WMAlarm *alarm = (WMAlarm *)[_alarms objectAtIndex:alarmIndex.row];
  alarm.active = [NSNumber numberWithBool:activeSwitch.on];
  
  
  WakeMeAppDelegate *app = [[UIApplication sharedApplication] delegate];
  
  if ([alarm.active boolValue]) {
    [app createNotificationForAlarm:alarm];
  } else {
    [app deleteNotificationOfAlarm:alarm];
  }
  
  NSManagedObjectContext *context = app.managedObjectContext;
  NSError *error;
  if (![context save:&error]) {
    NSLog(@"Could not save the alarm: %@", [error localizedDescription]);
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Core Data Error" 
                                                         message:@"Could not save the alarm. Please try again" 
                                                        delegate:nil 
                                               cancelButtonTitle:@"OK" 
                                               otherButtonTitles:nil];
    [errorAlert show];
  } else {
    [self dismissViewControllerAnimated:YES completion:nil];
  }
}

#pragma mark - Private methods

- (void)reloadAlarms {
  /**
   * Load all alarms from core data.
   */
  WakeMeAppDelegate *app = [[UIApplication sharedApplication] delegate];
  NSManagedObjectContext *context = app.managedObjectContext;
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Alarm" 
                                            inManagedObjectContext:context];
  fetchRequest.entity = entity;
  NSError *error;
  _alarms = [context executeFetchRequest:fetchRequest error:&error];
  // Show alert box in case any error occured
  if (error) {
    NSLog(@"Could not load the alarms: %@", [error localizedDescription]);
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Core Data Error" 
                                                         message:@"Could not load alarms." 
                                                        delegate:nil 
                                               cancelButtonTitle:@"OK" 
                                               otherButtonTitles:nil];
    [errorAlert show];
  }
}

@end
