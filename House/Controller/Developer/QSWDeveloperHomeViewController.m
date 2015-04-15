//
//  QSWDeveloperHomeViewController.m
//  House
//
//  Created by 王树朋 on 15/4/14.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWDeveloperHomeViewController.h"
#import "QSWDeveloperActivityViewController.h"
#import "QSYChatToolViewController.h"
#import "QSYSystemMessagesViewController.h"


#import "QSImageView+Block.h"

@interface QSWDeveloperHomeViewController ()

@end

@implementation QSWDeveloperHomeViewController

-(void)createNavigationBarUI
{

    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"开发商名称"];

}

-(void)createMainShowUI
{
    
    
    [super createMainShowUI];
    UIImageView *onSaleImageView = [QSImageView createBlockImageViewWithFrame:CGRectMake(15.0f, 84.0f, SIZE_DEVICE_WIDTH*160.0f/375.0f, SIZE_DEVICE_WIDTH*180.0f/375.0f) andSingleTapCallBack:^{
        APPLICATION_LOG_INFO(@"点击在线售楼", nil);
    }];
    onSaleImageView.image = [UIImage imageNamed:IMAGE_DEVELOPER_HOME_SALING];
    [self createOnsaleInfoUI:onSaleImageView andCount:@"108"];
    [self.view addSubview:onSaleImageView];

    UIImageView *activityImageView = [QSImageView createBlockImageViewWithFrame:CGRectMake(SIZE_DEVICE_WIDTH - 15.0f-SIZE_DEVICE_WIDTH*160.0f/375.0f, 84.0f, SIZE_DEVICE_WIDTH*160.0f/375.0f, SIZE_DEVICE_WIDTH*180.0f/375.0f) andSingleTapCallBack:^{
        APPLICATION_LOG_INFO(@"点击当前活动", nil);
        QSWDeveloperActivityViewController *acVC = [[QSWDeveloperActivityViewController alloc]init];
        [self.navigationController pushViewController:acVC animated:YES];
        
    }];
    activityImageView.image = [UIImage imageNamed:IMAGE_DEVELOPER_HOME_ACTIVES];

    [self createActivityInfoUI:activityImageView andCount:@"99"];
    [self.view addSubview:activityImageView];
    
    UIView *houseAttentionView=[[UIView alloc] initWithFrame:CGRectMake(35.0f, activityImageView.frame.origin.y+activityImageView.frame.size.height+20.0f, SIZE_DEVICE_WIDTH-70.0f, 25.0f+15.0f+5.0f+2*20.0f)];
    [self createHouseAttentionViewUI:houseAttentionView ];
    [self.view addSubview:houseAttentionView];
    
    UIImageView *settingImageView = [QSImageView createBlockImageViewWithFrame:CGRectMake(35.0f, houseAttentionView.frame.origin.y+houseAttentionView.frame.size.height+20.0f, SIZE_DEVICE_WIDTH*120.0f/375.0f, SIZE_DEVICE_WIDTH*133.0f/375.0f) andSingleTapCallBack:^{
        
        APPLICATION_LOG_INFO(@"点击设置", nil);
        settingImageView.highlighted = YES;
        QSYChatToolViewController *toolVC = [[QSYChatToolViewController alloc] init];
        [self.navigationController pushViewController:toolVC animated:YES];
        
    }];
    settingImageView.image = [UIImage imageNamed:IMAGE_DEVELOPER_HOME_SETTING];
    settingImageView.highlightedImage = [UIImage imageNamed:IMAGE_DEVELOPER_HOME_SETTING_HIGHTLIGHT];
    
    ///说明文字
    UILabel *settingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,0.0f, 60.0f, 20.0f)];
    settingLabel.text = @"设置";
    settingLabel.center=CGPointMake(settingImageView.frame.size.width / 2.0f, settingImageView.frame.size.height/2.0f+20.0f);
    settingLabel.textAlignment = NSTextAlignmentCenter;
    settingLabel.textColor = COLOR_CHARACTERS_BLACK;
    settingLabel.font = [UIFont systemFontOfSize:FONT_BODY_20];
    [settingImageView addSubview:settingLabel];
    [self.view addSubview:settingImageView];
    
    UIImageView *chatImageView = [QSImageView createBlockImageViewWithFrame:CGRectMake(SIZE_DEVICE_WIDTH-35.0f-settingImageView.frame.size.width, settingImageView.frame.origin.y, settingImageView.frame.size.width, settingImageView.frame.size.height) andSingleTapCallBack:^{
        
        APPLICATION_LOG_INFO(@"点击消息", nil);
        chatImageView.highlightedImage = [UIImage imageNamed:IMAGE_DEVELOPER_HOME_CHAT_HIGHTLIGHT];
        chatImageView.highlighted = YES;
        QSYSystemMessagesViewController *smVC = [[QSYSystemMessagesViewController alloc] init];
        [self.navigationController pushViewController:smVC animated:YES];
        
    }];
    chatImageView.image = [UIImage imageNamed:IMAGE_DEVELOPER_HOME_CHAT];

    
    ///说明文字
    UILabel *chatLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,0.0f, 60.0f, 20.0f)];
    chatLabel.text = @"消息";
    chatLabel.center=CGPointMake(chatImageView.frame.size.width / 2.0f, chatImageView.frame.size.height/2.0f+20.0f);
    chatLabel.textAlignment = NSTextAlignmentCenter;
    chatLabel.textColor = COLOR_CHARACTERS_BLACK;
    chatLabel.font = [UIFont systemFontOfSize:FONT_BODY_20];
    [chatImageView addSubview:chatLabel];
    [self.view addSubview:chatImageView];
    
}

