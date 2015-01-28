//
//  QSMultipleSelectedPopView.m
//  House
//
//  Created by ysmeng on 15/1/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSMultipleSelectedPopView.h"
#import "QSCustomSelectedView.h"
#import "QSBlockButtonStyleModel+Normal.h"

#import <objc/runtime.h>

///关联
static char SelectedAllViewKey;         //!<全选的view关联
static char SelectedItemRootViewKey;    //!<选择项放置的底view关联key

@interface QSMultipleSelectedPopView ()

@property (nonatomic,assign) BOOL isSelectedAll;                //!<是否全选标识
@property (nonatomic,retain) NSMutableDictionary *selectedInfos;//!<多选的结果

@end

@implementation QSMultipleSelectedPopView

#pragma mark - UI搭建
- (void)createCustomPopviewInfoUI
{
    
    ///单选弹出框的底view
    UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 84.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 84.0f)];
    rootView.backgroundColor = [UIColor whiteColor];
    [self addSubview:rootView];
    
    ///不限
    QSCustomSelectedView *unlimitedView = [[QSCustomSelectedView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, rootView.frame.size.width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andSelectedInfo:@"不限" andSelectedType:cCustomSelectedViewTypeMultiple andSelectedBoxTapCallBack:^(BOOL currentStatus) {
        
        ///如果不限当前为选择状态，则将所有选择项的选择状态置为NO
        [self setSelectedItemViewStatus:currentStatus];
        self.isSelectedAll = currentStatus;
        
        
    }];
    unlimitedView.selectedStatus = NO;
    self.isSelectedAll = NO;
    [rootView addSubview:unlimitedView];
    objc_setAssociatedObject(self, &SelectedAllViewKey, unlimitedView, OBJC_ASSOCIATION_ASSIGN);
    
    ///分隔线
    UILabel *unlimitedLineLable = [[UILabel alloc] initWithFrame:CGRectMake(unlimitedView.frame.origin.x + 10.0f, unlimitedView.frame.origin.y + unlimitedView.frame.size.height + 3.5f, unlimitedView.frame.size.width - 20.0f, 0.5f)];
    unlimitedLineLable.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [rootView addSubview:unlimitedLineLable];
    
    ///取消按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerWhite];
    buttonStyle.title = @"取消";
    CGFloat widthOfButton = (rootView.frame.size.width - 28.0f) / 2.0f;
    UIButton *cancelButton = [UIButton createBlockButtonWithFrame:CGRectMake(10.0f, rootView.frame.size.height - 69.0f, widthOfButton, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        [self hiddenCustomSingleSelectedPopview];
        
    }];
    [rootView addSubview:cancelButton];
    
    ///确认按钮
    buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerYellow];
    buttonStyle.title = @"确定";
    UIButton *confirmButton = [UIButton createBlockButtonWithFrame:CGRectMake(rootView.frame.size.width / 2.0f + 4.0f, cancelButton.frame.origin.y, widthOfButton, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///判断是否是不限
        if (self.isSelectedAll) {
            
            if (self.customPopviewTapCallBack) {
                
                self.customPopviewTapCallBack(cCustomPopviewActionTypeUnLimited,nil,-1);
                
            }
            
        } else {
            
            if (self.customPopviewTapCallBack) {
                
                ///将当前选择的信息回调
                self.customPopviewTapCallBack(cCustomPopviewActionTypeMultipleSelected,self.selectedInfos,-1);
                
            }
            
        }
        
        ///移聊复选窗口
        [self hiddenCustomSingleSelectedPopview];
        
    }];
    [rootView addSubview:confirmButton];
    
    ///分隔线
    UILabel *buttonLineLable = [[UILabel alloc] initWithFrame:CGRectMake(unlimitedView.frame.origin.x + 10.0f, confirmButton.frame.origin.y - 14.5f, unlimitedView.frame.size.width - 20.0f, 0.5f)];
    buttonLineLable.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [rootView addSubview:buttonLineLable];
    
    ///其他选择项的底view
    UIScrollView *selectedItemRootView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f,unlimitedView.frame.size.height + 4.0f, rootView.frame.size.width, rootView.frame.size.height - unlimitedView.frame.size.height - 88.0f)];
    selectedItemRootView.backgroundColor = [UIColor clearColor];
    selectedItemRootView.showsHorizontalScrollIndicator = NO;
    selectedItemRootView.showsVerticalScrollIndicator = NO;
    [rootView addSubview:selectedItemRootView];
    [rootView sendSubviewToBack:selectedItemRootView];
    objc_setAssociatedObject(self, &SelectedItemRootViewKey, selectedItemRootView, OBJC_ASSOCIATION_ASSIGN);
    
}

#pragma mark - 将选择项里的选择状态置为status
- (void)setSelectedItemViewStatus:(BOOL)status
{
    
    ///获取选择项的底view
    UIView *rootView = objc_getAssociatedObject(self, &SelectedItemRootViewKey);
    
    for (UIView *obj in [rootView subviews]) {
        
        if ([obj isKindOfClass:[QSCustomSelectedView class]]) {
            
            ((QSCustomSelectedView *)obj).selectedStatus = status;
            
        }
        
    }
    
}

