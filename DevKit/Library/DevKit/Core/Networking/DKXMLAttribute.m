/**
 * DevKit
 *
 * Created by Andy Roth.
 * Copyright 2009 Roozy. All rights reserved.
 */
#import "DKXMLAttribute.h"


@implementation DKXMLAttribute

@synthesize name, content;

- (id) initWithDictionary:(NSDictionary *)dictionary
{
	if((self = [super init]))
	{
		if([dictionary objectForKey:@"attributeName"] != nil) self.name = [dictionary objectForKey:@"attributeName"];
		if([dictionary objectForKey:@"attributeContent"] != nil) self.content = [dictionary objectForKey:@"attributeContent"];
	}
	
	return self;
}

- (void) dealloc
{
	[name release];
	[content release];
	
	[super dealloc];
}

@end
