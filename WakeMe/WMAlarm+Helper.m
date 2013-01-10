//
//  WMAlarm+Helper.m
//  WakeMe
//
//  Created by Agustinus Verdy Widyawiradi on 8/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WMAlarm+Helper.h"

@implementation WMAlarm (Helper)

- (BOOL)validateSound:(NSString *__autoreleasing *)soundName error:(NSError *__autoreleasing *)outError {
  if (*soundName == nil || [*soundName length] <= 0) {
    if (*outError != nil) {
      NSDictionary *errorDict = [NSDictionary dictionaryWithObject:@"Please select sound for the alarm" 
                                                            forKey:NSLocalizedDescriptionKey];
      *outError = [[NSError alloc] initWithDomain:NSCocoaErrorDomain 
                                             code:WM_ALARM_SOUND_LENGTH_ERROR_CODE
                                         userInfo:errorDict];
    }
    return NO;
  }
  return YES;
}

- (BOOL)validateChallenge:(NSString *__autoreleasing *)challengeName error:(NSError *__autoreleasing *)outError {
  if (*challengeName == nil || [*challengeName length] <= 0) {
    if (*outError != nil) {
      NSDictionary *errorDict = [NSDictionary dictionaryWithObject:@"Please select challenge for the alarm" 
                                                            forKey:NSLocalizedDescriptionKey];
      *outError = [[NSError alloc] initWithDomain:NSCocoaErrorDomain 
                                             code:WM_ALARM_CHALLENGE_LENGTH_ERROR_CODE
                                         userInfo:errorDict];
    }
    return NO;
  }
  return YES;
}


-(NSString *) description {
  return [NSString stringWithFormat:@"\
          Name:\t%@\n\
          Active:\t%@\n\
          Snooze:\t%@\n\
          Time:\t%@\n\
          Challenge:\t%@\n\
          Sound:\t%@\n",
          self.name,
          ([self.active intValue] ? @"Yes":@"No"),
          ([self.snoozable intValue] ? @"Yes" : @"No"),
          self.time,
          self.challenge,
          self.sound
          ];
  
}

@end
