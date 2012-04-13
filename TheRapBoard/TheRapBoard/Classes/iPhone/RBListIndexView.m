//
//  RBListIndexView.m
//  TheRapBoard
//
//  Created by Andy Roth on 11/15/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import "RBListIndexView.h"

@interface RBListIndexView ()
{
@private
    UIImageView *_background;
	NSArray *_indexSet;
}
@end

@implementation RBListIndexView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
		_background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IndexBackground.png"]];
		_background.frame = CGRectMake(17, 0, _background.frame.size.width, _background.frame.size.height);
		_background.hidden = YES;
		[self addSubview:_background];
		
		UIImageView *letters = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IndexLetters.png"]];
		letters.frame = CGRectMake(17, 0, _background.frame.size.width, _background.frame.size.height);
		[self addSubview:letters];
		[letters release];
		
		UILongPressGestureRecognizer *reco = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress:)];
		reco.minimumPressDuration = 0;
		[self addGestureRecognizer:reco];
		[reco release];
		
		_indexSet = [[NSArray alloc] initWithObjects:@"#",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    }
    return self;
}

- (void) didLongPress:(UILongPressGestureRecognizer *)reco
{
	if(reco.state == UIGestureRecognizerStateBegan || reco.state == UIGestureRecognizerStateChanged)
	{
		_background.hidden = NO;
		
		CGPoint location = [reco locationInView:self];
		CGFloat percent = location.y / self.frame.size.height;
		int index = roundf(percent * (float)[_indexSet count]);
		index = MAX(MIN([_indexSet count]-1, index), 0);
		NSString *indexString = [_indexSet objectAtIndex:index];
		
		[delegate viewDidSelectIndex:indexString];

	}
	else if(reco.state == UIGestureRecognizerStateEnded || reco.state == UIGestureRecognizerStateCancelled)
	{
		_background.hidden = YES;
		
		CGPoint location = [reco locationInView:self];
		CGFloat percent = location.y / self.frame.size.height;
		int index = roundf(percent * (float)[_indexSet count]);
		index = MAX(MIN([_indexSet count]-1, index), 0);
		NSString *indexString = [_indexSet objectAtIndex:index];
		
		[delegate viewDidSelectIndex:indexString];
	}
}

- (void) dealloc
{
	[_background release];
	
	[super dealloc];
}

@end
