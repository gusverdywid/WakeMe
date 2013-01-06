//
//  WakeMeAppDelegate.m
//  WakeMe
//
//  Created by Agustinus Verdy Widyawiradi on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WakeMeAppDelegate.h"

#import "WMSoundsListViewController.h"

@implementation WakeMeAppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){    
    // HACK (to deal with initialization delay):
    // Initial setup of audio player
    // Pass the Silent.caf (blank audio file) just to help the with the
    // setup (acts as dummy)
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"Silent" 
                                                          ofType:AUDIO_TYPE];
    // Play and stop the player straight away
    if ([self playSoundWithAudioPath:audioPath numberOfLoops:1]) {
      [_audioPlayer stop];
    }
  });
  
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  // Saves changes in the application's managed object context before the application terminates.
  [self saveContext];
}

- (void)saveContext
{
  NSError *error = nil;
  NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
  if (managedObjectContext != nil) {
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    } 
  }
}

#pragma mark - Core Data stack

  // Returns the managed object context for the application.
  // If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
  if (__managedObjectContext != nil) {
    return __managedObjectContext;
  }
  
  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  if (coordinator != nil) {
    __managedObjectContext = [[NSManagedObjectContext alloc] init];
    [__managedObjectContext setPersistentStoreCoordinator:coordinator];
  }
  return __managedObjectContext;
}

  // Returns the managed object model for the application.
  // If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
  if (__managedObjectModel != nil) {
    return __managedObjectModel;
  }
  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"WakeMeModel" withExtension:@"momd"];
  __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  return __managedObjectModel;
}

  // Returns the persistent store coordinator for the application.
  // If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
  if (__persistentStoreCoordinator != nil) {
    return __persistentStoreCoordinator;
  }
  
  NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"WakeMe.sqlite"];
  
  NSError *error = nil;
  __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
  if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
    /*
     Replace this implementation with code to handle the error appropriately.
     
     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
     
     Typical reasons for an error here include:
     * The persistent store is not accessible;
     * The schema for the persistent store is incompatible with current managed object model.
     Check the error message to determine what the actual problem was.
     
     
     If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
     
     If you encounter schema incompatibility errors during development, you can reduce their frequency by:
     * Simply deleting the existing store:
     [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
     
     * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
     [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
     
     Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
     
     */
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }    
  
  return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

  // Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark - Audio player management

/**
 * Setup audio player and play the sound in the specified path as many as the
 * number of loops
 * This method will return boolean value YES if the audio is successfully played
 * and NO otherwise
 */
- (BOOL)playSoundWithAudioPath:(NSString *)audioPath numberOfLoops:(NSInteger)loops {
  if (_audioPlayer != nil && _audioPlayer.playing) {
    [_audioPlayer stop];
  }
  
  NSError *playbackError;
  
  NSURL *audioUrl = [NSURL fileURLWithPath:audioPath];
  _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioUrl
                                                        error:&playbackError];
  
  BOOL success = NO;
  if (_audioPlayer != nil && !playbackError) {
    [_audioPlayer prepareToPlay];
    [_audioPlayer setNumberOfLoops:loops];
    success = [_audioPlayer play];
  } else {
    NSLog(@"%@", playbackError);
  }
  return success;
}

/**
 * Tell the audio player to stop playing currently played audio file
 */
- (void)stopAudioPlayer {
  if (_audioPlayer != nil && _audioPlayer.playing)
    [_audioPlayer stop];
}


#pragma mark - Alarm notification

/**
 * Create and register local notification
 */
- (void)createNotificationForAlarm:(WMAlarm *)alarm {
  UILocalNotification *alarmNotification = [[UILocalNotification alloc] init];
  alarmNotification.fireDate = alarm.time;
  alarmNotification.repeatInterval = NSDayCalendarUnit;
  alarmNotification.soundName = [NSString stringWithFormat:@"%@%@", alarm.sound, AUDIO_TYPE];
  alarmNotification.timeZone = [NSTimeZone defaultTimeZone];
  alarmNotification.alertBody = alarm.name;
  alarmNotification.alertAction = @"View";
  NSString *alarmId = [[alarm.objectID URIRepresentation] absoluteString];
  alarmNotification.userInfo = [NSDictionary dictionaryWithObject:alarmId
                                                           forKey:@"ID"];
  [[UIApplication sharedApplication] scheduleLocalNotification:alarmNotification];
}

/**
 * Delete local notification
 */
- (void)deleteNotificationOfAlarm:(NSString *)alarmID {
  NSArray *registeredNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
  UILocalNotification *tempNotification = nil;
  for (UILocalNotification *localNotification in registeredNotifications) {
    NSString *notificationID = [localNotification.userInfo objectForKey:@"ID"];
    if ([notificationID isEqual:alarmID]) {
      tempNotification = localNotification;
      break;
    }
  }
  [[UIApplication sharedApplication] cancelLocalNotification:tempNotification];
}


#pragma mark - Timer

/**
 * Register an alarm with a timer that will execute
 * an action for the alarm
 */
- (void)registerTimerForAlarm:(WMAlarm *)alarm {
  NSTimer *newTimer = [[NSTimer alloc] initWithFireDate:alarm.time 
                                               interval:1 
                                                 target:self 
                                               selector:@selector(executeAlarm:) 
                                               userInfo:alarm 
                                                repeats:NO];
  [_timers addObject:newTimer];
  [[NSRunLoop currentRunLoop] addTimer:newTimer forMode:NSRunLoopCommonModes];
}

/**
 * Invalidate and delete timer of the associated alarm from array of timers
 */
- (void)deleteTimerOfAlarm:(WMAlarm *)alarm {
  NSTimer *tempTimer = nil;
  for (NSTimer *timer in _timers) {
    if ([timer.userInfo isEqual:alarm]) {
      tempTimer = timer;
      break;
    }
  }
  if (tempTimer) {
    [_timers delete:tempTimer];
    [tempTimer invalidate];
  }
}

/**
 * Process actions of an alarm upon the specified time is reached
 */
- (void)executeAlarm:(NSTimer *)timer {
  [_timers removeObject:timer];
  [timer invalidate];
  
  WMAlarm *alarm = (WMAlarm *)timer.userInfo;
  
  /**
   * Play the alarm sound
   */
  if (alarm.sound != nil && alarm.sound.length > 0) {
    NSString *audioPath = [[NSBundle mainBundle] pathForResource:alarm.sound
                                                          ofType:AUDIO_TYPE];
    [self playSoundWithAudioPath:audioPath numberOfLoops:0];
  }
}

@end
