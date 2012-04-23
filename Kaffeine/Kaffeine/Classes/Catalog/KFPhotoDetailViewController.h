//
//  KFPhotoDetailViewController.h
//  Kaffeine
//
//  Created by Andy Roth on 10/19/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KFPhoto.h"

@interface KFPhotoDetailViewController : UIViewController
{
@private
	IBOutlet UIImageView *_imageView;
    
    IBOutlet UILabel *_titleLabel;
    IBOutlet UILabel *_priceLabel;
    IBOutlet UILabel *_descriptionLabel;
}

- (id) initWithPhoto:(KFPhoto *)photo;

@end
