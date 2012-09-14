//
//  KFInfoViewController.m
//  Kaffeine
//
//  Created by Andy Roth on 9/14/12.
//  Copyright (c) 2012 AKQA. All rights reserved.
//

#import "KFInfoViewController.h"

@interface KFInfoViewController ()

@property (nonatomic, assign) IBOutlet UITextView *textView;

- (IBAction)close:(id)sender;

@end

@implementation KFInfoViewController

- (void)viewDidLoad
{
    UIImageView *backgroundTexture = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundTexture.png"]];
    [self.view insertSubview:backgroundTexture atIndex:0];
    
    _textView.backgroundColor = [UIColor clearColor];
    _textView.font = [UIFont systemFontOfSize:16.0];
}

- (IBAction)close:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
