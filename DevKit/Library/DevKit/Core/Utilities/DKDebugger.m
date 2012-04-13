//
//  DKDebugger.m
//  BlankProject
//
//  Created by Andy Roth on 6/17/11.
//  Copyright 2011 Roozy. All rights reserved.
//

#import "DKDebugger.h"

@interface DKDebugger()

+ (NSString *) debugFilePath;

@end

@implementation DKDebugger

+ (NSString *) debugFilePath
{
	NSString *pathString = [[[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"debug.txt"] absoluteString];
	pathString = [pathString stringByReplacingOccurrencesOfString:@"file://localhost" withString:@""];
	pathString = [pathString stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
	
	return pathString;
}

+ (void) startWritingToDebugFile
{
	const char *path = [[self debugFilePath] fileSystemRepresentation];
	freopen(path, "w", stderr);
}

+ (NSData *) dataFromDebugFile
{
	return [NSData dataWithContentsOfFile:[self debugFilePath]];
}

+ (NSString *) stringFromDebugFile
{
	return [[[NSString alloc] initWithData:[self dataFromDebugFile] encoding:NSUTF8StringEncoding] autorelease];
}

@end
