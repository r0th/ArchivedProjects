//
//  KFCategory.h
//  Kaffeine
//
//  Created by Andy Roth on 10/18/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KFCategory : NSObject

+ (KFCategory *) categoryWithDictionary:(NSDictionary *)dictionary;

- (void) getPhotosWithHandler:(void (^)(NSArray *results))handler;

@property (nonatomic, retain) NSString *categoryID;
@property (nonatomic, retain) NSString *name;

@end
