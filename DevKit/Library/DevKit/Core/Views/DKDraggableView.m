/**
 * DevKit
 *
 * Created by Andy Roth.
 * Copyright 2009 Roozy. All rights reserved.
 */

#import "DKDraggableView.h"


@implementation DKDraggableView

@synthesize delegate;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	
	_offsetPoint = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	
	CGPoint globalPoint = [touch locationInView:self.superview];
	
	[self setFrame:CGRectMake(globalPoint.x - _offsetPoint.x, globalPoint.y - _offsetPoint.y, self.frame.size.width, self.frame.size.height)];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if(delegate != nil)
	{
		[delegate dragDidEnd:self];
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	if(delegate != nil)
	{
		[delegate dragDidEnd:self];
	}
}

- (void) dealloc
{
	delegate = nil;
	[super dealloc];
}

@end
