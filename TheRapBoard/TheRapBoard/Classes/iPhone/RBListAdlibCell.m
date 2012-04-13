//
//  RBListAdlibCell.m
//  TheRapBoard
//
//  Created by Andy Roth on 11/15/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import "RBListAdlibCell.h"

@implementation RBListAdlibCell

- (id) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if(self)
	{
		
	}
	
	return self;
}

- (void) awakeFromNib
{
	_nameLabel.font = [UIFont fontWithName:@"UnitedSansCond-Bold" size:32.0];
	_adlibLabel.font = [UIFont fontWithName:@"UnitedSansCond-Light" size:32.0];
	_nameLabel.textColor = [UIColor colorWithRed:244.0/255.0 green:241.0/255.0 blue:222.0/255.0 alpha:1.0];
	_adlibLabel.textColor = [UIColor colorWithRed:244.0/255.0 green:241.0/255.0 blue:222.0/255.0 alpha:1.0];
}

- (void) setAdlib:(RBRapperAdlib *)adlib
{
	[_button setAdlib:adlib];
	_nameLabel.text = [adlib.rapper.name uppercaseString];
	_adlibLabel.text = [adlib.content uppercaseString];
	
	[_pageControl setCurrentPage:[adlib.rapper.adlibs indexOfObject:adlib] ofTotal:[adlib.rapper.adlibs count]];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[_button touchesBegan:touches withEvent:event];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[_button touchesMoved:touches withEvent:event];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[_button touchesEnded:touches withEvent:event];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[_button touchesCancelled:touches withEvent:event];
}

@end
