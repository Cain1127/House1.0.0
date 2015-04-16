//
//  QSWDeveloperBuildingsTableViewCell.m
//  House
//
//  Created by 王树朋 on 15/4/16.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWDeveloperBuildingsTableViewCell.h"

#import "QSBlockButtonStyleModel+Normal.h"
#import "QSBlockButton.h"
#import "QSImageView+Block.h"
#import <objc/runtime.h>

#define SIZE_MARGIN_LEFT_RIGHT ([[UIScreen mainScreen] bounds].size.width >= 375.0f ? 35.0f : 25.0f)


///关联
static char MainImageViewKey;   //!<头像
static char TitleLabelKey;      //!<主题名称
static char AdressLabelKey;     //!<地址
static char PriceLabelKey;      //!<价钱
static char PageCountLabelKey;  //!<浏览量
static char OrderCountLabelKey; //!<预约量
static char PublishTimeLabelKey;//!<发布时间

@interface QSWDeveloperBuildingsTableViewCell()

@property(nonatomic,copy) void(^developerBuildingsCellButtonCallBack)(DEVELOPER_BUILDINGS_BUTTON_ACTION_TYPE actionType);               //!<开发商楼盘按钮事件回调

@end

@implementation QSWDeveloperBuildingsTableViewCell

-(instancetype)initWithFrame:(CGRect)frame
{

    if (self = [super initWithFrame:frame]) {
        [self createCellInfoUI];
    }

    return self;
}

#pragma mark -cell的UI
-(void)createCellInfoUI
{
    
    ///头像
    UIImageView *mainImageView = [QSImageView createBlockImageViewWithFrame:CGRectMake(SIZE_MARGIN_LEFT_RIGHT, 20.0f, 100.0f, 100.0f) andSingleTapCallBack:^{
        
        NSLog(@"点击头像");
        if (self.developerBuildingsCellButtonCallBack) {
            
            self.developerBuildingsCellButtonCallBack(dDeveloperBuildingsActionTypeHeaderImage);
            

        }
        
    }];
    [self.contentView addSubview:mainImageView];
    objc_setAssociatedObject(self, &MainImageViewKey, mainImageView, OBJC_ASSOCIATION_ASSIGN);
    UIImageView *bgSixImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, mainImageView.frame.size.width, mainImageView.frame.size.height)];
    
    ///白色六边背景
    bgSixImageView.image = [UIImage imageNamed:@"public_sixform_hollow_100x80"];
    [mainImageView addSubview:bgSixImageView];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(mainImageView.frame.origin.x+mainImageView.frame.size.width+10.0f, mainImageView.frame.origin.y+27.5f, 120.0f, 20.0f)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [self.contentView addSubview:titleLabel];
    objc_setAssociatedObject(self, &TitleLabelKey, titleLabel, OBJC_ASSOCIATION_ASSIGN);
    
    UILabel *adressLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y+titleLabel.frame.size.height+10.0f, titleLabel.frame.size.width, 15.0f)];
    adressLabel.textAlignment = NSTextAlignmentLeft;
    adressLabel.font = [UIFont systemFontOfSize:14.0f];
    adressLabel.textColor = COLOR_CHARACTERS_GRAY;
    [self.contentView addSubview:adressLabel];
    objc_setAssociatedObject(self, &AdressLabelKey, adressLabel, OBJC_ASSOCIATION_ASSIGN);
    
    UIView *priceRootView = [[UIView alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH-70.0f-SIZE_MARGIN_LEFT_RIGHT, titleLabel.frame.origin.y, 70.0f, 35.0f)];
    priceRootView.backgroundColor = COLOR_CHARACTERS_LIGHTYELLOW;
    priceRootView.layer.borderWidth = 6.0f;
    [self.contentView addSubview:priceRootView];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 7.5f, 50.0f, 20.0f)];
  //  priceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    priceLabel.textAlignment = NSTextAlignmentRight;
    priceLabel.font = [UIFont systemFontOfSize:18.0f];
    [priceRootView addSubview:priceLabel];
    objc_setAssociatedObject(self, &PriceLabelKey, priceLabel, OBJC_ASSOCIATION_ASSIGN);
    
    UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0f, 10.0f, 20.0f, 15.0f)];
