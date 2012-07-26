//
//  main.m
//  WakeMe
//
//  Created by Agustinus Verdy Widyawiradi on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <stdio.h>

#import "WakeMeAppDelegate.h"

FILE *fopen$UNIX2003( const char *filename, const char *mode ) {
  return fopen(filename, mode);
}

size_t fwrite$UNIX2003( const void *a, size_t b, size_t c, FILE *d ) {
  return fwrite(a, b, c, d);
}

int main(int argc, char *argv[])
{
  @autoreleasepool {
      return UIApplicationMain(argc, argv, nil, NSStringFromClass([WakeMeAppDelegate class]));
  }
}