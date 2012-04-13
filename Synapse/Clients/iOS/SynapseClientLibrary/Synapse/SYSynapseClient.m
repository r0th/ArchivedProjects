//
//  SYSynapseClient.m
//  SynapseClientLibrary
//
//  Created by Roth on 8/20/10.
//  Copyright 2010 Roozy. All rights reserved.
//

#import "SYSynapseClient.h"
#import "NSStream+Synapse.h"
#import "JSON.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation SYSynapseClient

@synthesize address, name, port, delegate;

#pragma mark Init

- (id) init
{
	if(self = [super init])
	{
		address = @"127.0.0.1";
		port = 2460;
	}
	
	return self;
}

#pragma mark Public methods

- (void) connect
{
	[self connect:address port:port];
}

- (void) connect:(NSString *)serverAddress port:(int)serverPort
{
	address = serverAddress;
	port = serverPort;
	
	[NSStream getStreamsToHostNamed:address port:port inputStream:&iStream outputStream:&oStream];
	
	[iStream retain];
	[oStream retain];
	
	[iStream setDelegate:self];
	[oStream setDelegate:self];
	
	[iStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[oStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	
	[iStream open];
	[oStream open];
}

- (void) sendMessage:(NSString *)message
{
	[self sendMessageInternal:SYSynapseDataTypeMessage payload:message];
}

#pragma mark Motion data methods

- (void) startMotionUpdates
{
	if(!accelerometer)
	{
		accelerometer = [UIAccelerometer sharedAccelerometer];
	}
	
	accelerometer.delegate = self;
}

- (void) stopMotionUpdates
{
	if(accelerometer)
	{
		accelerometer.delegate = nil;
	}
}

#pragma mark Touch methods

- (void) sendTouchX:(CGFloat)x y:(CGFloat)y
{
	CGFloat realX = MAX(0, MIN(1, x));
	CGFloat realY = MAX(0, MIN(1, y));
	NSString *json = [NSString stringWithFormat:@"{\"touchX\":\"%f\",\"touchY\":\"%f\"}", realX, realY];
	[self sendMessageInternal:SYSynapseDataTypeTouch payload:json];
}

#pragma mark Private methods

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
	if(eventCode == NSStreamEventOpenCompleted)
	{
		//NSLog(@"stream opened");
	}
	else if(eventCode == NSStreamEventErrorOccurred)
	{
		if(delegate && [delegate respondsToSelector:@selector(client:didFailWithError:)])
		{
			[delegate client:self didFailWithError:@"Stream could not open."];
		}		
	}
	else if(eventCode == NSStreamEventHasBytesAvailable)
	{
		uint8_t buffer[1024];
		unsigned int len = 0;
		len = [iStream read:buffer maxLength:1024];
		
		NSData *data = [[NSData alloc] initWithBytes:(const void *)buffer length:len];
		
		if([data length] > 0)
		{
			SYSynapseData *messageData = [[SYSynapseData alloc] initWithData:data];
			
			[self parseReceivedData:messageData];
		}
	}
	else if(eventCode == NSStreamEventEndEncountered)
	{
		if(delegate && [delegate respondsToSelector:@selector(client:didDisconnectWithName:)])
		{
			[delegate client:self didDisconnectWithName:name];
		}
	}
}

- (void) sendMessageInternal:(SYSynapseDataType)type payload:(NSString *)payload
{
	if(oStream)
	{
		SYSynapseData *messageData = [[SYSynapseData alloc] init];
		messageData.type = type;
		messageData.payload = payload;
		
		NSData *data = [messageData serialize];
		
		[oStream write:(uint8_t *)[data bytes] maxLength:[data length]];
	}
}

- (void) parseReceivedData:(SYSynapseData *)data
{
	if(data.type == SYSynapseDataTypeConnected)
	{
		// When making the connection handshake, set the client's name and send the server an acknowledgement
		name = data.payload;
		[self sendMessageInternal:SYSynapseDataTypeConnected payload:@""];
		
		if(delegate && [delegate respondsToSelector:@selector(client:didConnectWithName:)])
		{
			[delegate client:self didConnectWithName:name];
		}
	}
	else if(data.type == SYSynapseDataTypeMessage)
	{
		// If the data is a message, call the delegate method
		if(delegate && [delegate respondsToSelector:@selector(client:didReceiveMessage:)])
		{
			[delegate client:self didReceiveMessage:data.payload];
		}
	}
	else if(data.type == SYSynapseDataTypeVibrate)
	{
		// If the data is a vibrate message, vibrate the phone
		AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
	}
}

#pragma mark Accelerometer Delegate

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	NSString *json = [NSString stringWithFormat:@"{\"deviceX\":\"%f\",\"deviceY\":\"%f\",\"deviceZ\":\"%f\"}", acceleration.x, acceleration.y, acceleration.z];
	[self sendMessageInternal:SYSynapseDataTypeMotion payload:json];
}

@end
