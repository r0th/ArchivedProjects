//
//  UIApplication+Mirroring.m
//  DevKit
//
//  Created by Andy Roth on 3/23/11.
//  Copyright 2011 Roozy. All rights reserved.
//

#import "NSObject+ExternalScreen.h"
#import <QuartzCore/QuartzCore.h>

#pragma mark - View Category

@interface UIView (ScreenCapture)

- (UIImage *) viewAsImage;

@end

@implementation UIView (ScreenCapture)

- (UIImage *) viewAsImage
{
	UIGraphicsBeginImageContext(self.bounds.size);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return viewImage;
}

@end

#pragma mark - Singleton Manager

@interface RIApplicationMirroringManager : NSObject
{
	CADisplayLink *displayLink;
	
	UIWindow *externalWindow;
	UIImageView *externalImageView;
	
	UIImage *currentImage;
	
	BOOL mirroring;
}

+ (RIApplicationMirroringManager *) sharedManager;

- (void) start;
- (void) stop;

- (void) startMirroringScreen:(UIScreen *)screen;
- (void) stopMirroringScreen;

- (void) setupForManualUpdates;
- (void) mirrorOnExternalScreen;
- (void) displayImageOnExternalScreen:(UIImage *)image;

@end

@implementation RIApplicationMirroringManager

static RIApplicationMirroringManager *instance;

+ (RIApplicationMirroringManager *) sharedManager
{
	if(!instance)
	{
		instance = [[RIApplicationMirroringManager alloc] init];
	}
	
	return instance;
}

- (void) start
{
	if(!mirroring)
	{
		mirroring = YES;
		
		// Register for screen notifications
		NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
		[center addObserver:self selector:@selector(screenDidConnect:) name:UIScreenDidConnectNotification object:nil];
		[center addObserver:self selector:@selector(screenDidDisconnect:) name:UIScreenDidDisconnectNotification object:nil];
		[center addObserver:self selector:@selector(screenModeDidChange:) name:UIScreenModeDidChangeNotification object:nil];
		
		// Setup screen mirroring for an existing screen
		NSArray *connectedScreens = [UIScreen screens];
		if ([connectedScreens count] > 1)
		{
			UIScreen *mainScreen = [UIScreen mainScreen];
			for (UIScreen *screen in connectedScreens)
			{
				if (screen != mainScreen)
				{
					// Start mirroring if an external screen is already connected
					[self startMirroringScreen:screen];
					break;
				}
			}
		}
	}
}

- (void) stop
{
	if(mirroring)
	{
		mirroring = NO;
		
		// Unregister from screen notifications
		NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
		[center removeObserver:self name:UIScreenDidConnectNotification object:nil];
		[center removeObserver:self name:UIScreenDidDisconnectNotification object:nil];
		[center removeObserver:self name:UIScreenModeDidChangeNotification object:nil];
		
		[self stopMirroringScreen];
	}
}

- (void) screenDidConnect:(NSNotification *)aNotification
{
	[self startMirroringScreen:[aNotification object]];
}

- (void) screenDidDisconnect:(NSNotification *)aNotification
{
	[self stopMirroringScreen];
}

- (void) screenModeDidChange:(NSNotification *)aNotification
{
	
}

