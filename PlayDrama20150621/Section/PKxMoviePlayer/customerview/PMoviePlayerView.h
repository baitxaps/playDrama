//
//  PMoviePlayerView.h
//  PlayDrama
//
//  Created by RHC on 15/5/26.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^LimitFullScreenBlock)(BOOL isFullScreen);

@interface PMoviePlayerView : UIView

@property (copy,nonatomic)LimitFullScreenBlock limitFullScreenBlock;
@property (weak, nonatomic) IBOutlet UILabel  *movieTextLabel;//影片名称
@property (weak,nonatomic) UIViewController *viewController;
@property (readonly) BOOL                      playing;

+ (PMoviePlayerView *)initNib;
- (void)playWithContentPath: (NSString *) path parameters: (NSDictionary *) parameters;
- (void)hidetopContainerView:(BOOL)hide;
- (void)viewDidAppear;
- (void)viewWillDisappear;

@end
