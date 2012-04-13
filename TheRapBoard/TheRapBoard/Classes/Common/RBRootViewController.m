//
//  RBViewController.m
//  TheRapBoard
//
//  Created by Andy Roth on 11/11/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import "RBRootViewController.h"
#import "RBPhoneContentViewController.h"
#import "RBPadContentViewController.h"

@interface RBRootViewController ()
{
@private
	UIViewController *_contentViewController;
}

@end

@implementation RBRootViewController

- (void) viewDidLoad
{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
	{
	    _contentViewController = [[RBPhoneContentViewController alloc] init];
		_contentViewController.view.frame = self.view.bounds;
		[self.view addSubview:_contentViewController.view];
	}
	else
	{
	    _contentViewController = [[RBPadContentViewController alloc] init];
		_contentViewController.view.frame = self.view.bounds;
		[self.view addSubview:_contentViewController.view];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
	{
	    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
	}
	else
	{
	    return YES;
	}
}

- (void) dealloc
{
	[_contentViewController release];
	
	[super dealloc];
}

@end
