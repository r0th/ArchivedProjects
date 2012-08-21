//
//  KFPhotoDetailContainerViewController.h
//  Kaffeine
//
//  Created by Andy Roth on 8/21/12.
//  Copyright (c) 2012 AKQA. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KFPhoto.h"

@protocol KFPhotoDetailContainerViewControllerDelegate <NSObject>

- (KFPhoto *)photoNextFromPhoto:(KFPhoto *)photo;
- (KFPhoto *)photoPreviousToPhoto:(KFPhoto *)photo;

@end

@interface KFPhotoDetailContainerViewController : UIViewController

@property (nonatomic, assign) id <KFPhotoDetailContainerViewControllerDelegate> delegate;

- (id)initWithPhoto:(KFPhoto *)photo;

@end
