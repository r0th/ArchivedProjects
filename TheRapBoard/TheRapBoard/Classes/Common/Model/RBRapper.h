//
//  RBRapper.h
//  TheRapBoard
//
//  Created by Andy Roth on 11/11/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBRapper : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *imageName;
@property (nonatomic, retain) NSString *highlightedImageName;
@property (nonatomic, retain) NSArray *adlibs;

+ (NSArray *) allRappers;
+ (NSArray *) allAdlibs;

@end
