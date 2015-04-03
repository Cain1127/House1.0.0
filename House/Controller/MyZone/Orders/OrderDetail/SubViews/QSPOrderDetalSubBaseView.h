//
//  QSPOrderDetalSubBaseView.h
//  House
//
//  Created by CoolTea on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

//上下间隙
#define     CONTENT_TOP_BOTTOM_OFFSETY     14.0f

//左右间隙
#define     CONTENT_LEFT_RIGHT_OFFSETX     CONTENT_TOP_BOTTOM_OFFSETY //35.0f


#define SetHeightToZero(a)  if(a){[a setFrameHeightToZero];}


@interface QSPOrderDetalSubBaseView : UIView

@property (nonatomic , assign)CGFloat showHeight;

- (void)addAfterView:(UIView* __strong *)view;

- (void)addAfterViewList:(NSArray*)viewList;

- (void)ResetOtherViewOffsetY;

- (NSArray*)getAfterViewsList;

- (void)setFrameHeightToShowHeight;

- (void)setFrameHeightToZero;


@end
