//
//  RBPhoneContentViewController.h
//  TheRapBoard
//
//  Created by Andy Roth on 11/11/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
	RBViewModeGrid,
	RBViewModeList
} RBViewMode;

@interface RBPhoneContentViewController : UIViewController
{
	IBOutlet UIView *_contentViewContainer;
	IBOutlet UIButton *_gridButton;
	IBOutlet UIButton *_listButton;
}

- (IBAction) toggleViewMode:(id)sender;

@end
