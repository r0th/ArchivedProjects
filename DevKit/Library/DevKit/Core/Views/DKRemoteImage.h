/**
 * DevKit
 *
 * Created by Andy Roth.
 * Copyright 2009 Roozy. All rights reserved.
 */

#import <Foundation/Foundation.h>

@class DKRemoteImage;

@protocol DKRemoteImageDelegate <NSObject>

- (void)remoteImageDidStartLoad:(DKRemoteImage *)remoteImage;
- (void)remoteImageDidComplete:(DKRemoteImage *)remoteImage;
- (void)remoteImageDidProgress:(DKRemoteImage *)remoteImage percent:(CGFloat)percent;
- (void)remoteImageDidFail:(DKRemoteImage *)remoteImage;

@end

@protocol DKRemoteImageDelegate;

@interface DKRemoteImage : UIImageView
{
	id <DKRemoteImageDelegate> delegate;
	NSString *_source;
	NSMutableData *_webData;
	NSURLConnection *_connection;
	BOOL _loadComplete;
	
	NSUInteger _totalSize;
}

@property (nonatomic, assign) id <DKRemoteImageDelegate> delegate;
@property (nonatomic, retain) NSString *source;

- (id) initWithSource:(NSString *)newSource withDelegate:(id <DKRemoteImageDelegate>)newDelegate;

@end
