//
//  QSYAskRentTipsViewController.m
//  House
//
//  Created by ysmeng on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYAskRentTipsViewController.h"
#import "QSYAskRecommendRentHouseViewController.h"

@interface QSYAskRentTipsViewController ()

@property (nonatomic,copy) NSString *recommendID;//!<求租记录的ID

@end

@implementation QSYAskRentTipsViewController

#pragma mark - 初始化
/**
 *  @author             yangshengmeng, 15-04-03 09:04:42
 *
 *  @brief              根据求租记录的ID创建对应的发布成功提示页
 *
 *  @param recommendID  求租记录的ID
 *
 *  @return             返回当前创建的求租成功提示信息
 *
 *  @since              1.0.0
 */
- (instancetype)initWithRecommendID:(NSString *)recommendID
{

    if (self = [super init]) {
        
        self.recommendID = recommendID;
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{
    
    ///由于本页面不需要导航栏UI，故需要重载此方法，并且不执行任何代码
    
}

- (void)createMainShowUI
{
    
    ///提示图片
    QSImageView *tipsImageView = [[QSImageView alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH / 2.0f - 30.0f, SIZE_DEVICE_HEIGHT / 2.0f - 80.0f, 60.0f, 68.0f)];
    tipsImageView.image = [UIImage imageNamed:IMAGE_ZONE_ORDER_LIST_CELL_ACCEPT_BT_NORMAL];
    [self.view addSubview:tipsImageView];
    
    ///提示信息
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake((SIZE_DEVICE_WIDTH - 240.0f) / 2.0f, tipsImageView.frame.origin.y + tipsImageView.frame.size.height + 5.0f, 240.0f, 60.0f)];
    messageLabel.text = @"成功提交求租求购，\n3秒后自动进入推荐房源！";
    messageLabel.font = [UIFont systemFontOfSize:FONT_BODY_18];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.numberOfLines = 2;
    [self.view addSubview:messageLabel];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        QSYAskRecommendRentHouseViewController *recommendRentHouseVC = [[QSYAskRecommendRentHouseViewController alloc] initWithRecommendID:self.recommendID];
        [recommendRentHouseVC setTurnBackDistanceStep:3];
        [self.navigationController pushViewController:recommendRentHouseVC animated:YES];
        
    });
    
}

@end
