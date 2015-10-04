//
//  GOMenuView.m
//  golo
//
//  Created by Chenhairong on 14/11/12.
//  Copyright (c) 2014年 Chenhairong. All rights reserved.
//
#import "PSegmentMenuView.h"
#import "PMenuCollectionCell.h"

const CGFloat IndicatorViewW = 30.0;
const NSUInteger ItemBtnBaseTag = 1000;
const NSUInteger kUnreadLabelBaseTag = 2000;
const NSUInteger kUnreadDotBaseTag = 3000;
const CGFloat LineViewH = 3.0f;
const CGFloat TextFontSizeUnselected = 14.0;
const CGFloat TextFontSizeSelected = 16.0;
const CGFloat ViewMargin = 5.0;
const CGFloat MaxCollectionViewH = 200.0;
const CGFloat kUnreadLabelSize = 14.0;
const CGFloat kUnreadDotSize = 10.0;
static NSString *cellIdentifer = @"cellIdentifer";

@interface PSegmentMenuView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>

@property (strong, nonatomic)UIScrollView           *scrollView;//menu 父视图
@property (strong, nonatomic)UIView                 *lineView;//滑动色条视图
@property (strong, nonatomic)UIButton               *indicatorBtn;//more指示按钮
@property (strong, nonatomic)UIView                 *allMenuView;//所有菜单下拉视图
@property (strong, nonatomic)UICollectionView       *collectionView;
@property (strong, nonatomic)UIView                 *mySuperView;
@property (assign, nonatomic)BOOL                   isShowAllMenuView;
@property (assign, nonatomic)GOMenuContentType      menuType;

@end
@implementation PSegmentMenuView

- (instancetype)initWithFrame:(CGRect)frame type:(GOMenuContentType)type
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.autoresizesSubviews = NO;
        _menuType = type;
        [self defaultSettings];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)updateTitleAtIndex:(NSInteger)index withTitle:(NSString *)title
{
    if (index > _menuItemArray.count || !title || title.length == 0)
    {
        return;
    }
    
    [_menuItemArray replaceObjectAtIndex:index withObject:title];
    UIButton *tmpBtn = (UIButton *)[_scrollView viewWithTag:ItemBtnBaseTag + index];
    [tmpBtn setTitle:title forState:UIControlStateNormal];
}

- (void)updateUnreadCountAtIndex:(NSInteger)index withCount:(NSInteger)count
{
    if (_menuType != GOMenuContentTypeContentWithUnreadMark || index > _menuItemArray.count)
    {
        return;
    }
    UILabel *unreadL = (UILabel *)[_scrollView viewWithTag:kUnreadLabelBaseTag + index];
    if (count == 0)
    {
        unreadL.text = @"";
        unreadL.hidden = YES;
    }else
    {
        CGRect unreadFrame = unreadL.frame;
        unreadFrame.size = CGSizeMake(kUnreadLabelSize, kUnreadLabelSize);
        unreadL.frame = unreadFrame;
        unreadL.layer.cornerRadius = kUnreadLabelSize/2;
        unreadL.hidden = NO;
        if (count >= 100)
        {
            unreadL.text = @"99+";
        }else
        {
            unreadL.text = [NSString stringWithFormat:@"%ld",(long)count];
        }
    }
}

- (void)isShowDotAtIndex:(NSInteger)menuIndex isShow:(BOOL)isShow
{
    if (_menuType != GOMenuContentTypeContentWithUnreadMark || menuIndex > _menuItemArray.count)
    {
        return;
    }
    UILabel *unreadL = (UILabel *)[_scrollView viewWithTag:kUnreadLabelBaseTag + menuIndex];
    if (!isShow)
    {
        unreadL.hidden = YES;
        unreadL.text = @"";
    }else
    {
        CGRect unreadFrame = unreadL.frame;
        unreadFrame.size = CGSizeMake(kUnreadDotSize, kUnreadDotSize);
        unreadL.frame = unreadFrame;
        unreadL.layer.cornerRadius = kUnreadDotSize/2;
        unreadL.text = @"";
        unreadL.hidden = NO;
    }
}

- (NSInteger)getUnreadCountAtIndex:(NSInteger)menuIndex
{
    NSInteger unreadCount = 0;
    if (_menuType != GOMenuContentTypeContentWithUnreadMark || menuIndex > _menuItemArray.count)
    {
        return unreadCount;
    }
    UILabel *unreadL = (UILabel *)[_scrollView viewWithTag:kUnreadLabelBaseTag + menuIndex];
    NSString *unreadCountS = unreadL.text;
    if (unreadCountS && unreadCountS.length)
    {
        unreadCount = [unreadCountS integerValue];
    }else
    {
        unreadCount = 0;
    }
    return unreadCount;
}

