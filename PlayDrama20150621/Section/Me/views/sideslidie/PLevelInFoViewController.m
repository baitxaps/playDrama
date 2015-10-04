//
//  PLevelIInFoViewController.m
//  PlayDrama
//
//  Created by hairong.chen on 15/7/30.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PLevelInFoViewController.h"
#import "PlayTabBarViewController.h"

@interface PLevelInFoViewController ()

@end

@implementation PLevelInFoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *leftItem = \
    [[UIBarButtonItem alloc] initWithText:@"返回"
                                   target:self
                                   action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = leftItem;

}


- (void)backAction:(id)sender
{
    UIViewController *barvc     =[PlayTabBarViewController shareInstance];
    UINavigationController *nav =[[UINavigationController alloc] initWithRootViewController:barvc];
    
    [self.sideMenuViewController setContentViewController:nav animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
