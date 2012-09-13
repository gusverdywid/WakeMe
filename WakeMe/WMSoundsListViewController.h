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

@interface WMSoundsListViewController : UITableViewController {
  NSArray *_soundNames;
  NSInteger _selRow;
  
  AVAudioPlayer *_audioPlayer;
}

@property(nonatomic, readonly) NSArray *soundNames;
@property(nonatomic, readonly) NSInteger selRow;

- (IBAction)doneSelectSound:(id)sender;

@end

@protocol WMSoundsListViewControllerDelegate <NSObject>


@end
