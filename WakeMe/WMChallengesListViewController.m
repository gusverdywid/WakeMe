//
//  WMChallengesListViewController.m
//  WakeMe
//
//  Created by Agustinus Verdy Widyawiradi on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WMChallengesListViewController.h"

@interface WMChallengesListViewController ()

@end

@implementation WMChallengesListViewController


@synthesize challengeNames = _challengeNames;
@synthesize selRow = _selRow;
@synthesize challengeSelectionDelegate = _challengeSelectionDelegate;


- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        [self initialize];
    }
    return self;
}

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
   * Read the challenge names from plist file
   */
  NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ChallengesList"
                                                       ofType:@"plist"];
  _challengeNames = [[NSArray alloc] initWithContentsOfFile:filePath];
  
  /**
   * Init to -1 because 0 is a valid row
   */
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  // Only need 1 section (section 0) so any section would have no row
  if (section == 0)
    return [_challengeNames count];
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ChallengesListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
  if (indexPath.section == 0) {
    cell.textLabel.text = [_challengeNames objectAtIndex:indexPath.row];
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
  }
}


#pragma mark - Custom public method

/**
 * Used for selecting the row of selected challenge
 */
- (void)selectChallengeWithName:(NSString *)challengeName {
  NSUInteger challengeIndex = 0;
  for (NSString *name in _challengeNames) {
    if ([name isEqualToString:challengeName]) {
      _selRow = challengeIndex;
      NSIndexPath *selectedIndex = [NSIndexPath indexPathForRow:_selRow
                                                      inSection:0];
      [self.tableView selectRowAtIndexPath:selectedIndex
                                  animated:NO
                            scrollPosition:UITableViewScrollPositionTop];
      break;
    }
    challengeIndex++;
  }
}


#pragma mark - IBAction

- (IBAction)finishSelectingChallenge:(id)sender {
  
  // In case user didn't select any challenge
  if (_selRow >= 0) {
    // Getting the name of the selected challenge
    NSString *selectedChallenge = [_challengeNames objectAtIndex:_selRow];
    [_challengeSelectionDelegate challengeSelectionSelectChallengeWithName:selectedChallenge];
    
    // Pop itself
    [self.navigationController popViewControllerAnimated:YES];
  }
}

@end
