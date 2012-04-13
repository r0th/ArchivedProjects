//
//  SynapseClientLibraryTouchController.h
//  SynapseClientLibrary
//
//  Created by Roth on 8/26/10.
//  Copyright 2010 Roozy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYSynapseClient.h"


@interface SynapseClientLibraryTouchController : UIViewController
{
	SYSynapseClient *client;
}

@property (nonatomic, retain) SYSynapseClient *client;

- (IBAction) close;

@end
