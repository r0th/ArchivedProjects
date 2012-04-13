//
//  RBRapperButton.m
//  TheRapBoard
//
//  Created by Andy Roth on 11/14/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import "RBRapperButton.h"
#import "RBAudioManager.h"

@interface RBRapperButton ()
{
@private
    RBRapperAdlib *_adlib;
	
	UIImageView *_imageView;
	BOOL _touchesMoved;
}

- (void) initialize;
- (void) playAdlib;

@end

@implementation RBRapperButton

- (id) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(self)
	{
		[self initialize];
	}
	
	return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if(self)
	{
		[self initialize];
	}
	
	return self;
}

- (void) initialize
{
	self.backgroundColor = [UIColor clearColor];
	
	_imageView = [[UIImageView alloc] initWithFrame:self.bounds];
	_imageView.contentMode = UIViewContentModeScaleAspectFill;
	[self addSubview:_imageView];
}

- (void) setAdlib:(RBRapperAdlib *)adlib
{
	[_adlib release];
	_adlib = [adlib retain];
	
	self.backgroundColor = [UIColor clearColor];
	_imageView.image = [UIImage imageNamed:_adlib.rapper.imageName];
}

- (void) playAdlib
{
	[[RBAudioManager sharedManager] playAdlib:_adlib];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	_imageView.image = [UIImage imageNamed:_adlib.rapper.highlightedImageName];
	_touchesMoved = NO;
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	_imageView.image = [UIImage imageNamed:_adlib.rapper.imageName];
	_touchesMoved = YES;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	_imageView.image = [UIImage imageNamed:_adlib.rapper.imageName];
	
	if(!_touchesMoved)
	{
		[self playAdlib];
	}
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	_imageView.image = [UIImage imageNamed:_adlib.rapper.imageName];
}

- (void) dealloc
{
	[_adlib release];
	
	[super dealloc];
}

@end
