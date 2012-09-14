//
//  NSObject+GlobalViews.h
//  Kaffeine
//
//  Created by Andy Roth on 10/18/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KFPhoto.h"

@interface NSObject (GlobalViews)

- (void) showLoadingViewWithMessage:(NSString *)message;
- (void) hideLoadingView;

- (void)showLoadingViewWithMessage:(NSString *)message forced:(BOOL)forced;
- (void)hideLoadingViewForcedOpen;

- (void) showImage:(UIImage *)image fullscreenFromFrame:(CGRect)frame;

@end
