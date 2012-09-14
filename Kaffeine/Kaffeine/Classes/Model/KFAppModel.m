//
//  KFAppModel.m
//  Kaffeine
//
//  Created by Andy Roth on 10/18/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import "KFAppModel.h"
#import "AFJSONRequestOperation.h"
#import "KFURLHelper.h"
#import "KFCategory.h"
#import "KFStoreManager.h"

@interface KFAppModel ()
{
@private
    NSArray *_categories;
	NSMutableArray *_purchasedPhotos;
	NSMutableArray *_purchasedPhotoIDs;
}
@end

@implementation KFAppModel

#pragma mark - Categories

- (void) getCategoriesWithHandler:(void (^)(NSArray *results))handler
{	
	// Return cached results
	if(_categories)
	{
		handler(_categories);
	}
	else
	{
		// Load results asynchronously
		NSURLRequest *request = [NSURLRequest requestWithURL:[KFURLHelper allCategoriesURL]];
		AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSURLResponse *response, id json){
			NSDictionary *baseJSON = (NSDictionary *)json;
			NSArray *categoriesJSON = [baseJSON objectForKey:@"categories"];
			NSArray *productsJSON = [baseJSON objectForKey:@"products"];
			NSMutableArray *results = [[NSMutableArray alloc] init];
			NSMutableSet *productIDs = [[NSMutableSet alloc] init];
			
			for(NSDictionary *categoryJSON in categoriesJSON)
			{
				[results addObject:[KFCategory categoryWithDictionary:categoryJSON]];
			}
			
			for(NSDictionary *productJSON in productsJSON)
			{
				[productIDs addObject:[productJSON objectForKey:@"id"]];
			}
			
			_categories = [results retain];
			[results release];
			
			KFStoreManager *manager = [KFStoreManager sharedManager];
			[manager getProducts:productIDs withHandler:^(NSArray *results){
				// Do nothing with products, they're cached in the store manager now
                handler(_categories);
			}];
			
			[productIDs release];
			
		} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
			handler(nil);
		}];
		
		NSOperationQueue *queue = [[[NSOperationQueue alloc] init] autorelease];
		[queue addOperation:op];
	}
}

#pragma mark - Photos

- (void) addPurchasedPhotoToLibrary:(KFPhoto *)photo
{
	if(!_purchasedPhotos) _purchasedPhotos = [[NSMutableArray alloc] init];
	
	// Verify the product hasn't already been added
	for(KFPhoto *purchased in _purchasedPhotos)
	{
		if([photo.product.productIdentifier isEqualToString:purchased.product.productIdentifier]) return;
	}
	
	[_purchasedPhotos addObject:photo];
	
	// Add the product ID to the user defaults
	if(!_purchasedPhotoIDs) _purchasedPhotoIDs = [[NSMutableArray alloc] init];
	[_purchasedPhotoIDs addObject:photo.product.productIdentifier];
	
	[[NSUserDefaults standardUserDefaults] setObject:_purchasedPhotoIDs forKey:@"purchasedPhotos"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *) purchasedPhotos
{
	return _purchasedPhotos;
}

#pragma mark - Singleton

static KFAppModel *_sharedModel = nil;

+ (KFAppModel*) sharedModel
{
    @synchronized(self)
	{
        if (_sharedModel == nil)
		{
            [[self alloc] init];
        }
    }
	
    return _sharedModel;
}

+ (id) allocWithZone:(NSZone *)zone
{
    @synchronized(self)
	{
        if (_sharedModel == nil)
		{
            _sharedModel = [super allocWithZone:zone];
            return _sharedModel;
        }
    }
	
    return nil;
}

- (id) copyWithZone:(NSZone *)zone
{
    return self;
}

- (id) retain
{
    return self;
}

- (unsigned) retainCount
{
    return UINT_MAX;
}

- (oneway void) release
{
    //do nothing
}

- (id) autorelease
{
    return self;
}

@end
