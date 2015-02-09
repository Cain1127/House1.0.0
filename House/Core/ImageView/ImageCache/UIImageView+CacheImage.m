//
//  UIImageView+CacheImage.m
//  House
//
//  Created by ysmeng on 15/1/21.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "UIImageView+CacheImage.h"
#import "UIImage+Compressed.h"

@implementation UIImageView (CacheImage)

#pragma mark - 请求图片
/**
 *  @author                 yangshengmeng, 15-01-21 15:01:48
 *
 *  @brief                  根据给定的URL请求图片，并配置本地缓存文件
 *
 *  @param url              请求图片的URL
 *  @param placeholderImage 请求失败时的默认图片
 *
 *  @since                  1.0.0
 */
- (void)loadImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage
{
    
    ///基本校验
    if (nil == url) {
        
        return;
        
    }
    
    if (![url.absoluteString hasPrefix:@"http://"]) {
        
        return;
        
    }

    ///获取本地图片
    NSString *imageCacheFilePath = [self getCacheImageWithURL:url];
    
    ///本地是否已有缓存
    if (imageCacheFilePath) {
        
        __block UIImage *tempImage = nil;
        
        ///获取image，判断是否需要缩小
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
           
            tempImage = [self compressedImageFitToSelf:[UIImage imageWithData:[NSData dataWithContentsOfFile:imageCacheFilePath]]];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                self.image = tempImage;
                
            });
            
        });
        
        return;
        
    }
    
    ///本地没有缓存，进行网络请求
    [self requestImageDataWithURL:url placeholderImage:placeholderImage];

}

#pragma mark - 通过网络请求图片
///通过网络请求图片
- (void)requestImageDataWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage
{

    ///异步请求
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        ///封装请求3秒超时
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3.0f];
        
        ///请求数据
        NSData *imageData = [NSURLConnection sendSynchronousRequest:imageRequest returningResponse:nil error:nil];
        
        ///判断是否获取成功
        if (imageData) {
            
            ///压缩图片，并显示
            UIImage *showImage = [self compressedImageFitToSelf:[UIImage imageWithData:imageData]];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                self.image = showImage;
                
            });
            
            ///把图片保存在本地
            [self saveImageWithImage:imageData andIndentify:[self getImageCacheIdentifyWithURL:url]];
            
        } else {
        
            ///加载默认图片
            if (placeholderImage) {
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    self.image = placeholderImage;
                    
                });
                
            }
        
        }
        
        
    });

}

#pragma mark - 请求本地缓存图片
///根据URL获取本地缓存图片
- (NSString *)getCacheImageWithURL:(NSURL *)url
{

    ///获取唯一标识
    NSString *indentify = [self getImageCacheIdentifyWithURL:url];
    
    ///如果标识符无效
    if (nil == indentify) {
        
        return nil;
        
    }
    
    return [self getImageFromCache:indentify];

}

#pragma mark - 获取本地缓存图片
///根据唯一标识获取本地缓存图片
- (NSString *)getImageFromCache:(NSString *)identify
{

    ///获取沙盒缓存地址
    NSString *cacheDirectorPath = [self getImageCacheDirectory];
    
    if (cacheDirectorPath) {
        
        ///查找文件
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",cacheDirectorPath,identify];
        BOOL isExitFile = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
        
        if (isExitFile) {
            
            return filePath;
            
        }
        
    }
    
    return nil;

}

#pragma mark - 根据图片请求的url，生成缓存唯一标识
///根据URL生成本地缓存的唯一标识
- (NSString *)getImageCacheIdentifyWithURL:(NSURL *)url
{

    ///url转为string
    NSString *urlString = url.absoluteString;
    
    ///按</>切分
    NSArray *sepArray = [urlString componentsSeparatedByString:@"/"];
    
    ///返回最后一项内容
    return [sepArray lastObject];

}

#pragma mark - 图片缓存路径
///返回缓存路径
- (NSString *)getImageCacheDirectory
{
    
    ///沙盒目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/imageCache"];
    
    ///判断文件夹是否存在，存在直接返回，不存在则创建
    BOOL isDir = NO;
    BOOL isExitDirector = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
    
    ///如果已存在对应的路径，返回
    if (isDir && isExitDirector) {
        
        return path;
        
    }
    
    ///不存在创建
    BOOL isCreateSuccessDirector = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    
    if (isCreateSuccessDirector) {
        
        return path;
        
    }
    
    return nil;

}

#pragma mark - 将网络请求返回的图片存放本地
///将图片信息保存在本地
- (void)saveImageWithImage:(NSData *)data andIndentify:(NSString *)indentify
{

    ///缓存路径
    NSString *filePath = [[self getImageCacheDirectory] stringByAppendingPathComponent:indentify];
    BOOL isWriteSuccess = [data writeToFile:filePath atomically:YES];
    if (isWriteSuccess) {
        
        NSLog(@"================图片写入本地成功=================");
        
    } else {
    
        NSLog(@"================图片写入本地失败=================");
    
    }

}

#pragma mark - 图片按自身大小压缩
///按自身显示的大小，压缩图片
- (UIImage *)compressedImageFitToSelf:(UIImage *)image
{
    
    ///图片的大小
    CGSize originalImageSize = CGSizeMake(CGImageGetWidth([image CGImage]), CGImageGetHeight([image CGImage]));

    ///初始如果imageView太小，则表示为自适应图片框，不需要压缩
    if (self.frame.size.width < 2.0f && self.frame.size.height < 2.0f) {
        
        return image;
        
    }
    
    ///判断如果原图不大于显示的两倍，则直接返回
    if (((self.frame.size.width * 2) >= originalImageSize.width) && ((self.frame.size.height * 2.0f) >= originalImageSize.height)) {
        
        return image;
        
    }
    
    ///图片临时指针
    UIImage *tempImage = nil;
    CGSize tempSize = originalImageSize;
    
    ///如果宽大于显示宽的两倍，则压缩宽
    if ((self.frame.size.width * 2.0f) < originalImageSize.width) {
        
        tempImage = [image compressedImageWithSize:CGSizeMake(self.frame.size.width * 2.0f, tempSize.height)];
        tempSize = CGSizeMake(self.frame.size.width * 2.0f, tempSize.height);
        
    }
    
    ///如果高大于显示高的两倍，则压缩高
    if ((self.frame.size.height * 2.0f) < originalImageSize.height) {
        
        tempImage = [image compressedImageWithSize:CGSizeMake(tempSize.width,self.frame.size.height * 2.0f)];
        tempSize = CGSizeMake(tempSize.width,self.frame.size.height * 2.0f);
        
    }
    
    return tempImage;

}

@end
