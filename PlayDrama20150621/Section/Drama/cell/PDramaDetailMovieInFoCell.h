//
//  PDramaDetailTableViewCell.h
//  PlayDrama
//
//  Created by RHC on 15/4/25.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PDramaEntity;

@interface PDramaDetailMovieInFoCell : UITableViewCell

@property (nonatomic,strong)PDramaEntity *dramaEntity;

+ (PDramaDetailMovieInFoCell *)loadCell;

- (CGFloat)tableViewWithData:(PDramaEntity *)dramaEntity heightForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
