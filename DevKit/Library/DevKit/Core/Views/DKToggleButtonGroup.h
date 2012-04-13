/**
 * DevKit
 *
 * Created by Andy Roth.
 * Copyright 2009 Roozy. All rights reserved.
 */

#import <Foundation/Foundation.h>

@class DKToggleButton;

@interface DKToggleButtonGroup : NSObject
{
@private
	NSMutableArray *_buttons;
}

@property (nonatomic, readonly) DKToggleButton *selectedButton;
@property (nonatomic, readonly) int selectedButtonIndex;

- (id) initWithButtons:(NSArray *)buttons;
- (void) addButton:(DKToggleButton *)newButton;
- (void) didClickButton:(DKToggleButton *)button;

@end
