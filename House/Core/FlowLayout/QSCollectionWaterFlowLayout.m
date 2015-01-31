//
//  QSCollectionWaterFlowLayout.m
//  House
//
//  Created by ysmeng on 15/1/30.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCollectionWaterFlowLayout.h"

@interface QSCollectionWaterFlowLayout ()

@property (nonatomic,assign) UICollectionViewScrollDirection scrollDirection;//!<布局方向
@property (nonatomic,assign) CGFloat defaultMaxSize;                    //!<布局方向的最大尺寸

@property (nonatomic,assign) NSInteger totalSection;                    //!<列头固定的列数
@property (nonatomic,retain) NSMutableArray *numberOfColumnInSection;   //!<每一个section中的列头数量
@property (nonatomic,retain) NSMutableArray *numberOfRowsInSection;     //!<每一个section中的cell总数

@property (nonatomic,retain) NSMutableArray *defaultSizeInSection;      //!<每一个section中默认的宽或高
@property (nonatomic,retain) NSMutableArray *defaultSpaceInSection;     //!<每一个section中默认布局方向间隙
@property (nonatomic,retain) NSMutableArray *defaultScrollSpace;        //!<section中非布局方向的默认间隙

@property (nonatomic,retain) NSMutableArray *layoutAttributes;          //!<当前布局信息数组

@end

@implementation QSCollectionWaterFlowLayout

/**
 *  @author                 yangshengmeng, 15-01-30 18:01:05
 *
 *  @brief                  创建一个给定布局方向，同时有默认方向的尺寸布局器
 *
 *  @param direction        布局方向
 *  @param headerRowNumber  列头的数量
 *  @param defaultSize      默认尺寸：垂直布局时，表示默认的宽度；水平布局时表示默认高度
 *  @param defaultSpace     默认的间隙：垂直布局时，默认的上下间隙；水平布局时，表示左右间隙
 *
 *  @return                 返回当前创建的布局器
 *
 *  @since                  1.0.0
 */
- (instancetype)initWithScrollDirection:(UICollectionViewScrollDirection)direction
{

    if (self = [super init]) {
     
        ///保存相关参数
        self.scrollDirection = direction;
        
        ///初始化相关参数
        self.numberOfColumnInSection = [[NSMutableArray alloc] init];
        self.numberOfRowsInSection = [[NSMutableArray alloc] init];
        self.defaultSizeInSection = [[NSMutableArray alloc] init];
        self.defaultSpaceInSection = [[NSMutableArray alloc] init];
        self.defaultScrollSpace = [[NSMutableArray alloc] init];
        self.layoutAttributes = [[NSMutableArray alloc] init];
        
    }
    
    return self;

}

