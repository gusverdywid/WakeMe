//
//  WMAlarm.m
//  WakeMe
//
//  Created by Agustinus Verdy Widyawiradi on 8/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WMAlarm.h"


@implementation WMAlarm

@dynamic active;
@dynamic challenge;
@dynamic name;
@dynamic snoozable;
@dynamic sound;
@dynamic time;

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
