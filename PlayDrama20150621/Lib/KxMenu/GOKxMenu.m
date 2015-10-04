//
//  KxMenu.m
//  kxmenu project
//  https://github.com/kolyvan/kxmenu/
//
//  Created by Kolyvan on 17.05.13.
//

/*
 Copyright (c) 2013 Konstantin Bukreev. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 - Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*
 Some ideas was taken from QBPopupMenu project by Katsuma Tanaka.
 https://github.com/questbeat/QBPopupMenu
 */

#import "GOKxMenu.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "Photo.h"

#import "UIView+Draw.h"

#define kMaxScreenHeight   ([UIScreen mainScreen].bounds.size.height)

const CGFloat kArrowSize = 12.f;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface GOKxMenuView : UIView
@end

@interface GOKxMenuOverlay : UIView
@end

@implementation GOKxMenuOverlay

// - (void) dealloc { NSLog(@"dealloc %@", self); }

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        
        UITapGestureRecognizer *gestureRecognizer;
        gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                    action:@selector(singleTap:)];
        [self addGestureRecognizer:gestureRecognizer];
    }
    return self;
}

// thank horaceho https://github.com/horaceho
// for his solution described in https://github.com/kolyvan/kxmenu/issues/9

- (void)singleTap:(UITapGestureRecognizer *)recognizer
{
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[GOKxMenuView class]] && [v respondsToSelector:@selector(dismissMenu:)]) {
            [v performSelector:@selector(dismissMenu:) withObject:@(YES)];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kGOKxMenuDismissNoticeKey object:nil];
}

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@implementation GOKxMenuItem

+ (instancetype) menuItem:(NSString *) title
                    image:(UIImage *) image
                   target:(id)target
                   action:(SEL) action
{
    return [[GOKxMenuItem alloc] init:title
                                image:image
                               target:target
                               action:action];
}

+ (instancetype) menuItem:(NSString *) title
                 imageUrl:(NSString *) imageUrl
         placeholderImage:(UIImage *)placeholderImage
                   target:(id)target
                   action:(SEL) action
{
    return [[GOKxMenuItem alloc] init:title
                             imageUrl:imageUrl
                     placeholderImage:placeholderImage
                               target:target
                               action:action];
}

- (id) init:(NSString *) title
      image:(UIImage *) image
     target:(id)target
     action:(SEL) action
{
    NSParameterAssert(title.length || image);
    
    self = [super init];
    if (self) {
        
        _title = title;
        _image = image;
        _target = target;
        _action = action;
    }
    return self;
}

- (id) init:(NSString *) title
   imageUrl:(NSString *) imageUrl
placeholderImage:(UIImage *)placeholderImage
     target:(id)target
     action:(SEL) action
{
    NSParameterAssert(title.length || imageUrl);
    
    self = [super init];
    if (self) {
        
        _title = title;
        _imageUrl = imageUrl;
        _target = target;
        _action = action;
        _placeholderImage = placeholderImage;
    }
    return self;
}


- (BOOL) enabled
{
    return _target != nil && _action != NULL;
}

- (void) performAction
{
    __strong id target = self.target;
    
    if (target && [target respondsToSelector:_action]) {
        
        [target performSelectorOnMainThread:_action withObject:self waitUntilDone:YES];
    }
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"<%@ #%p %@>", [self class], self, _title];
}

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

typedef enum {
    
    KxMenuViewArrowDirectionNone,
    KxMenuViewArrowDirectionUp,
    KxMenuViewArrowDirectionDown,
    KxMenuViewArrowDirectionLeft,
    KxMenuViewArrowDirectionRight,
    
} KxMenuViewArrowDirection;

@implementation GOKxMenuView {
    
    KxMenuViewArrowDirection    _arrowDirection;
    CGFloat                     _arrowPosition;
    UIScrollView                *_contentView;
    NSArray                     *_menuItems;
    NSUInteger                  _selectedIndex;
}

