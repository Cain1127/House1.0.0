//
//  FSCalendarHeader.m
//  Pods
//
//  Created by Wenchao Ding on 29/1/15.
//
//

#import "FSCalendarHeader.h"
#import "FSCalendar.h"
#import "UIView+FSExtension.h"
#import "NSDate+FSExtension.h"

#define kNumberOfItems (2100-1970+1)*12 // From 1970 to 2100
#define kBlueText [UIColor colorWithRed:14/255.0 green:69/255.0 blue:221/255.0 alpha:1.0]

@interface FSCalendarHeader ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *collectionViewFlowLayout;

- (void)updateAlpha;

@end

@implementation FSCalendarHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    _dateFormat = @"yyyy年MM月";
    _dateFormatter = [[NSDateFormatter alloc] init];
    _dateFormatter.dateFormat = _dateFormat;
    _minDissolveAlpha = 0.2;
    
    _collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionViewFlowLayout.minimumInteritemSpacing = 0;
    _collectionViewFlowLayout.minimumLineSpacing = 0;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_collectionViewFlowLayout];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    _collectionView.scrollEnabled = NO;
    _collectionView.userInteractionEnabled = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self addSubview:_collectionView];
    
    [_collectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == _collectionView && [keyPath isEqualToString:@"contentSize"]) {
        [_collectionView removeObserver:self forKeyPath:@"contentSize"];
        CGFloat scrollOffset = self.scrollOffset;
        _scrollOffset = 0;
        self.scrollOffset = scrollOffset;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _collectionViewFlowLayout.itemSize = CGSizeMake(self.fs_width * 0.5,
                                                    self.fs_height);
    _collectionView.frame = self.bounds;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return kNumberOfItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
    if (!titleLabel) {
        titleLabel = [[UILabel alloc] initWithFrame:cell.contentView.bounds];
        titleLabel.tag = 100;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:titleLabel];
    }
    titleLabel.font = self.calendar.headerTitleFont;
    titleLabel.textColor = self.calendar.headerTitleColor;
    NSDate *date = [[NSDate dateWithTimeIntervalSince1970:0] fs_dateByAddingMonths:indexPath.item];
    titleLabel.text = [_dateFormatter stringFromDate:date];
    
    CGFloat position = [cell convertPoint:CGPointMake(CGRectGetMidX(cell.bounds), CGRectGetMidY(cell.bounds)) toView:self].x;
    CGFloat center = CGRectGetMidX(self.bounds);
    cell.contentView.alpha = 1.0 - (1.0-_minDissolveAlpha)*ABS(center-position)/_collectionViewFlowLayout.itemSize.width;
    
    return cell;
}

#pragma mark - Setter & Getter

- (void)setScrollOffset:(CGFloat)scrollOffset
{
    if (_scrollOffset != scrollOffset) {
        _scrollOffset = scrollOffset;
        _collectionView.contentOffset = CGPointMake((_scrollOffset-0.5)*_collectionViewFlowLayout.itemSize.width, 0);
        [self updateAlpha];
    }
}

- (void)setCalendar:(FSCalendar *)calendar
{
    if (_calendar != calendar) {
        _calendar = calendar;
        [self reloadData];
    }
}

- (void)setDateFormat:(NSString *)dateFormat
{
    if (![_dateFormat isEqualToString:dateFormat]) {
        _dateFormat = [dateFormat copy];
        _dateFormatter.dateFormat = dateFormat;
        [self reloadData];
    }
}

- (void)setMinDissolveAlpha:(CGFloat)minDissolveAlpha
{
    if (_minDissolveAlpha != minDissolveAlpha) {
        _minDissolveAlpha = minDissolveAlpha;
        [self reloadData];
    }
}

#pragma mark - Public

- (void)reloadData
{
    [_collectionView reloadData];
}

#pragma mark - Private

- (void)updateAlpha
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *cells = _collectionView.visibleCells;
        [cells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UICollectionViewCell *cell = obj;
            CGFloat position = [cell convertPoint:CGPointMake(CGRectGetMidX(cell.bounds), CGRectGetMidY(cell.bounds)) toView:self].x;
            CGFloat center = CGRectGetMidX(self.bounds);
            cell.contentView.alpha = 1.0 - (1.0-_minDissolveAlpha)*ABS(center-position)/_collectionViewFlowLayout.itemSize.width;
        }];
    });
}

@end
