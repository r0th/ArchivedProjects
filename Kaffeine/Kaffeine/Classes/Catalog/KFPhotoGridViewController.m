//
//  KFPhotoGridViewController.m
//  Kaffeine
//
//  Created by Andy Roth on 10/18/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import "KFPhotoGridViewController.h"
#import "NSObject+GlobalViews.h"
#import "KFPhotoGridButton.h"
#import "UIFont+Custom.h"

@interface KFPhotoGridViewController ()
{
@private
    KFCategory *_category;
	NSArray *_photos;
	UIScrollView *_scrollView;
}

- (void) refreshData;

@end

@implementation KFPhotoGridViewController

#pragma mark - Initialization

- (id) initWithCategory:(KFCategory *)category
{
	self = [super init];
	if(self)
	{
		_category = [category retain];
		_photos = nil;
	}
	
	return self;
}

- (void) viewDidLoad
{
	self.view.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Icon-Back.png"] style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    [backButton release];
	
	_scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
	_scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:_scrollView];
	
	if(!_photos)
	{		
		[_category getPhotosWithHandler:^(NSArray *results){
			_photos = [results retain];
			[self refreshData];
		}];
	}
}

- (void) refreshData
{
	CGFloat startX = 4;
	CGFloat xOffset = startX;
	CGFloat yOffset = 4;
	
	CGFloat buttonWidth = 75;
	CGFloat buttonHeight = 96;
	CGFloat xPadding = 4;
    CGFloat yPadding = 4;
    
    int index = 0;
	
	for(KFPhoto *photo in _photos)
	{
		KFPhotoGridButton *button = [[KFPhotoGridButton alloc] initWithFrame:CGRectMake(xOffset, yOffset, buttonWidth, buttonHeight) photo:photo];
		[button addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = index;
		[_scrollView addSubview:button];
		[button release];
		
		if(xOffset == startX + ((xPadding + buttonWidth) * 3))
		{
			xOffset = startX;
			yOffset += buttonHeight + yPadding;
		}
		else
		{
			xOffset += buttonWidth + xPadding;
		}
        
        index++;
	}
	
	if(xOffset != startX) yOffset += buttonHeight + yPadding;
	
	_scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, yOffset);
}

#pragma mark - Button Actions

- (void) tappedButton:(UIButton *)button
{
	KFPhoto *photo = [_photos objectAtIndex:button.superview.tag];
	
	KFPhotoDetailContainerViewController *detail = [[KFPhotoDetailContainerViewController alloc] initWithPhoto:photo];
    detail.delegate = self;
	[self.navigationController pushViewController:detail animated:YES];
	[detail release];
}

- (void) viewWillLayoutSubviews
{
	CGFloat startX = 4;
	CGFloat xOffset = startX;
	CGFloat yOffset = 4;
	
	CGFloat buttonWidth = 75;
	CGFloat buttonHeight = 96;
	CGFloat xPadding = 4;
    CGFloat yPadding = 4;
	
	for(UIView *view in _scrollView.subviews)
	{
		if([view isKindOfClass:[KFPhotoGridButton class]])
		{
			view.frame = CGRectMake(xOffset, yOffset, buttonWidth, buttonHeight);
			
			if(xOffset == startX + ((xPadding + buttonWidth) * 3))
            {
                xOffset = startX;
                yOffset += buttonHeight + yPadding;
            }
            else
            {
                xOffset += buttonWidth + xPadding;
            }
		}
	}
	
	if(xOffset != startX) yOffset += buttonHeight + yPadding;
	
	_scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, yOffset);
}

#pragma mark - Container Delegate

- (KFPhoto *)photoNextFromPhoto:(KFPhoto *)photo
{
    int photoIndex = [_photos indexOfObject:photo];
    if (photoIndex == _photos.count - 1) return nil;
    
    return [_photos objectAtIndex:photoIndex + 1];
}

- (KFPhoto *)photoPreviousToPhoto:(KFPhoto *)photo
{
    int photoIndex = [_photos indexOfObject:photo];
    if (photoIndex == 0) return nil;
    
    return [_photos objectAtIndex:photoIndex - 1];
}

#pragma mark - Cleanup

- (void) dealloc
{
	[_category release];
	[_photos release];
	[_scrollView release];
	
	[super dealloc];
}

@end