- (id)init
{
    self = [super initWithFrame:CGRectZero];
    if(self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.opaque = YES;
        self.alpha = 0;
        self.userInteractionEnabled = YES;
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowOffset = CGSizeMake(2, 2);
        self.layer.shadowRadius = 2;
    }
    
    return self;
}

// - (void) dealloc { NSLog(@"dealloc %@", self); }

- (void) setupFrameInView:(UIView *)view
                 fromRect:(CGRect)fromRect
{
    const CGSize contentSize = _contentView.frame.size;
    
    const CGFloat outerWidth = view.bounds.size.width;
    const CGFloat outerHeight = view.bounds.size.height;
    
    const CGFloat rectX0 = fromRect.origin.x;
    const CGFloat rectX1 = fromRect.origin.x + fromRect.size.width;
    const CGFloat rectXM = fromRect.origin.x + fromRect.size.width * 0.5f;
    const CGFloat rectY0 = fromRect.origin.y;
    const CGFloat rectY1 = fromRect.origin.y + fromRect.size.height;
    const CGFloat rectYM = fromRect.origin.y + fromRect.size.height * 0.5f;;
    
    const CGFloat widthPlusArrow = contentSize.width + kArrowSize;
    const CGFloat heightPlusArrow = contentSize.height + kArrowSize;
    const CGFloat widthHalf = contentSize.width * 0.5f;
    const CGFloat heightHalf = contentSize.height * 0.5f;
    
    const CGFloat kMargin = 5.f;
    
    if (heightPlusArrow < (outerHeight - rectY1))
    {
        _arrowDirection = KxMenuViewArrowDirectionUp;
        CGPoint point = (CGPoint){
            rectXM - widthHalf,
            rectY1
        };
        
        if (point.x < kMargin)
            point.x = kMargin;
        
        if ((point.x + contentSize.width + kMargin) > outerWidth)
            point.x = outerWidth - contentSize.width - kMargin;
        
        if (point.y < 0) {
            point.y = kMargin * 4;
        }
        
        _arrowPosition = rectXM - point.x;
        //_arrowPosition = MAX(16, MIN(_arrowPosition, contentSize.width - 16));
        _contentView.frame = (CGRect){0, kArrowSize, contentSize};
        self.frame = (CGRect) {
            point,
            contentSize.width,
            contentSize.height + kArrowSize
        };

        if (contentSize.height > kMaxScreenHeight) {
            _contentView.frame = (CGRect){0,kArrowSize,contentSize.width,kMaxScreenHeight};
            self.frame = (CGRect) {
                
                point,
                contentSize.width,
                kMaxScreenHeight - kMargin * 4
            };
        }
    }
    else if (heightPlusArrow < rectY0)
    {
        _arrowDirection = KxMenuViewArrowDirectionDown;
        CGPoint point = (CGPoint){
            rectXM - widthHalf,
            rectY0 - heightPlusArrow
        };
        
        if (point.x < kMargin)
            point.x = kMargin;
        
        if ((point.x + contentSize.width + kMargin) > outerWidth)
            point.x = outerWidth - contentSize.width - kMargin;
        
        if (point.y < 0) {
            point.y = kMargin  * 4;
        }
        
        _arrowPosition = rectXM - point.x;
        _contentView.frame = (CGRect){CGPointZero, contentSize};
        self.frame = (CGRect) {
            
            point,
            contentSize.width,
            contentSize.height + kArrowSize
        };
        
        if (contentSize.height > kMaxScreenHeight) {
            _contentView.frame = (CGRect){CGPointZero,contentSize.width,kMaxScreenHeight};
            self.frame = (CGRect) {
                
                point,
                contentSize.width,
                kMaxScreenHeight - kMargin * 4
            };
        }
    
    }
    else if (widthPlusArrow < (outerWidth - rectX1))
    {
        _arrowDirection = KxMenuViewArrowDirectionLeft;
        CGPoint point = (CGPoint){
            rectX1,
            rectYM - heightHalf
        };
        
        if (point.y < kMargin)
            point.y = kMargin;
        
        if ((point.y + contentSize.height + kMargin) > outerHeight)
            point.y = outerHeight - contentSize.height - kMargin;
        
        if (point.y < 0) {
            point.y = kMargin * 4;
        }
        
        _arrowPosition = rectYM - point.y;
        _contentView.frame = (CGRect){kArrowSize, 0, contentSize};
        self.frame = (CGRect) {
            
            point,
            contentSize.width + kArrowSize,
            contentSize.height
        };
        
        if (contentSize.height > kMaxScreenHeight) {
            _contentView.frame = (CGRect){kArrowSize,0,contentSize.width,kMaxScreenHeight};
            self.frame = (CGRect) {
                
                point,
                contentSize.width + kArrowSize,
                kMaxScreenHeight - kMargin * 4
            };
        }
      
    }
    else if (widthPlusArrow < rectX0)
    {
        _arrowDirection = KxMenuViewArrowDirectionRight;
        CGPoint point = (CGPoint){
            rectX0 - widthPlusArrow,
            rectYM - heightHalf
        };
        
        if (point.y < kMargin)
            point.y = kMargin;
        
        if ((point.y + contentSize.height + 5) > outerHeight)
            point.y = outerHeight - contentSize.height - kMargin;
        
        if (point.y < 0) {
            point.y = kMargin * 4;
        }
        
        _arrowPosition = rectYM - point.y;
        _contentView.frame = (CGRect){CGPointZero, contentSize};
        if (contentSize.height > kMaxScreenHeight) {
            _contentView.frame = (CGRect){CGPointZero,contentSize.width,kMaxScreenHeight};
            self.frame = (CGRect) {
                
                point,
                contentSize.width  + kArrowSize,
                kMaxScreenHeight - kMargin * 4
            };
        }
    
    }
    else
    {
        _arrowDirection = KxMenuViewArrowDirectionNone;
        if (contentSize.height > kMaxScreenHeight) {
            _contentView.frame = (CGRect){CGPointZero,contentSize.width,kMaxScreenHeight};
        }
        self.frame = (CGRect) {
            
            (outerWidth - contentSize.width)   * 0.5f,
            (outerHeight - contentSize.height) * 0.5f,
            contentSize,
        };
    }
}

