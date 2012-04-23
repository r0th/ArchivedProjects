//
//  KFFullscreenView.h
//  Kaffeine
//
//  Created by Andy Roth on 4/11/12.
//  Copyright (c) 2012 AKQA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KFFullscreenView : UIView <UIScrollViewDelegate>
{
@private
    UIScrollView *_scrollView;
    UIImageView *_imageView;
}

@property (nonatomic, assign) UIImage *image;

@end
