//
//  NSObject+GlobalViews.m
//  Kaffeine
//
//  Created by Andy Roth on 10/18/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import "NSObject+GlobalViews.h"
#import "KFRootViewController.h"
#import "KFAppModel.h"
#import "KFAppDelegate.h"

@implementation NSObject (GlobalViews)

- (KFRootViewController *) rootViewController
{
	KFAppDelegate *delegate = (KFAppDelegate *)[UIApplication sharedApplication].delegate;
	
	return (KFRootViewController *)delegate.window.rootViewController;
}

- (void) showLoadingViewWithMessage:(NSString *)message
{
	KFRootViewController *root = [self rootViewController];
	[root showLoadingViewWithMessage:message];
}

- (void) hideLoadingView
{
	KFRootViewController *root = [self rootViewController];
	[root hideLoadingView];
}

- (void) showImage:(UIImage *)image fullscreenFromFrame:(CGRect)frame
{
    KFRootViewController *root = [self rootViewController];
	[root showImage:image fullscreenFromFrame:frame];
}

@end