- (void)showMenuInView:(UIView *)view
              fromRect:(CGRect)rect
             menuItems:(NSArray *)menuItems
          selectedItem:(NSUInteger)selectedIndex
{
    _menuItems = menuItems;
    _selectedIndex = selectedIndex;
    _contentView = [self mkContentViewAndShowSelectedIndex:YES];
    
    //------------------------------------------------------
   // [_contentView drawBounderWidth:1 Color:[UIColor greenColor]];
    
    [self addSubview:_contentView];
    [self setupFrameInView:view fromRect:rect];
    
    GOKxMenuOverlay *overlay = [[GOKxMenuOverlay alloc] initWithFrame:view.bounds];
    [overlay addSubview:self];
    [view addSubview:overlay];
    _contentView.hidden = YES;
    const CGRect toFrame = self.frame;
    self.frame = (CGRect){self.arrowPoint, 1, 1};
    
    [UIView animateWithDuration:0.2
                     animations:^(void) {
                         
                         self.alpha = 1.0f;
                         self.frame = toFrame;
                         
                     } completion:^(BOOL completed) {
                         _contentView.hidden = NO;
                     }];
    
}


- (void)showMenuInView:(UIView *)view
              fromRect:(CGRect)rect
             menuItems:(NSArray *)menuItems
{
    _menuItems = menuItems;
    
    _contentView = [self mkContentViewAndShowSelectedIndex:NO];
    [self addSubview:_contentView];
    
    [self setupFrameInView:view fromRect:rect];
    
    GOKxMenuOverlay *overlay = [[GOKxMenuOverlay alloc] initWithFrame:view.bounds];
    [overlay addSubview:self];
    [view addSubview:overlay];
    
    _contentView.hidden = YES;
    const CGRect toFrame = self.frame;
    self.frame = (CGRect){self.arrowPoint, 1, 1};
    
    [UIView animateWithDuration:0.2
                     animations:^(void) {
                         
                         self.alpha = 1.0f;
                         self.frame = toFrame;
                         
                     } completion:^(BOOL completed) {
                         _contentView.hidden = NO;
                     }];
    
}

