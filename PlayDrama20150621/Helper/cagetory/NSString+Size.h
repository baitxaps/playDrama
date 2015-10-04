//
//  NSString+Size.h
//  X431AutoDiag
//
//  Created by chenhairong on 14-3-11.
//  Copyright (c) 2014年 cnLaunch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Size)

/*
 * 文字宽度 (1行, 最大宽度为预设CGFLOAT_MAX)
 */
- (CGFloat)widthWithFont:(UIFont *)font;

/*
 * 文字宽度 (1行, 最大宽度为maxWidth)
 */
- (CGFloat)widthWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth;

/*
 * 固定宽度的文字高度
 */
- (CGFloat)heightWithFixWidth:(CGFloat)width font:(UIFont *)font;
- (CGSize)getWidthWithText:(NSString*)text andFont:(UIFont*)font;
- (CGSize)sizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth;
/*
 * 文字size (1行)
 */
- (CGSize)textSizeWithFont:(UIFont *)font;

/*
 * 文字size
 */
- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;


/*
 * 文字size
 */
- (CGSize)textDrawAtPoint:(CGPoint)point withFont:(UIFont *)font;

- (CGSize)textDrawInRect:(CGRect)rect withFont:(UIFont *)font;

- (CGSize)textDrawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode;

- (CGSize)textDrawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)textAlignment;

@end
