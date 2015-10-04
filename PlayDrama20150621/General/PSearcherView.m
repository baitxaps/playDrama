//
//  PSearcherView.m
//  PlayDrama
//
//  Created by RHC on 15/4/9.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PSearcherView.h"

@interface PSearcherView()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@end

@implementation PSearcherView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.searchTextField.delegate = self;
    [self.searchTextField setValue:RGB(0xb3b0b0, 1)
                        forKeyPath:@"_placeholderLabel.textColor"];
    [self.searchTextField  setValue:[UIFont boldSystemFontOfSize:13]
                         forKeyPath:@"_placeholderLabel.font"];
    self.searchBtn.exclusiveTouch = YES;
    self.textLabel.font = PNAVGATION_Font;
    
    //[self.searchTextField drawBounderWidth:1 Color:[UIColor blackColor]];
    self.backgroundColor = RGB(0x111111,0.2);
}

+(PSearcherView *)initNib
{
    PSearcherView *view = nil;
    view = [[NSBundle mainBundle] loadNibNamed:@"PSearcherView" owner:self options:nil][0];
    return view;
}


- (void)hideWithDuration:(NSTimeInterval)duration animated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:duration animations:^{
           [self alphaWithNum:0.f];
        }];
    }else{
       [self alphaWithNum:0.f];
    }
}

- (void)showWithDuration:(NSTimeInterval)duration animated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:duration animations:^{
            [self alphaWithNum:1.f];
        }];
    }else{
        [self alphaWithNum:1.f];
    }
}

- (void)hide
{
   [self alphaWithNum:0.f];
}

- (void)show
{
    [self alphaWithNum:1.f];
}


- (void)alphaWithNum:(CGFloat)num
{
    self.searchBtn.alpha        = num;
    self.searchTextField.alpha  = num;
}

- (IBAction)searchAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(searchForData:)]) {
        [self textFieldResignFirstResponder];
        [self.delegate searchForData:self.searchTextField.text];
    }
}

- (void)textFieldResignFirstResponder
{
    [self.searchTextField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self textFieldResignFirstResponder];
    return YES;
}



//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    self.viewController.navigationController.navigationBarHidden = YES;
//    [self searchview];
//}


-(UIView *)searchview
{
    UIView *sv = [self viewWithTag:10086];
    if (!sv) {
        sv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
        [self addSubview:sv];
        sv.backgroundColor   = [UIColor redColor];
        sv.tag               = 10086;
        UITapGestureRecognizer  *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeSearchView)];
        [sv addGestureRecognizer:gesture];
    }
    return sv;
}



- (void)closeSearchView
{
    UIView *sv = [self viewWithTag:10086];
    [sv removeFromSuperview];
    self.viewController.navigationController.navigationBarHidden = NO;
}

@end
