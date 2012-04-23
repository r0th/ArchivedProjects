//
//  KFPhotoGridButton.h
//  Kaffeine
//
//  Created by Andy Roth on 10/19/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KFPhoto.h"

@interface KFPhotoGridButton : UIView

@property (nonatomic, readonly) KFPhoto *photo;

- (id) initWithFrame:(CGRect)frame photo:(KFPhoto *)photo;
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
