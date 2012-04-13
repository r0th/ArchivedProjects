//
//  RBPhoneContentViewController.m
//  TheRapBoard
//
//  Created by Andy Roth on 11/11/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import "RBPhoneContentViewController.h"
#import "RBRapper.h"
#import "RBPhoneGridViewController.h"
#import "RBPhoneListViewController.h"

@interface RBPhoneContentViewController ()
{
@private
    RBViewMode _viewMode;
	UIViewController *_contentViewController;
}

- (void) updateView;

@end

@implementation RBPhoneContentViewController

#pragma mark - Initialization

- (void) viewDidLoad
{
	_viewMode = RBViewModeGrid;
	
	/*
	UIImageView *defaultImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];
	[self.view addSubview:defaultImage];
	
	[UIView animateWithDuration:0.5 animations:^{
		defaultImage.alpha = 0;
	} completion:^(BOOL finished) {
		[defaultImage removeFromSuperview];
		[defaultImage release];
	}];
	 */
	
	[self updateView];
}

#pragma mark - Views

- (void) updateView
{
	if(_contentViewController)
	{
		[_contentViewController.view removeFromSuperview];
		[_contentViewController release];
		_contentViewController = nil;
	}
	
	if(_viewMode == RBViewModeGrid)
	{
		_contentViewController = [[RBPhoneGridViewController alloc] init];
		_contentViewController.view.frame = _contentViewContainer.bounds;
		[_contentViewContainer addSubview:_contentViewController.view];
	}
	else
	{
		_contentViewController = [[RBPhoneListViewController alloc] init];
		_contentViewController.view.frame = _contentViewContainer.bounds;
		[_contentViewContainer addSubview:_contentViewController.view];
	}
}

#pragma mark - Button Actions

- (IBAction) toggleViewMode:(id)sender
{
	if(sender == _gridButton)
	{
		_viewMode = RBViewModeGrid;
		_gridButton.selected = YES;
		_listButton.selected = NO;
	}
	else
	{
		_viewMode = RBViewModeList;
		_gridButton.selected = NO;
		_listButton.selected = YES;
	}
	
	if((_viewMode == RBViewModeGrid && ![_contentViewController isKindOfClass:[RBPhoneGridViewController class]]) || (_viewMode == RBViewModeList && ![_contentViewController isKindOfClass:[RBPhoneListViewController class]]))
	{
		[self updateView];
	}
}

#pragma mark - Cleanup

- (void) dealloc
{
	[_contentViewController release];
	
	[super dealloc];
}

@end
