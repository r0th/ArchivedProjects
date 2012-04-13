/**
 * DevKit
 *
 * Created by Andy Roth.
 * Copyright 2009 Roozy. All rights reserved.
 */

#import "DKToggleButton.h"
#import "DKToggleButtonGroup.h"


@implementation DKToggleButton

@synthesize enableClick, group, delegate;

- (id) init
{
	if((self = [super init]))
	{
		_on = YES;
		[self addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
	}
	
	return self;
}

- (id) initWithImages:(UIImage *)onImage offImage:(UIImage *)offImage
{
	if((self = [self init]))
	{
		[self setImages:onImage offImage:offImage];
	}
	
	return self;
}

- (void) setOn:(BOOL)isOn
{
	if(isOn != _on)
	{
		_on = isOn;
		
		if(_on)
		{
			[self setImage:_onImage forState:UIControlStateNormal];
			[self setImage:_onImage forState:UIControlStateHighlighted];
		}
		else
		{
			[self setImage:_offImage forState:UIControlStateNormal];
			[self setImage:_offImage forState:UIControlStateHighlighted];
		}
		
		if(delegate) [delegate button:self didChangeState:_on];
	}
}

- (BOOL) on
{
	return _on;
}

- (void) setImages:(UIImage *)onImage offImage:(UIImage *)offImage
{
	[self setTitle:nil forState:UIControlStateNormal];
	
	// Set the images
	_onImage = [onImage retain];
	_offImage = [offImage retain];
	
	// Refresh
	[self setOn:NO];
}

- (void) onClick
{
	[self setOn:!_on];
	if(group) [group didClickButton:self];
}

- (void) dealloc
{
	[_onImage release];
	[_offImage release];
	delegate = nil;
	group = nil;
	
	[super dealloc];
}

@end