- (void)updateUnreadDotAtIndex:(NSInteger)index shouldShow:(BOOL)shouldShow
{
    if (_menuType != GOMenuContentTypeContentWithUnreadDot || index > _menuItemArray.count)
    {
        return;
    }
    UIImageView *unreadImageV = (UIImageView *)[_scrollView viewWithTag:kUnreadDotBaseTag + index];
    unreadImageV.hidden = !shouldShow;
}

- (void)defaultSettings
{
    _selectedIndexColor   = LightGreenColor;
    _unSelectedIndexColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.0];
    _maxItemsCountPerPage = 3;
    _isShowAllIndicator = NO;
    _currentSelectedIndex = 0;
    //self.backgroundColor = [UIColor colorWithRed:247.0/255 green:247.0/255 blue:247.0/255 alpha:1.0];
    self.backgroundColor = [UIColor blackColor];
}

- (void)setMenuItemArray:(NSMutableArray *)menuItemArray
{
    _menuItemArray = menuItemArray;
    if (_menuItemArray.count < 1)
    {
        return;
    }else
    {
        [self setupSubViews];
    }
}
//栏目的宽度
- (CGFloat)menuItemWidth
{
    CGFloat viewW = self.frame.size.width - ViewMargin*(_maxItemsCountPerPage + 1);
    if (_isShowAllIndicator)
    {
        viewW = viewW - IndicatorViewW;
    }
    return viewW/_maxItemsCountPerPage;//每个menu的宽度
}
//栏目的高度
- (CGFloat)menuItemHeight
{
    return self.frame.size.height - LineViewH;
}

- (void)setScrollViewFrame
{
    if (_isShowAllIndicator)
    {
        _scrollView.frame = CGRectMake(0.0, 0.0, self.frame.size.width - IndicatorViewW, self.frame.size.height - 1);
    }else
    {
        _scrollView.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height - 1);
    }
    CGFloat itemW = [self menuItemWidth];
    _scrollView.contentSize = CGSizeMake(_menuItemArray.count *itemW + (_menuItemArray.count + 1)*ViewMargin, self.frame.size.height);
    _scrollView.contentOffset = CGPointMake(0, 0);
    _scrollView.clipsToBounds = YES;
}

