
/**
 * DevKit
 *
 * Created by Andy Roth.
 * Copyright 2009 Roozy. All rights reserved.
 */

#import "DKXMLLoader.h"
#import "XPathQuery.h"
#import "DKXMLNode.h"


@implementation DKXMLLoader

@synthesize delegate;

- (id) initWithDelegate:(id <DKXMLLoaderDelegate>) theDelegate
{
	if((self = [super init]))
	{
		self.delegate = theDelegate;
	}
	
	return self;
}

- (void) loadWithURL:(NSString *)url xPathQuery:(NSString *)xPathQuery
{
	_xPathQuery = [xPathQuery copy];
	NSString *urlString = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	
	NSURL *realURL = [NSURL URLWithString:urlString];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:realURL];
	
	connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
	if( connection )
	{
		_webData = [[NSMutableData data] retain];
	}
	else
	{
		if([delegate respondsToSelector:@selector(xmlLoader:didFail:)]) [delegate xmlLoader:self didFail:YES];
	}	
}

- (void) loadWithRequest:(NSMutableURLRequest *)request xPathQuery:(NSString *)xPathQuery
{
	_xPathQuery = [xPathQuery copy];
	
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if( connection )
	{
		_webData = [[NSMutableData data] retain];
	}
	else
	{
		if([delegate respondsToSelector:@selector(xmlLoader:didFail:)]) [delegate xmlLoader:self didFail:YES];
	}	
}

- (void) setRootNamespace:(NSString *)prefix withURI:(NSString *)uri
{
	_nsPrefix = [prefix copy];
	_nsURI = [uri copy];
}

- (void) performQuery:(NSString *)query
{
	if(_webData)
	{
		NSMutableArray *results = [self formatResults:PerformXMLXPathQuery(_webData, _xPathQuery, _nsPrefix, _nsURI)];
		
		if(delegate)
		{
			if([delegate respondsToSelector:@selector(xmlLoader:receivedResultWithRootNode:)] && [results count] > 0) [delegate xmlLoader:self receivedResultWithRootNode:[results objectAtIndex:0]];
		}
		
		[_webData release];
		[results release];
	}
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
	
	CGFloat percent = ((float)[_webData length]) / ((float)_totalSize);
	if([delegate respondsToSelector:@selector(xmlLoader:didProgress:)]) [delegate xmlLoader:self didProgress:percent];
}


-(void) connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)error
{
	[connection release];
	[_webData release];
	connection = nil;
	_webData = nil;
	
	if([delegate respondsToSelector:@selector(xmlLoader:didFail:)]) [delegate xmlLoader:self didFail:YES];
}


-(void) connectionDidFinishLoading:(NSURLConnection *)aConnection
{
	NSMutableArray *results = [self formatResults:PerformXMLXPathQuery(_webData, _xPathQuery, _nsPrefix, _nsURI)];
	
	if([results count] == 0) NSLog(@"[DKXMLLoader] : No results");
	
	if(delegate)
	{
		if([delegate respondsToSelector:@selector(xmlLoader:receivedResultWithRootNode:)] && [results count] > 0) [delegate xmlLoader:self receivedResultWithRootNode:[results objectAtIndex:0]];
	}
	
	[_webData release];
	[connection release];
	connection = nil;
	_webData = nil;
}

#pragma mark -
#pragma mark XML Formatting

- (NSMutableArray *) formatResults:(NSArray *)xmlResults
{
	NSMutableArray *newResults = [[NSMutableArray alloc] init];
	for(int i = 0; i < [xmlResults count]; i++)
	{
		DKXMLNode *newNode = [[DKXMLNode alloc] initWithDictionary:[xmlResults objectAtIndex:i]];
		[newResults addObject:newNode];
		[newNode release];
	}
	
	return [newResults autorelease];
}

- (void) dealloc
{
	[_xPathQuery release];
	[_nsPrefix release];
	[_nsURI release];
	[_webData release];
	[connection release];
	
	[super dealloc];
}

@end