///创建在售楼盘UI
- (void)createOnsaleInfoUI:(UIView *)view andCount:(NSString *)count
{
    
    ///说明文字
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,0.0f, view.frame.size.width, 20.0f)];
    titleLabel.text = @"在售楼盘";
    titleLabel.center=CGPointMake(view.frame.size.width / 2.0f, view.frame.size.height/2.0f+10.0f);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = COLOR_CHARACTERS_BLACK;
    titleLabel.font = [UIFont systemFontOfSize:FONT_BODY_20];
    [view addSubview:titleLabel];
    
    ///在售楼盘数量
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,titleLabel.frame.origin.y-5.0f-30.0f, view.frame.size.width/2.0f+20.0f, 30.0f)];
    countLabel.text = count;
    countLabel.textAlignment = NSTextAlignmentRight;
    countLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_35];
    countLabel.textColor = COLOR_CHARACTERS_BLACK;
    [view addSubview:countLabel];
    
    ///单位
    UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(countLabel.frame.origin.x + countLabel.frame.size.width, countLabel.frame.origin.y + countLabel.frame.size.height - 20.0f, 20.0f, 20.0f)];
    unitLabel.text = @"个";
    unitLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    unitLabel.textColor = COLOR_CHARACTERS_BLACK;
    [view addSubview:unitLabel];
    
}

///创建当前活UI
- (void)createActivityInfoUI:(UIView *)view andCount:(NSString *)count
{
    ///说明文字
    UILabel *activityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,0.0f, view.frame.size.width, 20.0f)];
    activityLabel.text = @"当前活动";
    activityLabel.center=CGPointMake(view.frame.size.width / 2.0f, view.frame.size.height/2.0f+10.0f);
    activityLabel.textAlignment = NSTextAlignmentCenter;
    activityLabel.textColor = COLOR_CHARACTERS_BLACK;
    activityLabel.font = [UIFont systemFontOfSize:FONT_BODY_20];
    [view addSubview:activityLabel];
    
    ///当前活动数量
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,activityLabel.frame.origin.y-5.0f-30.0f, view.frame.size.width/2.0f+15.0f, 30.0f)];
    countLabel.text = count;
    countLabel.textAlignment = NSTextAlignmentRight;
    countLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_35];
    countLabel.textColor = COLOR_CHARACTERS_BLACK;
    [view addSubview:countLabel];
    
    ///单位
    UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(countLabel.frame.origin.x + countLabel.frame.size.width, countLabel.frame.origin.y + countLabel.frame.size.height - 20.0f, 20.0f, 20.0f)];
    unitLabel.text = @"个";
    unitLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    unitLabel.textColor = COLOR_CHARACTERS_BLACK;
    [view addSubview:unitLabel];
    

    
}

