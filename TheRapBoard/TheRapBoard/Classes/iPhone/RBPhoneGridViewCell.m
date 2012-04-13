//
//  RBPhoneGridViewCell.m
//  TheRapBoard
//
//  Created by Andy Roth on 11/14/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import "RBPhoneGridViewCell.h"
#import "RBRapperButton.h"

@interface RBPhoneGridViewCell ()
{
@private
    RBRapperButton *_button1;
	RBRapperButton *_button2;
	RBRapperButton *_button3;
}
@end

@implementation RBPhoneGridViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
	{
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.backgroundColor = [UIColor clearColor];
		
		_button1 = [[RBRapperButton alloc] initWithFrame:CGRectMake(-7, -6, 116, 138)];
		[self addSubview:_button1];
		
		_button2 = [[RBRapperButton alloc] initWithFrame:CGRectMake(-7 + 116 - 7, -6, 116, 138)];
		[self addSubview:_button2];
		
		_button3 = [[RBRapperButton alloc] initWithFrame:CGRectMake(-7 + 116 - 7 + 116 - 7, -6, 116, 138)];
		[self addSubview:_button3];
    }
	
    return self;
}

- (void) setAdlibs:(NSArray *)adlibs
{
	if([adlibs count] > 0)
	{
		RBRapperAdlib *adlib1 = [adlibs objectAtIndex:0];
		
		_button1.hidden = NO;
		[_button1 setAdlib:adlib1];
	}
	else
	{
		_button1.hidden = YES;
	}
	
	if([adlibs count] > 1)
	{
		RBRapperAdlib *adlib2 = [adlibs objectAtIndex:1];
		
		_button2.hidden = NO;
		[_button2 setAdlib:adlib2];
	}
	else
	{
		_button2.hidden = YES;
	}
	
	if([adlibs count] > 2)
	{
		RBRapperAdlib *adlib3 = [adlibs objectAtIndex:2];
		
		_button3.hidden = NO;
		[_button3 setAdlib:adlib3];
	}
	else
	{
		_button3.hidden = YES;
	}
}

- (void) dealloc
{
	[_button1 release];
	[_button2 release];
	[_button3 release];
	
	[super dealloc];
}

@end
