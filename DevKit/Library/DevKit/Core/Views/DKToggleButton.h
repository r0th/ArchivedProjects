/**
 * DevKit
 *
 * Created by Andy Roth.
 * Copyright 2009 Roozy. All rights reserved.
 */

#import <Foundation/Foundation.h>

@class DKToggleButtonGroup;
@class DKToggleButton;

@protocol DKToggleButtonDelegate

- (void) button:(DKToggleButton *)button didChangeState:(BOOL)isOn;

@end


@interface DKToggleButton : UIButton
{
	BOOL enableClick;
	DKToggleButtonGroup *group;
	
	id <DKToggleButtonDelegate> delegate;
	
@private
	BOOL _on;
	UIImage *_onImage;
	UIImage *_offImage;
}

@property (nonatomic, assign) id <DKToggleButtonDelegate> delegate;

@property (nonatomic, assign) DKToggleButtonGroup *group;
@property (nonatomic) BOOL enableClick;
@property (nonatomic) BOOL on;

- (id) initWithImages:(UIImage *)onImage offImage:(UIImage *)offImage;
- (void) setImages:(UIImage *)onImage offImage:(UIImage *)offImage;

@end