- (void)dismissMenu:(BOOL) animated
{
    if (self.superview) {
        if (animated) {
            
            _contentView.hidden = YES;
            const CGRect toFrame = (CGRect){self.arrowPoint, 1, 1};
            
            [UIView animateWithDuration:0.2
                             animations:^(void) {
                                 
                                 self.alpha = 0;
                                 self.frame = toFrame;
                                 
                             } completion:^(BOOL finished) {
                                 
                                 if ([self.superview isKindOfClass:[GOKxMenuOverlay class]])
                                     [self.superview removeFromSuperview];
                                 [self removeFromSuperview];
                             }];
            
        } else {
            
            if ([self.superview isKindOfClass:[GOKxMenuOverlay class]])
                [self.superview removeFromSuperview];
            [self removeFromSuperview];
        }
    }
}

- (void)performAction:(id)sender
{
    [self dismissMenu:YES];
    
    UIButton *button = (UIButton *)sender;
    GOKxMenuItem *menuItem = _menuItems[button.tag];
    [menuItem performAction];
}

- (UIScrollView *) mkContentViewAndShowSelectedIndex:(BOOL)showSelected
{
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    
    if (!_menuItems.count)
        return nil;
    
    const CGFloat kMinMenuItemHeight = 40.f;
    const CGFloat kMinMenuItemWidth = 40.f;
    const CGFloat kMarginX = 10.f;
    const CGFloat kMarginY = 5.f;
    const CGFloat kSelectedMarkWidth = 8.0f;
    UIFont *titleFont = [GOKxMenu titleFont];
    if (!titleFont) titleFont = [UIFont boldSystemFontOfSize:16];
    
    CGFloat maxImageWidth = 0;
    CGFloat maxItemHeight = 0;
    CGFloat maxItemWidth = 0;
    
    for (GOKxMenuItem *menuItem in _menuItems)
    {
        const CGSize imageSize = menuItem.image.size;
        if (imageSize.width > maxImageWidth)
            maxImageWidth = imageSize.width;
        if (menuItem.imageUrl)
        {
            maxImageWidth = menuItem.placeholderImage.size.width;
        }
    }
    
    if (maxImageWidth) {
        maxImageWidth += kMarginX;
    }
    
    for (GOKxMenuItem *menuItem in _menuItems)
    {
        const CGSize titleSize = [menuItem.title sizeWithFont:titleFont];
        const CGSize imageSize = menuItem.image.size;
        
        const CGFloat itemHeight = MAX(titleSize.height, imageSize.height) + kMarginY * 2;
        const CGFloat itemWidth  = ((!menuItem.enabled && !menuItem.image) ? titleSize.width : maxImageWidth + titleSize.width) + kMarginX * 4;
        if (itemHeight > maxItemHeight)
            maxItemHeight = itemHeight;
        
        if (itemWidth > maxItemWidth)
            maxItemWidth = itemWidth;
    }
    
    maxItemWidth  = MAX(maxItemWidth, kMinMenuItemWidth);
    maxItemHeight = MAX(maxItemHeight, kMinMenuItemHeight);
    if (showSelected)
    {
        maxItemWidth += (kSelectedMarkWidth*2);
    }
    const CGFloat titleX = kMarginX * 2 + maxImageWidth;
    const CGFloat titleWidth = maxItemWidth - titleX - kMarginX * 2;
    
    UIImage *selectedImage = [GOKxMenuView selectedImage:(CGSize){maxItemWidth, maxItemHeight + 2}];
    UIImage *gradientLine  = [GOKxMenuView gradientLine: (CGSize){maxItemWidth - kMarginX * 4, 1}];
    
    UIScrollView *contentView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    contentView.scrollEnabled = YES;
    contentView.autoresizingMask = UIViewAutoresizingNone;
    contentView.backgroundColor = [UIColor clearColor];
    contentView.opaque = NO;
    
    CGFloat itemY = kMarginY * 2;
    NSUInteger itemNum = 0;
    
    for ( NSInteger i = 0; i < _menuItems.count; i ++)
    {
        GOKxMenuItem *menuItem = _menuItems[i];
        const CGRect itemFrame = (CGRect){0, itemY, maxItemWidth, maxItemHeight};
        
        UIView *itemView = [[UIView alloc] initWithFrame:itemFrame];
        itemView.autoresizingMask = UIViewAutoresizingNone;
        itemView.backgroundColor = [UIColor clearColor];
        itemView.opaque = NO;
        [contentView addSubview:itemView];
        
        if (menuItem.enabled)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.exclusiveTouch = YES;
            button.tag = itemNum;
            button.frame = itemView.bounds;
            button.enabled = menuItem.enabled;
            button.backgroundColor = [UIColor clearColor];
            button.opaque = NO;
            button.autoresizingMask = UIViewAutoresizingNone;
            [button addTarget:self action:@selector(performAction:) forControlEvents:UIControlEventTouchUpInside];
            [button setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
            
            [itemView addSubview:button];
        }
        
        if (menuItem.title.length)
        {
            CGRect titleFrame;
            if (!menuItem.enabled && !menuItem.image)
            {
                titleFrame = (CGRect){
                    kMarginX * 2,
                    kMarginY,
                    maxItemWidth - kMarginX * 4,
                    maxItemHeight - kMarginY * 2
                };
            }
            else
            {
                
                titleFrame = (CGRect){
                    titleX,
                    kMarginY,
                    titleWidth,
                    maxItemHeight - kMarginY * 2
                };
            }
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
            titleLabel.text = menuItem.title;
            titleLabel.font = titleFont;
            titleLabel.textAlignment = menuItem.alignment;
            titleLabel.textColor = menuItem.foreColor ? menuItem.foreColor : [UIColor blackColor];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.autoresizingMask = UIViewAutoresizingNone;
            [itemView addSubview:titleLabel];
        }
        
        if (menuItem.image)
        {
            const CGRect imageFrame = {kMarginX * 2, kMarginY, maxImageWidth, maxItemHeight - kMarginY * 2};
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
            imageView.image = menuItem.image;
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeCenter;
            imageView.autoresizingMask = UIViewAutoresizingNone;
            [itemView addSubview:imageView];
            
            if (menuItem.bindImage)
            {
                CGRect bindFrame = {imageFrame.origin.x + imageFrame.size.width - 16,
                    imageFrame.origin.y + imageFrame.size.height - 16, 16, 16};
                UIImageView *bindImage = [[UIImageView alloc] initWithFrame:bindFrame];
                bindImage.image = menuItem.bindImage;
                bindImage.clipsToBounds = YES;
                bindImage.contentMode = UIViewContentModeBottomRight;
                [itemView addSubview:bindImage];
            }
        }
        
        if (menuItem.imageUrl)
        {
            const CGRect imageFrame = {kMarginX * 2, kMarginY, menuItem.placeholderImage.size.width, menuItem.placeholderImage.size.height};
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
            __weak UIImageView *weakImageV = imageView;
            [imageView setImageWithURL:[NSURL URLWithString:menuItem.imageUrl] placeholderImage:menuItem.placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                if (image)
                {
                    image = [Photo scaleImage:image toWidth:menuItem.placeholderImage.size.width toHeight:menuItem.placeholderImage.size.height];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakImageV.image = image;
                    });
                }
            }];
            
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeCenter;
            imageView.autoresizingMask = UIViewAutoresizingNone;
            [itemView addSubview:imageView];
            if (menuItem.bindImage)
            {
                CGRect bindFrame = {imageFrame.origin.x + imageFrame.size.width - 16,
                    imageFrame.origin.y + imageFrame.size.height - 16, 16, 16};
                UIImageView *bindImage = [[UIImageView alloc] initWithFrame:bindFrame];
                bindImage.image = menuItem.bindImage;
                bindImage.clipsToBounds = YES;
                bindImage.contentMode = UIViewContentModeBottomRight;
                [itemView addSubview:bindImage];
            }
        }
        
        if (itemNum < _menuItems.count - 1)
        {
            UIImageView *gradientView = [[UIImageView alloc] initWithImage:gradientLine];
            gradientView.frame = (CGRect){kMarginX * 2, maxItemHeight + 1, gradientLine.size};
            gradientView.contentMode = UIViewContentModeLeft;
            [itemView addSubview:gradientView];
            
            itemY += 2;
        }
        
        //添加选中的标记
        if (i == _selectedIndex && showSelected)
        {
            UIImageView *selectedMarkV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GOUnReadFlag"]];
            selectedMarkV.frame = (CGRect){maxItemWidth - 20,(maxItemHeight - kSelectedMarkWidth)/2,kSelectedMarkWidth,kSelectedMarkWidth};
            selectedMarkV.contentMode = UIViewContentModeScaleAspectFill;
            [itemView addSubview:selectedMarkV];
        }
        itemY += maxItemHeight;
        ++itemNum;
    }
    //设置菜单的最大高度
    CGFloat maxH = MIN(itemY + kMarginY * 2, 370.0);//默认显示7部车
    contentView.frame = (CGRect){0, 0, maxItemWidth, maxH};
    contentView.contentSize = CGSizeMake(maxItemWidth, itemY + kMarginY * 2);
   
    return contentView;
}

