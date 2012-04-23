//
//  KFCartTableViewCell.m
//  Kaffeine
//
//  Created by Andy Roth on 10/19/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import "KFLibraryTableViewCell.h"
#import "NSObject+GlobalViews.h"

@interface KFLibraryTableViewCell ()
{
@private
    UIImageView *_imageView;
	UILabel *_titleLabel;
	UIButton *_saveButton;
	
	KFPhoto *_photo;
}
@end

@implementation KFLibraryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
	{
        UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
        borderView.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:borderView];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 48, 48)];
		_imageView.contentMode = UIViewContentModeScaleAspectFill;
		_imageView.clipsToBounds = YES;
		[borderView addSubview:_imageView];
        [borderView release];
		
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(62, 0, 200, 30)];
		_titleLabel.backgroundColor = [UIColor clearColor];
		_titleLabel.textColor = [UIColor whiteColor];
		_titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
		_titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
		_titleLabel.center = CGPointMake(_titleLabel.center.x, 30);
		[self.contentView addSubview:_titleLabel];
		
		_saveButton = [[UIButton alloc] initWithFrame:CGRectMake(280, 0, 21, 21)];
		_saveButton.center = CGPointMake(_saveButton.center.x, 30);
		_saveButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		[_saveButton setImage:[UIImage imageNamed:@"Icon-Settings.png"] forState:UIControlStateNormal];
		[_saveButton addTarget:self action:@selector(promptToSave) forControlEvents:UIControlEventTouchUpInside];
		[self.contentView addSubview:_saveButton];
    }
    return self;
}

- (void) setPhoto:(KFPhoto *)photo
{
	[_photo release];
	_photo = [photo retain];
	
	_titleLabel.text = _photo.product.localizedTitle;
	
	[_photo getThumbnailImageWithHandler:^(UIImage *image){
		_imageView.image = image;
	}];
}

- (KFPhoto *) photo
{
	return _photo;
}

- (void)promptToSave
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Save to Camera Roll", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self savePhoto];
    }
}

- (void) savePhoto
{
	[self showLoadingViewWithMessage:@"Saving full size image"];
	
	[_photo getFullImageWithHandler:^(UIImage *image){
		UIImageWriteToSavedPhotosAlbum(image, NULL, NULL, NULL);
		[self hideLoadingView];
	}];
}

- (void) dealloc
{
	[_imageView release];
	[_titleLabel release];
	[_photo release];
	[_saveButton release];
	
	[super dealloc];
}

@end
