//
//  KFURLHelper.h
//  Kaffeine
//
//  Created by Andy Roth on 10/18/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KFCategory.h"
#import "KFPhoto.h"

@interface KFURLHelper : NSObject

+ (NSURL *) allCategoriesURL;
+ (NSURL *) thumbnailURLForPhoto:(KFPhoto *)photo;
+ (NSURL *) fullURLForPhoto:(KFPhoto *)photo;

@end
