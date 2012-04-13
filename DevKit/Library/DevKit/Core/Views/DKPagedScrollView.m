//
//  DKPagedScrollView.m
//  DevKit
//
//  Created by Andy Roth on 4/20/11.
//  Copyright 2011 Roozy. All rights reserved.
//

#import "DKPagedScrollView.h"

@interface DKPagedScrollView (Internal)

- (void) updateContentSize;
- (void) scrollSafelyToCenter;
- (UIView *) createLeftView;
- (UIView *) createCenterView;
- (UIView *) createRightView;

@end


@implementation DKPagedScrollView

@synthesize contentDelegate = _contentDelegate;
@synthesize dataSource = _dataSource;
@synthesize direction = _direction;

#pragma mark - Initialization

- (id) initWithCoder:(NSCoder *)aDecoder
{
	if((self = [super initWithCoder:aDecoder]))
	{
		_leftContainer = [[UIView alloc] initWithFrame:CGRectZero];
		[self addSubview:_leftContainer];
		
		_centerContainer = [[UIView alloc] initWithFrame:CGRectZero];
		[self addSubview:_centerContainer];
		
		_rightContainer = [[UIView alloc] initWithFrame:CGRectZero];
		[self addSubview:_rightContainer];
		
		self.pagingEnabled = YES;
		super.delegate = self;
		self.showsHorizontalScrollIndicator = NO;
		self.showsVerticalScrollIndicator = NO;
		self.clipsToBounds = YES;
		
		_direction = DKPagedScrollViewDirectionHorizontal;
	}
	
	return self;
}

- (id) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(self)
	{
		_leftContainer = [[UIView alloc] initWithFrame:CGRectZero];
		[self addSubview:_leftContainer];
		
		_centerContainer = [[UIView alloc] initWithFrame:CGRectZero];
		[self addSubview:_centerContainer];
		
		_rightContainer = [[UIView alloc] initWithFrame:CGRectZero];
		[self addSubview:_rightContainer];
		
		self.pagingEnabled = YES;
		super.delegate = self;
		self.showsHorizontalScrollIndicator = NO;
		self.showsVerticalScrollIndicator = NO;
		self.clipsToBounds = YES;
		
		_direction = DKPagedScrollViewDirectionHorizontal;
	}
	
	return self;
}

- (void) setDelegate:(id<UIScrollViewDelegate>)delegate {}

- (NSUInteger) currentPageIndex
{
	if((self.contentOffset.x == 0 && _direction == DKPagedScrollViewDirectionHorizontal) || (self.contentOffset.y == 0 && _direction == DKPagedScrollViewDirectionVertical))
	{
		return 0;
	}
	
	return _currentPageIndex;
}

- (void) reloadData
{
	if(_currentPageIndex == 0) _currentPageIndex = 1;
	_totalItems = [_dataSource numberOfItemsInScrollView];
	
	// Remove any previous views
	if(_leftContainerChild)
	{
		[_leftContainerChild removeFromSuperview];
		[_leftContainerChild release];
		_leftContainerChild = nil;
	}
	
	if(_centerContainerChild)
	{
		[_centerContainerChild removeFromSuperview];
		[_centerContainerChild release];
		_centerContainerChild = nil;
	}
	
	if(_rightContainerChild)
	{
		[_rightContainerChild removeFromSuperview];
		[_rightContainerChild release];
		_rightContainerChild = nil;
	}
	
	// Fill the container with appropriate views
	_leftContainerChild = [[self createLeftView] retain];
	[_leftContainer addSubview:_leftContainerChild];
	
	_centerContainerChild = [[self createCenterView] retain];
	[_centerContainer addSubview:_centerContainerChild];
	
	_rightContainerChild = [[self createRightView] retain];
	[_rightContainer addSubview:_rightContainerChild];
	
	CGSize contentViewSize = [_contentDelegate sizeForContentViews];
	
	if(_direction == DKPagedScrollViewDirectionHorizontal)
	{
		_rightContainer.frame = CGRectMake(contentViewSize.width * 2, 0, contentViewSize.width, contentViewSize.height);
		_centerContainer.frame = CGRectMake(contentViewSize.width, 0, contentViewSize.width, contentViewSize.height);
		_leftContainer.frame = CGRectMake(0, 0, contentViewSize.width, contentViewSize.height);
	}
	else
	{
		_rightContainer.frame = CGRectMake(0, contentViewSize.height * 2, contentViewSize.width, contentViewSize.height);
		_centerContainer.frame = CGRectMake(0, contentViewSize.height, contentViewSize.width, contentViewSize.height);
		_leftContainer.frame = CGRectMake(0, 0, contentViewSize.width, contentViewSize.height);
	}
	
	[self updateContentSize];
}

