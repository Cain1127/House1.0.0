//
//  QSCollectionVerticalFlowLayout.m
//  House
//
//  Created by ysmeng on 15/4/5.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCollectionVerticalFlowLayout.h"

@interface QSCollectionVerticalFlowLayout ()

@property (nonatomic,retain) NSMutableArray *layoutAttributes;      //!<当前布局信息数组
@property (nonatomic,assign) CGFloat widthSize;                     //!<每一个cell的宽度
@property (nonatomic,retain) NSMutableArray *heightSizesList;       //!<每一个cell的高度
@property (nonatomic,assign) NSInteger totalNumberOfCell;           //!<总的cell个数
@property (nonatomic,assign) CGFloat gapHorizontal;                 //!<水平方向的间隙
@property (nonatomic,assign) CGFloat gapVertical;                   //!<垂直方向的间隙

@end

@implementation QSCollectionVerticalFlowLayout

/**
 *  @author             yangshengmeng, 15-04-05 22:04:29
 *
 *  @brief              按给定的宽度，创建一个带有一行头信息的布局器
 *
 *  @param width        瀑布注元素的宽度
 *
 *  @return             返回当前创建的布局器
 *
 *  @since              1.0.0
 */
- (instancetype)initWithItemWidth:(CGFloat)width
{

    if (self = [super init]) {
        
        ///初始化相关参数
        self.layoutAttributes = [[NSMutableArray alloc] init];
        self.widthSize = width > 0.0f && width <= self.collectionView.frame.size.width / 2.0f ? width : self.collectionView.frame.size.width / 2.0f;
        self.heightSizesList = [[NSMutableArray alloc] init];
        self.totalNumberOfCell = 0;
        self.gapHorizontal = 0.0f;
        self.gapVertical = 0.0f;
        
    }
    
    return self;

}

#pragma mark - 布局参数初始化
///布局参数初始化
- (void)initLayoutParams
{
    
    ///原尺寸
    CGFloat maxWidth = self.collectionView.frame.size.width;
    
    ///总的cell个数
    self.totalNumberOfCell = [self.collectionView numberOfItemsInSection:0];
    self.gapHorizontal = (maxWidth - 2.0f * self.widthSize) / 3.0f;
    self.gapVertical = [self.delegate gapVerticalForCustomVerticalFlowItem];
    
    ///清空数据
    [self.heightSizesList removeAllObjects];
    
    ///保存头信息的高度
    CGFloat heightHeader = [self.delegate heightForCustomVerticalFlowLayoutHeader];
    [self.heightSizesList addObject:[NSNumber numberWithFloat:heightHeader]];
    
    ///获取默认参数
    for (int i = 1; i < self.totalNumberOfCell; i++) {
        
        ///当前元素坐标
        NSIndexPath *currentIndex = [NSIndexPath indexPathForItem:(i - 1) inSection:0];
        
        ///获取每一个cell的高度
        CGFloat heightOfCell = [self.delegate customVerticalFlowLayout:self collectionView:self.collectionView heightForItemAtIndexPath:currentIndex];
        
        ///保存默认的高
        heightOfCell = (heightOfCell > 0.0f) ? heightOfCell : 0.0f;
        [self.heightSizesList addObject:[NSNumber numberWithFloat:(heightOfCell)]];
        
    }
    
}

- (void)prepareLayout
{
    
    [super prepareLayout];
    
    if (!self.delegate) {
        
        return;
        
    }
    
    ///判断第一次的参数初始化标识
    [self initLayoutParams];
    
    ///清空布局暂存数据
    [self.layoutAttributes removeAllObjects];
    
    ///总的元素个数
    NSInteger totalCellNumber = [self.collectionView numberOfItemsInSection:0];
    
    ///CELL布局实现
    for (int i = 0; i < totalCellNumber; i++) {
        
        ///当前元素坐标
        NSIndexPath *currentIndex = [NSIndexPath indexPathForItem:i inSection:0];
        
        ///获取当前坐标系的frame
        CGRect currentFrame = [self getFrameWithIndex:i];
        
        ///取得原CELL的布局属性
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:currentIndex];
        
        //设置CELL新的FRAME
        attributes.frame = currentFrame;
        
        //把实现好布局的CELL添加到CELL的数据源
        [self.layoutAttributes addObject:attributes];
        
    }
    
}

#pragma mark - 计算给定section的给定row坐标系
///计算给定section的给定row坐标系
- (CGRect)getFrameWithIndex:(int)index
{
    
    ///默认返回的frame
    CGRect tempFrame;
    
    ///获取当前布局的默认间隙
    CGFloat gapVertical = self.gapVertical;
    CGFloat gapHorizontal = self.gapHorizontal;
    
    ///获取Cell的尺寸
    CGFloat widthOfCell = self.widthSize;
    CGFloat heightOfCell = [self.heightSizesList[index] floatValue];
    
    ///判断是否第一个元素：是头信息项
    if (0 == index) {
        
        tempFrame = CGRectMake(0.0f, 0.0f, self.collectionView.frame.size.width, heightOfCell);
        
    } else if (1 == index) {
        
        UICollectionViewLayoutAttributes *headerAttributes = self.layoutAttributes[0];
        CGRect headerFrame = headerAttributes.frame;
        tempFrame = CGRectMake(gapHorizontal, headerFrame.origin.y + headerFrame.size.height + gapVertical, widthOfCell, heightOfCell);
        
    } else if (2 == index) {
        
        UICollectionViewLayoutAttributes *firstAttributes = self.layoutAttributes[1];
        CGRect firstFrame = firstAttributes.frame;
        tempFrame = CGRectMake(firstFrame.origin.x + firstFrame.size.width + gapHorizontal, firstFrame.origin.y, widthOfCell, heightOfCell);
    
    } else {
    
        UICollectionViewLayoutAttributes *aboveAttributes = self.layoutAttributes[index - 2];
        CGRect aboveFrame = aboveAttributes.frame;
        tempFrame = CGRectMake(gapHorizontal, aboveFrame.origin.y + aboveFrame.size.height + gapVertical, widthOfCell, heightOfCell);
    
    }
    
    return tempFrame;
    
}

#pragma mark - 设置collectionView的ContentSize
///设置collectionView的ContentSize
- (CGSize)collectionViewContentSize
{
    
    return CGSizeMake(self.collectionView.frame.size.width, [self getMaxContentSize]);
    
}

///返回当前最大的滚动尺寸
- (CGFloat)getMaxContentSize
{
    
    ///默认最大的尺寸
    CGFloat maxSize = 0.0f;
    
    for (int i = 0;i < self.totalNumberOfCell; i++) {
        
        UICollectionViewLayoutAttributes *attributes = self.layoutAttributes[i];
        
        ///找最大y坐标
        if (maxSize < attributes.frame.origin.y + attributes.frame.size.height) {
            
            maxSize = attributes.frame.origin.y + attributes.frame.size.height;
            
        }
        
    }
    
    return maxSize + 10.0f;
    
}

#pragma mark - 返回对应cell的Attributs
//最重要的代理方法返回CELL的布局FRAME属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path
{
    
    return self.layoutAttributes[path.row];
    
}

///返回属性串
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    NSMutableArray *attributes = [NSMutableArray array];
    
    for (int i = 0;i < self.totalNumberOfCell;i++) {
        
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]]];
        
    }
    
    return attributes;
    
}

@end
