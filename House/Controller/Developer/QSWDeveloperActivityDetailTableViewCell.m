//
//  QSWDeveloperActivityDetailTableViewCell.m
//  House
//
//  Created by 王树朋 on 15/4/15.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWDeveloperActivityDetailTableViewCell.h"

#import "QSImageView+Block.h"

#import <objc/runtime.h>

///关联
static char TenantLabelKey;         //!<房客姓名
static char PhoneLabelKey;          //!<电话号码
static char SignUpCountLabelKey;    //!<报名人数

@implementation QSWDeveloperActivityDetailTableViewCell


-(instancetype)initWithFrame:(CGRect)frame
{

    if (self = [super initWithFrame:frame]) {
        
        [self createDetailInfo];
        
    }
    
    return self;

}

#pragma mark - 创建UI
-(void)createDetailInfo
{

    UILabel *tenantLabel = [[UILabel alloc] initWithFrame:CGRectMake(35.0f, 20.0f, 90.0f, 17.5f)];
    tenantLabel.text = @"房客:谢婷婷";
    tenantLabel.font = [UIFont systemFontOfSize:16.0f];
    tenantLabel.textColor = COLOR_CHARACTERS_GRAY;
    [self.contentView addSubview:tenantLabel];
    objc_setAssociatedObject(self, &TenantLabelKey, tenantLabel, OBJC_ASSOCIATION_ASSIGN);
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(tenantLabel.frame.origin.x+tenantLabel.frame.size.width+5.0f, tenantLabel.frame.origin.y, 100.0f, tenantLabel.frame.size.height)];
    phoneLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
    tenantLabel.font = [UIFont systemFontOfSize:16.0f];
    tenantLabel.text = @"13800138000";
    [self.contentView addSubview:phoneLabel];
    objc_setAssociatedObject(self, &PhoneLabelKey, phoneLabel, OBJC_ASSOCIATION_ASSIGN);
    
    
    UILabel *signUpLabel = [[UILabel alloc] initWithFrame:CGRectMake(35.0f, tenantLabel.frame.origin.y+tenantLabel.frame.size.height+5.0f, 75.0f, 17.5f)];
    signUpLabel.text = @"报名人数:";
    signUpLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
    signUpLabel.textAlignment = NSTextAlignmentLeft;
    signUpLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.contentView addSubview:signUpLabel];
    
    UILabel *signUpCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(signUpLabel.frame.origin.x+signUpLabel.frame.size.width+5.0f, signUpLabel.frame.origin.y, 60.0f, signUpLabel.frame.size.height)];
    signUpCountLabel.textAlignment = NSTextAlignmentLeft;
    signUpCountLabel.textColor = COLOR_CHARACTERS_YELLOW;
    signUpCountLabel.text = @"";
    signUpCountLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.contentView addSubview:signUpCountLabel];
    
    UIImageView *touchImageView = [QSImageView createBlockImageViewWithFrame:CGRectMake(SIZE_DEVICE_WIDTH-70.0f, 20.0f, 35.0f, 40.0f) andSingleTapCallBack:^{
        NSLog(@"打电话");
    }];
    touchImageView.image = [UIImage imageNamed:IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_NORMAL];
    [self.contentView addSubview:touchImageView];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(35.0f, 80.0f-0.25f, SIZE_DEVICE_WIDTH-2.0f*35.0f, 0.25f)];
    lineLabel.backgroundColor = COLOR_CHARACTERS_LIGHTGRAY;
    [self.contentView addSubview:lineLabel];
    
}

#pragma mark -更新数据
-(void)updateActivityDetailModel:(QSDeveloperActivityDetailDataModel *)dataModel
{

    UILabel *tenantLabel = objc_getAssociatedObject(self, &TenantLabelKey);
    UILabel *phoneLabel = objc_getAssociatedObject(self, &PhoneLabelKey);
    UILabel *signUpCountLabel = objc_getAssociatedObject(self, &SignUpCountLabelKey);
    
    tenantLabel.text = [NSString stringWithFormat:@"%@%@",@"房客: ",dataModel.buyer_name ? dataModel.buyer_name : @""];
    phoneLabel.text = dataModel.buyer_phone ? dataModel.buyer_phone : @"";
    signUpCountLabel.text = dataModel.o_expand_2 ? dataModel.o_expand_2 : @"";


}


@end