- (CGPoint) arrowPoint
{
    CGPoint point;
    
    if (_arrowDirection == KxMenuViewArrowDirectionUp) {
        
        point = (CGPoint){ CGRectGetMinX(self.frame) + _arrowPosition, CGRectGetMinY(self.frame) };
        
    } else if (_arrowDirection == KxMenuViewArrowDirectionDown) {
        
        point = (CGPoint){ CGRectGetMinX(self.frame) + _arrowPosition, CGRectGetMaxY(self.frame) };
        
    } else if (_arrowDirection == KxMenuViewArrowDirectionLeft) {
        
        point = (CGPoint){ CGRectGetMinX(self.frame), CGRectGetMinY(self.frame) + _arrowPosition  };
        
    } else if (_arrowDirection == KxMenuViewArrowDirectionRight) {
        
        point = (CGPoint){ CGRectGetMaxX(self.frame), CGRectGetMinY(self.frame) + _arrowPosition  };
        
    } else {
        
        point = self.center;
    }
    
    return point;
}

+ (UIImage *) selectedImage: (CGSize) size
{
    const CGFloat locations[] = {0,1};
    const CGFloat components[] = {
        0.216, 0.471, 0.871, 1,
        0.059, 0.353, 0.839, 1,
    };
    
    return [self gradientImageWithSize:size locations:locations components:components count:2];
}

