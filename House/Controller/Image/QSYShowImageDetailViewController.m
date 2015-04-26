//
//  QSYShowImageDetailViewController.m
//  House
//
//  Created by ysmeng on 15/3/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYShowImageDetailViewController.h"

#import "QSAutoScrollView.h"

@interface QSYShowImageDetailViewController () <QSAutoScrollViewDelegate>

@property (nonatomic,copy) NSString *title;                         //!<标题
@property (nonatomic,assign) int currentIndex;                      //!<当前页码
@property (nonatomic,assign) SHOW_IMAGE_ORIGINAL_VCTYPE showType;   //!<图片展示页的类型
@property (nonatomic,copy) SHOWIMAGECALLBACKBLOCK showImageCallBack;//!<展示图片页面相关事件回调
@property (nonatomic,retain) UIImage *image;                        //!<传进来的图片
@property (nonatomic,retain) NSMutableArray *images;                //!<图片集

@end

@implementation QSYShowImageDetailViewController

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-03-26 16:03:56
 *
 *  @brief          创建一个查看单图片的视图，显示一个图片
 *
 *  @param image    图片
 *  @param title    标题
 *  @param vcType   图片查看页面的类型
 *  @param callBack 图片查看页面相关事件的回调
 *
 *  @return         返回当前创建的图片查看器
 *
 *  @since          1.0.0
 */
- (instancetype)initWithImage:(UIImage *)image andTitle:(NSString *)title andType:(SHOW_IMAGE_ORIGINAL_VCTYPE)vcType andCallBack:(SHOWIMAGECALLBACKBLOCK)callBack
{

    if (self = [super init]) {
        
        ///保存图片
        self.image = image;
        
        ///保存标题
        self.title = title ? title : @"查看图片";
        
        ///保存类型
        self.showType = vcType;
        
        ///保存回调
        if (callBack) {
            
            self.showImageCallBack = callBack;
            
        }
        
    }
    
    return self;

}

/**
 *  @author         yangshengmeng, 15-03-26 16:03:18
 *
 *  @brief          创建一个查看图集的视图
 *
 *  @param images   图片数组
 *  @param index    当前页码
 *  @param title    标题
 *  @param vcType   查看图片控制器的类型
 *  @param callBack 相关事件的回调
 *
 *  @return         返回当前创建的图片查看器
 *
 *  @since 1.0.0
 */
- (instancetype)initWithImages:(NSArray *)images andCurrentIndex:(int)index andTitle:(NSString *)title andType:(SHOW_IMAGE_ORIGINAL_VCTYPE)vcType andCallBack:(SHOWIMAGECALLBACKBLOCK)callBack
{

    if (self = [super init]) {
        
        ///保存参数
        self.images = [[NSMutableArray alloc] initWithArray:images];
        self.currentIndex = (index >= 0 && index < [images count]) ? index : 0;
        self.title = title ? title : @"查看图片";
        self.showType = vcType;
        if (callBack) {
            
            self.showImageCallBack = callBack;
            
        }
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    [self setNavigationBarTitle:self.title];

}

- (void)createMainShowUI
{

    switch (self.showType) {
            ///单图片编辑查看
        case sShowImageOriginalVCTypeSingleEdit:
            
            break;
            
            ///多图片编辑查看
        case sShowImageOriginalVCTypeMultiEdit:
            
            [self createMultipleImageEditUI];
            
            break;
            
        default:
            break;
    }

}

#pragma mark - 创建多图片查看，并带有编辑功能的UI
///创建多图片查看，并带有编辑功能的UI
- (void)createMultipleImageEditUI
{

    ///创建图片滚动页
    QSAutoScrollView *imageShowView = [[QSAutoScrollView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f) andDelegate:self andScrollDirectionType:aAutoScrollDirectionTypeRightToLeft andShowPageIndex:YES andCurrentPage:self.currentIndex isAutoScroll:YES andShowTime:4.0f andTapCallBack:^(id params) {}];
    [self.view addSubview:imageShowView];

}

#pragma mark - 图片集自滚动展示相关设置
- (int)numberOfScrollPage:(QSAutoScrollView *)autoScrollView
{

    return (int)[self.images count];

}

- (UIView *)autoScrollViewShowView:(QSAutoScrollView *)autoScrollView viewForShowAtIndex:(int)index
{
    
    ///底view
    UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, autoScrollView.frame.size.width, autoScrollView.frame.size.height)];
    
    ///指定下标的图片
    UIImage *image = self.images[index];
    UIImageView *imageView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, image.size.height)];
    imageView.image = image;
    [rootView addSubview:imageView];
    
    return rootView;

}

- (id)autoScrollViewTapCallBackParams:(QSAutoScrollView *)autoScrollView viewForShowAtIndex:(int)index
{

    return @"hello";

}

@end
