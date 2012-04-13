/*
 
 DKXMLLoader
 
 This class provides a simple interface to load and parse XML documents.
 It accepts an XML URL, along with an XPath query to parse the results.  To receive everything, simply use '/'.
 
 Each result in the array returns a DKXMLNode object.  Each DKXMLNode has the following properties:
 
 NSString *name;
 NSString *content;
 NSMutableArray *attributes;
 NSMutableArray *children;
 
 And 2 methods:
 
 - (DKXMLNode *) getChildByName:(NSString *)name;
 - (DKXMLAttribute *) getAttributeByName:(NSString *)name;
 
 Alternatively, the attributes and children arrays may be accessed directly.
 
 */

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "DKXMLNode.h"

@class DKXMLLoader;

@protocol DKXMLLoaderDelegate <NSObject>

/*
 * Called when the xml loader has successfully received and parsed the results
 */
- (void)xmlLoader:(DKXMLLoader *)xmlLoader receivedResultWithRootNode:(DKXMLNode *)rootNode;

@optional
- (void)xmlLoader:(DKXMLLoader *)xmlLoader didProgress:(CGFloat)percent;
- (void)xmlLoader:(DKXMLLoader *)xmlLoader didFail:(BOOL)failed;

@end

@interface DKXMLLoader : NSObject
{
	id <DKXMLLoaderDelegate> delegate;
@private
	NSMutableData *_webData;
	NSString *_xPathQuery;
	NSString *_nsPrefix;
	NSString *_nsURI;
	NSUInteger _totalSize;
	NSURLConnection *connection;
}

@property (nonatomic, assign) id <DKXMLLoaderDelegate> delegate;

// Public methods
- (id) initWithDelegate:(id <DKXMLLoaderDelegate>) theDelegate;
- (void) loadWithURL:(NSString *)url xPathQuery:(NSString *)xPathQuery;
- (void) loadWithRequest:(NSMutableURLRequest *)request xPathQuery:(NSString *)xPathQuery;
- (void) setRootNamespace:(NSString *)prefix withURI:(NSString *)uri;

// Internal methods
- (void) performQuery:(NSString *)query;
- (NSMutableArray *) formatResults:(NSArray *)xmlResults;

@end
