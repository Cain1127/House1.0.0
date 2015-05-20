//
//  QSVerticalCodeView.m
//  Eating
//
//  Created by ysmeng on 14/11/21.
//  Copyright (c) 2014年 Quentin. All rights reserved.
//

#import "QSVerticalCodeView.h"

@interface QSVerticalCodeView ()

@property (nonatomic,assign) int vercodeNumber;     //!<验证码的个数:最少6个
@property (nonatomic,retain) UIColor *textColor;    //!<验证码文本的颜色
@property (nonatomic,assign) CGFloat textFontSize;  //!<验证码文本的颜色
@property (nonatomic,strong) UIView *showView;      //显示随机验证码的view
@property (nonatomic,copy) NSString *code;          //随机验证码文字

@end

@implementation QSVerticalCodeView

#pragma mark - 初始化
/**
 *  @author                 yangshengmeng, 15-03-13 16:03:30
 *
 *  @brief                  创建本地验证码生成view
 *
 *  @param frame            大小和位置
 *  @param bgColor          验证码的背景颜色：默认灰色
 *  @param textColor        文字的颜色：默认随机颜色
 *  @param fontSize         验证码的字体大小
 *  @param verCodeCallBack  验证码改变时的回调，回调中的文本就是验证码
 *
 *  @return                 返回当前创建的验证码view
 *
 *  @since                  1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andVercodeNum:(int)verNum andBackgroudColor:(UIColor *)bgColor andTextColor:(UIColor *)textColor andTextFont:(CGFloat)fontSize andVerCodeChangeCallBack:(void(^)(NSString *verCode))verCodeCallBack
{
    if (self = [super initWithFrame:frame]) {
        
        ///背景颜色
        self.backgroundColor = bgColor ? bgColor : [UIColor lightGrayColor];
        
        ///验证码个数
        self.vercodeNumber = verNum >= 2 ? verNum : 4;
        
        ///文本颜色
        self.textColor = textColor ? textColor : nil;
        
        ///文本字体大小
        self.textFontSize = fontSize >= 12.0f ? fontSize : 12.0f;
        
        ///保存回调
        if (verCodeCallBack) {
            
            self.vercodeChangeCallBack = verCodeCallBack;
            
        }
        
        ///添加视图
        [self createVerShowUI];
        
        ///添加单击手势
        [self addSingleTapGesture];
        
        ///生成验证码
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self changeVerticalCode];
            
        });
        
    }
    
    return self;
}

//创建显示UI
- (void)createVerShowUI
{
    
    self.showView = [[UIView alloc] initWithFrame:CGRectMake(2.0f, 2.0f, self.frame.size.width - 4.0f, self.frame.size.height - 4.0)];
    self.showView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.showView];
    
}

///添加单击手势事件
- (void)addSingleTapGesture
{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapToGenerateCode:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
    
}

- (void)onTapToGenerateCode:(UITapGestureRecognizer *)tap
{
    
    ///首先清空
    for (UIView *view in self.showView.subviews) {
        
        [view removeFromSuperview];
        
    }
    
    //生成新的验证码
    [self changeVerticalCode];
    
}

///变换验证码
- (void)changeVerticalCode
{
    
    ///生成随机验证码文字
    const int count = self.vercodeNumber;
    char data[count];
    for (int x = 0; x < count; x++) {
        
        int j = '0' + (arc4random_uniform(75));
        if((j >= 58 && j <= 64) || (j >= 91 && j <= 96)){
            
            --x;
            
        } else {
            
            data[x] = (char)j;
            
        }
        
    }
    NSString *text = [[NSString alloc] initWithBytes:data length:count encoding:NSUTF8StringEncoding];
    
    //保存验证码
    self.code = text;
    
    ///计算每一个验证码占的大小
    CGSize cSize;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:self.textFontSize]};
    cSize = [@"S" boundingRectWithSize:CGSizeMake(self.showView.frame.size.width,
                                              self.showView.frame.size.height)
                           options:NSStringDrawingTruncatesLastVisibleLine |
     NSStringDrawingUsesLineFragmentOrigin |
     NSStringDrawingUsesFontLeading
                        attributes:attribute
                           context:nil].size;
    
    ///宽度上变宽一点
    cSize = CGSizeMake(cSize.width + 2.0f, cSize.height + 1.0f);
    
#else
    
    cSize = [@"S" sizeWithFont:[UIFont systemFontOfSize:self.textFontSize]];
    ///宽度上变宽一点
    cSize = CGSizeMake(cSize.width + 2.0f, cSize.height + 1.0f);
    
#endif
    
    CGFloat singleTextWidth = self.showView.frame.size.width / text.length;
    CGFloat singleTextHeight = self.showView.frame.size.height;
    int widthLeft = (singleTextWidth - cSize.width) > 0 ? (singleTextWidth - cSize.width) : 0;
    int heightLeft = (singleTextHeight - cSize.height) > 0 ? (singleTextHeight - cSize.height) : 0;
    
    CGPoint point;
    float pX, pY;
    NSArray *rotationArray = @[[NSNumber numberWithFloat:M_PI_4],
                               [NSNumber numberWithFloat:M_PI_4 / 2.0f],
                               [NSNumber numberWithFloat:-M_PI_4 / 2.0f],
                               [NSNumber numberWithFloat:-M_PI_4],
                               [NSNumber numberWithFloat:0.0f]];
    for (int i = 0; i < count; i++) {
        
        ///随机坐标
        pX = arc4random() % widthLeft + singleTextWidth * i;
        pY = arc4random() % heightLeft;
        point = CGPointMake(pX, pY);
        unichar c = [text characterAtIndex:i];
        UILabel *tempLabel = [[UILabel alloc]
                              initWithFrame:CGRectMake(pX, pY,
                                                       cSize.width,
                                                       cSize.height)];
        tempLabel.backgroundColor = [UIColor clearColor];
        
        ///随机旋转角度
        int rangRotationIndex = arc4random() % 5;
        tempLabel.transform = CGAffineTransformMakeRotation([rotationArray[rangRotationIndex] floatValue]);
        
        ///字体颜色
        UIColor *color = nil;
        if (self.textColor) {
            
            color = self.textColor;
            
        } else {
        
            float red = arc4random() % 100 / 100.0;
            float green = arc4random() % 100 / 100.0;
            float blue = arc4random() % 100 / 100.0;
            color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        
        }
        
        NSString *textC = [NSString stringWithFormat:@"%C", c];
        tempLabel.textColor = color;
        tempLabel.font = [UIFont boldSystemFontOfSize:self.textFontSize];
        tempLabel.text = textC;
        tempLabel.adjustsFontSizeToFitWidth = YES;
        [self.showView addSubview:tempLabel];
        
    }
    
    // 干扰线
    float redDisturb;
    float greenDisturb;
    float blueDisturb;
    
    ///画线上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    ///线条宽度
    CGContextSetLineWidth(context, 2.0);
    ///设置线条样式
    CGContextSetLineCap(context, kCGLineCapSquare);
    
    for(int i = 0; i < count; i++) {
        
        ///随机颜色
        redDisturb = arc4random() % 100 / 100.0;
        greenDisturb = arc4random() % 100 / 100.0;
        blueDisturb = arc4random() % 100 / 100.0;
        
        ///线条颜色
        CGContextSetRGBStrokeColor(context, redDisturb, greenDisturb, blueDisturb, 1.0f);
        
        ///获取随机起始坐标
        pX = arc4random() % (int)self.showView.frame.size.width;
        pY = arc4random() % (int)self.showView.frame.size.height;
        
        ///开始一个起始路径
        CGContextBeginPath(context);
        
        ///绘制
        CGContextMoveToPoint(context, pX, pY);
        pX = arc4random() % (int)self.showView.frame.size.width;
        pY = arc4random() % (int)self.showView.frame.size.height;
        CGContextAddLineToPoint(context, pX, pY);
        CGContextStrokePath(context);
        
    }
    
    ///回调生成的随机验证码
    if (self.vercodeChangeCallBack) {
        
        self.vercodeChangeCallBack(text);
        
    }
    
    return;
    
}

@end
