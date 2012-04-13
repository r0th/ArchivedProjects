//
//  SynapseClientLibraryTouchController.m
//  SynapseClientLibrary
//
//  Created by Roth on 8/26/10.
//  Copyright 2010 Roozy. All rights reserved.
//

#import "SynapseClientLibraryTouchController.h"


@implementation SynapseClientLibraryTouchController

@synthesize client;

- (IBAction) close
{
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self.view];
	
	if(client) [client sendTouchX:point.x/self.view.frame.size.width y:point.y/self.view.frame.size.height];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self.view];
	
	if(client) [client sendTouchX:point.x/self.view.frame.size.width y:point.y/self.view.frame.size.height];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
