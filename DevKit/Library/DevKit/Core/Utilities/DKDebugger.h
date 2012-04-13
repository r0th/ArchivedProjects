//
//  DKDebugger.h
//  BlankProject
//
//  Created by Andy Roth on 6/17/11.
//  Copyright 2011 Roozy. All rights reserved.
//

#import <Foundation/Foundation.h>

#define debug(format, ...) CFShow([NSString stringWithFormat:@"[%@] : %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], [NSString stringWithFormat:format, ## __VA_ARGS__]]);
#define trace(format, ...) CFShow([NSString stringWithFormat:format, ## __VA_ARGS__]);

@interface DKDebugger : NSObject

+ (void) startWritingToDebugFile;
+ (NSData *) dataFromDebugFile;
+ (NSString *) stringFromDebugFile;

@end
