/**
 * DevKit
 *
 * Created by Andy Roth.
 * Copyright 2009 Roozy. All rights reserved.
 */

#import <Foundation/Foundation.h>

@class DKXMLAttribute;

@interface DKXMLNode : NSObject
{
	// Main elements
	NSString *name;
	NSString *content;
	NSMutableArray *attributes;
	NSMutableArray *children;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSMutableArray *attributes;
@property (nonatomic, retain) NSMutableArray *children;

- (DKXMLNode *) getChildNodeByName:(NSString *)name;
- (DKXMLNode *) getChildNodeThatContains:(NSString *)string;
- (DKXMLAttribute *) getAttributeByName:(NSString *)name;

- (id) initWithDictionary:(NSDictionary *)dictionary;

@end
