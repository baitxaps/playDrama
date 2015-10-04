//
//  PSearcherView.h
//  PlayDrama
//
//  Created by RHC on 15/4/9.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol searchForDataDelegate <NSObject>

- (void)searchForData:(NSString *)text;

@end

@interface PSearcherView : UIView

@property (weak,   nonatomic) IBOutlet UILabel          *textLabel;
@property (weak,   nonatomic) IBOutlet UITextField      *searchTextField;
@property (assign ,nonatomic) id<searchForDataDelegate>delegate;
@property (assign ,nonatomic) UIViewController          *viewController;

+(PSearcherView *)initNib;
- (void)hideWithDuration:(NSTimeInterval)duration animated:(BOOL)animated;
- (void)showWithDuration:(NSTimeInterval)duration animated:(BOOL)animated;
- (void)textFieldResignFirstResponder;
- (void)show;
- (void)hide;
@end