+ (UIImage *) gradientLine: (CGSize) size
{
    const CGFloat locations[5] = {0,0.2,0.5,0.8,1};
    
    const CGFloat R = 0.44f, G = 0.44f, B = 0.44f;
    
    const CGFloat components[20] = {
        R,G,B,0.1,
        R,G,B,0.4,
        R,G,B,0.7,
        R,G,B,0.4,
        R,G,B,0.1
    };
    
    return [self gradientImageWithSize:size locations:locations components:components count:5];
}

+ (UIImage *) gradientImageWithSize:(CGSize) size
                          locations:(const CGFloat []) locations
                         components:(const CGFloat []) components
                              count:(NSUInteger)count
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef colorGradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawLinearGradient(context, colorGradient, (CGPoint){0, 0}, (CGPoint){size.width, 0}, 0);
    CGGradientRelease(colorGradient);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void) drawRect:(CGRect)rect
{
    [self drawBackground:self.bounds
               inContext:UIGraphicsGetCurrentContext()];
}

- (void)drawBackground:(CGRect)frame
             inContext:(CGContextRef) context
{
    //CGFloat R0 = 0.267, G0 = 0.303, B0 = 0.335;
    //CGFloat R1 = 0.040, G1 = 0.040, B1 = 0.040;
    
    CGFloat R0 = 1, G0 = 1, B0 = 1;
    CGFloat R1 = 0.95, G1 = 0.95, B1 = 0.95;
    
    UIColor *tintColor = [GOKxMenu tintColor];
    if (tintColor) {
        
        CGFloat a;
        [tintColor getRed:&R0 green:&G0 blue:&B0 alpha:&a];
    }
    
    CGFloat X0 = frame.origin.x;
    CGFloat X1 = frame.origin.x + frame.size.width;
    CGFloat Y0 = frame.origin.y;
    CGFloat Y1 = frame.origin.y + frame.size.height;
    
    // render arrow
    
    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    
    // fix the issue with gap of arrow's base if on the edge
    const CGFloat kEmbedFix = 3.f;
    
    if (_arrowDirection == KxMenuViewArrowDirectionUp) {
        
        const CGFloat arrowXM = _arrowPosition;
        const CGFloat arrowX0 = arrowXM - kArrowSize;
        const CGFloat arrowX1 = arrowXM + kArrowSize;
        const CGFloat arrowY0 = Y0;
        const CGFloat arrowY1 = Y0 + kArrowSize + kEmbedFix;
        
        [arrowPath moveToPoint:    (CGPoint){arrowXM, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowXM, arrowY0}];
        
        [[UIColor colorWithRed:R0 green:G0 blue:B0 alpha:1] set];
        
        Y0 += kArrowSize;
        
    } else if (_arrowDirection == KxMenuViewArrowDirectionDown) {
        
        const CGFloat arrowXM = _arrowPosition;
        const CGFloat arrowX0 = arrowXM - kArrowSize;
        const CGFloat arrowX1 = arrowXM + kArrowSize;
        const CGFloat arrowY0 = Y1 - kArrowSize - kEmbedFix;
        const CGFloat arrowY1 = Y1;
        
        [arrowPath moveToPoint:    (CGPoint){arrowXM, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowXM, arrowY1}];
        
        [[UIColor colorWithRed:R1 green:G1 blue:B1 alpha:1] set];
        
        Y1 -= kArrowSize;
        
    } else if (_arrowDirection == KxMenuViewArrowDirectionLeft) {
        
        const CGFloat arrowYM = _arrowPosition;
        const CGFloat arrowX0 = X0;
        const CGFloat arrowX1 = X0 + kArrowSize + kEmbedFix;
        const CGFloat arrowY0 = arrowYM - kArrowSize;;
        const CGFloat arrowY1 = arrowYM + kArrowSize;
        
        [arrowPath moveToPoint:    (CGPoint){arrowX0, arrowYM}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowYM}];
        
        [[UIColor colorWithRed:R0 green:G0 blue:B0 alpha:1] set];
        
        X0 += kArrowSize;
        
    } else if (_arrowDirection == KxMenuViewArrowDirectionRight) {
        
        const CGFloat arrowYM = _arrowPosition;
        const CGFloat arrowX0 = X1;
        const CGFloat arrowX1 = X1 - kArrowSize - kEmbedFix;
        const CGFloat arrowY0 = arrowYM - kArrowSize;;
        const CGFloat arrowY1 = arrowYM + kArrowSize;
        
        [arrowPath moveToPoint:    (CGPoint){arrowX0, arrowYM}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowYM}];
        
        [[UIColor colorWithRed:R1 green:G1 blue:B1 alpha:1] set];
        
        X1 -= kArrowSize;
    }
    
    [arrowPath fill];
    
    // render body
    
    const CGRect bodyFrame = {X0, Y0, X1 - X0, Y1 - Y0};
    
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:bodyFrame
                                                          cornerRadius:8];
    
    const CGFloat locations[] = {0, 1};
    const CGFloat components[] = {
        R0, G0, B0, 1,
        R1, G1, B1, 1,
    };
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace,
                                                                 components,
                                                                 locations,
                                                                 sizeof(locations)/sizeof(locations[0]));
    CGColorSpaceRelease(colorSpace);
    
    
    [borderPath addClip];
    
    CGPoint start, end;
    
    if (_arrowDirection == KxMenuViewArrowDirectionLeft ||
        _arrowDirection == KxMenuViewArrowDirectionRight) {
        
        start = (CGPoint){X0, Y0};
        end = (CGPoint){X1, Y0};
        
    } else {
        
        start = (CGPoint){X0, Y0};
        end = (CGPoint){X0, Y1};
    }
    
    CGContextDrawLinearGradient(context, gradient, start, end, 0);
    
    CGGradientRelease(gradient);
}

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

