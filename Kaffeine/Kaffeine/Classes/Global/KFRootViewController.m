//
//  KFRootViewController.m
//  Kaffeine
//
//  Created by Andy Roth on 10/17/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import "KFRootViewController.h"
#import "KFCatalogViewController.h"
#import "KFTermsViewController.h"
#import "KFAppModel.h"
#import "KFPhotoDetailViewController.h"
#import "KFLibraryViewController.h"
#import "UIFont+Custom.h"
#import "KFFullscreenView.h"
#import "KFTabBarController.h"

@interface KFRootViewController ()
{
@private
    KFTabBarController *_tabBarController;
	
	UIView *_loadingView;
	UILabel *_loadingLabel;
    BOOL _loadingViewForcedOpen;
    
    KFFullscreenView *_fullscreenView;
    CGRect _returningFrame;
}

@end

@implementation KFRootViewController

- (void) viewDidLoad
{
    UIImageView *backgroundTexture = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundTexture.png"]];
    [self.view addSubview:backgroundTexture];
	
	_tabBarController = [[KFTabBarController alloc] init];
	_tabBarController.view.frame = self.view.bounds;
	[self.view addSubview:_tabBarController.view];
	
	_loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
	_loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
	_loadingView.alpha = 0;
	
	UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	activityIndicator.center = CGPointMake(_loadingView.frame.size.width/2, _loadingView.frame.size.height/2);
	activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	[activityIndicator startAnimating];
	[_loadingView addSubview:activityIndicator];
	[activityIndicator release];
	
	_loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, activityIndicator.frame.origin.y + 30, 320, 20)];
	_loadingLabel.backgroundColor = [UIColor clearColor];
	_loadingLabel.textColor = [UIColor whiteColor];
	_loadingLabel.font = [UIFont boldSystemFontOfSize:12.0];
	_loadingLabel.textAlignment = UITextAlignmentCenter;
	_loadingLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	[_loadingView addSubview:_loadingLabel];
}

- (void) showLoadingViewWithMessage:(NSString *)message
{
	_loadingLabel.text = message;
	if(!_loadingView.superview) [self.view addSubview:_loadingView];
	
	[UIView animateWithDuration:0.5 animations:^{
		_loadingView.alpha = 1.0;
	}];
}

- (void) hideLoadingView
{
    if (_loadingViewForcedOpen) return;
    
	[UIView animateWithDuration:0.5 animations:^{
		_loadingView.alpha = 0.0;
	} completion:^(BOOL finished){
		[_loadingView removeFromSuperview];
	}];
}

- (void)showLoadingViewWithMessage:(NSString *)message forced:(BOOL)forced
{
    _loadingViewForcedOpen = forced;
    [self showLoadingViewWithMessage:message];
}

- (void)hideLoadingViewForcedOpen
{
    _loadingViewForcedOpen = NO;
    [self hideLoadingView];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
	[viewController viewDidAppear:NO];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void) viewWillLayoutSubviews
{
	_loadingView.frame = self.view.bounds;
}

#pragma mark - Fullscreen

- (void) showImage:(UIImage *)image fullscreenFromFrame:(CGRect)frame
{
    self.view.userInteractionEnabled = NO;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    // First just animate an image view
    _returningFrame = CGRectMake(frame.origin.x, frame.origin.y + 44, frame.size.width, frame.size.height);
    CGRect finalFrame = CGRectMake(0, -20, 320, 480);
    
    _fullscreenView = [[KFFullscreenView alloc] initWithFrame:finalFrame];
    _fullscreenView.image = image;
    _fullscreenView.alpha = 0;
    _fullscreenView.frame = _returningFrame;
    _fullscreenView.clipsToBounds = YES;
    [self.view addSubview:_fullscreenView];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeFullscreen)];
    [_fullscreenView addGestureRecognizer:tapRecognizer];
    [tapRecognizer release];
    
    [UIView animateWithDuration:0.3 animations:^
    {
        _fullscreenView.frame = CGRectMake(0, -20, 320, 480);
        _fullscreenView.alpha = 1.0;
    }
                     completion:^(BOOL finished)
    {
        self.view.userInteractionEnabled = YES;
    }];
}

- (void)closeFullscreen
{
    self.view.userInteractionEnabled = NO;
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    [UIView animateWithDuration:0.3 animations:^
     {
         _fullscreenView.frame = _returningFrame;
         _fullscreenView.alpha = 0;
     }
                     completion:^(BOOL finished)
     {         
         [_fullscreenView removeFromSuperview];
         [_fullscreenView release];
         _fullscreenView = nil;
         
         self.view.userInteractionEnabled = YES;
     }];
}

- (void)didBecomeActive
{
    [_tabBarController reloadCategories];
}

- (void) dealloc
{
    [_tabBarController release];
	
	[_loadingView release];
	[_loadingLabel release];
    [_fullscreenView release];
	
	[super dealloc];
}

@end
