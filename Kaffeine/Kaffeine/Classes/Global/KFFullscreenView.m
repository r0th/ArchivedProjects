//
//  KFFullscreenView.m
//  Kaffeine
//
//  Created by Andy Roth on 4/11/12.
//  Copyright (c) 2012 AKQA. All rights reserved.
//

#import "KFFullscreenView.h"

@implementation KFFullscreenView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor blackColor];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.minimumZoomScale = 0.5;
        _scrollView.maximumZoomScale = [UIScreen mainScreen].scale;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_scrollView addSubview:_imageView];
        
        UIImageView *watermark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Watermark.png"]];
        watermark.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
        [self addSubview:watermark];
        [watermark release];
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    _imageView.image = image;
    
    CGFloat xOffset = (image.size.width - _imageView.frame.size.width) / 2;
    CGFloat yOffset = (image.size.height - _imageView.frame.size.height) / 2;
    
    _imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    _scrollView.contentSize = _imageView.frame.size;
    _scrollView.contentOffset = CGPointMake(xOffset, yOffset);
    _scrollView.zoomScale = _scrollView.maximumZoomScale;
}

- (UIImage *)image
{
    return _imageView.image;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    _imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)dealloc
{
    [_scrollView release];
    [_imageView release];
    
    [super dealloc];
}

@end