- (void) startMirroringScreen:(UIScreen *)screen
{
	// Create the external window with an image view
	externalWindow = [[UIWindow alloc] initWithFrame:screen.bounds];
	externalWindow.screen = screen;
	externalWindow.backgroundColor = [UIColor blackColor];
	externalWindow.hidden = NO;
	
	externalImageView = [[UIImageView alloc] initWithFrame:externalWindow.frame];
	externalImageView.contentMode = UIViewContentModeScaleAspectFit;
	[externalWindow addSubview:externalImageView];
	
	// Start the timer
	displayLink = [[CADisplayLink displayLinkWithTarget:self selector:@selector(onTimer)] retain];
	[displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void) stopMirroringScreen
{
	// Stop the timer
	[displayLink invalidate];
	[displayLink release];
	displayLink = nil;
	
	// Release the views
	[externalImageView release];
	[externalWindow release];
	externalImageView = nil;
	externalWindow = nil;
}

- (void) setupForManualUpdates
{
	if(!mirroring)
	{
		mirroring = YES;
		
		// Register for screen notifications
		NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
		[center addObserver:self selector:@selector(screenDidConnect:) name:UIScreenDidConnectNotification object:nil];
		[center addObserver:self selector:@selector(screenDidDisconnect:) name:UIScreenDidDisconnectNotification object:nil];
		[center addObserver:self selector:@selector(screenModeDidChange:) name:UIScreenModeDidChangeNotification object:nil];
		
		// Setup screen mirroring for an existing screen
		NSArray *connectedScreens = [UIScreen screens];
		if ([connectedScreens count] > 1)
		{
			UIScreen *mainScreen = [UIScreen mainScreen];
			for (UIScreen *screen in connectedScreens)
			{
				if (screen != mainScreen)
				{
					// Create the external window with an image view
					externalWindow = [[UIWindow alloc] initWithFrame:screen.bounds];
					externalWindow.screen = screen;
					externalWindow.backgroundColor = [UIColor blackColor];
					externalWindow.hidden = NO;
					
					externalImageView = [[UIImageView alloc] initWithFrame:externalWindow.frame];
					externalImageView.contentMode = UIViewContentModeScaleAspectFit;
					[externalWindow addSubview:externalImageView];
					
					// Start mirroring if an external screen is already connected
					[self displayImageOnExternalScreen:currentImage];
					break;
				}
			}
		}
	}
}

- (void) screenDidConnectManual:(NSNotification *)aNotification
{
	UIScreen *screen = (UIScreen *)aNotification.object;
	
	// Create the external window with an image view
	externalWindow = [[UIWindow alloc] initWithFrame:screen.bounds];
	externalWindow.screen = screen;
	externalWindow.backgroundColor = [UIColor blackColor];
	externalWindow.hidden = NO;
	
	externalImageView = [[UIImageView alloc] initWithFrame:externalWindow.frame];
	externalImageView.contentMode = UIViewContentModeScaleAspectFit;
	[externalWindow addSubview:externalImageView];
	
	[self displayImageOnExternalScreen:currentImage];
}

- (void) screenDidDisconnectManual:(NSNotification *)aNotification
{
	[self stopMirroringScreen];
}

- (void) screenModeDidChangeManual:(NSNotification *)aNotification
{
	
}

- (void) mirrorOnExternalScreen
{
	[self setupForManualUpdates];
	
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	if(!window) window = [[UIApplication sharedApplication].windows objectAtIndex:0];
	
	UIImage *image = [window viewAsImage];
	[self displayImageOnExternalScreen:image];
	
	if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft)
	{
		externalImageView.transform = CGAffineTransformMakeRotation(1.57079633);
	}
	else if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
	{
		externalImageView.transform = CGAffineTransformMakeRotation(-1.57079633);
	}
	else if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)
	{
		externalImageView.transform = CGAffineTransformMakeRotation(3.14159265);
	}
	else
	{
		externalImageView.transform = CGAffineTransformMakeRotation(0);
	}
}

- (void) displayImageOnExternalScreen:(UIImage *)image
{
	[self setupForManualUpdates];
	
	currentImage = image;
	externalImageView.image = image;
}

- (void) onTimer
{
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	if(!window) window = [[UIApplication sharedApplication].windows objectAtIndex:0];
	
	UIImage *image = [window viewAsImage];
	
	externalImageView.image = image;
	
	if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft)
	{
		externalImageView.transform = CGAffineTransformMakeRotation(1.57079633);
	}
	else if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)
	{
		externalImageView.transform = CGAffineTransformMakeRotation(-1.57079633);
	}
	else if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)
	{
		externalImageView.transform = CGAffineTransformMakeRotation(3.14159265);
	}
	else
	{
		externalImageView.transform = CGAffineTransformMakeRotation(0);
	}
}

@end

#pragma mark - Application Category

@implementation NSObject (ExternalScreen)

- (void) beginScreenMirroring
{
	[[RIApplicationMirroringManager sharedManager] start];
}

- (void) endScreenMirroring
{
	[[RIApplicationMirroringManager sharedManager] stop];
}

- (void) mirrorOnExternalScreen
{
	[[RIApplicationMirroringManager sharedManager] mirrorOnExternalScreen];
}

- (void) displayImageOnExternalScreen:(UIImage *)image
{
	[[RIApplicationMirroringManager sharedManager] displayImageOnExternalScreen:image];
}

@end
