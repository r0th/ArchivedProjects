//
//  KFStoreManager.h
//  Kaffeine
//
//  Created by Andy Roth on 10/26/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "KFPhoto.h"

@interface KFStoreManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>

+ (KFStoreManager *) sharedManager;

- (void) start;
- (void) restorePreviousPurchases;
- (void) restorePreviousPurchasesFromAppleWithHandler:(void (^)(void))handler;
- (void) getProducts:(NSSet *)productIDs withHandler:(void (^)(NSArray *results))handler;
- (void) purchasePhoto:(KFPhoto *)photo;

@end
