//
//  KFTermsViewController.m
//  Kaffeine
//
//  Created by Andy Roth on 10/17/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import "KFTermsViewController.h"
#import "UIFont+Custom.h"

@implementation KFTermsViewController

- (void) viewDidLoad
{
	_textView.font = [UIFont systemFontOfSize:12.0];
	
	NSData *termsData = [[NSData alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Terms" withExtension:@"txt"]];
	NSString *terms = [[NSString alloc] initWithData:termsData encoding:NSUTF8StringEncoding];
	_textView.text = terms;
	[termsData release];
	[terms release];
}

@end
