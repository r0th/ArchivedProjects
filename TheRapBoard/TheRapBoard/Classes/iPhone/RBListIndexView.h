//
//  RBListIndexView.h
//  TheRapBoard
//
//  Created by Andy Roth on 11/15/11.
//  Copyright (c) 2011 AKQA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RBListIndexViewDelegate <NSObject>

- (void) viewDidSelectIndex:(NSString *)index;

@end

@interface RBListIndexView : UIView

@property (nonatomic, assign) id <RBListIndexViewDelegate> delegate;

@end
