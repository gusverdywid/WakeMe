//
//  WMSoundSelectionViewController.h
//  WakeMe
//
//  Created by Agustinus Verdy Widyawiradi on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@class WMSoundSelectionViewController;

@protocol WMSoundSelectionViewControllerDelegate <NSObject>
 @required
  - (void)soundSelectionSelectSound:(NSString *)selectedSound;
@end


@interface WMSoundSelectionViewController : UITableViewController {
  NSArray *_soundNames;
  NSInteger _selectedRow;
  
  __weak id<WMSoundSelectionViewControllerDelegate> _soundSelectionDelegate;
}

@property(nonatomic, readonly) NSArray *soundNames;
@property(nonatomic, readonly) NSInteger selectedRow;

@property(nonatomic, weak) id<WMSoundSelectionViewControllerDelegate> soundSelectionDelegate;

- (void)selectSoundWithName:(NSString *)selectedSoundName;

- (IBAction)finishSelectingSound:(id)sender;

@end