/**
 * DevKit
 *
 * Created by Andy Roth.
 * Copyright 2009 Roozy. All rights reserved.
 */

#import "NSString+DKExtended.h"


@implementation NSString (DKExtended)

- (BOOL) contains:(NSString *)insideString
{
	return ([self rangeOfString:insideString].location != NSNotFound);
}

- (NSString *) stringWithoutWhitespace
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *) stringByReplacingString:(NSString *)replaced withString:(NSString *)withString
{
	while([self contains:replaced])
	{
		self = [self stringByReplacingCharactersInRange:[self rangeOfString:replaced] withString:withString];
	}
	
	return self;
}

@end
