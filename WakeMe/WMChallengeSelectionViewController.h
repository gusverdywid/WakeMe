//
//  WMChallengeSelectionViewController.h
//  WakeMe
//
//  Created by Agustinus Verdy Widyawiradi on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WMChallengeSelectionViewControllerDelegate <NSObject>
 @required
 // Will be used to pass the name of selected challenge
  - (void)challengeSelectionSelectChallengeWithName:(NSString *)selectedChallenge;
@end


@interface WMChallengeSelectionViewController : UITableViewController {
  NSArray *_challengeNames;
  NSInteger _selectedRow;
  
  __weak id<WMChallengeSelectionViewControllerDelegate> _challengeSelectionDelegate;
}

@property(nonatomic, readonly) NSArray *challengeNames;
@property(nonatomic, readonly) NSInteger selectedRow;

@property(nonatomic, weak) id<WMChallengeSelectionViewControllerDelegate> challengeSelectionDelegate;

- (void)selectChallengeWithName:(NSString *)challengeName;

- (IBAction)finishSelectingChallenge:(id)sender;

@end
