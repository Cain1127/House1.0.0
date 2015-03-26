//
//  UIImage+Thumbnail.m
//  ComicFans-iOS
//
//  Created by EggmanQi on 14/9/5.
//  Copyright (c) 2014年 FabriQate Ltd. All rights reserved.
//

#import "UIImage+Thumbnail.h"

@implementation UIImage (Thumbnail)

- (UIImage*)thumbnailWithSize:(CGSize)aSize
{
    
    ///判断自身是否是有效对象
    if (!self) {
        
        return nil;
        
    }
    
    ///获取上下文
    CGImageRef imageRef = [self CGImage];
    
    float _width = CGImageGetWidth(imageRef);
    float _height = CGImageGetHeight(imageRef);
    
    CGFloat length = _width>_height ? _height : _width;
    CGRect rect = CGRectMake((_width-length)/2, (_height-length)/2, length, length);
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, rect);
    CGRect smallBounds = CGRectMake(0, 0, length, length);
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    
    imageRef = [smallImage CGImage];
    UIImage *thumb = nil;
    
    _width = CGImageGetWidth(imageRef);
    _height = CGImageGetHeight(imageRef);
    
    // hardcode width and height for now, shouldn't stay like that
    float _resizeToWidth;
    float _resizeToHeight;
    
    _resizeToWidth = aSize.width;
    _resizeToHeight = aSize.height;
    
    float _moveX = 0.0f;
    float _moveY = 0.0f;
    
    // resize the image if it is bigger than the screen only
    
    if ( (_width > _resizeToWidth) || (_height > _resizeToHeight) ) {
        
        float _amount = 0.0f;
        if (_width < _height) {
            _amount = _resizeToWidth / _width;
            _width *= _amount;
            _height *= _amount;
        }else {
            _amount = _resizeToHeight / _height;
            _width *= _amount;
            _height *= _amount;
        }
    }
    
    _width = (NSInteger)_width;
    _height = (NSInteger)_height;
    
    _resizeToWidth = _width;
    _resizeToHeight = _height;
    
    CGContextRef bitmap = CGBitmapContextCreate(
                                                NULL,
                                                _resizeToWidth,
                                                _resizeToHeight,
                                                CGImageGetBitsPerComponent(imageRef),
                                                CGImageGetBitsPerPixel(imageRef)*_resizeToWidth,
                                                CGImageGetColorSpace(imageRef),
                                                CGImageGetBitmapInfo(imageRef)
                                                );
    // now center the image
    _moveX = (_resizeToWidth - _width) / 2;
    _moveY = (_resizeToHeight - _height) / 2;
    
    CGContextSetRGBFillColor(bitmap, 1.f, 1.f, 1.f, 1.0f);
    CGContextFillRect( bitmap, CGRectMake(0, 0, _resizeToWidth, _resizeToHeight));
    // CGContextRotateCTM( bitmap, 180*(M_PI/180));
    CGContextDrawImage( bitmap, CGRectMake(_moveX, _moveY, _width, _height), imageRef );
    
    // create a templete imageref.
    CGImageRef ref = CGBitmapContextCreateImage( bitmap );
    thumb = [UIImage imageWithCGImage:ref];
    
    // release the templete imageref.
    CGContextRelease( bitmap );
    CGImageRelease( ref );
    
    return thumb;
    
}

@end
