//
//  SynapseClientLibraryViewController.h
//  SynapseClientLibrary
//
//  Created by Roth on 8/20/10.
//  Copyright 2010 Roozy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYSynapseClient.h"

@interface SynapseClientLibraryViewController : UIViewController <SYSynapseClientDelegate, UITextFieldDelegate>
{
	SYSynapseClient *demoClient;
	
	IBOutlet UITextField *statusField;
	IBOutlet UITextField *messageField;
	
	IBOutlet UITextField *ipField;
	IBOutlet UITextField *portField;
}

- (IBAction) connect;
- (IBAction) sendMessage;
- (IBAction) startMotion;
- (IBAction) stopMotion;
- (IBAction) openTouchController;

@end

