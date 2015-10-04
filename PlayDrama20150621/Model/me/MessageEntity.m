//
//  MessageEntity.m
//  PlayDrama
//
//  Created by hairong.chen on 15/8/5.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "MessageEntity.h"
#import "PUILayoutConst.h"


@interface MessageEntity ()
@property (nonatomic,assign) CGRect    rtLabelViewRect;
@end

@implementation MessageEntity

+ (instancetype)GroupWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        
        NSString *msg = dict[@"msg"];
        msg = msg.length >0? msg:@"";
        
        CGFloat width        = UIScreenWidth - kWidthOffset;
        CGFloat Height       = [self heightWithString:dict[@"msg"] width:width];
        self.rtLabelViewRect = (CGRect){{KCellXGapBetweenSubViews,KCellYGapBetweenSubViews}, {width,Height}};
    }
    return self;
}

- (instancetype)initWithString:(NSString *)string
{
    if (self = [super init]) {
        
        CGFloat width          = UIScreenWidth - kWidthOffset;
        CGFloat heightOffset   = [self heightWithString:string width:width]- kRTLabelHeight;
        self.rtLabelViewRect   = \
        (CGRect){{KCellXGapBetweenSubViews,KCellXGapBetweenSubViews}, {width,heightOffset + kCellBoundsHeight}};
        self.msg                = string;
    }
    return self;
}

- (CGFloat)heightWithString:(NSString *)string width:(CGFloat)width
{
    CGFloat height = [string heightWithFixWidth:width font:kBase15Font];
    
    return height + KCellXGapBetweenSubViews ;
}

@end
