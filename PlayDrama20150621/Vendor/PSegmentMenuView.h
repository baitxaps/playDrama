//
//  GOMenuView.h
//  golo
//
//  Created by Chenhairong on 14/11/12.
//  Copyright (c) 2014年 hechao. All rights reserved.
//
/**
 * 1:这个类是项目中栏目选择的类，采用动态布局，maxItemsCountPerPage用于设置屏幕的一行显示的栏目个数，如果menuItemArray的个数大于用户设置的maxItemsCountPerPage，这时候是可以左右滑动的，isShowMoreIndicator用于设置是否显示下拉，下拉列表会将全部的item罗列出来，罗列的格式按照列数等于maxItemsCountPerPage的格式。
 * 2:可以设置currentSelectedIndex属性的值，滑动到当前选择的item。
 **/
#import <UIKit/UIKit.h>
#define kGOSegmentMenuViewH 40.f
extern const NSUInteger ItemBtnBaseTag;
typedef void (^GOMenuItemBlock)(NSInteger index);
typedef NS_ENUM(NSInteger, GOMenuContentType)
{
    GOMenuContentTypeDefault = 0,//默认风格，只展示一个标签
    GOMenuContentTypeContentWithUnreadMark,//在右上角带有未读消息个数标记的
    GOMenuContentTypeContentWithUnreadDot//在标题右边加未读的小点
};
@interface PSegmentMenuView : UIView
@property (strong, nonatomic)UIColor        *selectedIndexColor;//选中的index的标签字颜色，选中指示条的颜色跟这个颜色一致
@property (strong, nonatomic)UIColor        *unSelectedIndexColor;//未选中的index的标签字颜色
@property (strong, nonatomic)NSMutableArray *menuItemArray;//栏目数据源，设置了
@property (assign, nonatomic)NSInteger      maxItemsCountPerPage;//屏幕的一行显示的栏目个数
@property (assign, nonatomic)NSUInteger     currentSelectedIndex;//当前选中的index
@property (copy, nonatomic) GOMenuItemBlock menuItemBlock;//点击了某个index的block回调
@property (assign, nonatomic)BOOL           isShowAllIndicator;//是否显示更多下拉按钮
@property (strong, nonatomic)UIColor       *selectColor;        //字体选择颜色
- (instancetype)initWithFrame:(CGRect)frame type:(GOMenuContentType)type;
/**
 *  更新某个index的标题
 *
 *  @param index 下标
 *  @param title 标题
 */
- (void)updateTitleAtIndex:(NSInteger)index withTitle:(NSString *)title;
/**
 *  更新某个index的未读消息个数 type为GOMenuContentTypeContentWithUnreadMark才有未读标签
 *
 *  @param index 下标
 *  @param count 未读消息个数 多余100显示99+
 */
- (void)updateUnreadCountAtIndex:(NSInteger)index withCount:(NSInteger)count;
/**
 *  设置某个index有未读提示 type为GOMenuContentTypeContentWithUnreadDot的才有新消息标记
 *
 *  @param index      菜单的下标
 *  @param shouldShow 是否显示未读标记
 */
- (void)updateUnreadDotAtIndex:(NSInteger)index shouldShow:(BOOL)shouldShow;

/**
 *  显示红点，针对GOMenuContentTypeContentWithUnreadMark类型的。
 *
 *  @param menuIndex 菜单索引
 *  @param isShow    是否显示红点
 */
- (void)isShowDotAtIndex:(NSInteger)menuIndex isShow:(BOOL)isShow;
/**
 *  获取某个index上显示的未读消息的个数
 *
 *  @param menuIndex 菜单的index
 *
 *  @return 红点的未读消息个数
 */
- (NSInteger)getUnreadCountAtIndex:(NSInteger)menuIndex;
@end
