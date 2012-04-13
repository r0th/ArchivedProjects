//
//  RBListAdlibCell.h
//  TheRapBoard
//
//  Created by Andy Roth on 11/15/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBRapperAdlib.h"
#import "RBRapperButton.h"
#import "RBPageControl.h"

@interface RBListAdlibCell : UIView <UIGestureRecognizerDelegate>
{
	IBOutlet RBRapperButton *_button;
	IBOutlet UILabel *_nameLabel;
	IBOutlet UILabel *_adlibLabel;
	IBOutlet RBPageControl *_pageControl;
}

- (void) setAdlib:(RBRapperAdlib *)adlib;

@end
