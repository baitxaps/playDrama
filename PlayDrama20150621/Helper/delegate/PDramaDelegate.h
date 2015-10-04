//
//  PDramaDelegate.h
//  PlayDrama
//
//  Created by hairong.chen on 15/7/23.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PDramaDelegate <NSObject>
@optional

- (void)tableViewCellImageClickInIndexPath:(NSIndexPath *)indexPath imgIndex:(NSInteger)index; // 点击cell里面的图片
- (void)tableViewCellClickInIndexPath:(NSIndexPath *)indexPath;
- (void)tableViewCellClickInCell:(UITableViewCell *)cell;
- (void)tableViewCommentsCell:(UITableViewCell *)cell;
- (void)tableViewCellClickWithView:(id )view indexPath:(NSIndexPath *)indexPath;
- (void)tableViewCellClickInIndexPath:(NSIndexPath *)indexPath isExpand:(BOOL)isExpand;
- (void)tableViewCellClickInIndexPath:(NSIndexPath *)indexPath cellIndex:(NSInteger)cellIndex;

//- (void)zoneBaseTableViewCellNameLabelClickInIndexPath:(NSIndexPath *)indexPath;
//- (void)workShopListTableViewCellCommentsShouldOpen:(BOOL)shouldOpen indexPath:(NSIndexPath *)indexPath;
//- (void)workShopListTableViewCellCommentsNameClick:(NSString *)uid indexPath:(NSIndexPath *)indexPath;
//- (void)workShopListTableViewCellDidSelected:(NSIndexPath *)indexPath type:(GOShareCellSelectedType)type object:(id)obj;
//- (void)workShopListTableViewCellGroupNameLabelClickInIndexPath:(NSIndexPath *)indexPath;
//- (BOOL)workShopListTableViewCellCanShowDeleteMenuInIndexPath:(NSIndexPath *)indexPath; // 是否可以显示
@end
