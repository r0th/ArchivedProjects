//
//  SynapseClientLibraryViewController.m
//  SynapseClientLibrary
//
//  Created by Roth on 8/20/10.
//  Copyright 2010 Roozy. All rights reserved.
//

#import "SynapseClientLibraryViewController.h"
#import "SynapseClientLibraryTouchController.h"

@implementation SynapseClientLibraryViewController

- (void) viewDidLoad
{
	NSString *savedIP = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedIP"];
	NSString *savedPort = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedPort"];
	
	if(savedIP) ipField.text = savedIP;
	if(savedPort) portField.text = savedPort;
	
	demoClient = [[SYSynapseClient alloc] init];
	demoClient.delegate = self;
	[demoClient retain];
}

- (IBAction) connect
{
	statusField.text = @"Connecting";
	
	[[NSUserDefaults standardUserDefaults] setObject:ipField.text forKey:@"savedIP"];
	[[NSUserDefaults standardUserDefaults] setObject:portField.text forKey:@"savedPort"];
	
	demoClient.address = ipField.text;
	demoClient.port = [portField.text intValue];
	[demoClient connect];
}

- (IBAction) sendMessage
{
	[demoClient sendMessage:@"Hey AIR, whats up?"];
}

- (IBAction) startMotion
{
	[demoClient startMotionUpdates];
}

- (IBAction) stopMotion
{
	[demoClient stopMotionUpdates];
}

- (IBAction) openTouchController
{
	SynapseClientLibraryTouchController *cont = [[SynapseClientLibraryTouchController alloc] init];
	cont.client = demoClient;
	[self presentModalViewController:cont animated:YES];
}

#pragma mark Client Delegate

- (void) client:(SYSynapseClient *)client didConnectWithName:(NSString *)name
{
	statusField.text = [NSString stringWithFormat:@"Connected : %@", name];
}

- (void) client:(SYSynapseClient *)client didReceiveMessage:(NSString *)message
{
	messageField.text = message;
}

- (void) client:(SYSynapseClient *)client didDisconnectWithName:(NSString *)name
{
	statusField.text = @"Disconnected";
}

- (void) client:(SYSynapseClient *)client didFailWithError:(NSString *)error
{
	statusField.text = error;
}

#pragma mark Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	
	return NO;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
