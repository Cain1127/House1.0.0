//
//  QSAutoScrollView.m
//  House
//
//  Created by ysmeng on 15/1/19.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSAutoScrollView.h"

@interface QSAutoScrollView ()

@property (nonatomic,assign) AUTOSCROLL_DIRECTION_TYPE autoScrollDirectionType;//!<自滚动方向
@property (nonatomic,assign) id<QSAutoScrollViewDelegate> delegate;     //!<数据源代理
@property (nonatomic,retain) NSMutableArray *dequeueReusableViewsArray; //!<复用队列容器
@property (nonatomic,copy) void(^autoScrollViewTapCallBack)(id params); //!<单击滚动view时的回调

@end

@implementation QSAutoScrollView

#pragma mark - 初始化
/**
 *  @author                 yangshengmeng, 15-01-19 11:01:16
 *
 *  @brief                  根据代理和滚动类型，创建一个类广告自滚动的视图
 *
 *  @param frame            在父视图中的位置和大小
 *  @param delegate         滚动视图的代理
 *  @param directionType    滚动的方向
 *
 *  @return                 返回一个自滚动的视图
 *
 *  @since                  1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andDelegate:(id<QSAutoScrollViewDelegate>)delegate andScrollDirectionType:(AUTOSCROLL_DIRECTION_TYPE)directionType andTapCallBack:(void (^)(id))callBack
{

    if (self = [super initWithFrame:frame]) {
        
        ///保存代理
        self.delegate = delegate;
        
        ///保存回调
        if (callBack) {
            
            self.autoScrollViewTapCallBack = callBack;
            
        }
        
        ///保存滚动方向
        self.autoScrollDirectionType = directionType;
        
        ///创建UI
        [self createAutoShowViewUI];
        
    }
    
    return self;

}

#pragma mark - 搭建滚动UI
///搭建滚动UI
- (void)createAutoShowViewUI
{

    

}

#pragma mark - 返回可复用的view
/**
 *  @author             yangshengmeng, 15-01-19 10:01:33
 *
 *  @brief              通过利用名字，返回当前滚动视图中是否存在对应的可用复用展示view
 *
 *  @param indentify    复用唯一标记
 *
 *  @return             返回复用view
 *
 *  @since              1.0.0
 */
- (UIView *)dequeueReusableViewWithIdentifier:(NSString *)indentify
{

    return nil;

}

@end
