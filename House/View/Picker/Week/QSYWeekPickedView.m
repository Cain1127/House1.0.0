//
//  QSYWeekPickedView.m
//  House
//
//  Created by ysmeng on 15/3/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYWeekPickedView.h"

#import "QSCustomSelectedView.h"

#import "QSBlockButtonStyleModel+Normal.h"

#import "QSCoreDataManager+House.h"

#import "QSBaseConfigurationDataModel.h"

@interface QSYWeekPickedView ()

///选择星期后的回调
@property (nonatomic,copy) void(^pickWeekCallBack)(WEEK_PICKED_CALLBACK_TYPE actionType,NSArray *pickedDatas);
@property (nonatomic,retain) NSMutableArray *pickedDataInfo;//!<选择的信息

@end

@implementation QSYWeekPickedView

/**
 *  @author                     yangshengmeng, 15-03-27 12:03:41
 *
 *  @brief                      创建一个星期选择窗口
 *
 *  @param frame                大小和位置
 *  @param selectedItemModel    当前选择的内容项
 *  @param callBack             选择后的回调
 *
 *  @return                     返回当前创建的星期选择view
 *
 *  @since                      1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andPickeData:(NSArray *)pickedSource andPickedCallBack:(void(^)(WEEK_PICKED_CALLBACK_TYPE actionType,NSArray *pickedDatas))callBack
{

    if (self = [super initWithFrame:frame]) {
        
        ///背景颜色
        self.backgroundColor = [UIColor whiteColor];
        
        ///数组初始化
        self.pickedDataInfo = [[NSMutableArray alloc] init];
        
        //保存已选择项
        if ([pickedSource count] > 0) {
            
            [self.pickedDataInfo addObjectsFromArray:pickedSource];
            
        }
        
        ///保存回调
        if (callBack) {
            
            self.pickWeekCallBack = callBack;
            
        }
        
        ///搭建UI
        [self createWeekPickedInfoUI];
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createWeekPickedInfoUI
{
    
    CGFloat xpoint = 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT;
    CGFloat maxWidth = self.frame.size.width - 4.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT;

    ///选择项
    QSScrollView *pickedItemRootView = [[QSScrollView alloc] initWithFrame:CGRectMake(xpoint, 5.0f, maxWidth, self.frame.size.height - 44.0f - 35.0f - 10.0f)];
    [self createPickedItemUI:pickedItemRootView];
    [self addSubview:pickedItemRootView];
    
    ///分隔线
    UILabel *sepLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpoint, self.frame.size.height - 44.0f - 35.0f, maxWidth, 0.25f)];
    sepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self addSubview:sepLabel];
    
    ///按钮
    CGFloat height = 44.0f;
    CGFloat width = (maxWidth - 8.0f) / 2.0f;
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerWhite];
    
    ///取消按钮
    buttonStyle.title = @"取消";
    UIButton *cancelButton = [UIButton createBlockButtonWithFrame:CGRectMake(xpoint, self.frame.size.height - 44.0f - 20.0f, width, height) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///回调
        if (self.pickWeekCallBack) {
            
            self.pickWeekCallBack(wWeekPickedCallBackTypeCancel,nil);
            
        }
        
    }];
    [self addSubview:cancelButton];
    
    ///确认按钮
    buttonStyle.title = @"确认";
    UIButton *confirmButton = [UIButton createBlockButtonWithFrame:CGRectMake(cancelButton.frame.origin.x + cancelButton.frame.size.width + 8.0f, self.frame.size.height - 44.0f - 20.0f, width, height) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///判断是否有数据
        if ([self.pickedDataInfo count] > 0) {
            
            ///回调
            if (self.pickWeekCallBack) {
                
                self.pickWeekCallBack(wWeekPickedCallBackTypePicked,self.pickedDataInfo);
                
            }
            
        } else {
            
            ///回调
            if (self.pickWeekCallBack) {
                
                self.pickWeekCallBack(wWeekPickedCallBackTypeCancel,nil);
                
            }
            
        }
        
    }];
    [self addSubview:confirmButton];

}

#pragma mark - 创建选择项
- (void)createPickedItemUI:(UIScrollView *)rootView
{

    ///获取星期选择项
    NSArray *dataSource = [QSCoreDataManager getWeeksPickedType];
    
    ///循环创建选择项
    for (int i = 0; i < [dataSource count]; i++) {
        
        ///模型
        __block QSBaseConfigurationDataModel *selectedItemModel = dataSource[i];
        
        QSCustomSelectedView *tempSelectedItem = [[QSCustomSelectedView alloc] initWithFrame:CGRectMake(0.0f, i * VIEW_SIZE_NORMAL_BUTTON_HEIGHT, rootView.frame.size.width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andSelectedInfo:selectedItemModel.val andSelectedType:cCustomSelectedViewTypeMultiple andSelectedBoxTapCallBack:^(BOOL currentStatus) {
            
            ///判断是否是选择
            if (currentStatus) {
                
                ///添加
                [self addWeekData:selectedItemModel];
                
            } else {
            
                ///删除
                [self deleteWeekData:selectedItemModel];
            
            }
            
        }];
        [rootView addSubview:tempSelectedItem];
        
        ///判断是否处于选择状态
        tempSelectedItem.selectedStatus = [self checkIsSelectedData:selectedItemModel];
        
        ///分隔线
        UILabel *buttonLineLable = [[UILabel alloc] initWithFrame:CGRectMake(tempSelectedItem.frame.origin.x + 10.0f, tempSelectedItem.frame.origin.y + tempSelectedItem.frame.size.height - 0.25f, tempSelectedItem.frame.size.width - 20.0f, 0.5f)];
        buttonLineLable.backgroundColor = COLOR_CHARACTERS_BLACKH;
        [rootView addSubview:buttonLineLable];
        
    }
    
    ///判断是否需要创建滚动
    CGFloat maxHeight = VIEW_SIZE_NORMAL_BUTTON_HEIGHT * [dataSource count];
    if (maxHeight > rootView.frame.size.height) {
        
        rootView.contentSize = CGSizeMake(rootView.frame.size.width, maxHeight + 10.0f);
        
    }

}

#pragma mark - 添加选择项
- (void)addWeekData:(QSBaseConfigurationDataModel *)model
{
    
    for (QSBaseConfigurationDataModel *obj in self.pickedDataInfo) {
        
        if ([obj.key isEqualToString:model.key]) {
            
            return;
            
        }
        
    }
    
    [self.pickedDataInfo addObject:model];
    
}

#pragma mark - 删除选择项
- (void)deleteWeekData:(QSBaseConfigurationDataModel *)model
{
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.pickedDataInfo];
    
    for (QSBaseConfigurationDataModel *obj in tempArray) {
        
        if ([obj.key isEqualToString:model.key]) {
            
            [tempArray removeObject:obj];
            
            self.pickedDataInfo = tempArray;
            
            break;
            
        }
        
    }

}

#pragma mark - 检测是否在已选中
- (BOOL)checkIsSelectedData:(QSBaseConfigurationDataModel *)model
{

    for (QSBaseConfigurationDataModel *obj in self.pickedDataInfo) {
        
        if ([obj.key isEqualToString:model.key]) {
            
            return YES;
            
        }
        
    }
    
    return NO;

}

@end
