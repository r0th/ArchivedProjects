//
//  SYSynapseData.m
//  SynapseClientLibrary
//
//  Created by Roth on 8/22/10.
//  Copyright 2010 Roozy. All rights reserved.
//

#import "SYSynapseData.h"
#import "JSON.h"


@implementation SYSynapseData

@synthesize type, payload;

#pragma mark Init

- (id) initWithData:(NSData *)data
{
	if(self = [super init])
	{
		[self performSelector:@selector(deserialize:) withObject:data];
	}
	
	return self;
}

#pragma mark Public methods

- (NSData *) serialize
{
	NSString *objectType;
	
	if(type == SYSynapseDataTypeConnected)
	{
		objectType = @"connected";
	}
	else if(type == SYSynapseDataTypeMessage)
	{
		objectType = @"message";
	}
	else if(type == SYSynapseDataTypeMotion)
	{
		objectType = @"motion";
	}
	else if(type == SYSynapseDataTypeVibrate)
	{
		objectType = @"vibrate";
	}
	else if(type == SYSynapseDataTypeTouch)
	{
		objectType = @"touch";
	}
	
	NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:objectType, @"type", payload, @"payload", nil];
	NSString *jsonString = [dict JSONRepresentation];
	
	return [jsonString dataUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark Private methods

- (void) deserialize:(NSData *)data
{
	NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSObject *ob = [jsonString JSONValue];
	NSString *objectType = [ob valueForKey:@"type"];
	payload = [ob valueForKey:@"payload"];
	
	if([objectType isEqualToString:@"connected"])
	{
		type = SYSynapseDataTypeConnected;
	}
	else if([objectType isEqualToString:@"message"])
	{
		type = SYSynapseDataTypeMessage;
	}
	else if([objectType isEqualToString:@"motion"])
	{
		type = SYSynapseDataTypeMotion;
	}
	else if([objectType isEqualToString:@"vibrate"])
	{
		type = SYSynapseDataTypeVibrate;
	}
	else if([objectType isEqualToString:@"touch"])
	{
		type = SYSynapseDataTypeTouch;
	}
}

@end
