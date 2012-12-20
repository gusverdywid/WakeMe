  //
  //  WMSoundsListViewController.m
  //  WakeMe
  //
  //  Created by Agustinus Verdy Widyawiradi on 8/7/12.
  //  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
  //

#import "WMSoundsListViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface WMSoundsListViewController ()

@end

@implementation WMSoundsListViewController


@synthesize soundNames = _soundNames;
@synthesize selRow = _selRow;
@synthesize soundSelectionDelegate = _soundSelectionDelegate;


- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
      // Custom initialization
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if ((self = [super initWithCoder:aDecoder])) {
    [self initialize];
  }
  return self;
}

- (void)initialize {
  /**
   * Load all the names of the sounds
   */
  NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
  NSFileManager *fm = [NSFileManager defaultManager];
  NSArray *filenames = [fm contentsOfDirectoryAtPath:bundleRoot error:nil];
  NSPredicate *filter = [NSPredicate predicateWithFormat:@"SELF ENDSWITH %@", AUDIO_TYPE];
  NSArray *filteredFilenames = [filenames filteredArrayUsingPredicate:filter];
  NSMutableArray *formattedFilenames = [[NSMutableArray alloc] init];
  for (NSString *filteredFilename in filteredFilenames) {
    [formattedFilenames addObject:
     [filteredFilename substringToIndex:[filteredFilename length]-[AUDIO_TYPE length]]
     ];
  }
  _soundNames = [NSArray arrayWithArray:formattedFilenames];
  
  // Initialize to -1 (no sound selected)
  _selRow = -1;
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
  [_soundSelectionDelegate soundSelectionStopSound];
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
  static NSString *CellIdentifier = @"SoundsListCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
    // Configure the cell...
  if (indexPath.section == 0) {
    cell.textLabel.text = [_soundNames objectAtIndex:indexPath.row];
    if (indexPath.row == _selRow) cell.accessoryType = UITableViewCellAccessoryCheckmark;
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
  
  if (indexPath.section == 0 && indexPath.row != _selRow) {
    _selRow = indexPath.row;
    
    [super.tableView reloadData];
    
    // Getting the name of the selected sound
    NSString *selectedSound = [_soundNames objectAtIndex:_selRow];
    NSString *audioPath = [[NSBundle mainBundle] pathForResource:selectedSound 
                                                          ofType:@"caf"];
    // Tell the delegate to play the sound
    [_soundSelectionDelegate soundSelectionPlaySound:audioPath];
  }
}


#pragma mark - IBAction

- (IBAction)doneSelectSound:(id)sender {
  
  // In case user didn't select any sound
  if (_selRow >= 0) {
    // Getting the name of the selected sound
    NSString *selectedSound = [_soundNames objectAtIndex:_selRow];
    [_soundSelectionDelegate soundSelectionSelectSound:selectedSound];
  
    // Pop itself
    [self.navigationController popViewControllerAnimated:YES];
  }
}

#pragma mark - Custom public method

- (void)selectSoundWithName:(NSString *)selSoundName {
  NSUInteger soundIndex = 0;
  for (NSString *soundName in _soundNames) {
    if ([soundName isEqualToString:selSoundName]) {
      _selRow = soundIndex;
      NSIndexPath *selectedIndex = [NSIndexPath indexPathForRow:_selRow inSection:0];
      [self.tableView selectRowAtIndexPath:selectedIndex
                                  animated:NO
                            scrollPosition:UITableViewScrollPositionTop];
      break;
    }
    soundIndex++;
  }
}

@end