#pragma mark - Scroll View Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	CGSize contentViewSize = [_contentDelegate sizeForContentViews];
	
	if((self.contentOffset.x == 0 && _direction == DKPagedScrollViewDirectionHorizontal) || (self.contentOffset.y == 0 && _direction == DKPagedScrollViewDirectionVertical))
	{		
		// Do nothing if we're all the way to the left
		if(_currentPageIndex == 1)
		{
			if([_contentDelegate respondsToSelector:@selector(pagedScrollView:didScrollToIndex:)])
			{
				[_contentDelegate pagedScrollView:self didScrollToIndex:0];
			}
			
			return;
		}
		
		// Decrement the product offset
		_currentPageIndex -= 1;
		
		// Remove the views
		[_rightContainerChild removeFromSuperview];
		[_centerContainerChild removeFromSuperview];
		[_leftContainerChild removeFromSuperview];
		
		// Dispose of the left view
		[_rightContainerChild release];
		_rightContainerChild = _centerContainerChild;
		_centerContainerChild = _leftContainerChild;
		_leftContainerChild = [[self createLeftView] retain];
		
		[_leftContainer addSubview:_leftContainerChild];
		[_centerContainer addSubview:_centerContainerChild];
		[_rightContainer addSubview:_rightContainerChild];
		
		// Scroll to the center container
		[self scrollSafelyToCenter];
		
		// Update the content size based on which views are available
		[self updateContentSize];
	}
	else if((self.contentOffset.x == contentViewSize.width * 2 && _direction == DKPagedScrollViewDirectionHorizontal) || (self.contentOffset.y == contentViewSize.height * 2 && _direction == DKPagedScrollViewDirectionVertical))
	{		
		// If we're all the way to the right, do nothing
		if(_currentPageIndex + 1 > _totalItems - 1)
		{
			return;
		}
		
		// Increment the product offset
		_currentPageIndex += 1;
		
		// Remove the views
		[_rightContainerChild removeFromSuperview];
		[_centerContainerChild removeFromSuperview];
		[_leftContainerChild removeFromSuperview];
		
		// Dispose of the left view
		[_leftContainerChild release];
		_leftContainerChild = _centerContainerChild;
		_centerContainerChild = _rightContainerChild;
		_rightContainerChild = [[self createRightView] retain];
		
		[_leftContainer addSubview:_leftContainerChild];
		[_centerContainer addSubview:_centerContainerChild];
		[_rightContainer addSubview:_rightContainerChild];
		
		// Scroll to the center container
		[self scrollSafelyToCenter];
		
		// Update the content size based on which views are available
		[self updateContentSize];
	}
	
	if([_contentDelegate respondsToSelector:@selector(pagedScrollView:didScrollToIndex:)])
	{
		[_contentDelegate pagedScrollView:self didScrollToIndex:_currentPageIndex];
	}
}

#pragma mark - Internal Methods

- (void) updateContentSize
{
	CGSize contentViewSize = [_contentDelegate sizeForContentViews];
	
	if(_rightContainerChild)
	{
		if(_direction == DKPagedScrollViewDirectionHorizontal)
		{
			self.contentSize =  CGSizeMake(contentViewSize.width * 3, contentViewSize.height);
		}
		else
		{
			self.contentSize =  CGSizeMake(contentViewSize.width, contentViewSize.height * 3);
		}
	}
	else if(_centerContainerChild)
	{
		if(_direction == DKPagedScrollViewDirectionHorizontal)
		{
			self.contentSize =  CGSizeMake(contentViewSize.width * 2, contentViewSize.height);
		}
		else
		{
			self.contentSize =  CGSizeMake(contentViewSize.width, contentViewSize.height * 2);
		}
	}
	else
	{
		self.contentSize =  CGSizeMake(contentViewSize.width, contentViewSize.height);
	}
}

- (void) scrollSafelyToCenter
{
	[self scrollRectToVisible:_centerContainer.frame animated:NO];
}

- (UIView *) createLeftView
{
	int leftIndex = _currentPageIndex - 1;
	
	if(leftIndex >= 0 && _totalItems > 0)
	{
		return [_contentDelegate contentViewForIndex:leftIndex];
	}
	
	return nil;
}

- (UIView *) createCenterView
{
	if(_currentPageIndex < _totalItems)
	{
		return [_contentDelegate contentViewForIndex:_currentPageIndex];
	}
	
	return nil;
}

- (UIView *) createRightView
{
	int rightIndex = _currentPageIndex + 1;
	
	if(rightIndex < _totalItems) // TODO: Remove -1 to show rightmost image
	{
		return [_contentDelegate contentViewForIndex:rightIndex];
	}
	
	return nil;
}

#pragma mark - Cleanup

- (void) dealloc
{
	[_leftContainerChild release];
	[_centerContainerChild release];
	[_rightContainerChild release];
	
	[_leftContainer release];
	[_centerContainer release];
	[_rightContainer release];
	
	[super dealloc];
}

@end
