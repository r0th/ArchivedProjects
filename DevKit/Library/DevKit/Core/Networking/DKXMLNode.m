/**
 * DevKit
 *
 * Created by Andy Roth.
 * Copyright 2009 Roozy. All rights reserved.
 */

#import "DKXMLNode.h"
#import "DKXMLAttribute.h"
#import "NSString+DKExtended.h"

@implementation DKXMLNode

@synthesize name, content, attributes, children;

- (id) initWithDictionary:(NSDictionary *)dictionary
{
	if((self = [super init]))
	{
		// Set name and content
		if([dictionary objectForKey:@"nodeName"] != nil) self.name = [dictionary objectForKey:@"nodeName"];
		if([dictionary objectForKey:@"nodeContent"] != nil) self.content = [dictionary objectForKey:@"nodeContent"];
		
		// Set the attributes
		NSMutableArray *atts = [[NSMutableArray alloc] init];
		NSArray *tempAttributes = [dictionary objectForKey:@"nodeAttributeArray"];
		if(tempAttributes)
		{		
			for(int i = 0; i < [tempAttributes count]; i++)
			{
				DKXMLAttribute *tempAttribute = [[DKXMLAttribute alloc] initWithDictionary:[tempAttributes objectAtIndex:i]];
				[atts addObject:tempAttribute];
				
				[tempAttribute release];
			}
		}
		
		self.attributes = atts;
		[atts release];
		
		// Set the children
		NSMutableArray *childs = [[NSMutableArray alloc] init];
		NSArray *tempChildren = [dictionary objectForKey:@"nodeChildArray"];
		if(tempChildren)
		{
			for(int j = 0; j < [tempChildren count]; j++)
			{
				DKXMLNode *tempChild = [[DKXMLNode alloc] initWithDictionary:[tempChildren objectAtIndex:j]];
				[childs addObject:tempChild];
				
				[tempChild release];
			}
		}
		
		self.children = childs;
		[childs release];
	}
	
	return self;
}

- (DKXMLNode *) getChildNodeByName:(NSString *)childName
{
	for(int i = 0; i < [children count]; i++)
	{
		DKXMLNode *node = (DKXMLNode *)[children objectAtIndex:i];
		
		if([node.name isEqualToString:childName])
		{
			return node;
		}
	}
	
	return nil;
}

- (DKXMLNode *) getChildNodeThatContains:(NSString *)string
{
	for(int i = 0; i < [children count]; i++)
	{
		DKXMLNode *node = (DKXMLNode *)[children objectAtIndex:i];
		
		if([node.name contains:string])
		{
			return node;
		}
	}
	
	return nil;
}

- (DKXMLAttribute *) getAttributeByName:(NSString *)attributeName
{
	for(int i = 0; i < [attributes count]; i++)
	{
		DKXMLAttribute *attribute = (DKXMLAttribute *)[attributes objectAtIndex:i];
		
		if([attribute.name isEqualToString:attributeName])
		{
			return attribute;
		}
	}
	
	return nil;
}

- (void) dealloc
{
	[name release];
	[content release];
	[attributes release];
	[children release];
	
	[super dealloc];
}

@end
