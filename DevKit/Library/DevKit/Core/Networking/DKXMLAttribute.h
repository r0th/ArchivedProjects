/**
 * DevKit
 *
 * Created by Andy Roth.
 * Copyright 2009 Roozy. All rights reserved.
 */

#import <Foundation/Foundation.h>


@interface DKXMLAttribute : NSObject
{
	NSString *name;
	NSString *content;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *content;

- (id) initWithDictionary:(NSDictionary *)dictionary;

@end
