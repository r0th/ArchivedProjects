//
//  KFPhotoGridButton.m
//  Kaffeine
//
//  Created by Andy Roth on 10/19/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import "KFPhotoGridButton.h"
#import "KFURLHelper.h"

@interface KFPhotoGridButton ()
{
@private
    KFPhoto *_photo;
    UIButton *_button;
}
@end

@implementation KFPhotoGridButton

#pragma mark - Initialization

- (id) initWithFrame:(CGRect)frame photo:(KFPhoto *)photo
{
	self = [super initWithFrame:frame];
	if(self)
	{
        _button = [[UIButton alloc] initWithFrame:CGRectMake(1, 1, frame.size.width - 2, frame.size.height - 2)];
        _button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        _button.clipsToBounds = YES;
        [self addSubview:_button];
        
		self.backgroundColor = [UIColor whiteColor];
		
		UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		activityIndicator.center = CGPointMake(frame.size.width/2, frame.size.height/2);
		[self addSubview:activityIndicator];
		[activityIndicator startAnimating];
		
		_photo = [photo retain];
		[_photo getThumbnailImageWithHandler:^(UIImage *image){
			[activityIndicator removeFromSuperview];
			[activityIndicator release];
			
			[_button setImage:image forState:UIControlStateNormal];
			[_button setImage:image forState:UIControlStateHighlighted];
		}];
	}
	
	return self;
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvent
{
    [_button addTarget:target action:action forControlEvents:controlEvent];
}

- (KFPhoto *) photo
{
	return _photo;
}

- (void) dealloc
{
	[_photo release];
	
	[super dealloc];
}

@end
