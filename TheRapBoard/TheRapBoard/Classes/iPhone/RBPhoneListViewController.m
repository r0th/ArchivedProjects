//
//  RBPhoneListViewController.m
//  TheRapBoard
//
//  Created by Andy Roth on 11/14/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import "RBPhoneListViewController.h"
#import "RBRapper.h"
#import "RBListTableViewCell.h"
#import "RBListIndexView.h"

@interface RBPhoneListViewController ()
{
@private
    NSArray *_rappers;
	RBListIndexView *_indexView;
	NSMutableDictionary *_indexPathLookup;
	UITableView *_tableView;
}
@end
@implementation RBPhoneListViewController

#pragma mark - Initialization

- (void) viewDidLoad
{
	_rappers = [[RBRapper allRappers] retain];
	
	self.tableView.backgroundColor = [UIColor clearColor];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.tableView.delaysContentTouches = NO;
	
	UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
	_tableView = [self.tableView retain];
	[view addSubview:self.tableView];
	self.view = view;
	[view release];
	
	_indexView = [[RBListIndexView alloc] initWithFrame:CGRectMake(320 - 48, 12, 37, 400)];
	_indexView.delegate = self;
	[self.view addSubview:_indexView];
	
	_indexPathLookup = [[NSMutableDictionary alloc] init];
	
	// Set the rappers' indexes
	int index = 0;
	for(RBRapper *rapper in _rappers)
	{
		// Check the index
		NSString *firstLetter = [[rapper.name substringToIndex:1] uppercaseString];
		if([firstLetter intValue] > 0) firstLetter = @"#";
		
		if(![_indexPathLookup objectForKey:firstLetter])
		{
			NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
			[_indexPathLookup setObject:indexPath forKey:firstLetter];
		}
		
		index++;
	}
}

#pragma mark - Table View

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 148;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_rappers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	RBListTableViewCell *cell = (RBListTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
	if(!cell)
	{
		cell = [[[RBListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
	}
	
	RBRapper *rapper = [_rappers objectAtIndex:indexPath.row];
	[cell setRapper:rapper];
	
	return cell;
}

#pragma mark - Indexing

- (void) viewDidSelectIndex:(NSString *)index
{
	NSIndexPath *path = [_indexPathLookup objectForKey:index];
	if(path)
	{
		[_tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:NO];
	}
}

#pragma mar - Cleanup

- (void) dealloc
{
	[_rappers release];
	[_indexView release];
	[_indexPathLookup release];
	[_tableView release];
	
	[super dealloc];
}

@end
