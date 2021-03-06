//
//  KFPhotoGridViewController.h
//  Kaffeine
//
//  Created by Andy Roth on 10/18/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KFCategory.h"
#import "KFPhotoDetailContainerViewController.h"

@interface KFPhotoGridViewController : UIViewController <KFPhotoDetailContainerViewControllerDelegate>

- (id) initWithCategory:(KFCategory *)category;

@end
