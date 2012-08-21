//
//  KFPhotoDetailContainerViewController.m
//  Kaffeine
//
//  Created by Andy Roth on 8/21/12.
//  Copyright (c) 2012 AKQA. All rights reserved.
//

#import "KFPhotoDetailContainerViewController.h"
#import "KFPhotoDetailViewController.h"

@interface KFPhotoDetailContainerViewController ()
{
@private
    KFPhotoDetailViewController *_currentViewController;
    KFPhotoDetailViewController *_nextViewController;
}

@end

@implementation KFPhotoDetailContainerViewController

@synthesize delegate = _delegate;

- (id)initWithPhoto:(KFPhoto *)photo
{
    self = [super init];
    if (self)
    {
        _currentViewController = [[KFPhotoDetailViewController alloc] initWithPhoto:photo];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Icon-Back.png"] style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    [backButton release];
	
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Icon-Cart.png"] style:UIBarButtonItemStylePlain target:self action:@selector(purchaseItem)];
	self.navigationItem.rightBarButtonItem = addButton;
	[addButton release];
	
    [self.view addSubview:_currentViewController.view];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeRight:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    [swipeRight release];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeLeft:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    [swipeLeft release];
}

- (void)purchaseItem
{
    [_currentViewController purchaseItem];
}

- (void)didSwipeRight:(UISwipeGestureRecognizer *)reco
{
    KFPhoto *previousPhoto = [_delegate photoPreviousToPhoto:_currentViewController.photo];
    if (previousPhoto)
    {
        _nextViewController = [[KFPhotoDetailViewController alloc] initWithPhoto:previousPhoto];
        _nextViewController.view.frame = CGRectMake(-320, 0, 320, _nextViewController.view.frame.size.height);
        [self.view addSubview:_nextViewController.view];
        
        [UIView animateWithDuration:0.3 animations:^{
            _currentViewController.view.frame = CGRectMake(320, 0, 320, _currentViewController.view.frame.size.height);
            _nextViewController.view.frame = CGRectMake(0, 0, 320, _nextViewController.view.frame.size.height);
        }
                         completion:^(BOOL finished)
        {
            [_currentViewController.view removeFromSuperview];
            [_currentViewController release];
            
            _currentViewController = _nextViewController;
            _nextViewController = nil;
        }];
    }
}

- (void)didSwipeLeft:(UISwipeGestureRecognizer *)reco
{
    KFPhoto *nextPhoto = [_delegate photoNextFromPhoto:_currentViewController.photo];
    if (nextPhoto)
    {
        _nextViewController = [[KFPhotoDetailViewController alloc] initWithPhoto:nextPhoto];
        _nextViewController.view.frame = CGRectMake(320, 0, 320, _nextViewController.view.frame.size.height);
        [self.view addSubview:_nextViewController.view];
        
        [UIView animateWithDuration:0.3 animations:^
        {
            _currentViewController.view.frame = CGRectMake(-320, 0, 320, _currentViewController.view.frame.size.height);
            _nextViewController.view.frame = CGRectMake(0, 0, 320, _nextViewController.view.frame.size.height);
        }
                         completion:^(BOOL finished)
        {
             [_currentViewController.view removeFromSuperview];
             [_currentViewController release];
             
             _currentViewController = _nextViewController;
             _nextViewController = nil;
        }];
    }
}

@end
