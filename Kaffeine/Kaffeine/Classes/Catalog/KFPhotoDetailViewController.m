//
//  KFPhotoDetailViewController.m
//  Kaffeine
//
//  Created by Andy Roth on 10/19/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import "KFPhotoDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIFont+Custom.h"
#import "NSObject+GlobalViews.h"
#import "KFStoreManager.h"

@interface KFPhotoDetailViewController ()
{
@private
    KFPhoto *_photo;
	UIImage *_image;
}

@end

@implementation KFPhotoDetailViewController

#pragma mark - Initialization

- (id) initWithPhoto:(KFPhoto *)photo
{
	self = [super init];
	if(self)
	{
		_photo = [photo retain];
	}
	
	return self;
}

- (KFPhoto *)photo
{
    return _photo;
}

- (void) viewDidLoad
{
    [_activityIndicator startAnimating];
    
	[_photo getPreviewImageWithHandler:^(UIImage *image){
        [_activityIndicator stopAnimating];
        _image = [image retain];
		_imageView.image = image;
	}];
	
	self.view.backgroundColor = [UIColor clearColor];
    
    _titleLabel.text = _photo.product.localizedTitle;
    _priceLabel.text = [NSString stringWithFormat:@"$%.2f", [_photo.product.price floatValue]];
    
    CGSize descriptionSize = [_photo.product.localizedDescription sizeWithFont:_descriptionLabel.font constrainedToSize:_descriptionLabel.frame.size lineBreakMode:UILineBreakModeWordWrap];
    _descriptionLabel.frame = CGRectMake(_descriptionLabel.frame.origin.x, _descriptionLabel.frame.origin.y, descriptionSize.width, descriptionSize.height);
    _descriptionLabel.numberOfLines = 0;
    _descriptionLabel.text = _photo.product.localizedDescription;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showFullScreen)];
    [_imageView addGestureRecognizer:tapRecognizer];
    _imageView.userInteractionEnabled = YES;
    [tapRecognizer release];
}

- (void)showFullScreen
{
    if (!_imageView.image) return;
    
    CGRect adjustedFrame = [self.view convertRect:_imageView.frame fromView:_imageView.superview];
    [self showImage:_imageView.image fullscreenFromFrame:adjustedFrame];
}

#pragma mark - Purchasing

- (void) purchaseItem
{
	// Invoke the store manager to add a payment queue
	[[KFStoreManager sharedManager] purchasePhoto:_photo];
}

#pragma mark - Cleanup

- (void) dealloc
{
	[_photo release];
    [_image release];
	
	[super dealloc];
}

@end
