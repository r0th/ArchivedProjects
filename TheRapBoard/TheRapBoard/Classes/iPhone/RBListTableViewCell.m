//
//  RBListTableViewCell.m
//  TheRapBoard
//
//  Created by Andy Roth on 11/15/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import "RBListTableViewCell.h"
#import "RBRapperAdlib.h"
#import "RBListAdlibCell.h"

@interface RBListTableViewCell ()
{
@private
    UIScrollView *_scrollView;
	NSMutableArray *_adlibViews;
}
@end

@implementation RBListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
	{
        self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 148)];
		_scrollView.pagingEnabled = YES;
		_scrollView.showsHorizontalScrollIndicator = NO;
		_scrollView.delaysContentTouches = NO;
		[self addSubview:_scrollView];
		
		_adlibViews = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) setRapper:(RBRapper *)rapper
{
	for(UIView *adlibView in _adlibViews)
	{
		[adlibView removeFromSuperview];
	}
	
	[_adlibViews removeAllObjects];
	
	CGFloat xOffset = 0;
	
	for(RBRapperAdlib *adlib in rapper.adlibs)
	{
		RBListAdlibCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"RBListAdlibCell" owner:nil options:nil] objectAtIndex:0];
		cell.frame = CGRectMake(xOffset, 0, 320, 148);
		[cell setAdlib:adlib];
		[_scrollView addSubview:cell];
		[_adlibViews addObject:cell];
		
		xOffset += 320;
	}
	
	_scrollView.contentSize = CGSizeMake(xOffset, 148);
}

- (void) dealloc
{
	[_scrollView release];
	[_adlibViews release];
	
	[super dealloc];
}

@end
