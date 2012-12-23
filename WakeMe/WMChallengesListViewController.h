//
//  WMChallengesListViewController.h
//  WakeMe
//
//  Created by Agustinus Verdy Widyawiradi on 8/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WMChallengeSelectionViewControllerDelegate <NSObject>
@required
@end


@interface WMChallengesListViewController : UITableViewController {
  NSArray *_challengeNames;
  NSInteger _selRow;
}

@property(nonatomic, readonly) NSArray *challengeNames;
@property(nonatomic, readonly) NSInteger selRow;

@end
