//
//  QSYAskSecondHandHouseViewController.m
//  House
//
//  Created by ysmeng on 15/4/1.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYAskSecondHandHouseViewController.h"

#import "QSBlockButtonStyleModel+Normal.h"
#import "UITextField+CustomField.h"

#import "QSFilterDataModel.h"
#import "QSBaseConfigurationDataModel.h"

#import "QSCoreDataManager+House.h"

@interface QSYAskSecondHandHouseViewController () <UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic,retain) QSFilterDataModel *releaseModel;               //!<发布时使用的数据模型
@property (nonatomic,assign) BUYHOUSE_RELEASE_STATUS_TYPE releaseStatus;    //!<当前求租信息的发布状态
@property (nonatomic,copy) void(^releasedCallBack)(BOOL isRelease);         //!<发布后的回调

@end

@implementation QSYAskSecondHandHouseViewController

/**
 *  @author             yangshengmeng, 15-04-01 14:04:42
 *
 *  @brief              创建一个发布求购的信息填写页面
 *
 *  @param filterModel  当前的求购信息数据模型
 *  @param isNewRelease 是否是新发布
 *  @param callBack     发布后的回调
 *
 *  @return             返回当前创建的求购发布页面
 *
 *  @since              1.0.0
 */
- (instancetype)initWithModel:(QSFilterDataModel *)filterModel andReleaseStatus:(BUYHOUSE_RELEASE_STATUS_TYPE)isNewRelease andCallBack:(void(^)(BOOL isRelease))callBack
{
    
    if (self = [super init]) {
        
        ///保存参数
        if (callBack) {
            
            self.releasedCallBack = callBack;
            
        }
        
        ///判断是否是新发布，或者重新发布
        if (bBuyhouseReleaseStatusTypeRerelease == isNewRelease) {
            
            self.releaseModel = filterModel;
            
        } else {
            
            self.releaseModel = [[QSFilterDataModel alloc] init];
            
        }
        
    }
    
    return self;
    
}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"求购"];
    
}

- (void)createMainShowUI
{

    ///过滤条件的底view
    QSScrollView *pickedRootView = [[QSScrollView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f - 44.0f - 15.0f)];
    [self createSettingInputUI:pickedRootView];
    [self.view addSubview:pickedRootView];
    
    ///底部确定按钮
    UIButton *commitButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_HEIGHT - 44.0f - 15.0f, SIZE_DEFAULT_MAX_WIDTH, 44.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        
        
    }];
    [commitButton setTitle:@"提交" forState:UIControlStateNormal];
    [commitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [commitButton setTitleColor:COLOR_CHARACTERS_YELLOW forState:UIControlStateHighlighted];
    commitButton.layer.cornerRadius = 6.0f;
    commitButton.backgroundColor = COLOR_CHARACTERS_YELLOW;
    [self.view addSubview:commitButton];

}

///搭建过滤器设置信息输入栏
- (void)createSettingInputUI:(QSScrollView *)view
{
    
    ///根据类型获取不同的加载plist配置文件信息
    NSDictionary *infoDict = [self getFilterSettingInfoWithType];
    
    ///数据无效，则不创建
    if (nil == infoDict || (0 >= [infoDict count])) {
        
        return;
        
    }
    
    ///遍历创建UI
    NSArray *tempInfoArray = [infoDict allValues];
    for (int i = 0; i < [tempInfoArray count]; i++) {
        
        NSDictionary *tempDict = tempInfoArray[i];
        UIView *tempTextField = [self createRightArrowSubviewWithViewInfo:tempDict];
        [view addSubview:tempTextField];
        
        ///分隔线
        UILabel *sepLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(tempTextField.frame.origin.x + 5.0f, tempTextField.frame.origin.y + tempTextField.frame.size.height + 3.5f, tempTextField.frame.size.width, 0.5f)];
        sepLineLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
        [view addSubview:sepLineLabel];
        
    }
    
    ///UI的最大高度记录
    CGFloat currentHeight = (44.0f + 8.0f) * [tempInfoArray count] + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP;
    
    ///说明信息
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT + 5.0f, currentHeight, SIZE_DEFAULT_MAX_WIDTH - SIZE_DEFAULT_MARGIN_LEFT_RIGHT - 5.0f, 30.0f)];
    tipsLabel.text = @"补充信息：(多选项)";
    tipsLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
    tipsLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    [view addSubview:tipsLabel];
    currentHeight = currentHeight + tipsLabel.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP;
    
    ///选择标签
    NSArray *featuresList = [QSCoreDataManager getHouseFeatureListWithType:fFilterMainTypeSecondHouse];
    
    ///每个标签的宽度
    CGFloat widthOfFeatures = 80.0f;
    CGFloat heightOfFeatures = 30.0f;
    CGFloat cornerOfFeatures = 3.0f;
    
    ///每行放置的个数
    int numOfFeaturesRow = SIZE_DEVICE_WIDTH > 320.0f ? 4 : 3;
    CGFloat gapOfFeatures = (SIZE_DEVICE_WIDTH - numOfFeaturesRow * widthOfFeatures) / (numOfFeaturesRow + 1);
    
    ///重置滚动页高度
    int sumRow = (int)([featuresList count] / numOfFeaturesRow + (([featuresList count] % numOfFeaturesRow) > 0 ? 1 : 0));
    
    ///创建每一个标签按钮
    int k = 0;
    for (int i = 0; i < sumRow; i++) {
        
        for (int j = 0; j < numOfFeaturesRow && k < [featuresList count]; j++) {
            
            ///标签模型
            QSBaseConfigurationDataModel *featuresModel = featuresList[k];
            
            UIButton *featuresButton = [UIButton createBlockButtonWithFrame:CGRectMake(gapOfFeatures + j * (widthOfFeatures + gapOfFeatures), currentHeight + i * (heightOfFeatures + 5.0f), widthOfFeatures, heightOfFeatures) andButtonStyle:nil andCallBack:^(UIButton *button) {
                
                if (button.selected) {
                    
                    button.selected = NO;
                    button.layer.borderColor = [COLOR_CHARACTERS_LIGHTGRAY CGColor];
                    
                    ///删除选择的标签
                    [self deleteFeatureWithModel:featuresModel];
                    
                } else {
                    
                    button.selected = YES;
                    button.layer.borderColor = [COLOR_CHARACTERS_BLACK CGColor];
                    
                    ///保存选择的标签
                    [self addFeatureWithModel:featuresModel];
                    
                }
                
            }];
            featuresButton.layer.borderColor = [COLOR_CHARACTERS_LIGHTGRAY CGColor];
            featuresButton.layer.borderWidth = 0.5f;
            [featuresButton setTitle:featuresModel.val forState:UIControlStateNormal];
            [featuresButton setTitleColor:COLOR_CHARACTERS_LIGHTGRAY forState:UIControlStateNormal];
            [featuresButton setTitleColor:COLOR_CHARACTERS_BLACK forState:UIControlStateSelected];
            featuresButton.layer.cornerRadius = cornerOfFeatures;
            featuresButton.titleLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
            featuresButton.titleLabel.adjustsFontSizeToFitWidth = YES;
            
            ///检测是否已存在标签信息
            featuresButton.selected = [self checkFeaturesIsPicked:featuresModel];
            
            [view addSubview:featuresButton];
            k++;
            
        }
        
    }
    
    ///重置高度
    currentHeight = currentHeight + heightOfFeatures * sumRow + 5.0f * (sumRow - 1) + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP;
    
    ///备注信息
    UITextView *commendField = [[UITextView alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, currentHeight, SIZE_DEFAULT_MAX_WIDTH, 160.0f)];
    commendField.backgroundColor = [UIColor whiteColor];
    commendField.showsHorizontalScrollIndicator = NO;
    commendField.showsVerticalScrollIndicator = NO;
    commendField.delegate = self;
    commendField.layer.borderColor = [COLOR_CHARACTERS_LIGHTGRAY CGColor];
    commendField.layer.borderWidth = 0.5f;
    commendField.layer.cornerRadius = VIEW_SIZE_NORMAL_CORNERADIO;
    [view addSubview:commendField];
    currentHeight = currentHeight + commendField.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP;
    
    ///判断是否可滚动
    if (currentHeight > view.frame.size.height) {
        
        view.contentSize = CGSizeMake(view.frame.size.width, currentHeight + 10.0f);
        
    }
    
}

