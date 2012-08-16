//
//  WakeMeTests.m
//  WakeMeTests
//
//  Created by Agustinus Verdy Widyawiradi on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WakeMeTests.h"
#import "WakeMeAppDelegate.h"
#import "WMAlarm.h"

@implementation WakeMeTests

- (void) setUp {
  [super setUp];
  
  WakeMeAppDelegate *app = [[UIApplication sharedApplication] delegate];
  context = app.managedObjectContext;
  coordinator = app.persistentStoreCoordinator;
}

- (void) tearDown {
  NSArray *stores = [coordinator persistentStores];
  for (NSPersistentStore *store in stores) {
    [coordinator removePersistentStore:store error:nil];
    [[NSFileManager defaultManager] removeItemAtURL:store.URL error:nil];
  }
  
  [super tearDown];
}

- (void) testAddAlarm {
  WMAlarm *alarm = [NSEntityDescription insertNewObjectForEntityForName:@"Alarm" inManagedObjectContext:context];
  alarm.name = @"Alarm1";
  alarm.sound = @"Sound1";
  
  NSFetchRequest *fetchReq = [[NSFetchRequest alloc] init];
  NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Alarm" inManagedObjectContext:context];
  [fetchReq setEntity:entityDesc];
  NSArray *alarms = [context executeFetchRequest:fetchReq error:nil];
  
  if ([alarms count] == 1) {
    STAssertEqualObjects(alarm, [alarms objectAtIndex:0], @"Error: Different object before save\n");
  } else {
    STFail(@"Error: Number of object in database = %d before save\n", [alarms count]);
  }
  
  
  if (context != nil) {
    NSError *error = nil;
    if (![context save:&error]) {
      STFail(@"%@\n", error);
    }
  } else STFail(@"Error: Managed context is null\n");
  
  alarms = [context executeFetchRequest:fetchReq error:nil];
  
  if ([alarms count] == 1) {
    STAssertEqualObjects(alarm, [alarms objectAtIndex:0], @"Error: Different object after save\n");
  } else {
    STFail(@"Error: Number of object in database = %d after save\n", [alarms count]);
  }
}

@end
