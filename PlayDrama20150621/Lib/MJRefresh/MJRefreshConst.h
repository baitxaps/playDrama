//
//  MJRefreshConst.h
//  MJRefresh
//
//  Created by mj on 14-1-3.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#ifdef DEBUG
#define MJLog(...) NSLog(__VA_ARGS__)
#else
#define MJLog(...)
#endif

#define MJColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
// 文字颜色
#define MJRefreshLabelTextColor MJColor(150, 150, 150)
#import <UIKit/UIKit.h>

extern const CGFloat MJRefreshViewHeight;
extern const CGFloat MJRefreshFastAnimationDuration;
extern const CGFloat MJRefreshSlowAnimationDuration;

extern NSString *const MJRefreshBundleName;
#define MJRefreshSrcName(file) [MJRefreshBundleName stringByAppendingPathComponent:file]

#define  MJRefreshFooterPullToRefresh    NSLocalizedString(@"上拉可以加载更多数据", nil)
#define  MJRefreshFooterReleaseToRefresh NSLocalizedString(@"松开立即加载更多数据", nil)
#define  MJRefreshFooterRefreshing       NSLocalizedString(@"正在加载数据...", nil);
#define  MJRefreshHeaderPullToRefresh    NSLocalizedString(@"下拉可以刷新", nil);
#define  MJRefreshHeaderReleaseToRefresh NSLocalizedString(@"正在刷新...", nil)
#define  MJRefreshHeaderRefreshing       NSLocalizedString(@"最后更新", nil)


extern NSString *const MJRefreshHeaderTimeKey;
extern NSString *const MJRefreshContentOffset;
extern NSString *const MJRefreshContentSize;














