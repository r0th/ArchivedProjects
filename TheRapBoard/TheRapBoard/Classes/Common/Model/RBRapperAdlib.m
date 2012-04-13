//
//  RBRapperAdlib.m
//  TheRapBoard
//
//  Created by Andy Roth on 11/11/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import "RBRapperAdlib.h"

@implementation RBRapperAdlib

@synthesize content, filename, rapper;

- (void) dealloc
{
	[content release];
	[filename release];
	rapper = nil;
	
	[super dealloc];
}

@end
