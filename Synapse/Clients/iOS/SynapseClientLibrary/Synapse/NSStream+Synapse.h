//
//  NSStream+Synapse.h
//  SynapseClientLibrary
//
//  Created by Roth on 8/19/10.
//  Copyright 2010 Roozy. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSStream (Synapse)

+ (void)getStreamsToHostNamed:(NSString *)hostName port:(NSInteger)port inputStream:(NSInputStream **)inputStream outputStream:(NSOutputStream **)outputStream;

@end