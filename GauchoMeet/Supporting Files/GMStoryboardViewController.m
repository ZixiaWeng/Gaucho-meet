//
//  GMStoryboardViewController.m
//  GauchoMeet
//
//  Created by Tyler Weimin Ouyang on 1/31/15.
//  Copyright (c) 2015 Golden. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GMStoryboardViewController.h"



@interface GMStoryboardViewController()

@property (nonatomic, strong) UIViewController *storyboardViewController;

@end



@implementation GMStoryboardViewController



- (Class)class { return [self.storyboardViewController class]; }

- (UIViewController *)storyboardViewController
{
    if(_storyboardViewController == nil)
    {
        
        UIStoryboard *storyboard = nil;
        NSString *identifier = self.restorationIdentifier;
        
        if(identifier)
        {
            @try {
                storyboard = [UIStoryboard storyboardWithName:identifier bundle:nil];
            }
            @catch (NSException *exception) {
                NSLog(@"Exception (%@): Unable to load the Storyboard titled '%@'.", exception, identifier);
            }
        }
        
        _storyboardViewController = [storyboard instantiateInitialViewController];
    }
    
    return _storyboardViewController;
}

- (UINavigationItem *)navigationItem
{
    return self.storyboardViewController.navigationItem ?: [super navigationItem];
}

- (void)loadView
{
    [super loadView];
    
    if(self.storyboardViewController && self.navigationController)
    {
        NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
        
        if(index != NSNotFound)
        {
            NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            [viewControllers replaceObjectAtIndex:index withObject:self.storyboardViewController];
            [self.navigationController setViewControllers:viewControllers animated:NO];
        }
    }
}
- (UIView *)view { return self.storyboardViewController.view; }



@end