static GOKxMenu *gMenu;
static UIColor *gTintColor;
static UIFont *gTitleFont;

@implementation GOKxMenu {
    
    GOKxMenuView *_menuView;
    BOOL        _observing;
}

+ (instancetype) sharedMenu
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        gMenu = [[GOKxMenu alloc] init];
    });
    return gMenu;
}

- (id) init
{
    NSAssert(!gMenu, @"singleton object");
    
    self = [super init];
    if (self) {
    }
    return self;
}

- (void) dealloc
{
    if (_observing) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void) showMenuInView:(UIView *)view
               fromRect:(CGRect)rect
              menuItems:(NSArray *)menuItems
{
    NSParameterAssert(view);
    NSParameterAssert(menuItems.count);
    
    if (_menuView) {
        
        [_menuView dismissMenu:NO];
        _menuView = nil;
    }
    
    if (!_observing) {
        
        _observing = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationWillChange:)
                                                     name:UIApplicationWillChangeStatusBarOrientationNotification
                                                   object:nil];
    }
    
    
    _menuView = [[GOKxMenuView alloc] init];
    [_menuView showMenuInView:view fromRect:rect menuItems:menuItems];
}

- (void) showMenuInView:(UIView *)view
               fromRect:(CGRect)rect
              menuItems:(NSArray *)menuItems
           selectedItem:(NSUInteger)selectedIndex
{
    NSParameterAssert(view);
    NSParameterAssert(menuItems.count);
    
    if (_menuView) {
        
        [_menuView dismissMenu:NO];
        _menuView = nil;
    }
    
    if (!_observing) {
        
        _observing = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationWillChange:)
                                                     name:UIApplicationWillChangeStatusBarOrientationNotification
                                                   object:nil];
    }
    
    
    _menuView = [[GOKxMenuView alloc] init];
    [_menuView showMenuInView:view fromRect:rect menuItems:menuItems selectedItem:selectedIndex];
}
- (void) dismissMenu
{
    if (_menuView) {
        
        [_menuView dismissMenu:NO];
        _menuView = nil;
    }
    
    if (_observing) {
        
        _observing = NO;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void) orientationWillChange: (NSNotification *) n
{
    [self dismissMenu];
}

+ (void) showMenuInView:(UIView *)view
               fromRect:(CGRect)rect
              menuItems:(NSArray *)menuItems
{
    [[self sharedMenu] showMenuInView:view fromRect:rect menuItems:menuItems];
}

+ (void) showMenuInView:(UIView *)view
               fromRect:(CGRect)rect
              menuItems:(NSArray *)menuItems
           selectedItem:(NSUInteger)selectedIndex
{
    [[self sharedMenu] showMenuInView:view fromRect:rect menuItems:menuItems selectedItem:selectedIndex];
}

+ (void) dismissMenu
{
    [[self sharedMenu] dismissMenu];
}

+ (UIColor *) tintColor
{
    return gTintColor;
}

+ (void) setTintColor: (UIColor *) tintColor
{
    if (tintColor != gTintColor) {
        gTintColor = tintColor;
    }
}

+ (UIFont *) titleFont
{
    return gTitleFont;
}

+ (void) setTitleFont: (UIFont *) titleFont
{
    if (titleFont != gTitleFont) {
        gTitleFont = titleFont;
    }
}

@end