#pragma mark -添加访问量\预约量等UI
///添加房源关注view
-(void)createHouseAttentionViewUI:(UIView *)view
{
    
    ///分隔线
    UILabel *topLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,0.0f, view.frame.size.width, 0.25f)];
    topLineLabel.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [view addSubview:topLineLabel];
    
    ///间隙
    CGFloat width = 65.0f;
    CGFloat gap = (view.frame.size.width - width * 3.0f) / 2.0f-10.0f;
    
    ///访问量
    UILabel *pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 20.0f+15.0f+5.0f, width, 15.0f)];
    pageLabel.text = @"访问量";
    pageLabel.textAlignment = NSTextAlignmentCenter;
    pageLabel.textColor = COLOR_CHARACTERS_GRAY;
    pageLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    [view addSubview:pageLabel];
    
    UILabel *pageCountLable = [[UILabel alloc] initWithFrame:CGRectMake(pageLabel.frame.origin.x, 20.0f, width / 2.0f + 5.0f, 25.0f)];
    pageCountLable.text =  @"0";
    pageCountLable.textAlignment = NSTextAlignmentRight;
    pageCountLable.font = [UIFont boldSystemFontOfSize:FONT_BODY_18];
    pageCountLable.textColor = COLOR_CHARACTERS_YELLOW;
    [view addSubview:pageCountLable];
    
    UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(pageCountLable.frame.origin.x + pageCountLable.frame.size.width, 20.0f+7.5f, 15.0f, 10.0f)];
    unitLabel.text = @"次";
    unitLabel.textAlignment = NSTextAlignmentLeft;
    unitLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_14];
    unitLabel.textColor = COLOR_CHARACTERS_GRAY;
    [view addSubview:unitLabel];
    
    ///分隔线
    UILabel *sepLine = [[UILabel alloc] initWithFrame:CGRectMake(unitLabel.frame.origin.x + unitLabel.frame.size.width + gap / 2.0f, 20.0f+5.0f, 0.25f, 30.0f)];
    sepLine.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:sepLine];
    
    ///预约量
    UILabel *medicalLabel = [[UILabel alloc] initWithFrame:CGRectMake(width + gap, pageLabel.frame.origin.y, width, 15.0f)];
    medicalLabel.text = @"预约量";
    medicalLabel.textAlignment = NSTextAlignmentCenter;
    medicalLabel.textColor = COLOR_CHARACTERS_GRAY;
    medicalLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    [view addSubview:medicalLabel];
    
    UILabel *medicalCountLable = [[UILabel alloc] initWithFrame:CGRectMake(medicalLabel.frame.origin.x, pageCountLable.frame.origin.y, width / 2.0f + 5.0f, 25.0f)];
    medicalCountLable.text =  @"0";
    medicalCountLable.textAlignment = NSTextAlignmentRight;
    medicalCountLable.font = [UIFont boldSystemFontOfSize:FONT_BODY_18];
    medicalCountLable.textColor = COLOR_CHARACTERS_YELLOW;
    [view addSubview:medicalCountLable];
    
    UILabel *unitLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(medicalCountLable.frame.origin.x + medicalCountLable.frame.size.width, 20.0f+7.5f, 15.0f, 10.0f)];
    unitLabel1.text = @"次";
    unitLabel1.textAlignment = NSTextAlignmentLeft;
    unitLabel1.font = [UIFont boldSystemFontOfSize:FONT_BODY_14];
    unitLabel1.textColor = COLOR_CHARACTERS_GRAY;
    [view addSubview:unitLabel1];
    
    ///分隔线
    UILabel *sepLine1 = [[UILabel alloc] initWithFrame:CGRectMake(medicalLabel.frame.origin.x + medicalLabel.frame.size.width + gap / 2.0f, 20.0f+5.0f, 0.25f, 30.0f)];
    sepLine1.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:sepLine1];
    
    ///最受欢迎
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(2.0f * (width + gap), pageLabel.frame.origin.y, width+20.0f, 15.0f)];
    welcomeLabel.text = @"最受欢迎楼盘";
    welcomeLabel.textAlignment = NSTextAlignmentLeft;
    welcomeLabel.textColor = COLOR_CHARACTERS_GRAY;
    welcomeLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    [view addSubview:welcomeLabel];
    
    UILabel *welcomeCountLable = [[UILabel alloc] initWithFrame:CGRectMake(welcomeLabel.frame.origin.x, 20.0f, width + 20.0f, 25.0f)];
    welcomeCountLable.text =  @"青山108号";
    welcomeCountLable.textAlignment = NSTextAlignmentLeft;
    welcomeCountLable.font = [UIFont boldSystemFontOfSize:FONT_BODY_18];
    welcomeCountLable.textColor = COLOR_CHARACTERS_YELLOW;
    [view addSubview:welcomeCountLable];
    
    ///分隔线
    UILabel *bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,view.frame.size.height- 0.25f, SIZE_DEVICE_WIDTH-70.0f,  0.25f)];
    bottomLineLabel.backgroundColor = COLOR_HEXCOLORH(0x000000, 0.5f);
    [view addSubview:bottomLineLabel];
    
}

@end
