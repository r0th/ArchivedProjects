//
//  SYSynapseClient.h
//  SynapseClientLibrary
//
//  Created by Roth on 8/20/10.
//  Copyright 2010 Roozy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYSynapseData.h"
#import <CoreMotion/CoreMotion.h>

@class SYSynapseClient;

@protocol SYSynapseClientDelegate <NSObject>

@optional

- (void) client:(SYSynapseClient *)client didConnectWithName:(NSString *)name;
- (void) client:(SYSynapseClient *)client didReceiveMessage:(NSString *)message;
- (void) client:(SYSynapseClient *)client didDisconnectWithName:(NSString *)name;
- (void) client:(SYSynapseClient *)client didFailWithError:(NSString *)error;

@end


@interface SYSynapseClient : NSObject <NSStreamDelegate, UIAccelerometerDelegate>
{
	NSString *address;
	int port;
	NSString *name;
	
	id <SYSynapseClientDelegate> delegate;
	
@private
	
	NSInputStream *iStream;
	NSOutputStream *oStream;
	
	UIAccelerometer *accelerometer;
}

@property (nonatomic, retain) NSString *address;
@property (nonatomic) int port;
@property (nonatomic, retain, readonly) NSString *name;
@property (nonatomic, retain) id <SYSynapseClientDelegate> delegate;

// Connect methods
- (void) connect;
- (void) connect:(NSString *)serverAddress port:(int)serverPort;

// Simple messaging methods
- (void) sendMessage:(NSString *)message;

// Internal methods
- (void) sendMessageInternal:(SYSynapseDataType)type payload:(NSString *)payload;
- (void) parseReceivedData:(SYSynapseData *)data;

// Motion methods
- (void) startMotionUpdates;
- (void) stopMotionUpdates;

// Touch methods
- (void) sendTouchX:(CGFloat)x y:(CGFloat)y;

@end
