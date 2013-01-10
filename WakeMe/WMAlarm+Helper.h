//
//  WMAlarm+Helper.h
//  WakeMe
//
//  Created by Agustinus Verdy Widyawiradi on 8/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WMAlarm.h"

#define WM_ALARM_SOUND_LENGTH_ERROR_CODE 1

@interface WMAlarm (Helper)

- (BOOL)validateSound:(NSString **)soundName error:(NSError **)outError;

@end
