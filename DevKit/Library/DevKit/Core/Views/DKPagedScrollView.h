//
//  DKPagedScrollView.h
//  DevKit
//
//  Created by Andy Roth on 4/20/11.
//  Copyright 2011 Roozy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DKPagedScrollView;

@protocol DKPagedScrollViewContentDelegate <NSObject>

- (UIView *) contentViewForIndex:(NSUInteger)index; // Returns an autoreleased view that should be displayed for a certain index of the datasource.
- (CGSize) sizeForContentViews; // Controls the width/height for paging. Should be the size of every content view.

@optional

- (void) pagedScrollView:(DKPagedScrollView *)scrollView didScrollToIndex:(NSUInteger)index;

@end

@protocol DKPagedScrollViewDataSource <NSObject>

- (NSUInteger) numberOfItemsInScrollView;

@end

typedef enum
{
	DKPagedScrollViewDirectionHorizontal,
	DKPagedScrollViewDirectionVertical
} DKPagedScrollViewDirection;

@interface DKPagedScrollView : UIScrollView <UIScrollViewDelegate>
{
    @private
	
	UIView *_leftContainer;
	UIView *_centerContainer;
	UIView *_rightContainer;
	
	UIView *_leftContainerChild;
	UIView *_centerContainerChild;
	UIView *_rightContainerChild;
	
	int _currentPageIndex;
	int _totalItems;
}

@property (nonatomic, assign) id <DKPagedScrollViewContentDelegate> contentDelegate;
@property (nonatomic, assign) id <DKPagedScrollViewDataSource> dataSource;

@property (nonatomic) DKPagedScrollViewDirection direction; // Defaults to DKPagedScrollViewDirectionHorizontal

@property (nonatomic, readonly) NSUInteger currentPageIndex;

- (void) reloadData;

@end
