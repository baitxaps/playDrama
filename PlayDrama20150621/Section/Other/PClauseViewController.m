//
//  PClauseViewController.m
//  PlayDrama
//
//  Created by RHC on 15/4/16.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PClauseViewController.h"

@interface PClauseViewController ()
@property (weak, nonatomic) IBOutlet UITextView *ternsOfServiceTextView;
@end

@implementation PClauseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithText:@"注册协议"
                                                               target:self
                                                               action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    NSError *error = nil;
    NSString *contentStr = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NSLocalizedString(@"clause", nil) ofType:@"txt"] encoding:NSUTF8StringEncoding error:&error];
    [self.ternsOfServiceTextView setText:contentStr];
}

- (void)backAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
