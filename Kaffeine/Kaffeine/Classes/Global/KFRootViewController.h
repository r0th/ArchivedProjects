//
//  KFRootViewController.h
//  Kaffeine
//
//  Created by Andy Roth on 10/17/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KFRootViewController : UIViewController <UITabBarControllerDelegate>

- (void) showLoadingViewWithMessage:(NSString *)message;
- (void) hideLoadingView;

- (void) showImage:(UIImage *)image fullscreenFromFrame:(CGRect)frame;

@end
