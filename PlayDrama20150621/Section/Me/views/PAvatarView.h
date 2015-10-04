//
//  PMeUserHeadView.h
//  PlayDrama
//
//  Created by hairong.chen on 15/8/5.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^UploadAvatarBlock) (UIImage *image);

@interface PAvatarView : UIView
@property (nonatomic, weak)  UIViewController *withController_;
@property (nonatomic,strong) NSMutableArray   *imageArray;//选择的图片
@property (nonatomic,  copy) UploadAvatarBlock uploadAvatarBlock;

+ (PAvatarView *) initWithNib;
- (void)avtarImageViewUpdate:(NSString *)url;//上传更新
@end
