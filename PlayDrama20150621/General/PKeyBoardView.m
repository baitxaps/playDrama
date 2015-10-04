//
//  PlayDrama

//  Created by hairong.chen on 15/7/2.
//  Copyright (c) 2015年 times. All rights reserved.

#define kBtnWidth       54
#define kBtnHeight      30
#define kBtnX            0
#define kBtnY            8
#define kTextViewHeight 30


#import "PKeyBoardView.h"
@interface PKeyBoardView()<UITextViewDelegate>

@property (nonatomic,assign)CGFloat    textViewWidth;
@property (nonatomic,assign)BOOL       isChange;
@property (nonatomic,assign)BOOL       reduce;
@property (nonatomic,assign)CGRect     originalKey;
@property (nonatomic,assign)CGRect     originalText;
@property (nonatomic,strong)UIButton   *sendBtn;
@property (nonatomic,strong)UIButton   *cancelBtn;
@property (nonatomic,assign)int        gap;

@end

@implementation PKeyBoardView

- (void)dealloc
{
    NSLog(@"----dealloc----");
    [self removeNotification];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(0xededed, 1);
        [self initTextView:frame];
        [self registerNotification];
    }
    return self;
}


- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeKeyBoard:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

-(void)initTextView:(CGRect)frame
{
    //cancelBtn
    CGRect cancelFrame  = CGRectMake(kBtnX,kBtnY, kBtnWidth, kBtnHeight);
    self.cancelBtn      = [self customButtonWithFrame:cancelFrame
                                           withAction:@selector(setInputBarViewResignFirstResponder)
                                            BgImgName:nil
                                                 text:@"取消"];
    
    [self addSubview:self.cancelBtn];
    
    //16 + 47, 8, self.frame.size.width - 54 - 16- 30 - 30, 30
    CGRect inputTextFrame   = CGRectMake(kBtnWidth, kBtnY, frame.size.width - 2*kBtnWidth, kTextViewHeight);;
    self.msgTextView        = [[UITextView alloc] init];
    self.msgTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.msgTextView.font   = [UIFont systemFontOfSize:14.f];
    [self.msgTextView setFrame:inputTextFrame];

    [self.msgTextView drawBounderWidth:.5 Color:RGBAColor(240, 169, 109, 1) radius:13];
    self.msgTextView.delegate = self;
    [self addSubview:self.msgTextView];

    CGRect placeHoldFrame   = CGRectMake(5, 0, self.msgTextView.frame.size.width - 10, kTextViewHeight);
    self.placeHoderLabel    = [[UILabel alloc] initWithFrame:placeHoldFrame];
    self.placeHoderLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.placeHoderLabel setTextColor:RGBAColor(200, 200, 200, 1)];
    [self.placeHoderLabel setTextAlignment:NSTextAlignmentLeft];
    [self.msgTextView addSubview:self.placeHoderLabel];
    
    //sendBtn
    CGRect sendFrame = CGRectMake(frame.size.width - kBtnWidth, kBtnY, kBtnWidth, kBtnHeight);
    self.sendBtn     = [self customButtonWithFrame:sendFrame
                                        withAction:@selector(sendTextAction:)
                                         BgImgName:nil
                                              text:@"发送"];
    [self addSubview:self.sendBtn];
    
}

- (UIButton *)customButtonWithFrame:(CGRect)frame
                         withAction:(SEL)action
                          BgImgName:(NSString *)imgName
                               text:(NSString *)text

{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:frame];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:text forState:UIControlStateNormal];
    btn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [btn setExclusiveTouch:YES];
    return btn;
}

- (void)sendTextAction:(UIButton *)sender
{
    NSString *comments =  [self.msgTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([comments length]==0 ||comments==nil) {
        [self makeToast:@"你输入为空,不能发送哦~" duration:1.0 position:@"center" tag:10010];
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(keyBoardViewHide:textView:)]) {
        [self.delegate keyBoardViewHide:self textView:self.msgTextView];
        [self setInputBarViewResignFirstResponder];
    }
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//
//    if ([text isEqualToString:@"\n"]){
//
//        if([self.delegate respondsToSelector:@selector(keyBoardViewHide: textView:)]){
//
//            [self.delegate keyBoardViewHide:self textView:self.msgTextView];
//        }
//        return NO;
//    }
//
//    return YES;
//}

- (void)textViewResignFirstResponder
{
    [self endEditing:YES];
}

- (void)setKeyBoardOffsetGap:(int)gap
{
    _gap = gap;
}


#pragma mark - notification

-(void)changeKeyBoard:(NSNotification *)aNotifacation
{
    CGPoint center = self.center;
    NSValue *keyboardEndBounds = [[aNotifacation userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect endRect = [keyboardEndBounds CGRectValue];
    
    [UIView animateWithDuration:[[aNotifacation.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]
                          delay:0.0f
                        options:[[aNotifacation.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]
                     animations:^{
                         CGPoint Point ;
                         Point = CGPointMake(center.x, endRect.origin.y-86-_gap);
                         if (endRect.origin.y == UIScreenHeight){
                             Point = CGPointMake(center.x, endRect.origin.y + 85);
                         }
                         self.center = Point;
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (void)hiddenOrShowPlaceHolder
{
    if (self.msgTextView.text.length > 0) {
        self.placeHoderLabel.hidden = YES;
    }
    else {
        self.placeHoderLabel.hidden = NO;
    }
}


- (void)textViewDidChange:(UITextView *)textView
{
    [self hiddenOrShowPlaceHolder];
}


- (void)setTextPlaceholder:(NSString *)placeholder
{
    self.placeHoderLabel.text = placeholder;
    self.placeHoderLabel.hidden = NO;
}

- (void)setInputBarViewResignNoClearFirstResponder
{
    [self.msgTextView resignFirstResponder];
    [self setFrame:CGRectMake(0, UIScreenHeight, self.frame.size.width, 44)];
}


- (void)setInputBarViewResignFirstResponder
{
    [self.msgTextView resignFirstResponder];
    [self.msgTextView setText:@""];
    [self setTextPlaceholder:@""];
    [self setFrame:CGRectMake(0, UIScreenHeight, self.frame.size.width, 44)];
}

@end