- (void)setupSubViews
{
    const NSInteger menuCount = _menuItemArray.count;
    if (menuCount < _maxItemsCountPerPage)
    {
        _maxItemsCountPerPage = menuCount;
    }
    
    if (_maxItemsCountPerPage > menuCount)
    {
        NSAssert(1, @"Max items count per page should not be larger than items total count!");
        return;
    }
    _scrollView = [[UIScrollView alloc] init];
    [self setScrollViewFrame];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    UIView *tlineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, 1)];
    tlineView.backgroundColor = [UIColor whiteColor];
    [self addSubview:tlineView];
    
    CGFloat itemW = [self menuItemWidth];
    CGFloat itemH = [self menuItemHeight];
    for (NSInteger index = 0; index < _menuItemArray.count; index ++)
    {
        @autoreleasepool {
            UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            itemBtn.exclusiveTouch = YES;
            itemBtn.frame = CGRectMake(ViewMargin*(index + 1) + itemW*index, 1, itemW, itemH);//0.0
            BOOL isSelected = (index == _currentSelectedIndex) ? YES :NO;
            itemBtn.tag = index + ItemBtnBaseTag;
            [itemBtn addTarget:self action:@selector(menuItemPressed:) forControlEvents:UIControlEventTouchUpInside];
            if (isSelected)
            {
                itemBtn.titleLabel.font = [UIFont systemFontOfSize:TextFontSizeSelected];
                [itemBtn setTitleColor:_selectedIndexColor forState:UIControlStateNormal];
            }else
            {
                itemBtn.titleLabel.font = [UIFont systemFontOfSize:TextFontSizeUnselected];
                [itemBtn setTitleColor:_unSelectedIndexColor forState:UIControlStateNormal];
            }
            [itemBtn setTitle:_menuItemArray[index] forState:UIControlStateNormal];
//            itemBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
            [_scrollView addSubview:itemBtn];
            if (_menuType == GOMenuContentTypeContentWithUnreadMark)//添加未读的标记
            {
                CGFloat menuTitleWidth = [self menuTitleWidthAtIndex:index];
                CGFloat orginX = itemBtn.center.x + menuTitleWidth/2 - 3;
                CGRect unreadLabelFrame = CGRectMake(orginX, 0.0, kUnreadLabelSize, kUnreadLabelSize);
                UILabel *unreadLabel = [[UILabel alloc] initWithFrame:unreadLabelFrame];
                CGPoint center = unreadLabel.center;
                center.y = itemBtn.center.y;
                unreadLabel.center = center;
                unreadLabel.backgroundColor = kUnreadBgColor;
                unreadLabel.layer.cornerRadius = kUnreadLabelSize/2;
                unreadLabel.layer.masksToBounds = YES;
                unreadLabel.font = [UIFont systemFontOfSize:8.0];
                unreadLabel.textColor = [UIColor whiteColor];
                unreadLabel.textAlignment = NSTextAlignmentCenter;
                unreadLabel.adjustsFontSizeToFitWidth = YES;
                unreadLabel.tag = index + kUnreadLabelBaseTag;
                //unreadLabel.text = @"99+";
                unreadLabel.hidden = YES;
                [_scrollView addSubview:unreadLabel];
            }else if (_menuType == GOMenuContentTypeContentWithUnreadDot)
            {
                CGFloat menuTitleWidth = [self menuTitleWidthAtIndex:index];
                CGFloat orginX = itemBtn.center.x + menuTitleWidth/2;
                CGFloat orginY = itemBtn.center.y - kUnreadDotSize/2;
                CGRect unreadDotFrame = CGRectMake(orginX, orginY, kUnreadDotSize, kUnreadDotSize);
                UIImageView *unreadMarkV = [[UIImageView alloc] initWithFrame:unreadDotFrame];
                unreadMarkV.contentMode = UIViewContentModeScaleToFill;
                unreadMarkV.image = [UIImage imageNamed:@"GOUnReadFlag"];
                unreadMarkV.tag = index + kUnreadDotBaseTag;
                unreadMarkV.hidden = YES;
                [_scrollView addSubview:unreadMarkV];
            }
        }
    }
    if (_isShowAllIndicator)
    {
        //设置下拉按钮
        _indicatorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _indicatorBtn.exclusiveTouch = YES;
        _indicatorBtn.frame = CGRectMake(ViewMargin*(_maxItemsCountPerPage + 1) + itemW * _maxItemsCountPerPage, 0.0, IndicatorViewW, itemH);
        UIImage *image = [UIImage imageNamed:@"close"];
        [_indicatorBtn setImage:image forState:UIControlStateNormal];
        _indicatorBtn.transform = CGAffineTransformRotate(_indicatorBtn.transform, M_PI_2);
        [_indicatorBtn addTarget:self action:@selector(allMenuBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_indicatorBtn];
    }
    //设置指示条
    if (menuCount > 1)
    {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(ViewMargin*(_currentSelectedIndex + 1) + _currentSelectedIndex*itemW, 0 , itemW, LineViewH)];
        _lineView.backgroundColor = _selectColor;
        [_scrollView addSubview:_lineView];
    }
}
#pragma mark - Private Methods

- (CGFloat)menuTitleWidthAtIndex:(NSInteger)index
{
    NSString *titleS = _menuItemArray[index];
    CGFloat maxW = [self menuItemWidth];
    CGSize titleSize = [titleS sizeWithFont:[UIFont systemFontOfSize:TextFontSizeSelected] constrainedToSize:CGSizeMake(maxW, kGOSegmentMenuViewH) lineBreakMode:NSLineBreakByCharWrapping];
    
    return titleSize.width;
}

//下拉三角按钮事件
- (void)allMenuBtnPressed:(UIButton *)sender
{
    if (_isShowAllMenuView)
    {
        return;
    }
    [self showAllMenuView];
}

- (void)menuItemPressed:(UIButton *)sender
{
    if (_isShowAllMenuView)
    {
        [self hideAllMenuView];
    }
    self.currentSelectedIndex = sender.tag - ItemBtnBaseTag;
}

- (void)setCurrentSelectedIndex:(NSUInteger)currentSelectedIndex
{
    _currentSelectedIndex = currentSelectedIndex;
    [self setCurrentIndex:_currentSelectedIndex withAnimate:YES];
}

