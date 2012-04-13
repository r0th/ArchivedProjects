/**
 * DevKit
 *
 * Created by Andy Roth.
 * Copyright 2009 Roozy. All rights reserved.
 */

#import <Foundation/Foundation.h>


@interface NSString (DKExtended)

// Checks to see if the string contains another string
- (BOOL) contains:(NSString *)insideString;

// Removes extra whitespace and line breaks around a string
- (NSString *) stringWithoutWhitespace;

// Replaces part of a string with another string and returns a new string
- (NSString *) stringByReplacingString:(NSString *)replaced withString:(NSString *)withString;

@end
