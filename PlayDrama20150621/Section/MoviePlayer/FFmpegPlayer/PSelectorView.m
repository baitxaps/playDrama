//
//  PDramaChoiceAorBView.m
//  PlayDrama
//
//  Created by hairong.chen on 15/7/6.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PSelectorView.h"
#define KPDramaABtnType          2008 //Ａ
#define kPDramaBBtnType          2009 //B

@interface PSelectorView()
@property (weak, nonatomic) IBOutlet UIView *optionAView;
@property (weak, nonatomic) IBOutlet UIView *optionBView;
@property (weak, nonatomic) IBOutlet UIButton *optionABtn;
@property (weak, nonatomic) IBOutlet UIButton *optionBBtn;
@property (weak, nonatomic) IBOutlet UILabel *optionATextLabel;
@property (weak, nonatomic) IBOutlet UILabel *optionBTextLabel;
@end

@implementation PSelectorView


+ (PSelectorView *) initWithNib
{
    PSelectorView *view = nil;
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PSelectorView"
                                                   owner:self
                                                 options:nil];
    for (id obj in array) {
        if ([obj isKindOfClass:[PSelectorView class]]) {
            view = (PSelectorView *)obj;
            break;
        }
    }
    return view;
}


- (void) awakeFromNib
{
    [super awakeFromNib];
    self.optionBView.backgroundColor = RGB(0xe9ca5d, 0.7);
    self.optionAView.backgroundColor = RGB(0x4eb07c, 0.7);
    
    self.optionATextLabel.textColor  = RGB(0x212121, 1);
    self.optionBTextLabel.textColor  = RGB(0x212121, 1);
    
    self.optionATextLabel.font       = [UIFont systemFontOfSize:13.0];
    self.optionBTextLabel.font       = [UIFont systemFontOfSize:13.0];
    
    self.optionABtn.tag              = KPDramaABtnType;
    self.optionBBtn.tag              = kPDramaBBtnType;
    
    UITapGestureRecognizer *gs       = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                              action:@selector(hide)];
    [self addGestureRecognizer:gs];
}


- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray              = dataArray;
    _optionATextLabel.text  = @"A";
    _optionBTextLabel.text  = @"B";
    
}

- (IBAction)dramaOptionAction:(id)sender
{
    NSInteger type = ((UIButton *)sender).tag - KPDramaABtnType;
    if (self.dramaOptionBlock && _dataArray.count){
        self.dramaOptionBlock(_dataArray[type]);
    }
}

- (void)hide
{
    CGRect  frame  = self.frame;
    frame.origin.y = UIScreenHeight + UIScreenWidth;
    //[UIView animateWithDuration:0.5 animations:^{
    [self setFrame: frame];
    // }];
}


@end
