//
//  RBPadContentViewController.m
//  TheRapBoard
//
//  Created by Andy Roth on 11/11/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import "RBPadContentViewController.h"
#import "RBRapperAdlib.h"
#import "RBRapperButton.h"

@interface RBPadContentViewController ()
{
@private
    
}

- (CGRect) frameForButtonAtIndex:(int)index;

@end

@implementation RBPadContentViewController

static CGFloat buttonWidth = 116;
static CGFloat buttonHeight = 138;

- (void) viewDidLoad
{
	NSArray *adlibs = [RBRapper allAdlibs];
	int index = 0;
	float maxHeight = 0.0;
	
	_scrollView.delaysContentTouches = NO;
	
	for(RBRapperAdlib *adlib in adlibs)
	{
		RBRapperButton *button = [[RBRapperButton alloc] initWithFrame:[self frameForButtonAtIndex:index]];
		[button setAdlib:adlib];
		[_scrollView addSubview:button];
		
		maxHeight = MAX(maxHeight, button.frame.origin.y + button.frame.size.height);
		index++;
	}
	
	_scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, maxHeight + 20);
}

- (CGRect) frameForButtonAtIndex:(int)index
{
	int numColumns = floorf(_scrollView.frame.size.width / buttonWidth);
	int row = floorf(index / numColumns);
	int column = index - (row * numColumns);
	
	float xPadding = (_scrollView.frame.size.width - (numColumns * buttonWidth)) / 2;
	float yPadding = 30.0;
	
	return CGRectMake((buttonWidth * column) + xPadding, (buttonHeight * row) + yPadding, buttonWidth, buttonHeight);
}

- (void) viewWillLayoutSubviews
{
	__block float maxHeight = 0.0;
	
	[UIView animateWithDuration:0.5 animations:^{
		
		int index = 0;
		for(UIView *view in _scrollView.subviews)
		{
			if([view isKindOfClass:[RBRapperButton class]])
			{
				view.frame = [self frameForButtonAtIndex:index];
				index++;
				
				maxHeight = MAX(maxHeight, view.frame.origin.y + view.frame.size.height);
			}
		}
	}];
	
	_scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, maxHeight + 20);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