- (void)setCurrentIndex:(NSUInteger)index withAnimate:(BOOL)animated
{
    //设置button的状态
    for (NSInteger i = 0; i < _menuItemArray.count; i ++)
    {
        UIButton *tmpBtn = (UIButton *)[self viewWithTag:ItemBtnBaseTag + i];
        BOOL isSelected = NO;
        isSelected = (tmpBtn.tag == ItemBtnBaseTag + index)? YES:NO;
        if (isSelected)
        {
            tmpBtn.titleLabel.font = [UIFont systemFontOfSize:TextFontSizeSelected];
            [tmpBtn setTitleColor:_selectColor forState:UIControlStateNormal];
           
        }else
        {
            tmpBtn.titleLabel.font = [UIFont systemFontOfSize:TextFontSizeUnselected];
            [tmpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    //设置lineView的位置
    CGRect lineFrame = _lineView.frame;
    CGFloat itemW = [self menuItemWidth];
    lineFrame = CGRectMake(ViewMargin*(_currentSelectedIndex + 1) + _currentSelectedIndex*itemW, lineFrame.origin.y, itemW, LineViewH);
    if (animated)
    {
        [UIView animateWithDuration:0.3 animations:^{
            _lineView.frame = lineFrame;
        }];
    }else
    {
        _lineView.frame = lineFrame;
    }
    
    //如果选中的index的不在屏幕内，滑动显示出来
    CGRect rect = CGRectMake(ViewMargin*(_currentSelectedIndex + 1) + [self menuItemWidth]*_currentSelectedIndex, 0.0, [self menuItemWidth], [self menuItemHeight]);
    [_scrollView scrollRectToVisible:rect animated:YES];
    if (_menuItemBlock)
    {
        _menuItemBlock(_currentSelectedIndex);
    }
}

#pragma mark - All Menu view
- (void)bgTappedAction:(UITapGestureRecognizer *)gesture
{
    [self hideAllMenuView];
}

//展示所有菜单视图
- (void)showAllMenuView
{
    _isShowAllMenuView = YES;
    _mySuperView = self.superview;
    if (!_allMenuView)
    {
        CGRect frame = [self convertRect:self.frame toView:_mySuperView];
        CGFloat orginY = CGRectGetMaxY(self.frame);
        CGFloat allMenuViewH = UIScreenHeight - orginY;
        _allMenuView = [[UIView alloc] initWithFrame:CGRectMake(0, orginY, frame.size.width, allMenuViewH)];
        _allMenuView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        
        UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];
        [_allMenuView addGestureRecognizer:bgTap];
        
        CGFloat collectionViewH = [self collectionViewHeight];
        CGFloat collectionCellW = (self.frame.size.width - ViewMargin*(_maxItemsCountPerPage + 1))/ _maxItemsCountPerPage;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(collectionCellW, self.frame.size.height - ViewMargin);
        flowLayout.sectionInset = UIEdgeInsetsMake(ViewMargin, 0.0, 0.0, 0.0);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, orginY, frame.size.width, collectionViewH) collectionViewLayout:flowLayout];
        [_collectionView registerClass:[PMenuCollectionCell class] forCellWithReuseIdentifier:cellIdentifer];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        //添加allMenuView 到self 的父视图
        [_mySuperView addSubview:_allMenuView];
        [_mySuperView addSubview:_collectionView];
    }
    CGRect menuFrame = _allMenuView.frame;
    [UIView animateWithDuration:0.3 animations:^{
        _allMenuView.frame = CGRectMake(menuFrame.origin.x, menuFrame.origin.y, menuFrame.size.width, 0);
        _allMenuView.alpha = 0.0;
        _collectionView.alpha = 0.0;
        
        _allMenuView.alpha = 1.0;
        _collectionView.alpha = 1.0;
        _allMenuView.frame = menuFrame;
    }];
    [_collectionView reloadData];
}

- (void)hideAllMenuView
{
    CGRect menuFrame = _allMenuView.frame;
    [UIView animateWithDuration:0.3 animations:^{
        _allMenuView.frame = menuFrame;
        _allMenuView.alpha = 1.0;
        _collectionView.alpha = 1.0;
        
        _allMenuView.alpha = 0.0;
        _collectionView.alpha = 0.0;
        _allMenuView.frame = CGRectMake(menuFrame.origin.x, menuFrame.origin.y, menuFrame.size.width, 0);
    } completion:^(BOOL finished) {
        [_collectionView removeFromSuperview];
        [_allMenuView removeFromSuperview];
        _collectionView = nil;
        _allMenuView = nil;
        _isShowAllMenuView = NO;
    }];
}

- (CGFloat)collectionViewHeight
{
    CGFloat cellH = self.frame.size.height + ViewMargin;//ViewMargin是collection的sectionInset的top的值
    CGFloat itemCount = [[NSNumber numberWithInteger:_maxItemsCountPerPage] floatValue];
    CGFloat rowN = ceilf(_menuItemArray.count/itemCount);
    return MIN(rowN*cellH + ViewMargin, MaxCollectionViewH);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _menuItemArray.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PMenuCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];
    cell.menuBtn.tag = indexPath.row;
    [cell.menuBtn setTitle:_menuItemArray[indexPath.row] forState:UIControlStateNormal];
    [cell.menuBtn setTitleColor:_unSelectedIndexColor forState:UIControlStateNormal];
    cell.menuBtn.userInteractionEnabled = NO;
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self hideAllMenuView];
    [self setCurrentSelectedIndex:indexPath.row];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    offset.y = 0;
    scrollView.contentOffset = offset;
}
@end