///当有选择框被选择时，需要检测是否需要显示全选
- (void)resetSelectedAllBox
{

    ///获取选择项的底view
    UIView *rootView = objc_getAssociatedObject(self, &SelectedItemRootViewKey);
    ///如果选择一项单选，则将不限的选择状态取消
    QSCustomSelectedView *unlimitedView = objc_getAssociatedObject(self, &SelectedAllViewKey);
    
    for (UIView *obj in [rootView subviews]) {
        
        if ([obj isKindOfClass:[QSCustomSelectedView class]]) {
            
            QSCustomSelectedView *selectedItemView = (QSCustomSelectedView *)obj;
            if (selectedItemView.selectedStatus) {
                
                continue;
                
            } else {
            
                unlimitedView.selectedStatus = NO;
                self.isSelectedAll = NO;
                return;
            
            }
            
        }
        
    }
    
    unlimitedView.selectedStatus = YES;
    self.isSelectedAll = YES;

}

#pragma mark - 根据数据源搭建选择项UI
- (void)createSingleSelectedInfoUI:(NSArray *)dataSource
{
    
    ///获取选择项的底view
    UIScrollView *rootView = objc_getAssociatedObject(self, &SelectedItemRootViewKey);
    if (nil == rootView) {
        
        return;
        
    }
    
    ///循环创建选择项
    for (int i = 0; i < [dataSource count]; i++) {
        
        ///模型
        NSDictionary *selectedItemDict = dataSource[i];
        
        QSCustomSelectedView *tempSelectedItem = [[QSCustomSelectedView alloc] initWithFrame:CGRectMake(0.0f, i * VIEW_SIZE_NORMAL_BUTTON_HEIGHT, rootView.frame.size.width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andSelectedInfo:[selectedItemDict valueForKey:@"info"] andSelectedType:cCustomSelectedViewTypeMultiple andSelectedBoxTapCallBack:^(BOOL currentStatus) {
            
            if (currentStatus) {
                
                ///判断是否已全选
                [self resetSelectedAllBox];
                
                ///添加参数
                [self.selectedInfos setObject:dataSource[i] forKey:[NSString stringWithFormat:@"%d",i]];
                
            } else {
            
                ///如果选择一项单选，则将不限的选择状态取消
                QSCustomSelectedView *unlimitedView = objc_getAssociatedObject(self, &SelectedAllViewKey);
                unlimitedView.selectedStatus = NO;
                self.isSelectedAll = NO;
                
                ///删除选择暂存参数
                [self.selectedInfos removeObjectForKey:[NSString stringWithFormat:@"%d",i]];
            
            }
            
        }];
        [rootView addSubview:tempSelectedItem];
        
        ///判断是否处于选择状态
        int selectedStatus = [[selectedItemDict valueForKey:@"selected"] intValue];
        if (1 == selectedStatus) {
            
            tempSelectedItem.selectedStatus = YES;
            
        } else {
        
            tempSelectedItem.selectedStatus = NO;
        
        }
        
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

#pragma mark - 移除单选弹出框
- (void)hiddenCustomSingleSelectedPopview
{
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    ///回收
    if ([self respondsToSelector:@selector(hiddenCustomPopview)]) {
        
        [self performSelector:@selector(hiddenCustomPopview)];
        
    }
    
#pragma clang diagnostic pop
    
}

#pragma mark - 根据数据源创建并显示一个多选窗口
/**
 *  @author                 yangshengmeng, 15-01-27 15:01:29
 *
 *  @brief                  弹出一个给定数据源的单选框
 *
 *  @param dataSource       数据源
 *  @param currentIndexs    当前选择状态的选择项
 *  @param selectedCallBack 选择并确认后的回调
 *
 *  @return                 返回当前创建的弹出窗口
 *
 *  @since                  1.0.0
 */
+ (instancetype)showMultipleSelectedViewWithDataSource:(NSArray *)dataSource andSelectedCallBack:(void(^)(CUSTOM_POPVIEW_ACTION_TYPE actionType,id params,int selectedIndex))selectedCallBack
{
    
    QSMultipleSelectedPopView *singleSelectedView = [[QSMultipleSelectedPopView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT)];
    
    ///保存回调
    if (selectedCallBack) {
        
        singleSelectedView.customPopviewTapCallBack = selectedCallBack;
        
    }
    
    ///搭建选择数据的UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [singleSelectedView createSingleSelectedInfoUI:dataSource];
        
    });
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    ///显示
    if ([singleSelectedView respondsToSelector:@selector(showCustomPopview)]) {
        
        [singleSelectedView performSelector:@selector(showCustomPopview)];
        
    }
    
#pragma clang diagnostic pop
    
    return singleSelectedView;
    
}

@end
