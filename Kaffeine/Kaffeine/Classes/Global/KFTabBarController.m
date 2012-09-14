//
//  KFTabBarController.m
//  Kaffeine
//
//  Created by Andy Roth on 4/11/12.
//  Copyright (c) 2012 AKQA. All rights reserved.
//

#import "KFTabBarController.h"

#import "KFCatalogViewController.h"
#import "KFLibraryViewController.h"
#import "KFTermsViewController.h"

@interface KFTabBarController ()
{
@private
    UIViewController *_catalogNavController;
	UIViewController *_libraryNavController;
	UIViewController *_termsViewController;
    
    UIButton *_catalogButton;
    UIButton *_libraryButton;
    UIButton *_termsButton;
    
    UIViewController *_currentViewController;
}

@end

@implementation KFTabBarController

- (void)viewDidLoad
{
    KFCatalogViewController *catalogViewController = [[KFCatalogViewController alloc] init];
	KFLibraryViewController *libraryViewController = [[KFLibraryViewController alloc] initWithStyle:UITableViewStylePlain];
	_termsViewController = [[KFTermsViewController alloc] init];
	
	_catalogNavController = [[UINavigationController alloc] initWithRootViewController:catalogViewController];
	_libraryNavController = [[UINavigationController alloc] initWithRootViewController:libraryViewController];
    
    [catalogViewController release];
    [libraryViewController release];
    
    // Create the bottom bar with buttons
    UIView *tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height  - 44, 320, 44)];
    tabBar.backgroundColor = [UIColor blackColor];
    [self.view addSubview:tabBar];
    
    _catalogButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 1, 106, 43)];
    _libraryButton = [[UIButton alloc] initWithFrame:CGRectMake(107, 1, 106, 43)];
    _termsButton = [[UIButton alloc] initWithFrame:CGRectMake(214, 1, 106, 43)];
    
    [_catalogButton setBackgroundImage:[UIImage imageNamed:@"TabBarButton-Deselected.png"] forState:UIControlStateNormal];
    [_libraryButton setBackgroundImage:[UIImage imageNamed:@"TabBarButton-Deselected.png"] forState:UIControlStateNormal];
    [_termsButton setBackgroundImage:[UIImage imageNamed:@"TabBarButton-Deselected.png"] forState:UIControlStateNormal];
    [_catalogButton setBackgroundImage:[UIImage imageNamed:@"TabBarButton-Selected.png"] forState:UIControlStateSelected];
    [_libraryButton setBackgroundImage:[UIImage imageNamed:@"TabBarButton-Selected.png"] forState:UIControlStateSelected];
    [_termsButton setBackgroundImage:[UIImage imageNamed:@"TabBarButton-Selected.png"] forState:UIControlStateSelected];
    
    [_catalogButton setTitle:@"Catalog" forState:UIControlStateNormal];
    [_libraryButton setTitle:@"Library" forState:UIControlStateNormal];
    [_termsButton setTitle:@"Terms" forState:UIControlStateNormal];
    
    _catalogButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
    _libraryButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
    _termsButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
    
    [tabBar addSubview:_catalogButton];
    [tabBar addSubview:_libraryButton];
    [tabBar addSubview:_termsButton];
    
    [_catalogButton addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventTouchUpInside];
    [_libraryButton addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventTouchUpInside];
    [_termsButton addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self tappedButton:_catalogButton];
}

- (void)tappedButton:(UIButton *)button
{
    if (button == _catalogButton && _currentViewController != _catalogNavController)
    {
        _catalogButton.selected = YES;
        _libraryButton.selected = NO;
        _termsButton.selected = NO;
        
        [_currentViewController.view removeFromSuperview];
        _currentViewController = _catalogNavController;
        _currentViewController.view.frame = CGRectMake(0, 0, 320, 416);
        [self.view insertSubview:_currentViewController.view atIndex:0];
    }
    else if (button == _libraryButton && _currentViewController != _libraryNavController)
    {
        _catalogButton.selected = NO;
        _libraryButton.selected = YES;
        _termsButton.selected = NO;
        
        [_currentViewController.view removeFromSuperview];
        _currentViewController = _libraryNavController;
        _currentViewController.view.frame = CGRectMake(0, 0, 320, 416);
        [self.view insertSubview:_currentViewController.view atIndex:0];
    }
    else if (button == _termsButton && _currentViewController != _termsViewController)
    {
        _catalogButton.selected = NO;
        _libraryButton.selected = NO;
        _termsButton.selected = YES;
        
        [_currentViewController.view removeFromSuperview];
        _currentViewController = _termsViewController;
        _currentViewController.view.frame = CGRectMake(0, 0, 320, 416);
        [self.view insertSubview:_currentViewController.view atIndex:0];
    }
}

- (void)reloadCategories
{
    KFCatalogViewController *catalog = (KFCatalogViewController *)[_catalogNavController.childViewControllers objectAtIndex:0];
    [catalog tryReload];
}

- (void)dealloc
{
    [_catalogNavController release];
    [_libraryNavController release];
    [_termsViewController release];
    
    [_catalogButton release];
    [_libraryButton release];
    [_termsButton release];
    
    [super dealloc];
}

@end
