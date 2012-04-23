//
//  KFStoreManager.m
//  Kaffeine
//
//  Created by Andy Roth on 10/26/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import "KFStoreManager.h"
#import "KFPhoto.h"
#import "KFAppModel.h"
#import "NSObject+GlobalViews.h"

@interface KFStoreManager ()
{
@private
    SKProductsRequest *_productsRequest;
    NSArray *_products;
	void (^_productsHandler)(NSArray *results);
	void (^_restoreHandler)(void);
	SKPaymentQueue *_paymentQueue;
	NSMutableDictionary *_queuedPhotos;
	
	BOOL _restoring;
}
@end

@implementation KFStoreManager

#pragma mark - Initialization

- (void) start
{
	_queuedPhotos = [[NSMutableDictionary alloc] init];
	
	_paymentQueue = [SKPaymentQueue defaultQueue];
	[_paymentQueue addTransactionObserver:self];
}

#pragma mark - Products

- (void) getProducts:(NSSet *)productIDs withHandler:(void (^)(NSArray *results))handler
{
	if(_productsHandler) Block_release(_productsHandler);
	_productsHandler = Block_copy(handler);
	
	if(_products)
	{
		_productsHandler(_products);
		return;
	}

	_productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIDs];
	_productsRequest.delegate = self;
	[_productsRequest start];
}

#pragma mark - Products Delegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	_products = [response.products copy];
	_productsHandler(_products);
    
    [_productsRequest release];
    _productsRequest = nil;
}

#pragma mark - Transactions

- (void) purchasePhoto:(KFPhoto *)photo
{
	[self showLoadingViewWithMessage:@"Purchasing photo"];
	
	[_queuedPhotos setObject:photo forKey:photo.product.productIdentifier];
	
	SKPayment *payment = [SKPayment paymentWithProduct:photo.product];
	[_paymentQueue addPayment:payment];
}

- (void) restorePreviousPurchases
{
	NSArray *purchased = [[NSUserDefaults standardUserDefaults] objectForKey:@"purchasedPhotos"];
	
	for(NSString *photoID in purchased)
	{
		for(SKProduct *product in _products)
		{
			if([product.productIdentifier isEqualToString:photoID])
			{
				KFPhoto *photo = [KFPhoto photoWithProduct:product];
				[[KFAppModel sharedModel] addPurchasedPhotoToLibrary:photo];
				
				break;
			}
		}
	}
}

- (void) restorePreviousPurchasesFromAppleWithHandler:(void (^)(void))handler
{
	_restoring = YES;
	
	if(_restoreHandler) Block_release(_restoreHandler);
	_restoreHandler = Block_copy(handler);
	
	[self showLoadingViewWithMessage:@"Restoring previous purchases"];
	[_paymentQueue restoreCompletedTransactions];
}

#pragma mark - Transactions Delegate

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
	for(SKPaymentTransaction *transaction in transactions)
	{
		if(transaction.transactionState == SKPaymentTransactionStatePurchased)
		{
			KFPhoto *photo = [_queuedPhotos objectForKey:transaction.payment.productIdentifier];
			
			// Save the photo
			[[KFAppModel sharedModel] addPurchasedPhotoToLibrary:photo];
			
			[_queuedPhotos removeObjectForKey:transaction.payment.productIdentifier];
			[queue finishTransaction:transaction];
			
			[self hideLoadingView];
		}
		else if(transaction.transactionState == SKPaymentTransactionStateRestored)
		{
			for(SKProduct *product in _products)
			{
				if([product.productIdentifier isEqualToString:transaction.payment.productIdentifier])
				{
					KFPhoto *photo = [KFPhoto photoWithProduct:product];
					[[KFAppModel sharedModel] addPurchasedPhotoToLibrary:photo];
				}
			}
		}
		else if(transaction.transactionState == SKPaymentTransactionStateFailed)
		{
			if(!_restoring)
			{
				[_queuedPhotos removeObjectForKey:transaction.payment.productIdentifier];
			
				[self hideLoadingView];
			}
		}
	}
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
	//NSLog(@"trans failed %@", [error description]);
	_restoring = NO;
	[self hideLoadingView];
	
	_restoreHandler();
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
	//NSLog(@"restored transactions (theyre still in the queue)");
	_restoring = NO;
	[self hideLoadingView];
	
	_restoreHandler();
}

#pragma mark - Singleton

static KFStoreManager *_sharedManager = nil;

+ (KFStoreManager*) sharedManager
{
    @synchronized(self)
	{
        if (_sharedManager == nil)
		{
            [[self alloc] init];
        }
    }
	
    return _sharedManager;
}

+ (id) allocWithZone:(NSZone *)zone
{
    @synchronized(self)
	{
        if (_sharedManager == nil)
		{
            _sharedManager = [super allocWithZone:zone];
            return _sharedManager;
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
