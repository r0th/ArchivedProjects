//
//  UIApplication+Mirroring.h
//  DevKit
//
//  Created by Andy Roth on 3/23/11.
//  Copyright 2011 Roozy. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (ExternalScreen)

// These methods work with a CADisplayLink to constantly update the external screen
- (void) beginScreenMirroring;
- (void) endScreenMirroring;

// These methods can be used manually to add content to the external screen
- (void) mirrorOnExternalScreen;
- (void) displayImageOnExternalScreen:(UIImage *)image;

@end