#pragma mark - 布局参数初始化
///布局参数初始化
- (BOOL)initLayoutParams
{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        ///获取section总数
        self.totalSection = [self.collectionView numberOfSections] > 0 ? [self.collectionView numberOfSections] : 1;
        
        ///获取默认方向的最大尺寸
        self.defaultMaxSize = 0.0f;
        if (UICollectionViewScrollDirectionVertical == self.scrollDirection) {
            
            self.defaultMaxSize = self.collectionView.frame.size.width;
            
        }
        
        if (UICollectionViewScrollDirectionHorizontal == self.scrollDirection) {
            
            self.defaultMaxSize = self.collectionView.frame.size.height;
            
        }
        
        ///获取默认参数
        for (int i = 0; i < self.totalSection; i++) {
            
            ///清空原每一个section的列头列数数据
            [self.numberOfColumnInSection removeAllObjects];
            ///清空原每一个section对应的行数
            [self.numberOfRowsInSection removeAllObjects];
            ///清空原每一个section中布局方向的间隙
            [self.defaultSpaceInSection removeAllObjects];
            ///清空原每一个section中非布局方向的默认间隙
            [self.defaultScrollSpace removeAllObjects];
            
            ///从代理中获取列头数量
            if ([self.delegate respondsToSelector:@selector(numberOfColumnInSection:)]) {
                
                [self.numberOfColumnInSection addObject:[NSNumber numberWithInteger:[self.delegate numberOfColumnInSection:i]]];
                
            } else {
                
                ///如若代理中没有配置列头数量，默认为2列
                [self.numberOfColumnInSection addObject:[NSNumber numberWithInt:2]];
                
            }
            
            ///从代理中获取每一个section的行数
            NSInteger delegateRows = [self.collectionView numberOfItemsInSection:i];
            [self.numberOfRowsInSection addObject:[NSNumber numberWithInteger:(delegateRows >= 0 ? delegateRows : 0)]];
            
            ///获取每一个section中的布局方向固定宽度/高度
            CGFloat defaultSize = [self.delegate customWaterFlowLayout:self collectionView:self.collectionView defaultSizeOfItemInSection:i];
            
            ///计算当前的默认尺寸是否超出范围
            CGFloat calculateDefaultSize = self.defaultMaxSize / [self.numberOfColumnInSection[i] intValue];
            
            ///保存默认的宽/高
            [self.defaultSizeInSection addObject:[NSNumber numberWithFloat:((defaultSize <= calculateDefaultSize && defaultSize > 0.0f) ? defaultSize : calculateDefaultSize)]];
            
            ///按给定的默认宽/高计算布局方向间隙
            CGFloat calculateDefaultSpace = (self.defaultMaxSize - [self.defaultSizeInSection[i] floatValue] * [self.numberOfColumnInSection[i] integerValue]) / ([self.numberOfColumnInSection[i] intValue] + 1);
            
            ///保存布局方向的默认间隙
            [self.defaultSpaceInSection addObject:[NSNumber numberWithFloat:(calculateDefaultSpace > 0.0f ? calculateDefaultSpace : 0.0f)]];
            
            ///非布局方向的间隙
            CGFloat defaultScrollSpace = [self.delegate customWaterFlowLayout:self collectionView:self.collectionView defaultScrollSpaceOfItemInSection:i];
            
            ///保存非布局方向的默认间隙
            [self.defaultScrollSpace addObject:[NSNumber numberWithFloat:(defaultScrollSpace >= 0.0f ? defaultScrollSpace : 0.0f)]];
            
        }
        
    });
    
    return YES;

}

#pragma mark - 准备布局时数据处理
///准备布局时数据处理
- (void)prepareLayout
{

    [super prepareLayout];
    
    if (!self.delegate) {
        
        return;
        
    }
    
    ///判断第一次的参数初始化标识
    BOOL isFinishParams = [self initLayoutParams];
    
    if (!isFinishParams) {
        
        return;
        
    }
    
    ///清空布局暂存数据
    [self.layoutAttributes removeAllObjects];
    
    ///CELL布局实现
    for (int i = 0; i < self.totalSection; i++) {
        
        ///对应section的属性数组
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        
        ///把对应section的属性列添加到全局属性列中
        [self.layoutAttributes addObject:tempArray];
        
        int sectionRows = [self.numberOfRowsInSection[i] intValue];
        for (int j = 0; j < sectionRows; j++) {
            
            ///当前cell的坐标
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            
            ///非布局方向的宽/高
            CGFloat scrollSize = [self.delegate customWaterFlowLayout:self collectionView:self.collectionView defaultScrollSizeOfItemAtIndexPath:indexPath];
            
            ///获取当前坐标系的frame
            CGRect currentFrame = [self getFrameWithSection:i andRow:j andScrollSize:scrollSize];
            
            ///取得原CELL的布局属性
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            //设置CELL新的FRAME
            attributes.frame = currentFrame;
            //把实现好布局的CELL添加到CELL的数据源
            [tempArray addObject:attributes];
            
        }
        
    }

}

