//
//  SynapseClientLibraryAppDelegate.h
//  SynapseClientLibrary
//
//  Created by Roth on 8/20/10.
//  Copyright 2010 Roozy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SynapseClientLibraryViewController;

@interface SynapseClientLibraryAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SynapseClientLibraryViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SynapseClientLibraryViewController *viewController;

@end

