//
//  KFPhoto.h
//  Kaffeine
//
//  Created by Andy Roth on 10/18/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface KFPhoto : NSObject

+ (KFPhoto *) photoWithProduct:(SKProduct *)product;

@property (nonatomic, retain) NSString *photoID;
@property (nonatomic, retain) SKProduct *product;

- (void) getThumbnailImageWithHandler:(void (^)(UIImage *image))handler;
- (void) getFullImageWithHandler:(void (^)(UIImage *image))handler;

@end