//    unitLabel.translatesAutoresizingMaskIntoConstraints = NO;
    unitLabel.textAlignment = NSTextAlignmentLeft;
    unitLabel.textColor = COLOR_CHARACTERS_GRAY;
    unitLabel.text = [NSString stringWithFormat:@"%@%@",@"/",APPLICATION_AREAUNIT];
    [priceRootView addSubview:unitLabel];
    
//    ///约束参数
//    NSDictionary *viewsVFL = NSDictionaryOfVariableBindings(priceLabel,unitLabel);
//    
//    ///约束
//    NSString *hVFL_all = @"H:|-(>=2)-[priceLabel(>=30)]-2-[unitLabel(25)]-(>=2)-|";
//    NSString *vVFL_priceLabel = @"V:|-7.5-[priceLabel(20)]";
//    NSString *vVFL_unitLabel = @"V:|-10-[unitLabel(15)]";
//    
//    ///添加约束
//    [priceRootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:hVFL_all options:0 metrics:nil views:viewsVFL]];
//    [priceRootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vVFL_priceLabel options:0 metrics:nil views:viewsVFL]];
//    [priceRootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vVFL_unitLabel options:0 metrics:nil views:viewsVFL]];
    
    UILabel *pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_MARGIN_LEFT_RIGHT, mainImageView.frame.origin.y+mainImageView.frame.size.height+10.0f, 50.0f, 20.0f)];
    pageLabel.text = @"浏览量:";
    pageLabel.textAlignment = NSTextAlignmentLeft;
    pageLabel.font = [UIFont systemFontOfSize:14.0f];
    pageLabel.textColor = COLOR_CHARACTERS_GRAY;
    [self.contentView addSubview:pageLabel];
    
    UILabel *pageCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(pageLabel.frame.origin.x+pageLabel.frame.size.width, pageLabel.frame.origin.y, 35.0f, 20.0f)];
    pageCountLabel.textAlignment = NSTextAlignmentLeft;
    pageCountLabel.font = [UIFont systemFontOfSize:18.0f];
    pageCountLabel.textColor = COLOR_CHARACTERS_YELLOW;
    [self.contentView addSubview:pageCountLabel];
    objc_setAssociatedObject(self, &PageCountLabelKey, pageCountLabel, OBJC_ASSOCIATION_ASSIGN);
    
    UILabel *orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(pageCountLabel.frame.origin.x+pageCountLabel.frame.size.width+10.0f, mainImageView.frame.origin.y+mainImageView.frame.size.height+10.0f, 50.0f, 20.0f)];
    orderLabel.text = @"预约单:";
    orderLabel.textAlignment = NSTextAlignmentLeft;
    orderLabel.font = [UIFont systemFontOfSize:14.0f];
    orderLabel.textColor = COLOR_CHARACTERS_GRAY;
    [self.contentView addSubview:orderLabel];
    
    UILabel *orderCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(orderLabel.frame.origin.x+orderLabel.frame.size.width, orderLabel.frame.origin.y, 45.0f, 20.0f)];
    orderCountLabel.textAlignment = NSTextAlignmentLeft;
    orderCountLabel.font = [UIFont systemFontOfSize:18.0f];
    orderCountLabel.textColor = COLOR_CHARACTERS_YELLOW;
    [self.contentView addSubview:orderCountLabel];
    objc_setAssociatedObject(self, &OrderCountLabelKey, orderCountLabel, OBJC_ASSOCIATION_ASSIGN);
    
    UILabel *publishTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH-SIZE_MARGIN_LEFT_RIGHT-110.0f, orderCountLabel.frame.origin.y, 110.0f, 20.0f)];
    publishTimeLabel.textColor = COLOR_CHARACTERS_GRAY;
    publishTimeLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:publishTimeLabel];
    objc_setAssociatedObject(self, &PublishTimeLabelKey, publishTimeLabel, OBJC_ASSOCIATION_ASSIGN);
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_MARGIN_LEFT_RIGHT, publishTimeLabel.frame.origin.y+publishTimeLabel.frame.size.height+20.0f-0.25f, SIZE_DEVICE_WIDTH-SIZE_MARGIN_LEFT_RIGHT*2.0f, 0.25f)];
    lineLabel.textColor = COLOR_CHARACTERS_GRAY;
    [self.contentView addSubview:lineLabel];
    
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeClearGray];
    buttonStyle.cornerRadio = 6.0f;
    buttonStyle.titleHightedColor = COLOR_CHARACTERS_LIGHTYELLOW;
    buttonStyle.titleFont = [UIFont systemFontOfSize:14.0f];
    
    buttonStyle.title = @"活动报名";
    UIButton *checkDetailLabel = [QSBlockButton createBlockButtonWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH/6.0f, 15.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        if (self.developerBuildingsCellButtonCallBack) {
            
            self.developerBuildingsCellButtonCallBack(dDeveloperBuildingsActionTypeSignUp);
            
        }
        
    }];
    checkDetailLabel.center = CGPointMake(SIZE_DEVICE_WIDTH/6.0f+SIZE_DEVICE_WIDTH/12.0f, lineLabel.frame.origin.y+20.0f+7.5f);

    [self.contentView addSubview:checkDetailLabel];
    
    UILabel *lineLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH/2.0f-0.25f, checkDetailLabel.frame.origin.y-10.0f, 0.25f, 35.0f)];
    lineLabel1.textColor = COLOR_CHARACTERS_GRAY;
    [self.contentView addSubview:lineLabel1];
    
    buttonStyle.title = @"暂停发布";
    UIButton *stopPublishLabel = [QSBlockButton createBlockButtonWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH/6.0f, 15.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        if (self.developerBuildingsCellButtonCallBack) {
            self.developerBuildingsCellButtonCallBack(dDeveloperBuildingsActionTypeStopPublish);
        }
        
    }];
    stopPublishLabel.center = CGPointMake(SIZE_DEVICE_WIDTH-SIZE_DEVICE_WIDTH/6.0f-SIZE_DEVICE_WIDTH/12.0f, lineLabel.frame.origin.y+20.0f+7.5);
    [self.contentView addSubview:stopPublishLabel];
    
    UILabel *bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, stopPublishLabel.frame.origin.y+stopPublishLabel.frame.size.height+20.0f, SIZE_DEVICE_WIDTH, 0.25)];
    bottomLineLabel.textColor = COLOR_CHARACTERS_GRAY;
    [self.contentView addSubview:bottomLineLabel];
    
    
}