#pragma mark - 计算给定section的给定row坐标系
///计算给定section的给定row坐标系
- (CGRect)getFrameWithSection:(int)section andRow:(int)row andScrollSize:(CGFloat)scrollSize
{
    
    ///默认返回的frame
    CGRect tempFrame;
    
    ///获取当前布局的默认间隙
    CGFloat defaultSpace = [self.defaultSpaceInSection[section] floatValue];
    CGFloat defaultScrollSpace = [self.defaultScrollSpace[section] floatValue];
    
    ///获取当前布局的默认尺寸
    CGFloat defaultSize = [self.defaultSizeInSection[section] floatValue];

    ///判断是否第一个元素：是则返回第一个属性
    if (0 == row) {
        
        ///判断布局方向
        if (UICollectionViewScrollDirectionVertical == self.scrollDirection) {
            
            tempFrame = CGRectMake(defaultSpace, defaultScrollSpace, defaultSize, scrollSize);
            
        }
        
        if (UICollectionViewScrollDirectionHorizontal == self.scrollDirection) {
            
            tempFrame = CGRectMake(defaultScrollSpace, defaultSpace, scrollSize, defaultSize);
            
        }
        
    } else {
    
        ///计算出当前需要布局cell的上一个布局cell属性坐标
        int column = [self.numberOfColumnInSection[section] intValue];
        
        ///现在cell，正好是最后一个元素
        if (row < column) {
            
            UICollectionViewLayoutAttributes *attributs = self.layoutAttributes[section][row - 1];
            CGRect aboveFrame = attributs.frame;
            
            ///判断布局方向
            if (UICollectionViewScrollDirectionVertical == self.scrollDirection) {
                
                tempFrame = CGRectMake(aboveFrame.origin.x + aboveFrame.size.width + defaultSpace, aboveFrame.origin.y, defaultSize, scrollSize);
                
            }
            
            if (UICollectionViewScrollDirectionHorizontal == self.scrollDirection) {
                
                tempFrame = CGRectMake(aboveFrame.origin.x, aboveFrame.origin.y + aboveFrame.size.height + defaultSpace, scrollSize, defaultSize);
                
            }
            
        } else {
        
            ///现在的行，正好是每一行的第一个元素
            UICollectionViewLayoutAttributes *attributs = self.layoutAttributes[section][row - column];
            CGRect aboveFrame = attributs.frame;
            
            ///判断布局方向
            if (UICollectionViewScrollDirectionVertical == self.scrollDirection) {
                
                tempFrame = CGRectMake(aboveFrame.origin.x, aboveFrame.origin.y + aboveFrame.size.height + defaultScrollSpace, defaultSize, scrollSize);
                
            }
            
            if (UICollectionViewScrollDirectionHorizontal == self.scrollDirection) {
                
                tempFrame = CGRectMake(aboveFrame.origin.x + aboveFrame.size.width + defaultScrollSpace, aboveFrame.origin.y, scrollSize, defaultSize);
                
            }
        
        }
        
    }
    
    return tempFrame;

}

#pragma mark - 设置collectionView的ContentSize
///设置collectionView的ContentSize
- (CGSize)collectionViewContentSize
{

    if (UICollectionViewScrollDirectionVertical == self.scrollDirection) {
        
        return CGSizeMake(self.collectionView.frame.size.width, [self getMaxContentSize]);
        
    } else {
    
        return CGSizeMake([self getMaxContentSize], self.collectionView.frame.size.height);
    
    }

}

///返回当前最大的滚动尺寸
- (CGFloat)getMaxContentSize
{

    ///默认最大的坐标
    CGFloat maxPoint = 0.0f;
    
    ///默认最大的尺寸
    CGFloat maxSize = 0.0f;
    
    for (int i = 0;i < self.totalSection; i++) {
        
        ///获取最大的尺寸
        CGFloat defaultSize = [self.defaultSizeInSection[i] floatValue];
        if (maxSize < defaultSize) {
            
            maxSize = defaultSize;
            
        }
        
        ///遍历获取最大的坐标
        for (int j = 0; j < [self.numberOfRowsInSection[i] intValue]; j++) {
            
            UICollectionViewLayoutAttributes *attributes = self.layoutAttributes[i][j];
            
            ///判断不同的布局方向
            if (UICollectionViewScrollDirectionVertical == self.scrollDirection) {
                
                if (maxPoint < attributes.frame.origin.y) {
                    
                    maxPoint = attributes.frame.origin.y;
                    
                }
                
            } else {
            
                if (maxPoint < attributes.frame.origin.x) {
                    
                    maxPoint = attributes.frame.origin.x;
                    
                }
            
            }
            
        }
        
    }
    
    return maxSize + maxPoint + 10.0f;

}

#pragma mark - 返回对应cell的Attributs
//最重要的代理方法返回CELL的布局FRAME属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path
{
    
    return self.layoutAttributes[path.section][path.row];
    
}

///返回属性串
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    NSMutableArray *attributes = [NSMutableArray array];
    
    for (int i = 0;i < self.totalSection;i++) {
        
        for (int j = 0; j < [self.numberOfRowsInSection[i] intValue];j++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            
            [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
            
        }
        
    }
    
    return attributes;
    
}

///到边缘是否重新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    
    return NO;
    
}

@end