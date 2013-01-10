  //
  //  WMSoundSelectionViewController.m
  //  WakeMe
  //
  //  Created by Agustinus Verdy Widyawiradi on 8/7/12.
  //  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
  //

#import "WMSoundSelectionViewController.h"
#import <AVFoundation/AVFoundation.h>

#import "WakeMeAppDelegate.h"

@interface WMSoundSelectionViewController ()

@end

@implementation WMSoundSelectionViewController


@synthesize soundNames = _soundNames;
@synthesize selectedRow = _selectedRow;
@synthesize soundSelectionDelegate = _soundSelectionDelegate;


/**
 * Override
 */
- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
      // Custom initialization
  }
  return self;
}

/**
 * Override
 */
- (id)initWithCoder:(NSCoder *)aDecoder {
  if ((self = [super initWithCoder:aDecoder])) {
    [self initialize];
  }
  return self;
}

/**
 * Common initialization code. Other inits should call this method to
 * complete the initialization process.
 */
- (void)initialize {
  /**
   * Load all the names of the sounds
   */
  NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
  NSFileManager *fm = [NSFileManager defaultManager];
  NSArray *filenames = [fm contentsOfDirectoryAtPath:bundleRoot error:nil];
  NSString *fileExt = [NSString stringWithFormat:@".%@", AUDIO_TYPE];
  NSPredicate *filter = [NSPredicate predicateWithFormat:@"SELF ENDSWITH %@", fileExt];
  NSArray *filteredFilenames = [filenames filteredArrayUsingPredicate:filter];
  NSMutableArray *formattedFilenames = [[NSMutableArray alloc] init];
  for (NSString *filteredFilename in filteredFilenames)
    [formattedFilenames addObject:[filteredFilename substringToIndex:[filteredFilename length]-[fileExt length]]];
  _soundNames = [NSArray arrayWithArray:formattedFilenames];
  
  // Initialize to -1 (no sound selected)
  _selectedRow = -1;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
  
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload {
  [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillDisappear:(BOOL)animated {
  /**
   * Stop the sound before switching view
   */
  WakeMeAppDelegate *app = [[UIApplication sharedApplication] delegate];
  [app stopAudioPlayer];
  
  [super viewWillDisappear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return _soundNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"SoundCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  // Configure the cell...
  if (indexPath.section == 0) {
    cell.textLabel.text = [_soundNames objectAtIndex:indexPath.row];
    if (indexPath.row == _selectedRow) cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else cell.accessoryType = UITableViewCellAccessoryNone;
  }
  return cell;
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
  
  if (indexPath.section == 0 && indexPath.row != _selectedRow) {
    _selectedRow = indexPath.row;
    
    [super.tableView reloadData];
    
    // Getting the name of the selected sound
    NSString *selectedSound = [_soundNames objectAtIndex:_selectedRow];
    NSString *audioPath = [[NSBundle mainBundle] pathForResource:selectedSound 
                                                          ofType:AUDIO_TYPE];
    // Tell the delegate to play the sound
    WakeMeAppDelegate *app = [[UIApplication sharedApplication] delegate];
    [app playSoundWithAudioPath:audioPath numberOfLoops:4];
  }
}


#pragma mark - IBAction

/**
 * IBAction if the user has finished with sound selection
 */
- (IBAction)finishSelectingSound:(id)sender {
  // In case user didn't select any sound
  if (_selectedRow >= 0) {
    // Getting the name of the selected sound
    NSString *selectedSound = [_soundNames objectAtIndex:_selectedRow];
    [_soundSelectionDelegate soundSelectionSelectSound:selectedSound];
    // Pop itself
    [self.navigationController popViewControllerAnimated:YES];
  }
}

#pragma mark - Custom public method

/**
 * Select the cell with the sound name as passed into 
 * "selectedSoundName" parameter
 */
- (void)selectSoundWithName:(NSString *)selectedSoundName {
  NSUInteger soundIndex = 0;
  for (NSString *soundName in _soundNames) {
    if ([soundName isEqualToString:selectedSoundName]) {
      _selectedRow = soundIndex;
      NSIndexPath *selectedIndex = [NSIndexPath indexPathForRow:_selectedRow inSection:0];
      [self.tableView selectRowAtIndexPath:selectedIndex
                                  animated:NO
                            scrollPosition:UITableViewScrollPositionTop];
      break;
    }
    soundIndex++;
  }
}

@end