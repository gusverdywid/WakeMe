//
//  WMAlarm+Helper.h
//  WakeMe
//
//  Created by Agustinus Verdy Widyawiradi on 8/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WMAlarm.h"

#define WM_ALARM_SOUND_LENGTH_ERROR_CODE 1
#define WM_ALARM_CHALLENGE_LENGTH_ERROR_CODE 2

@interface WMAlarm (Helper)

- (BOOL)validateSound:(NSString **)soundName error:(NSError **)outError;
- (BOOL)validateChallenge:(NSString **)challengeName error:(NSError **)outError;

@end
