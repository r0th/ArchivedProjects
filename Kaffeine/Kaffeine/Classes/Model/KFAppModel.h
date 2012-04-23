//
//  KFAppModel.h
//  Kaffeine
//
//  Created by Andy Roth on 10/18/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import	"KFPhoto.h"

@interface KFAppModel : NSObject

@property (nonatomic, readonly) NSArray *purchasedPhotos;

+ (KFAppModel*) sharedModel;

- (void) getCategoriesWithHandler:(void (^)(NSArray *results))handler;
- (void) addPurchasedPhotoToLibrary:(KFPhoto *)photo;

@end
