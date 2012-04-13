/**
 * DevKit
 *
 * Created by Andy Roth.
 * Copyright 2009 Roozy. All rights reserved.
 */

#import <Foundation/Foundation.h>

@class DKDraggableView;

@protocol DKDraggableViewDelegate <NSObject>

- (void) dragDidEnd:(DKDraggableView *)draggableView;

@end

@interface DKDraggableView : UIView
{
	id <DKDraggableViewDelegate> delegate;
	
@private
	CGPoint _offsetPoint;
}

@property (nonatomic, assign) id <DKDraggableViewDelegate> delegate;

@end