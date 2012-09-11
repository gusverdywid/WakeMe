//
//  WMSoundsListViewController.h
//  WakeMe
//
//  Created by Agustinus Verdy Widyawiradi on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMSoundsListViewController : UITableViewController {
  NSArray *_soundNames;
  NSInteger _selRow;
}

@property(nonatomic, readonly) NSArray *soundNames;
@property(nonatomic, readonly) NSInteger selRow;

@end
