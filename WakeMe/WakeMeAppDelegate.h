//
//  WakeMeAppDelegate.h
//  WakeMe
//
//  Created by Agustinus Verdy Widyawiradi on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "WMAlarm.h"

#define AUDIO_TYPE @"caf"

@interface WakeMeAppDelegate : UIResponder <UIApplicationDelegate> {
  AVAudioPlayer *_audioPlayer;
  NSMutableArray *_timers;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (BOOL)playSoundWithAudioPath:(NSString *)audioPath numberOfLoops:(NSInteger)loops;
- (void)stopAudioPlayer;

- (void)createNotificationForAlarm:(WMAlarm *)alarm;
- (void)deleteNotificationOfAlarm:(WMAlarm *)alarm;

@end
