//
//  HHTabBar.m
//  HHTabBarController
//
//  Created by 崔辉辉 on 2019/11/15.
//  Copyright © 2019 huihui. All rights reserved.
//

#import "HHTabBar.h"
#import "HHTabBar+Indicator.h"
#import "HHTabBar+Item.h"
@interface HHTabBar()

/// TabBar支持滚动时，需要使用此scrollView
@property (nonatomic, strong)UIScrollView *scrollView;

/// 当item匹配title的文字宽度时，左右留出空隙，item的宽度 = 文字宽度 + spacing
@property (nonatomic, assign)CGFloat itemFitTextWidthSpacing;


/// item的属性
@property (nonatomic, assign)CGFloat itemWidth;
@property (nonatomic, assign)CGFloat itemMinWidth;

@end

@implementation HHTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setup];
    }
    return self;
}
- (void)_setup
{
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    
    _selectedItemIndex = NSNotFound;
    self.itemTitleColor = [UIColor whiteColor];
    self.itemTitleSelectedColor = [UIColor blackColor];
    self.itemTitleFont = [UIFont systemFontOfSize:10];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollEnabled = NO;
    [self addSubview:_scrollView];
    
    _indicatorImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [_scrollView addSubview:_indicatorImageView];
}
- (void)setClipsToBounds:(BOOL)clipsToBounds
{
    [super setClipsToBounds:clipsToBounds];
    self.scrollView.clipsToBounds = clipsToBounds;
}
- (void)setFrame:(CGRect)frame
{
    BOOL resize = !CGSizeEqualToSize(frame.size, self.frame.size);
    [super setFrame:frame];
    if (resize) {
        self.scrollView.frame = self.bounds;
        [self updateAllUI];
    }
}
- (void)setItems:(NSArray<HHTabItem *> *)items
{
    _selectedItemIndex = NSNotFound;
    
    //将老的item从superview上移除
    [_items makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _items = [items copy];
    
    //初始化每一个item
    for (HHTabItem *item in self.items) {
        item.titleColor = self.itemTitleColor;
        item.titleSelectedColor = self.itemTitleSelectedColor;
        item.titleFont = self.itemTitleFont;
        
        [item addTarget:self action:@selector(tabItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:item];
    }
    
    //更新item的大小缩放
    [self updateItemsScaleIfNeeded];
    [self updateAllUI];
}
- (void)setTitles:(NSArray<NSString *> *)titles
{
    NSMutableArray *items = [NSMutableArray array];
    for (NSString *title in titles) {
        HHTabItem *item = [[HHTabItem alloc]init];
        item.title = title;
        [items addObject:item];
    }
    self.items = items;
}
- (void)setLeadingSpace:(CGFloat)leadingSpace
{
    _leadingSpace = leadingSpace;
    [self updateAllUI];
}
- (void)setTrailingSpace:(CGFloat)trailingSpace
{
    _trailingSpace = trailingSpace;
    [self updateAllUI];
}

- (void)updateAllUI
{
    [self updateItemsFrame];
    //更新items的indicatorInsets
    [self updateItemIndicatorInsets];
    [self updateIndicatorFrameWithIndex:self.selectedItemIndex];
}
- (void)updateItemsFrame
{
    if (self.items.count == 0) {
        return;
    }
    
    if (self.scrollView.scrollEnabled) {
        //支持滚动
        CGFloat x = self.leadingSpace;
        for (NSUInteger index = 0; index < self.items.count; index++) {
            HHTabItem *item = self.items[index];
            CGFloat width = 0;
            //item的宽度为一个固定值
            if (self.itemWidth > 0) {
                width = self.itemWidth;
            }
            //item的宽度为根据字体大小和spacing进行适配
            if (self.itemFitTextWidth) {
                width = MAX(item.titleWidth + self.itemFitTextWidthSpacing, self.itemMinWidth);
            }
            item.frame = CGRectMake(x, 0, width, self.frame.size.height);
            item.index = index;
            x += width;
        }
        self.scrollView.contentSize = CGSizeMake(MAX(x + self.trailingSpace, self.scrollView.frame.size.width), self.scrollView.frame.size.height);
    } else {
        //不支持滚动
        CGFloat x = self.leadingSpace;
        CGFloat allItemsWidth = self.frame.size.width - self.leadingSpace - self.trailingSpace;
        self.itemWidth = allItemsWidth / self.items.count;
        
        //四舍五入，取整，防止字体模糊
        self.itemWidth = floorf(self.itemWidth + 0.5f);
        
        for (NSUInteger index = 0; index < self.items.count; index++) {
            HHTabItem *item = self.items[index];
            item.frame = CGRectMake(x, 0, self.itemWidth, self.frame.size.height);
            item.index = index;
            
            x += self.itemWidth;
        }
        self.scrollView.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
    }
}

- (void)setSelectedItemIndex:(NSUInteger)selectedItemIndex
{
    [self setSelectedItemIndex:selectedItemIndex animated:self.indicatorSwitchAnimated callDelegate:YES];
}
- (void)setSelectedItemIndex:(NSUInteger)selectedItemIndex
                    animated:(BOOL)animated
{
    [self setSelectedItemIndex:selectedItemIndex animated:animated callDelegate:YES];
}
- (void)setSelectedItemIndex:(NSUInteger)selectedItemIndex
                    animated:(BOOL)animated
                callDelegate:(BOOL)callDelegate
{
    if (selectedItemIndex == _selectedItemIndex || selectedItemIndex >= self.items.count || self.items.count == 0) {
        return;
    }
    
    if (callDelegate && self.delegate && [self.delegate respondsToSelector:@selector(hh_tabBar:shouldSelectItemAtIndex:)]) {
        BOOL should = [self.delegate hh_tabBar:self shouldSelectItemAtIndex:selectedItemIndex];
        if (!should) {
            return;
        }
    }
    if (callDelegate && self.delegate && [self.delegate respondsToSelector:@selector(hh_tabBar:willSelectItemAtIndex:)]) {
        [self.delegate hh_tabBar:self willSelectItemAtIndex:selectedItemIndex];
    }
    
    if (_selectedItemIndex != NSNotFound) {
        HHTabItem *oldSelectedItem = self.items[_selectedItemIndex];
        oldSelectedItem.selected = NO;
        if (self.itemTitleSelectedFont) {
            if (self.itemFontChangeFollowContentScroll) {
                // 如果支持字体平滑渐变切换，则设置item的scale
                oldSelectedItem.transform = CGAffineTransformMakeScale(self.itemTitleUnselectedFontScale, self.itemTitleUnselectedFontScale);
                oldSelectedItem.titleFont = [self.itemTitleFont fontWithSize:self.itemTitleSelectedFont.pointSize];
            } else {
                oldSelectedItem.titleFont = self.itemTitleFont;
            }
        }
    }
    
    HHTabItem *newSelectedItem = self.items[selectedItemIndex];
    newSelectedItem.selected = YES;
    
    if (self.itemTitleSelectedFont) {
        if (self.itemFontChangeFollowContentScroll) {
            // 如果支持字体平滑渐变切换，则设置item的scale
            newSelectedItem.transform = CGAffineTransformMakeScale(1, 1);
        }
        newSelectedItem.titleFont = self.itemTitleSelectedFont;
    }
    
    if (animated && _selectedItemIndex != NSNotFound) {
        [UIView animateWithDuration:0.25f animations:^{
            [self updateIndicatorFrameWithIndex:selectedItemIndex];
        }];
    } else {
        [self updateIndicatorFrameWithIndex:selectedItemIndex];
    }
    
    _selectedItemIndex = selectedItemIndex;
    
    // 如果tabbar支持滚动，将选中的item放到tabbar的中央
    [self setSelectedItemCenter];
    
    if (callDelegate && self.delegate && [self.delegate respondsToSelector:@selector(hh_tabBar:didSelectedItemAtIndex:)]) {
        [self.delegate hh_tabBar:self didSelectedItemAtIndex:selectedItemIndex];
    }
}

- (void)setScrollEnabledAndItemWidth:(CGFloat)width
{
    self.scrollView.scrollEnabled = YES;
    self.itemWidth = width;
    self.itemFitTextWidth = NO;
    self.itemFitTextWidthSpacing = 0;
    self.itemMinWidth = 0;
    [self updateItemsFrame];
}
- (void)setScrollEnabledAndItemFitTextWidthWithSpacing:(CGFloat)spacing
{
    [self setScrollEnabledAndItemFitTextWidthWithSpacing:spacing minWidth:0];
}
- (void)setScrollEnabledAndItemFitTextWidthWithSpacing:(CGFloat)spacing minWidth:(CGFloat)minWidth
{
    self.scrollView.scrollEnabled = YES;
    self.itemFitTextWidth = YES;
    self.itemFitTextWidthSpacing = spacing;
    self.itemWidth = 0;
    self.itemMinWidth = minWidth;
    [self updateItemsFrame];
}

- (void)setSelectedItemCenter
{
    if (!self.scrollView.scrollEnabled) {
        return;
    }
    //修改偏移量
    CGFloat offsetX = self.selectedItem.center.x - self.scrollView.frame.size.width * 0.5f;
    
    //处理最小滚动偏移量
    if (offsetX < 0) {
        offsetX = 0;
    }
    
    //处理最大滚动偏移量
    CGFloat maxOffsetX = self.scrollView.contentSize.width - self.scrollView.frame.size.width;
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}
- (void)tabItemClicked:(HHTabItem *)item
{
    self.selectedItemIndex = item.index;
}

#pragma mark - 获取未选中字体与选中字体大小的比例
- (CGFloat)itemTitleUnselectedFontScale
{
    if (self.itemTitleSelectedFont) {
        return self.itemTitleFont.pointSize / self.itemTitleSelectedFont.pointSize;
    }
    return 1.0f;
}
- (HHTabItem *)selectedItem
{
    if (self.selectedItemIndex == NSNotFound) {
        return nil;
    }
    return self.items[self.selectedItemIndex];
}

- (void)updateItemsScaleIfNeeded
{
    if (self.itemTitleSelectedFont && self.itemFontChangeFollowContentScroll && self.itemTitleSelectedFont.pointSize != self.itemTitleFont.pointSize) {
        UIFont *normalFont = [self.itemTitleFont fontWithSize:self.itemTitleSelectedFont.pointSize];
        
        for (HHTabItem *item in self.items) {
            if (item.selected) {
                item.titleFont = self.itemTitleSelectedFont;
            } else {
                item.titleFont = normalFont;
                item.transform = CGAffineTransformMakeScale(self.itemTitleUnselectedFontScale, self.itemTitleUnselectedFontScale);
            }
        }
    }
}

- (void)updateSubViewsWhenParentScrollViewScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat scrollViewWidth = scrollView.frame.size.width;
    
    NSUInteger leftIndex = offsetX / scrollViewWidth;
    NSUInteger rightIndex = leftIndex + 1;
    
    HHTabItem *leftItem = self.items[leftIndex];
    HHTabItem *rightItem = nil;
    if (rightIndex < self.items.count) {
        rightItem = self.items[rightIndex];
    }
    
    // 计算右边按钮偏移量
    CGFloat rightScale = offsetX / scrollViewWidth;
    // 只想要 0～1
    rightScale = rightScale - leftIndex;
    CGFloat leftScale = 1 - rightScale;
    
    if (self.itemFontChangeFollowContentScroll && self.itemTitleUnselectedFontScale != 1.0f) {
        // 如果支持title大小跟随content的拖动进行变化，并且未选中字体和已选中字体的大小不一致
        
        // 计算字体大小的差值
        CGFloat diff = self.itemTitleUnselectedFontScale - 1;
        // 根据偏移量和差值，计算缩放值
        leftItem.transform = CGAffineTransformMakeScale(rightScale * diff + 1, rightScale * diff + 1);
        rightItem.transform = CGAffineTransformMakeScale(leftScale * diff + 1, leftScale * diff + 1);
    }
    
    if (self.itemColorChangeFollowContentScroll) {
        CGFloat normalRed, normalGreen, normalBlue, normalAlpha;
        CGFloat selectedRed, selectedGreen, selectedBlue, selectedAlpha;
        
        [self.itemTitleColor getRed:&normalRed green:&normalGreen blue:&normalBlue alpha:&normalAlpha];
        [self.itemTitleSelectedColor getRed:&selectedRed green:&selectedGreen blue:&selectedBlue alpha:&selectedAlpha];
        // 获取选中和未选中状态的颜色差值
        CGFloat redDiff = selectedRed - normalRed;
        CGFloat greenDiff = selectedGreen - normalGreen;
        CGFloat blueDiff = selectedBlue - normalBlue;
        CGFloat alphaDiff = selectedAlpha - normalAlpha;
        // 根据颜色值的差值和偏移量，设置tabItem的标题颜色
        leftItem.titleLabel.textColor = [UIColor colorWithRed:leftScale * redDiff + normalRed green:leftScale * greenDiff + normalGreen blue:leftScale * blueDiff + normalBlue alpha:leftScale * alphaDiff + normalAlpha];
        rightItem.titleLabel.textColor = [UIColor colorWithRed:rightScale * redDiff + normalRed green:rightScale * greenDiff + normalGreen blue:rightScale * blueDiff + normalBlue alpha:rightScale * alphaDiff + normalAlpha];
    }
    
    // 计算背景的frame
    if (self.indicatorScrollFollowContent) {
        if (self.indicatorAnimationStyle == HHTabBarIndicatorAnimationStyleDefault) {
            CGRect frame = self.indicatorImageView.frame;
            CGFloat xDiff = rightItem.indicatorFrame.origin.x - leftItem.indicatorFrame.origin.x;
            
            frame.origin.x = rightScale * xDiff + leftItem.indicatorFrame.origin.x;
            
            CGFloat widthDiff = rightItem.indicatorFrame.size.width - leftItem.indicatorFrame.size.width;
            frame.size.width = rightScale * widthDiff + leftItem.indicatorFrame.size.width;
            
            self.indicatorImageView.frame = frame;
        } else {
            //
        }
    }
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
