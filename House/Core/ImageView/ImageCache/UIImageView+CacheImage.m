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
    
    [self loadImageWithURL:url placeholderImage:placeholderImage isCommpressed:NO];
    
}

/**
 *  @author                 yangshengmeng, 15-03-02 13:03:29
 *
 *  @brief                  下载图片，并缓存到本地
 *
 *  @param url              图片的地址
 *  @param placeholderImage 请求失败后的默认图片
 *  @param flag             是否进行压缩
 *
 *  @since                  1.0.0
 */
- (void)loadImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage isCommpressed:(BOOL)flag
{
    
    ///先显示默认图片
    if (placeholderImage) {
        
        self.image = placeholderImage;
        
    }
    
    ///基本校验
    if (nil == url) {
        
        return;
        
    }
    
    if (![url.absoluteString hasPrefix:@"http://"]) {
        
        return;
        
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        ///获取本地图片
        NSString *imageCacheFilePath = [self getCacheImageWithURL:url];
        
        ///本地是否已有缓存
        if (imageCacheFilePath) {
            
            __block UIImage *tempImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:imageCacheFilePath]];
            
            ///判断是否需要压缩
            if (flag) {
                
                tempImage = [self compressedImageFitToSelf:tempImage];
                
            }
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                self.image = tempImage;
                
            });
            
            return;
            
        }
        
        ///本地没有缓存，进行网络请求
        [self requestImageDataWithURL:url placeholderImage:placeholderImage isCommpressed:flag];
        
    });
    
}

#pragma mark - 通过网络请求图片
///通过网络请求图片
- (void)requestImageDataWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage isCommpressed:(BOOL)flag
{
    
    ///封装请求3秒超时
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3.0f];
    
    ///请求数据
    NSData *imageData = [NSURLConnection sendSynchronousRequest:imageRequest returningResponse:nil error:nil];
    
    ///判断是否获取成功
    if (iImageValidTypeValid == [self checkJPEGValid:imageData]) {
        
        ///将数据转为图片
        __block UIImage *showImage = [UIImage imageWithData:imageData];
        
        ///判断是否需要压缩
        if (flag) {
            
            showImage = [self compressedImageFitToSelf:showImage];
            
        }
        
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

///返回缓存路径
+ (NSString *)getImageCacheDirectory
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

#pragma mark - 图片检测
- (IMAGE_VALID_TYPE)checkJPEGValid:(NSData *)tempData
{
    
    ///非图片
    if ([tempData length] < 4) return iImageValidTypeInValid;
    
    const unsigned char * bytes = (const unsigned char *)[tempData bytes];
    
    ///头信息缺失
    if (bytes[0] != 0xFF || bytes[1] != 0xD8) return iImageValidTypeHeaderInValid;
    
    ///图片尾信息缺失
    if (bytes[[tempData length] - 2] != 0xFF ||
        bytes[[tempData length] - 1] != 0xD9) return iImageValidTypeFooterInValid;
    
    ///图片完整
    return iImageValidTypeValid;
    
}

+ (IMAGE_VALID_TYPE)checkJPEGValid:(NSData *)tempData
{
    
    ///非图片
    if ([tempData length] < 4) return iImageValidTypeInValid;
    
    const unsigned char * bytes = (const unsigned char *)[tempData bytes];
    
    ///头信息缺失
    if (bytes[0] != 0xFF || bytes[1] != 0xD8) return iImageValidTypeHeaderInValid;
    
    ///图片尾信息缺失
    if (bytes[[tempData length] - 2] != 0xFF ||
        bytes[[tempData length] - 1] != 0xD9) return iImageValidTypeFooterInValid;
    
    ///图片完整
    return iImageValidTypeValid;
    
}

#pragma mark - 清空缓存
/**
 *  @author yangshengmeng, 15-05-11 15:05:03
 *
 *  @brief  清空缓存图片
 *
 *  @since  1.0.0
 */
+ (void)clearLoadImageCache:(void(^)(BOOL isClear))callBack
{

    NSString *path = [self getImageCacheDirectory];
    if (nil == path) {
        
        callBack(YES);
        
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:path error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        
        [fileManager removeItemAtPath:[path stringByAppendingPathComponent:filename] error:NULL];
        
    }
    
    callBack(YES);

}

@end
