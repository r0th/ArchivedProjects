//
//  RBPageControl.m
//  TheRapBoard
//
//  Created by Andy Roth on 11/16/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import "RBPageControl.h"

@implementation RBPageControl

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
	{
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void) setCurrentPage:(int)current ofTotal:(int)totalPages
{
	for(UIView *view in self.subviews)
	{
		[view removeFromSuperview];
	}
	
	// Image size: 10x9
	for(int i = 0; i < totalPages; i++)
	{
		UIImageView *dot = [[UIImageView alloc] initWithFrame:CGRectMake(20 * i, 0, 10, 9)];
		dot.image = i == current ? [UIImage imageNamed:@"PageDotOn.png"] : [UIImage imageNamed:@"PageDotOff.png"];
		[self addSubview:dot];
		[dot release];
	}
}

@end
