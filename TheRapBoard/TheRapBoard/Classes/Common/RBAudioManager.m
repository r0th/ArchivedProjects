//
//  RBAudioManager.m
//  TheRapBoard
//
//  Created by Andy Roth on 11/14/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import "RBAudioManager.h"

@implementation RBAudioManager

- (void) playAdlib:(RBRapperAdlib *)adlib
{
	NSArray *components = [adlib.filename componentsSeparatedByString:@"."];
	NSURL *url = [[NSBundle mainBundle] URLForResource:[components objectAtIndex:0] withExtension:[components objectAtIndex:1]];
	AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
	[player play];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
	[player release];
}

#pragma mark - Singleton

static RBAudioManager *sharedManager = nil;

+ (RBAudioManager *) sharedManager
{
    @synchronized(self)
	{
        if (sharedManager == nil)
		{
            [[self alloc] init];
        }
    }
	
    return sharedManager;
}

+ (id) allocWithZone:(NSZone *)zone
{
    @synchronized(self)
	{
        if (sharedManager == nil)
		{
            sharedManager = [super allocWithZone:zone];
            return sharedManager;
        }
    }
    return nil;
}

- (id) copyWithZone:(NSZone *)zone
{
    return self;
}

- (id) retain
{
    return self;
}

- (unsigned) retainCount
{
    return UINT_MAX;
}

- (oneway void)release
{
	
}

- (id) autorelease
{
    return self;
}

@end
