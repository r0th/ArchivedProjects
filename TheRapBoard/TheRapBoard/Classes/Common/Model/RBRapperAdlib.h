//
//  RBRapperAdlib.h
//  TheRapBoard
//
//  Created by Andy Roth on 11/11/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RBRapper.h"

@interface RBRapperAdlib : NSObject

@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *filename;
@property (nonatomic, assign) RBRapper *rapper;

@end
