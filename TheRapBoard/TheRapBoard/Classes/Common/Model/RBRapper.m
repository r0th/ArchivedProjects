//
//  RBRapper.m
//  TheRapBoard
//
//  Created by Andy Roth on 11/11/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import "RBRapper.h"
#import "RBRapperAdlib.h"

static NSArray *_allRappers;

@implementation RBRapper

@synthesize name, imageName, highlightedImageName, adlibs;

+ (void) initialize
{
	NSDictionary *data = [[NSDictionary alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Rappers" withExtension:@"plist"]];
	NSArray *allRapperData = [data objectForKey:@"rappers"];
	NSMutableArray *tempRappers = [[NSMutableArray alloc] init];
	
	for(NSDictionary *rapperData in allRapperData)
	{
		RBRapper *rapper = [[RBRapper alloc] init];
		rapper.name = [rapperData objectForKey:@"name"];
		rapper.imageName = [rapperData objectForKey:@"image"];
		rapper.highlightedImageName = [rapperData objectForKey:@"image-highlighted"];
		
		NSMutableArray *tempAdlibs = [[NSMutableArray alloc] init];
		NSArray *allAdlibData = [rapperData objectForKey:@"adlibs"];
		for(NSDictionary *adlibData in allAdlibData)
		{
			RBRapperAdlib *adlib = [[RBRapperAdlib alloc] init];
			adlib.content = [adlibData objectForKey:@"content"];
			adlib.filename = [adlibData objectForKey:@"file"];
			adlib.rapper = rapper;
			[tempAdlibs addObject:[adlib autorelease]];
		}
		
		rapper.adlibs = tempAdlibs;
		[tempAdlibs release];
		
		[tempRappers addObject:[rapper autorelease]];
	}
	
	_allRappers = [tempRappers retain];
	[tempRappers release];
}

+ (NSArray *) allRappers
{
	if(!_allRappers) [self initialize];
	
	return _allRappers;
}

+ (NSArray *) allAdlibs
{
	if(!_allRappers) [self initialize];
	
	NSMutableArray *results = [[NSMutableArray alloc] init];
	for(RBRapper *rapper in _allRappers)
	{
		[results addObjectsFromArray:rapper.adlibs];
	}
	
	return [results autorelease];
}

- (void) dealloc
{
	[name release];
	[imageName release];
	[highlightedImageName release];
	[adlibs release];
	
	[super dealloc];
}

@end
