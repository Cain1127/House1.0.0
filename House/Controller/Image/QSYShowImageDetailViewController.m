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

@property (nonatomic,copy) NSString *tempTitle;                     //!<标题
@property (nonatomic,copy) NSString *imageKey;                      //!<图片字段所在的字段名
@property (nonatomic,copy) NSString *imageRootURL;                  //!<图片请求所在的根地址
@property (nonatomic,assign) int currentIndex;                      //!<当前页码
@property (nonatomic,assign) SHOW_IMAGE_ORIGINAL_VCTYPE showType;   //!<图片展示页的类型
@property (nonatomic,copy) SHOWIMAGECALLBACKBLOCK showImageCallBack;//!<展示图片页面相关事件回调
@property (nonatomic,retain) UIImage *image;                        //!<传进来的图片
@property (nonatomic,retain) NSMutableArray *images;                //!<图片集
@property (nonatomic,retain) NSMutableDictionary *imageReuseDict;   //!<图片集的复用队列

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
        self.tempTitle = title ? title : @"查看图片";
        
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
        self.tempTitle = title ? title : @"查看图片";
        self.showType = vcType;
        if (callBack) {
            
            self.showImageCallBack = callBack;
            
        }
        
    }
    
    return self;

}

/**
 *  @author             yangshengmeng, 15-04-28 09:04:17
 *
 *  @brief              创建一个图片浏览窗口，通过给定的图片url
 *
 *  @param urlsList     图片集数组，其中必须包涵图片字段的内容项
 *  @param imageKey     图片字段
 *  @param currentIndex 当前显示页
 *  @param title        标题
 *  @param vcType       图片集查看类型
 *  @param callBack     图片集查看器的事件回调
 *
 *  @return             返回当前创建的图片集查看器
 *
 *  @since              1.0.0
 */
- (instancetype)initWithImageURLs:(NSArray *)urlsList andURLKey:(NSString *)imageKey andCurrentIndex:(int)currentIndex andTitle:(NSString *)title andType:(SHOW_IMAGE_ORIGINAL_VCTYPE)vcType andCallBack:(SHOWIMAGECALLBACKBLOCK)callBack
{

    if (self = [super init]) {
        
        ///保存参数
        self.images = [[NSMutableArray alloc] initWithArray:urlsList];
        self.imageReuseDict = [NSMutableDictionary dictionary];
        self.currentIndex = (currentIndex >= 0 && currentIndex < [urlsList count]) ? currentIndex : 0;
        self.tempTitle = APPLICATION_NSSTRING_SETTING(title, @"查看图片");
        self.showType = vcType;
        self.imageKey = APPLICATION_NSSTRING_SETTING(imageKey, @"");
        if (callBack) {
            
            self.showImageCallBack = callBack;
            
        }
        
    }
    
    return self;

}

/**
 *  @author             yangshengmeng, 15-04-28 09:04:35
 *
 *  @brief              根据给定的图片根请求地址和图片集中图片urlKVC的关键字，创建一个图片查看器
 *
 *  @param urlsList     图片url的集合
 *  @param imageKey     图片相对地址所在的KVC字关键字
 *  @param rootURL      图片请求的根地址
 *  @param currentIndex 当前显示图片的下标
 *  @param title        标题
 *  @param vcType       图片集类型
 *  @param callBack     图片集查看器相关事件
 *
 *  @return             返回当前创建的图片集查看器
 *
 *  @since              1.0.0
 */
- (instancetype)initWithImageURLs:(NSArray *)urlsList andURLKey:(NSString *)imageKey andImageRootURL:(NSString *)rootURL andCurrentIndex:(int)currentIndex andTitle:(NSString *)title andType:(SHOW_IMAGE_ORIGINAL_VCTYPE)vcType andCallBack:(SHOWIMAGECALLBACKBLOCK)callBack
{

    if (self = [super init]) {
        
        ///保存参数
        self.images = [[NSMutableArray alloc] initWithArray:urlsList];
        self.currentIndex = (currentIndex >= 0 && currentIndex < [urlsList count]) ? currentIndex : 0;
        self.tempTitle = APPLICATION_NSSTRING_SETTING(title, @"查看图片");
        self.showType = vcType;
        self.imageKey = APPLICATION_NSSTRING_SETTING(imageKey, @"");
        self.imageRootURL = APPLICATION_NSSTRING_SETTING(rootURL, @"");
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
    [self setNavigationBarTitle:self.tempTitle];

}

- (void)createMainShowUI
{

    switch (self.showType) {
            ///单图片编辑查看
        case sShowImageOriginalVCTypeSingleEdit:
        {
            
            if (!self.image) {
                
                return;
                
            }
        
            CGFloat width = SIZE_DEVICE_WIDTH;
            CGFloat height = width * self.image.size.height / self.image.size.width;
            if (height > SIZE_DEVICE_HEIGHT - 64.0f) {
                
                height = SIZE_DEVICE_HEIGHT - 64.0f;
                width = height * self.image.size.width / self.image.size.height;
                
            }
            UIImageView *imageView = [[QSImageView alloc] initWithFrame:CGRectMake((SIZE_DEVICE_WIDTH - width) / 2.0f, 64.0f, width, height)];
            imageView.image = self.image;
            imageView.userInteractionEnabled = YES;
            [self.view addSubview:imageView];
        
        }
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
    
    ///判断是否是url方式访问
    if ([self.imageRootURL length] > 0) {
        
        __block UIImageView *imageView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, autoScrollView.frame.size.height)];
        imageView.userInteractionEnabled = YES;
        
        ///请求图片数据
        NSURL *imageURL = [self getImageRequestURL:index];
        [imageView loadImageWithURL:imageURL placeholderImage:nil];
        
        return imageView;
        
    }
    
    ///底view
    UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, autoScrollView.frame.size.width, autoScrollView.frame.size.height)];
    
    ///指定下标的图片
    UIImage *image = self.images[index];
    UIImageView *imageView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, image.size.height)];
    imageView.image = image;
    imageView.userInteractionEnabled = YES;
    [rootView addSubview:imageView];
    
    return rootView;

}

- (id)autoScrollViewTapCallBackParams:(QSAutoScrollView *)autoScrollView viewForShowAtIndex:(int)index
{

    return @"hello";

}

#pragma mark - 返回图片url
- (NSURL *)getImageRequestURL:(int)index
{
    
    if ([self.imageKey length] <= 0) {
        
        return nil;
        
    }

    id tempObject = self.images[index];
    NSString *imageURLString = [tempObject valueForKey:self.imageKey];
    
    ///如果按给定的KVC条件，无法获取有效相对地址，则返回nil
    if ([imageURLString length] <= 0) {
        
        return nil;
        
    }
    
    ///如果原来地址已是全路径，则不再需要组装根路径
    if ([imageURLString hasPrefix:@"http"]) {
        
        return [NSURL URLWithString:imageURLString];
        
    }
    
    ///组装根路径
    if ([self.imageRootURL length] > 0) {
        
        if ([self.imageRootURL hasSuffix:@"/"]) {
            
            imageURLString = [NSString stringWithFormat:@"%@%@",self.imageRootURL,imageURLString];
            
        } else if ([imageURLString hasPrefix:@"/"]) {
        
            imageURLString = [NSString stringWithFormat:@"%@%@",self.imageRootURL,imageURLString];
        
        } else {
        
            [self.imageRootURL stringByAppendingString:@"/"];
            imageURLString = [NSString stringWithFormat:@"%@%@",self.imageRootURL,imageURLString];
        
        }
        
    }
    
    return [NSURL URLWithString:imageURLString];

}

@end
