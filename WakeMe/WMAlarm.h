//
//  WMAlarm.h
//  WakeMe
//
//  Created by Agustinus Verdy Widyawiradi on 12/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface WMAlarm : NSManagedObject

@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSString * challenge;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * snoozable;
@property (nonatomic, retain) NSString * sound;
@property (nonatomic, retain) NSDate * time;

@end
