//
//  KFCatalogViewController.m
//  Kaffeine
//
//  Created by Andy Roth on 10/17/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import "KFCatalogViewController.h"
#import "NSObject+GlobalViews.h"
#import "KFAppModel.h"
#import "KFCategory.h"
#import "UIFont+Custom.h"
#import "KFPhotoGridViewController.h"
#import "KFStoreManager.h"
#import "KFInfoViewController.h"
#import "KFAppDelegate.h"
#import "KFRootViewController.h"

@interface KFCatalogViewController ()
{
@private
    NSArray *_categories;
    UIScrollView *_scrollView;
    BOOL _loading;
}

- (void) refreshData;

@end

@implementation KFCatalogViewController

- (void) viewDidLoad
{
    self.view.backgroundColor = [UIColor clearColor];
    
    BOOL hasSeenInfo = [[NSUserDefaults standardUserDefaults] boolForKey:@"hasSeenInfo"];
    if (!hasSeenInfo)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasSeenInfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self showInfo];
    }
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Icon-Back.png"] style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    [backButton release];
    
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Icon-Info.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showInfo)];
    self.navigationItem.leftBarButtonItem = infoButton;
    [infoButton release];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
	_scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:_scrollView];
	
	if(!_categories && !_loading)
	{
        _loading = YES;
        
		[self showLoadingViewWithMessage:@"Loading categories" forced:YES];
		
		KFAppModel *model = [KFAppModel sharedModel];
		[model getCategoriesWithHandler:^(NSArray *results){
			
            _loading = NO;
            
			[self hideLoadingViewForcedOpen];
			[[KFStoreManager sharedManager] restorePreviousPurchases];
			
			_categories = [results retain];
            [self refreshData];
		}];
	}
}

- (void)tryReload
{
    if (_categories.count == 0 && !_loading)
    {
        [self showLoadingViewWithMessage:@"Loading categories" forced:YES];
		
		KFAppModel *model = [KFAppModel sharedModel];
		[model getCategoriesWithHandler:^(NSArray *results){
			
			[self hideLoadingViewForcedOpen];
			[[KFStoreManager sharedManager] restorePreviousPurchases];
			
			_categories = [results retain];
            [self refreshData];
		}];
    }
}

- (void)showInfo
{
    KFAppDelegate *delegate = (KFAppDelegate *)[UIApplication sharedApplication].delegate;
	KFRootViewController *root = (KFRootViewController *)delegate.window.rootViewController;
    
    KFInfoViewController *info = [[KFInfoViewController alloc] init];
    [root presentModalViewController:info animated:YES];
    [info release];
}

#pragma mark - Grid View

- (void) refreshData
{
	CGFloat startX = 38;
	CGFloat xOffset = startX;
	CGFloat yOffset = 10;
	
	CGFloat buttonWidth = 102;
	CGFloat buttonHeight = 100;
	CGFloat xPadding = 38;
    CGFloat yPadding = 15;
    
    int index = 0;
	
	for(KFCategory *category in _categories)
	{
		UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(xOffset, yOffset, buttonWidth, buttonHeight)];
        NSString *imageName = [NSString stringWithFormat:@"Category-%@.png", [category.categoryID capitalizedString]];
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        button.tag = index;
		[button addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, buttonHeight - 10, buttonWidth, 30)];
        categoryLabel.backgroundColor = [UIColor clearColor];
        categoryLabel.text = category.name;
        categoryLabel.font = [UIFont systemFontOfSize:12.0];
        categoryLabel.textColor = [UIColor whiteColor];
        categoryLabel.textAlignment = UITextAlignmentCenter;
        [button addSubview:categoryLabel];
        [categoryLabel release];
        
		[_scrollView addSubview:button];
		[button release];
		
		if(xOffset == startX + ((xPadding + buttonWidth)))
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

#pragma mark - Table view delegate

- (void)tappedButton:(UIButton *)button
{
	KFCategory *category = [_categories objectAtIndex:button.tag];
	KFPhotoGridViewController *photoGrid = [[KFPhotoGridViewController alloc] initWithCategory:category];
	[self.navigationController pushViewController:photoGrid animated:YES];
	[photoGrid release];
}

#pragma mark - Cleanup

- (void) dealloc
{
	[_categories release];
	
	[super dealloc];
}

@end
