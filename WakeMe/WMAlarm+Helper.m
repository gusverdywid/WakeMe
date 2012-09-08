//
//  WMAlarm+Helper.m
//  WakeMe
//
//  Created by Agustinus Verdy Widyawiradi on 8/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WMAlarm+Helper.h"

@implementation WMAlarm (Helper)

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
