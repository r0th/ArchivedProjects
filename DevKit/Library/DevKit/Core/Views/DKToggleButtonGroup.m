/**
 * DevKit
 *
 * Created by Andy Roth.
 * Copyright 2009 Roozy. All rights reserved.
 */

#import "DKToggleButtonGroup.h"
#import "DKToggleButton.h"


@implementation DKToggleButtonGroup

- (id) init
{
	if((self = [super init]))
	{
		_buttons = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (id) initWithButtons:(NSArray *)buttons
{
	if((self = [self init]))
	{
		for(int i = 0; i < [buttons count]; i++)
		{
			[self addButton:(DKToggleButton *)[buttons objectAtIndex:i]];
		}
	}
	
	return self;
}

- (DKToggleButton *) selectedButton
{
	DKToggleButton *tempButton;
	
	for(int i = 0; i < [_buttons count]; i++)
	{
		tempButton = (DKToggleButton *)[_buttons objectAtIndex:i];
		
		if(tempButton.on)
		{
			return tempButton;
		}
	}
	
	return nil;
}

- (int) selectedButtonIndex
{
	DKToggleButton *tempButton;
	
	for(int i = 0; i < [_buttons count]; i++)
	{
		tempButton = (DKToggleButton *)[_buttons objectAtIndex:i];
		
		if(tempButton.on)
		{
			return i;
		}
	}
	
	return 0;
}

- (void) addButton:(DKToggleButton *)newButton
{
	newButton.group = self;
	[_buttons addObject:newButton];
}

- (void) didClickButton:(DKToggleButton *)button
{
	DKToggleButton *tempButton;
	
	for(int i = 0; i < [_buttons count]; i++)
	{
		tempButton = (DKToggleButton *)[_buttons objectAtIndex:i];
		
		if(button != tempButton)
		{
			tempButton.on = NO;
		}
	}
}

- (void) dealloc
{
	[_buttons release];
	[super dealloc];
}

@end
