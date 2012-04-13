//
//  RBPhoneGridViewController.m
//  TheRapBoard
//
//  Created by Andy Roth on 11/11/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import "RBPhoneGridViewController.h"
#import "RBRapper.h"
#import "RBPhoneGridViewCell.h"

@interface RBPhoneGridViewController ()
{
@private
    NSArray *_allAdlibs;
}
@end

@implementation RBPhoneGridViewController

#pragma mark - Initialization

- (void) viewDidLoad
{
	_allAdlibs = [[RBRapper allAdlibs] retain];
	
	self.tableView.backgroundColor = [UIColor clearColor];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.tableView.delaysContentTouches = NO;
}

#pragma mark - Table View

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.row == 0) return 30;
	if(indexPath.row == ceilf([_allAdlibs count] / 3.0)+1) return 20;
	
	return 126;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return ceilf([_allAdlibs count] / 3.0) + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	RBPhoneGridViewCell *cell = (RBPhoneGridViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
	if(!cell)
	{
		cell = [[[RBPhoneGridViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
	}
	
	// Add an empty cell for the first and last cells
	if(indexPath.row == 0 || indexPath.row == ceilf([_allAdlibs count] / 3.0)+1)
	{
		[cell setAdlibs:nil];
		return cell;
	}
	
	int startIndex = (indexPath.row - 1) * 3;
	int length = MIN(3, [_allAdlibs count] - startIndex);
	
	NSArray *adlibs = [_allAdlibs subarrayWithRange:NSMakeRange(startIndex, length)];
	[cell setAdlibs:adlibs];
	
	return cell;
}

#pragma mark - Cleanup

- (void) dealloc
{
	[_allAdlibs release];
	
	[super dealloc];
}

@end
