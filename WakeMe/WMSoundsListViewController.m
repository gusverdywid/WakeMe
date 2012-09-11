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

@synthesize audioPlayer = _audioPlayer;

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
  
  /**
   * Load all the names of the sounds
   */
  NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
  NSFileManager *fm = [NSFileManager defaultManager];
  NSArray *filenames = [fm contentsOfDirectoryAtPath:bundleRoot error:nil];
  NSPredicate *filter = [NSPredicate predicateWithFormat:@"SELF ENDSWITH %@", @".caf"];
  NSArray *filteredFilenames = [filenames filteredArrayUsingPredicate:filter];
  NSMutableArray *formattedFilenames = [[NSMutableArray alloc] init];
  for (NSString *filteredFilename in filteredFilenames) {
    [formattedFilenames addObject:[filteredFilename substringToIndex:[filteredFilename length]-4]];
  }
  _soundNames = [NSArray arrayWithArray:formattedFilenames];
  
  for (NSString *soundName in _soundNames) {
    NSLog(@"%@\n", soundName);
  }
  
  _selRow = -1;
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
  
  if (indexPath.section == 0) _selRow = indexPath.row;
  [super.tableView reloadData];
  [self playAudio];
}

#pragma mark - Custom methods

- (void)playAudio {
  NSError *playbackError;
  NSString *audioPath = [[NSBundle mainBundle] 
                         pathForResource:[_soundNames objectAtIndex:_selRow] 
                         ofType:@"caf"];
  NSURL *audioUrl = [NSURL fileURLWithPath:audioPath];
  
  _audioPlayer = [[AVAudioPlayer alloc] 
                  initWithContentsOfURL:audioUrl 
                  error:&playbackError];
  if (_audioPlayer != nil) {
    [_audioPlayer setNumberOfLoops:4];
    [_audioPlayer prepareToPlay];
    [_audioPlayer play];
  } else {
    NSLog(@"%@", playbackError);
  }
}

@end
