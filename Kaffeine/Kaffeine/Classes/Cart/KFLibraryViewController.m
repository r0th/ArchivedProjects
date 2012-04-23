//
//  KFCartViewController.m
//  Kaffeine
//
//  Created by Andy Roth on 10/17/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import "KFLibraryViewController.h"
#import "KFAppModel.h"
#import "KFPhoto.h"
#import "UIFont+Custom.h"
#import "KFLibraryTableViewCell.h"
#import "NSObject+GlobalViews.h"
#import "KFStoreManager.h"

@interface KFLibraryViewController ()
{
@private
    NSArray *_library;
	
	UILabel *_noItemsLabel;
}
@end

@implementation KFLibraryViewController

- (void) viewDidLoad
{
	self.view.frame = CGRectMake(0, 0, 320, 364);
	
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	self.view.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Icon-Back.png"] style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    [backButton release];
	
	UIBarButtonItem *restoreButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Icon-Cart.png"] style:UIBarButtonItemStylePlain target:self action:@selector(restorePurchases)];
	self.navigationItem.rightBarButtonItem = restoreButton;
	[restoreButton release];
	
	_noItemsLabel = [[UILabel alloc] init];
	_noItemsLabel.font = [UIFont boldSystemFontOfSize:12.0];
	_noItemsLabel.textColor = [UIColor whiteColor];
	_noItemsLabel.backgroundColor = [UIColor clearColor];
	_noItemsLabel.text = @"There are no items in your library";
	[_noItemsLabel sizeToFit];
	_noItemsLabel.center = CGPointMake(roundf(self.view.frame.size.width/2), roundf(self.view.frame.size.height/2));
	_noItemsLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	_noItemsLabel.hidden = YES;
	[self.view addSubview:_noItemsLabel];
}

- (void) viewDidAppear:(BOOL)animated
{
	_library = [KFAppModel sharedModel].purchasedPhotos;
	
	// Show or hide no items message
	if([_library count] == 0)
	{
		_noItemsLabel.hidden = NO;
	}
	else
	{
		_noItemsLabel.hidden = YES;
	}
	
	[self.tableView reloadData];
}

- (void) restorePurchases
{
	[[KFStoreManager sharedManager] restorePreviousPurchasesFromAppleWithHandler:^{
		[self.tableView reloadData];
	}];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_library count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    KFLibraryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
	{
        cell = [[[KFLibraryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

	cell.backgroundColor = [UIColor clearColor];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	KFPhoto *photo = [_library objectAtIndex:indexPath.row];
	cell.photo = photo;
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60.0;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Nothing
}
	   
#pragma mark - Cleanup

- (void) dealloc
{
	[_noItemsLabel release];
	
	[super dealloc];
}

@end
