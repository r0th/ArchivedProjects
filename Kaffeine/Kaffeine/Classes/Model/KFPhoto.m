//
//  KFPhoto.m
//  Kaffeine
//
//  Created by Andy Roth on 10/18/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import "KFPhoto.h"
#import "AFImageRequestOperation.h"
#import "KFURLHelper.h"

@interface KFPhoto ()
{
@private
	UIImage *_cachedImage;
    UIImage *_cachedThumbnail;
}
@end

@implementation KFPhoto

@synthesize photoID = _photoID, product = _product;

- (void) getThumbnailImageWithHandler:(void (^)(UIImage *image))handler
{
    // Return cached results
	if(_cachedThumbnail)
	{
		handler(_cachedThumbnail);
	}
	else
	{
		// Load results asynchronously
		NSURLRequest *request = [NSURLRequest requestWithURL:[KFURLHelper thumbnailURLForPhoto:self]];
		AFImageRequestOperation *op = [AFImageRequestOperation imageRequestOperationWithRequest:request success:^(UIImage *image){
			_cachedThumbnail = [image retain];
			handler(_cachedThumbnail);
		}];
        
        [op setAuthenticationChallengeBlock:^(NSURLConnection *connection, NSURLAuthenticationChallenge *challenge) {
            [challenge.sender useCredential:[NSURLCredential credentialWithUser:@"onpunkt" password:@"lillymilo" persistence:NSURLCredentialPersistencePermanent] forAuthenticationChallenge:challenge];
        }];
		
		NSOperationQueue *queue = [[[NSOperationQueue alloc] init] autorelease];
		[queue addOperation:op];
	}
}

- (void) getPreviewImageWithHandler:(void (^)(UIImage *image))handler
{	
	// Return cached results
	if(_cachedImage)
	{
		handler(_cachedImage);
	}
	else
	{
		// Load results asynchronously
		NSURLRequest *request = [NSURLRequest requestWithURL:[KFURLHelper previewURLForPhoto:self]];
		AFImageRequestOperation *op = [AFImageRequestOperation imageRequestOperationWithRequest:request success:^(UIImage *image){
			_cachedImage = [image retain];
			handler(_cachedImage);
		}];
        
        [op setAuthenticationChallengeBlock:^(NSURLConnection *connection, NSURLAuthenticationChallenge *challenge) {
            [challenge.sender useCredential:[NSURLCredential credentialWithUser:@"onpunkt" password:@"lillymilo" persistence:NSURLCredentialPersistencePermanent] forAuthenticationChallenge:challenge];
        }];
		
		NSOperationQueue *queue = [[[NSOperationQueue alloc] init] autorelease];
		[queue addOperation:op];
	}
}

- (void) getFullImageWithHandler:(void (^)(UIImage *image))handler
{	
	// Load results asynchronously
	NSURLRequest *request = [NSURLRequest requestWithURL:[KFURLHelper fullURLForPhoto:self]];
	AFImageRequestOperation *op = [AFImageRequestOperation imageRequestOperationWithRequest:request success:^(UIImage *image){
		handler(image);
	}];
    
    [op setAuthenticationChallengeBlock:^(NSURLConnection *connection, NSURLAuthenticationChallenge *challenge) {
        [challenge.sender useCredential:[NSURLCredential credentialWithUser:@"onpunkt" password:@"lillymilo" persistence:NSURLCredentialPersistencePermanent] forAuthenticationChallenge:challenge];
    }];
	
	NSOperationQueue *queue = [[[NSOperationQueue alloc] init] autorelease];
	[queue addOperation:op];
}

+ (KFPhoto *) photoWithProduct:(SKProduct *)product
{
	KFPhoto *photo = [[KFPhoto alloc] init];
	photo.product = product;
	photo.photoID = [product.productIdentifier stringByReplacingOccurrencesOfString:@"com.kaffeineapp." withString:@""];
	
	return [photo autorelease];
}

- (void) dealloc
{
	[_photoID release];
	[_product release];
	[_cachedImage release];
	
	[super dealloc];
}

@end
