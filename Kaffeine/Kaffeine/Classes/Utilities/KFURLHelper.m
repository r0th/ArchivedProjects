//
//  KFURLHelper.m
//  Kaffeine
//
//  Created by Andy Roth on 10/18/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import "KFURLHelper.h"

@implementation KFURLHelper

static NSString *baseURL = @"http://www.kaffeineapp.com/content";

+ (NSURL *) allCategoriesURL
{
	return [NSURL URLWithString:[NSString stringWithFormat:@"%@/products.json", baseURL]];
}

+ (NSURL *) thumbnailURLForPhoto:(KFPhoto *)photo
{
	return [NSURL URLWithString:[NSString stringWithFormat:@"%@/images/%@_t.jpg", baseURL, photo.photoID]];
}

+ (NSURL *) previewURLForPhoto:(KFPhoto *)photo
{
	return [NSURL URLWithString:[NSString stringWithFormat:@"%@/images/%@_thumb.jpg", baseURL, photo.photoID]];
}

+ (NSURL *) fullURLForPhoto:(KFPhoto *)photo
{
	return [NSURL URLWithString:[NSString stringWithFormat:@"%@/images/%@_full.jpg", baseURL, photo.photoID]];
}

@end
