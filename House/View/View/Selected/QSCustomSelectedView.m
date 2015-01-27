//
//  QSCustomSelectedView.m
//  House
//
//  Created by ysmeng on 15/1/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCustomSelectedView.h"

#import <objc/runtime.h>

///关联
static char InfoLabelKey;   //!<信息关联
static char SelectedBoxKey; //!<选择框的关联

@interface QSCustomSelectedView ()

@property (nonatomic,retain) NSString *choiceInfo;                      //!<选择项显示的信息
@property (nonatomic,assign) CUSTOM_SELECTED_VIEW_TYPE selectedBoxType; //!<选择框的类型
@property (nonatomic,copy) void(^selectedBoxCallBack)(BOOL currentStatus);//!<单击时的回调

@end

@implementation QSCustomSelectedView

#pragma mark - 初始化
/**
 *  @author             yangshengmeng, 15-01-27 16:01:11
 *
 *  @brief              根据给定的信息和类型，创建一个选择view
 *
 *  @param frame        大小和位置
 *  @param info         选择项的显示信息
 *  @param selectedType 选择框的类型
 *
 *  @return             返回当前创建的选择框
 *
 *  @since              1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andSelectedInfo:(NSString *)info andSelectedType:(CUSTOM_SELECTED_VIEW_TYPE)selectedType andSelectedBoxTapCallBack:(void(^)(BOOL currentStatus))selectedBoxCallBack
{

    if (self = [super initWithFrame:frame]) {
        
        ///背影颜色
        self.backgroundColor = [UIColor clearColor];
        
        ///选择状态为普通
        self.selectedStatus = NO;
        
        ///保存参数
        self.choiceInfo = info;
        
        self.selectedBoxType = NO;
        
        ///保存回调
        if (selectedBoxCallBack) {
            
            self.selectedBoxCallBack = selectedBoxCallBack;
            
        }
        
        ///搭建UI
        [self createCustomSelectedBoxViewUI];
        
        ///添加手势
        [self addSingleTapGestureForSelectedView];
        
    }
    
    return self;

}

#pragma mark - UI搭建
///UI搭建
- (void)createCustomSelectedBoxViewUI
{

    ///信息显示
    UILabel *infoLabel = [[QSLabel alloc] initWithFrame:CGRectMake(10.0f, 2.0f, 240.0f, self.frame.size.height - 4.0f)];
    infoLabel.textColor = COLOR_CHARACTERS_GRAY;
    infoLabel.font = [UIFont systemFontOfSize:FONT_BODY_18];
    infoLabel.textAlignment = NSTextAlignmentLeft;
    infoLabel.text = self.choiceInfo;
    [self addSubview:infoLabel];
    objc_setAssociatedObject(self, &InfoLabelKey, infoLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///选择框
    QSImageView *selectedBoxView = [[QSImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 30.0f, (self.frame.size.height - 20.0f) / 2.0f, 20.0f, 20.0f)];
    selectedBoxView.image = [UIImage imageNamed:[self getSelectedBoxNormalImage]];
    [self addSubview:selectedBoxView];
    objc_setAssociatedObject(self, &SelectedBoxKey, selectedBoxView, OBJC_ASSOCIATION_ASSIGN);

}

///返回选择框的普通状态图片
- (NSString *)getSelectedBoxNormalImage
{

    if (cCustomSelectedViewTypeSingle == self.selectedBoxType) {
        
        return IMAGE_PUBLIC_SINGLE_SELECTED_NORMAL;
        
    } else {
    
        return IMAGE_PUBLIC_MULTIPLE_SELECTED_NORMAL;
    
    }

}

///返回选择框的选择状态图片
- (NSString *)getSelectedBoxSelectedImage
{
    
    if (cCustomSelectedViewTypeSingle == self.selectedBoxType) {
        
        return IMAGE_PUBLIC_SINGLE_SELECTED_HIGHLIGHTED;
        
    } else {
        
        return IMAGE_PUBLIC_MULTIPLE_SELECTED_HIGHLIGHTED;
        
    }
    
}

#pragma mark - 添加选择view的单击手势
- (void)addSingleTapGestureForSelectedView
{

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reversalSelectedStatus)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];

}

///反转选择框的选择状态
- (void)reversalSelectedStatus
{

    ///判断是否单选：单选时，当前选项处于选择状态，则不回调
    if (cCustomSelectedViewTypeSingle == self.selectedBoxType) {
        
        if (self.selectedStatus) {
            
            return;
            
        }
        
    }
    
    self.selectedStatus = !self.selectedStatus;
    if (self.selectedBoxCallBack) {
        
        self.selectedBoxCallBack(self.selectedStatus);
        
    }

}

#pragma mark - 更换选择view的状态状态
- (void)setSelectedStatus:(BOOL)selectedStatus
{

    UIImageView *selectedBoxView = objc_getAssociatedObject(self, &SelectedBoxKey);
    if (selectedStatus) {
        
        selectedBoxView.image = [UIImage imageNamed:[self getSelectedBoxSelectedImage]];
        
    } else {
    
        selectedBoxView.image = [UIImage imageNamed:[self getSelectedBoxNormalImage]];
    
    }

}

@end
