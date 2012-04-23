//
//  KFCategory.m
//  Kaffeine
//
//  Created by Andy Roth on 10/18/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import "KFCategory.h"
#import "KFPhoto.h"
#import "AFJSONRequestOperation.h"
#import "KFURLHelper.h"
#import "KFStoreManager.h"

@interface KFCategory ()
{
@private
    NSArray *_photos;
}
@end

@implementation KFCategory

@synthesize categoryID = _categoryID, name = _name;

#pragma mark - Photos

- (void) getPhotosWithHandler:(void (^)(NSArray *results))handler
{	
	// Return cached results
	if(_photos)
	{
		handler(_photos);
	}
	else
	{
		// Get all the products
		KFStoreManager *manager = [KFStoreManager sharedManager];
		[manager getProducts:nil withHandler:^(NSArray *results){
			NSMutableArray *photos = [[NSMutableArray alloc] init];
			for(SKProduct *product in results)
			{
				NSString *photoID = [product.productIdentifier stringByReplacingOccurrencesOfString:@"com.kaffeineapp." withString:@""];
				NSString *categoryID = [[photoID componentsSeparatedByString:@"_"] objectAtIndex:0];
				
				if([categoryID isEqualToString:self.categoryID])
				{
					[photos addObject:[KFPhoto photoWithProduct:product]]; 
				}
			}
			
			_photos = [photos retain];
			[photos release];
			
			handler(_photos);
		}];
	}
}

+ (KFCategory *) categoryWithDictionary:(NSDictionary *)dictionary
{
	KFCategory *cat = [[KFCategory alloc] init];
	cat.categoryID = [dictionary objectForKey:@"id"];
	cat.name = [dictionary objectForKey:@"name"];
	
	return [cat autorelease];
}

- (void) dealloc
{
	[_categoryID release];
	[_name release];
	[_photos release];
	
	[super dealloc];
}

@end