#pragma mark -更新楼盘数据
-(void)updateDeveloperBulidingsModel:(void (^)(DEVELOPER_BUILDINGS_BUTTON_ACTION_TYPE))callBack
{
    
    if (callBack) {
        
        self.developerBuildingsCellButtonCallBack = callBack;
        
    }
    
    UIImageView *imageView = objc_getAssociatedObject(self, &MainImageViewKey);
    UILabel *titleLabel = objc_getAssociatedObject(self, &TitleLabelKey);
    UILabel *adressLabel = objc_getAssociatedObject(self, &AdressLabelKey);
    UILabel *priceLabel = objc_getAssociatedObject(self, &PriceLabelKey);
    UILabel *pageLabel = objc_getAssociatedObject(self, &PageCountLabelKey);
    UILabel *orderLabel = objc_getAssociatedObject(self, &OrderCountLabelKey);
    UILabel *publishLabel = objc_getAssociatedObject(self, &PublishTimeLabelKey);
    
    imageView.image = [UIImage imageNamed:IMAGE_USERICON_DEFAULT_100];
    titleLabel.text = @"珠江公寓";
    adressLabel.text = @"广湛路-珠江路";
    priceLabel.text = @"999";
    pageLabel.text = @"888";
    orderLabel.text = @"345";
    publishLabel.text = [NSString stringWithFormat:@"%@%@",@"2015-04-15",@"发布"];
  

}

@end
