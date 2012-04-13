/**
 * DevKit
 *
 * Created by Andy Roth.
 * Copyright 2009 Roozy. All rights reserved.
 */

#import "DKFileUploader.h"
#import "NSString+DKExtended.h"


@implementation DKFileUploader

@synthesize delegate, uploadServiceURI;

- (id) initWithDelegate:(id<DKFileUploaderDelgate>)uploaderDelegate uploadServiceURI:(NSString *)uri
{
	self = [super init];
	if(self)
	{
		delegate = uploaderDelegate;
		uploadServiceURI = uri;
	}
	
	return self;
}

- (void) uploadImage:(UIImage *)image
{
	// Create the request
	NSData *data = UIImageJPEGRepresentation(image, 1.0);
	
	// Generate the post header:
	NSString *post = [NSString stringWithCString:
					  "--AaB03x\r\nContent-Disposition: form-data; name=\"upload[file]\"; filename=\"image.jpg\"\r\nContent-Type: application/octet-stream\r\nContent-Transfer-Encoding: binary\r\n\r\n"
										encoding:NSASCIIStringEncoding];
	// Get the post header int ASCII format:
	NSData *postHeaderData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	// Generate the mutable data variable:
	NSMutableData *postData = [[NSMutableData alloc] initWithLength:[postHeaderData length] + [data length] ];
	[postData setData:postHeaderData];
	
	// Add the image:
	[postData appendData: data];
	
	// Add the closing boundry:
	[postData appendData: [@"\r\n--AaB03x--" dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
	
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	
	// Setup the request:
	NSMutableURLRequest *uploadRequest = [[NSMutableURLRequest alloc]
										   initWithURL:[NSURL URLWithString:uploadServiceURI]
										   cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
	[uploadRequest setHTTPMethod:@"POST"];
	[uploadRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[uploadRequest setValue:@"multipart/form-data; boundary=AaB03x" forHTTPHeaderField:@"Content-Type"];
	[uploadRequest setHTTPBody:postData];
	
	[postData release];
	
	// Create the connection
	uploadConnection = [[NSURLConnection alloc] initWithRequest:uploadRequest delegate:self];
	
	[uploadRequest release];
	
	if( uploadConnection )
	{
		_webData = [[NSMutableData data] retain];
	}
	else
	{
		[delegate fileUploader:self didFail:@"Error"]; 
	}
}

/*
 NSURLConnection progress
 */
- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
	CGFloat percent = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
	[delegate fileUploader:self didProgress:percent];
}

/*
 NSURLConnectionDelegate
 */
-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	_totalSize = (NSUInteger)[response expectedContentLength];
	[_webData setLength: 0];
}


-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[_webData appendData:data];
}


-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[uploadConnection release];
	[_webData release];
	uploadConnection = nil;
	_webData = nil;
	
	[delegate fileUploader:self didFail:@"Error"];
}


-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSString *response = [[NSString alloc] initWithData:_webData encoding:NSASCIIStringEncoding];
	
	if([response contains:@"Error"])
	{
		[delegate fileUploader:self didFail:[response autorelease]];
	}
	else
	{
		[delegate fileUploader:self didSucceedWithResponse:[response autorelease]];
	}
	
	[uploadConnection release];
	[_webData release];
	uploadConnection = nil;
	_webData = nil;
}

- (void) dealloc
{
	[uploadConnection release];
	[_webData release];
	uploadConnection = nil;
	_webData = nil;
	delegate = nil;
	
	[super dealloc];
}

@end
