/**
 * DevKit
 *
 * Created by Andy Roth.
 * Copyright 2009 Roozy. All rights reserved.
 */

#import <Foundation/Foundation.h>

@class DKFileUploader;

@protocol DKFileUploaderDelgate

- (void) fileUploader:(DKFileUploader *)uploader didSucceedWithResponse:(NSString *)response;
- (void) fileUploader:(DKFileUploader *)uploader didProgress:(CGFloat)progress;
- (void) fileUploader:(DKFileUploader *)uploader didFail:(NSString *)response;

@end


@interface DKFileUploader : NSObject
{
	id <DKFileUploaderDelgate> delegate;
	NSString *uploadServiceURI;
	
	NSMutableData *_webData;
	NSUInteger _totalSize;
	NSURLConnection *uploadConnection;
}

@property (nonatomic, assign) id <DKFileUploaderDelgate> delegate;
@property (nonatomic, retain) NSString *uploadServiceURI;

- (id) initWithDelegate:(id<DKFileUploaderDelgate>)uploaderDelegate uploadServiceURI:(NSString *)uri;
- (void) uploadImage:(UIImage *)image;

@end
