//
//  QSCustomSingleSelectedPopView.m
//  House
//
//  Created by ysmeng on 15/1/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCustomSingleSelectedPopView.h"
#import "QSCustomSelectedView.h"
#import "QSBlockButtonStyleModel+Normal.h"

#import <objc/runtime.h>

///关联
static char UnlimitedSelectedViewKey;   //!<不限选择项的关联
static char SelectedItemRootViewKey;    //!<选择项放置的底view关联key

@interface QSCustomSingleSelectedPopView ()

@property (nonatomic,assign) BOOL isUnlimited;              //!<是否不限
@property (nonatomic,retain) NSString *currentSelectedInfo; //!<当前选择的项
@property (nonatomic,assign) int currentSelectedIndex;      //!<当前选择项的下标

/**
 *  @author             yangshengmeng, 15-01-27 16:01:41
 *
 *  @brief              根据给定的数据源，创建单选项的选择内容
 *
 *  @param dataSource   数据源
 *  @param index        当前选择状态的下标
 *
 *  @since              1.0.0
 */
- (void)createSingleSelectedInfoUI:(NSArray *)dataSource andCurrentIndex:(int)index;

@end

@implementation QSCustomSingleSelectedPopView

#pragma mark - UI搭建
- (void)createCustomPopviewInfoUI
{
    
    ///单选弹出框的底view
    UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 84.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 84.0f)];
    rootView.backgroundColor = [UIColor whiteColor];
    [self addSubview:rootView];
    
    ///在底view上添加单击事件
    [self addSingleTapActionForRootView:rootView];
    
    ///不限
    QSCustomSelectedView *unlimitedView = [[QSCustomSelectedView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, rootView.frame.size.width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andSelectedInfo:@"不限" andSelectedType:cCustomSelectedViewTypeSingle andSelectedBoxTapCallBack:^(BOOL currentStatus) {
        
        ///如果不限当前为选择状态，则将所有选择项的选择状态置为NO
        [self setSelectedItemViewStatus];
        self.isUnlimited = YES;
        
        
    }];
    unlimitedView.selectedStatus = YES;
    self.isUnlimited = YES;
    [rootView addSubview:unlimitedView];
    objc_setAssociatedObject(self, &UnlimitedSelectedViewKey, unlimitedView, OBJC_ASSOCIATION_ASSIGN);
    
    ///分隔线
    UILabel *unlimitedLineLable = [[UILabel alloc] initWithFrame:CGRectMake(unlimitedView.frame.origin.x + 10.0f, unlimitedView.frame.origin.y + unlimitedView.frame.size.height + 3.5f, unlimitedView.frame.size.width - 20.0f, 0.5f)];
    unlimitedLineLable.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [rootView addSubview:unlimitedLineLable];
    
    ///取消按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerWhite];
    buttonStyle.title = @"取消";
    CGFloat widthOfButton = (rootView.frame.size.width - 28.0f) / 2.0f;
    UIButton *cancelButton = [UIButton createBlockButtonWithFrame:CGRectMake(10.0f, rootView.frame.size.height - 69.0f, widthOfButton, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        if (self.customPopviewTapCallBack) {
            
            self.customPopviewTapCallBack(cCustomPopviewActionTypeCancel,nil,-2);
            
        }
        [self hiddenCustomSingleSelectedPopview];
        
    }];
    [rootView addSubview:cancelButton];
    
    ///确认按钮
    buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerYellow];
    buttonStyle.title = @"确定";
    UIButton *confirmButton = [UIButton createBlockButtonWithFrame:CGRectMake(rootView.frame.size.width / 2.0f + 4.0f, cancelButton.frame.origin.y, widthOfButton, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///判断是否是不限
        if (self.isUnlimited) {
            
            if (self.customPopviewTapCallBack) {
                
                self.customPopviewTapCallBack(cCustomPopviewActionTypeUnLimited,nil,0);
                
            }
            
        } else {
        
            if (self.customPopviewTapCallBack) {
                
                ///将当前选择的信息回调
                self.customPopviewTapCallBack(cCustomPopviewActionTypeSingleSelected,self.currentSelectedInfo,self.currentSelectedIndex);
                
            }
        
        }
        
        ///移聊选择框
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

#pragma mark - 将选择项里的选择状态置为NO
- (void)setSelectedItemViewStatus
{

    ///获取选择项的底view
    UIView *rootView = objc_getAssociatedObject(self, &SelectedItemRootViewKey);
    
    for (UIView *obj in [rootView subviews]) {
        
        if ([obj isKindOfClass:[QSCustomSelectedView class]]) {
            
            ((QSCustomSelectedView *)obj).selectedStatus = NO;
            
        }
        
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

#pragma mark - 在显示的底view上添加单击事件
- (void)addSingleTapActionForRootView:(UIView *)view
{

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleSelectedViewRootViewTapAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [view addGestureRecognizer:tap];

}

///底view的单击手势：为了屏蔽单击事件往上往递
- (void)singleSelectedViewRootViewTapAction:(UITapGestureRecognizer *)tap
{

    

}

#pragma mark - 根据数据源搭建选择项UI
- (void)createSingleSelectedInfoUI:(NSArray *)dataSource andCurrentIndex:(int)index
{

    ///获取选择项的底view
    UIScrollView *rootView = objc_getAssociatedObject(self, &SelectedItemRootViewKey);
    if (nil == rootView) {
        
        return;
        
    }
    
    ///循环创建选择项
    for (int i = 0; i < [dataSource count]; i++) {
        
        __block QSCustomSelectedView *tempSelectedItem = [[QSCustomSelectedView alloc] initWithFrame:CGRectMake(0.0f, i * VIEW_SIZE_NORMAL_BUTTON_HEIGHT, rootView.frame.size.width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andSelectedInfo:dataSource[i] andSelectedType:cCustomSelectedViewTypeSingle andSelectedBoxTapCallBack:^(BOOL currentStatus) {
            
            ///如果选择一项单选，则将不限的选择状态取消
            QSCustomSelectedView *unlimitedView = objc_getAssociatedObject(self, &UnlimitedSelectedViewKey);
            unlimitedView.selectedStatus = NO;
            self.isUnlimited = NO;
            
            ///让所有单选项处于非选择状态
            [self setSelectedItemViewStatus];
            
            ///保存选择信息
            self.currentSelectedInfo = dataSource[i];
            self.currentSelectedIndex = i;
            
            tempSelectedItem.selectedStatus = YES;
            
        }];
        [rootView addSubview:tempSelectedItem];
        
        ///分隔线
        UILabel *buttonLineLable = [[UILabel alloc] initWithFrame:CGRectMake(tempSelectedItem.frame.origin.x + 10.0f, tempSelectedItem.frame.origin.y + tempSelectedItem.frame.size.height - 0.25f, tempSelectedItem.frame.size.width - 20.0f, 0.5f)];
        buttonLineLable.backgroundColor = COLOR_CHARACTERS_BLACKH;
        [rootView addSubview:buttonLineLable];
        
        ///是否存在选择状态的下标
        if (index >= 0 && i == index) {
            
            tempSelectedItem.selectedStatus = YES;
            self.isUnlimited = NO;
            QSCustomSelectedView *unlimitedView = objc_getAssociatedObject(self, &UnlimitedSelectedViewKey);
            unlimitedView.selectedStatus = NO;
            self.currentSelectedInfo = dataSource[i];
            self.currentSelectedIndex = i;
            
        }
        
    }
    
    ///判断是否需要创建滚动
    CGFloat maxHeight = VIEW_SIZE_NORMAL_BUTTON_HEIGHT * [dataSource count];
    if (maxHeight > rootView.frame.size.height) {
        
        rootView.contentSize = CGSizeMake(rootView.frame.size.width, maxHeight + 10.0f);
        
    }

}

#pragma mark - 根据数据源创建并显示一个单选窗口
/**
 *  @author                 yangshengmeng, 15-01-27 15:01:29
 *
 *  @brief                  弹出一个给定数据源的单选框
 *
 *  @param dataSource       数据源
 *  @param currentIndex     当前选择状态的选择项
 *  @param selectedCallBack 选择并确认后的回调
 *
 *  @return                 返回当前创建的弹出窗口
 *
 *  @since                  1.0.0
 */
+ (instancetype)showSingleSelectedViewWithDataSource:(NSArray *)dataSource andCurrentSelectedIndex:(int)currentIndex andSelectedCallBack:(void(^)(CUSTOM_POPVIEW_ACTION_TYPE actionType,id params,int selectedIndex))selectedCallBack
{

    QSCustomSingleSelectedPopView *singleSelectedView = [[QSCustomSingleSelectedPopView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT)];
    
    ///保存回调
    if (selectedCallBack) {
        
        singleSelectedView.customPopviewTapCallBack = selectedCallBack;
        
    }
    
    ///搭建选择数据的UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [singleSelectedView createSingleSelectedInfoUI:dataSource andCurrentIndex:currentIndex];
        
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