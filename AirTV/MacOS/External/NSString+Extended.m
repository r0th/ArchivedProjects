/**
 * iLibraryCore
 *
 * Created by Andy Roth.
 * Copyright 2009 Roozy. All rights reserved.
 */

#import "NSString+Extended.h"


@implementation NSString (Extended)

- (BOOL) contains:(NSString *)insideString
{
	return ([self rangeOfString:insideString].location != NSNotFound);
}

- (NSString *) removeWhitespace
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *) replaceString:(NSString *)replaced withString:(NSString *)withString
{
	while([self contains:replaced])
	{
		self = [self stringByReplacingCharactersInRange:[self rangeOfString:replaced] withString:withString];
	}
	
	return self;
}

@end
