//
//  SYSynapseData.h
//  SynapseClientLibrary
//
//  Created by Roth on 8/22/10.
//  Copyright 2010 Roozy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum SYSynapseDataType
{
	SYSynapseDataTypeConnected,
	SYSynapseDataTypeMessage,
	SYSynapseDataTypeMotion,
	SYSynapseDataTypeVibrate,
	SYSynapseDataTypeTouch
} SYSynapseDataType;

@interface SYSynapseData : NSObject
{
	SYSynapseDataType type;
	NSString *payload;
}

@property (nonatomic) SYSynapseDataType type;
@property (nonatomic, retain) NSString *payload;

- (id) initWithData:(NSData *)data;

- (NSData *) serialize;

@end
