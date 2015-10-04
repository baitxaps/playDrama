//
//  PRootViewController.m
//  PlayDrama
//
//  Created by hairong.chen on 15/7/30.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PRootViewController.h"
#import "PMeSlideViewController.h"
#import "PlayTabBarViewController.h"

@interface PRootViewController ()

@end

@implementation PRootViewController

- (void)awakeFromNib
{
    self.menuPreferredStatusBarStyle    = UIStatusBarStyleLightContent;
    self.contentViewShadowColor         = [UIColor blackColor];
    self.contentViewShadowOffset        = CGSizeMake(0, 0);
    self.contentViewShadowOpacity       = 0.6;
    self.contentViewShadowRadius        = 12;
    self.contentViewShadowEnabled       = YES;
    
   // self.contentViewController          = \
    [self.storyboard instantiateViewControllerWithIdentifier:DRAMACONTENT_STORYBOARDID];
    self.contentViewController        = [PlayTabBarViewController shareInstance];
    self.contentViewController.view.backgroundColor = [UIColor blackColor];//防止侧滑出现白条
    
    UIStoryboard *sliderBoard           = [UIStoryboard storyboardWithName:PSLIDER_STORYBOARD
                                                                    bundle:[NSBundle mainBundle]];
    self.rightMenuViewController        =\
    [sliderBoard instantiateViewControllerWithIdentifier:DRAMARSLIDER_STORYBOARDID];
    
    
    
    self.backgroundImage                = [UIImage imageNamed:@"slider_BG"];
    self.delegate                       = self;
}


#pragma mark -
#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    PDebugLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    PDebugLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    PDebugLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    PDebugLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
