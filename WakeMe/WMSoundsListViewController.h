//
//  WMSoundsListViewController.h
//  WakeMe
//
//  Created by Agustinus Verdy Widyawiradi on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#define AUDIO_TYPE @".caf"

@class WMSoundsListViewController;

@protocol WMSoundsListViewControllerDelegate <NSObject>
 @required
  - (void)soundSelectionDidCancel:(WMSoundsListViewController *)controller;
  - (void)soundSelectionDidFinish:(NSString *)selectedSound;
@end


@interface WMSoundsListViewController : UITableViewController {
  NSArray *_soundNames;
  NSInteger _selRow;

  AVAudioPlayer *_audioPlayer;
  
  __weak id<WMSoundsListViewControllerDelegate> _soundSelectionDelegate;
}

@property(nonatomic, readonly) NSArray *soundNames;
@property(nonatomic, readonly) NSInteger selRow;

@property(nonatomic, weak)
  id<WMSoundsListViewControllerDelegate> soundSelectionDelegate;

- (IBAction)doneSelectSound:(id)sender;

@end