#pragma mark - 创建右剪头控制
- (UIView *)createRightArrowSubviewWithViewInfo:(NSDictionary *)tempDict
{
    
    NSString *orderString = [tempDict valueForKey:@"order"];
    int index = [orderString intValue];
    
    ///显示信息栏
    UITextField *tempTextField = [UITextField createCustomTextFieldWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 8.0f + index * (8.0f + 44.0f), SIZE_DEFAULT_MAX_WIDTH - SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 44.0f) andPlaceHolder:nil andLeftTipsInfo:[tempDict valueForKey:@"left_title"] andLeftTipsTextAlignment:NSTextAlignmentCenter andTextFieldStyle:cCustomTextFieldStyleRightArrowLeftTipsLightGray];
    tempTextField.font = [UIFont systemFontOfSize:FONT_BODY_16];
    tempTextField.delegate = self;
    [tempTextField setValue:[tempDict valueForKey:@"action_type"] forKey:@"customFlag"];
    tempTextField.placeholder = [tempDict valueForKey:@"placehold"];
    NSString *filterInfo = [self.releaseModel valueForKey:[tempDict valueForKey:@"filter_key"]];
    if ([filterInfo length] > 0) {
        
        tempTextField.text = filterInfo;
        
    }
    
    return tempTextField;
    
}

#pragma mark - 根据不同的类型返回对应的配置文件
- (NSDictionary *)getFilterSettingInfoWithType
{
    
    ///配置信息文件路径
    NSString *infoPath = [[NSBundle mainBundle] pathForResource:PLIST_FILE_NAME_FILTER_ASK_SECONDHOUSE ofType:PLIST_FILE_TYPE];
    return [NSDictionary dictionaryWithContentsOfFile:infoPath];
    
}

#pragma mark - 保存/删除标签
- (void)addFeatureWithModel:(QSBaseConfigurationDataModel *)model
{
    
    for (QSBaseConfigurationDataModel *obj in self.releaseModel.features_list) {
        
        if ([obj.key isEqualToString:model.key]) {
            
            return;
            
        }
        
    }
    
    ///添加
    [self.releaseModel.features_list addObject:model];
    
}

- (void)deleteFeatureWithModel:(QSBaseConfigurationDataModel *)model
{
    
    ///临时数组
    NSArray *tempArray = [[NSArray alloc] initWithArray:self.releaseModel.features_list];
    [self.releaseModel.features_list removeAllObjects];
    for (QSBaseConfigurationDataModel *obj in tempArray) {
        
        if (![obj.key isEqualToString:model.key]) {
            
            [self.releaseModel.features_list addObject:obj];
            
        }
        
    }
    
}

#pragma mark - 检测标签是否已选择
- (BOOL)checkFeaturesIsPicked:(QSBaseConfigurationDataModel *)model
{
    
    for (QSBaseConfigurationDataModel *obj in self.releaseModel.features_list) {
        
        if ([obj.key isEqualToString:model.key]) {
            
            return YES;
            
        }
        
    }
    return NO;
    
}

@end
