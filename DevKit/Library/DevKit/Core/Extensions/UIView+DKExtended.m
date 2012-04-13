/**
 * DevKit
 *
 * Created by Andy Roth.
 * Copyright 2009 Roozy. All rights reserved.
 */

#import "UIView+DKExtended.h"
#import <QuartzCore/QuartzCore.h>


@implementation UIView (DKExtended)

- (CGFloat) x
{
	return self.frame.origin.x;
}

- (void) setX:(CGFloat)value
{
	self.frame = CGRectMake(value, self.y, self.width, self.height);
}

- (CGFloat) y
{
	return self.frame.origin.y;
}

- (void) setY:(CGFloat)value
{
	self.frame = CGRectMake(self.x, value, self.width, self.height);
}

- (CGFloat) width
{
	return self.frame.size.width;
}

- (void) setWidth:(CGFloat)value
{
	self.frame = CGRectMake(self.x, self.y, value, self.height);
}

- (CGFloat) height
{
	return self.frame.size.height;
}

- (void) setHeight:(CGFloat)value
{
	self.frame = CGRectMake(self.x, self.y, self.width, value);
}

- (UIImage *) viewAsImage
{
	UIGraphicsBeginImageContext(self.bounds.size);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return viewImage;
}

@end
