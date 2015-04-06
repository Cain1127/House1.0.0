//
//  QSChatContactsView.m
//  House
//
//  Created by ysmeng on 15/2/9.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSChatContactsView.h"

#import "QSYContactListTableViewCell.h"

#import "QSBlockButtonStyleModel+Normal.h"

#import "QSYContactsListReturnData.h"
#import "QSYContactInfoSimpleModel.h"

#import "QSCoreDataManager+User.h"
#import "QSRequestManager.h"

#import "MJRefresh.h"

@interface QSChatContactsView () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) USER_COUNT_TYPE userType;          //!<用户类型
@property (nonatomic,strong) UITableView *contactsListView;     //!<联系人列表
@property (nonatomic,retain) NSMutableArray *contactDataSource; //!<联系人

///联系人列表中相关事件的回调
@property (nonatomic,copy) void(^contactListCallBack)(CONTACT_LIST_ACTION_TYPE actionType,id params);

@end

@implementation QSChatContactsView

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-04-03 11:04:18
 *
 *  @brief          创建联系人列表
 *
 *  @param frame    大小和位置
 *  @param userType 当前用户的类型
 *  @param callBack 列表中相关事件的回调
 *
 *  @return         返回当前创建的联系人列表
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andUserType:(USER_COUNT_TYPE)userType andCallBack:(void(^)(CONTACT_LIST_ACTION_TYPE actionType,id params))callBack
{
    
    if (self = [super initWithFrame:frame]) {
        
        ///背景颜色
        self.backgroundColor = [UIColor whiteColor];
        
        ///保存类型
        self.userType = userType;
        
        ///保存回调
        if (callBack) {
            
            self.contactListCallBack = callBack;
            
        }
        
        ///数据源初始化
        self.contactDataSource = [[NSMutableArray alloc] init];
        
        ///搭建UI
        [self createChatContactsUI];
        
    }
    
    return self;
    
}

#pragma mark - UI重建
/**
 *  @author yangshengmeng, 15-04-03 11:04:53
 *
 *  @brief  更新联系人列表
 *
 *  @since  1.0.0
 */
- (void)rebuildContactsView
{

    for (UIView *obj in [self subviews]) {
        
        [obj removeFromSuperview];
        
    }
    
    [self createChatContactsUI];

}

#pragma mark - UI搭建
///UI搭建
- (void)createChatContactsUI
{

    ///判断是否已登录
    if ([QSCoreDataManager isLogin]) {
        
        ///创建已登录的联系人列表
        [self createLoginedUI];
        
    } else {
    
        ///直接显示无联系人
        [self createNoContactUI:YES];
    
    }

}

///已登录时，先请求数据，再创建列表
- (void)createLoginedUI
{
    
    for (UIView *obj in [self subviews]) {
        
        [obj removeFromSuperview];
        
    }

    ///联系人列表
    self.contactsListView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height) style:UITableViewStyleGrouped];
    self.contactsListView.dataSource = self;
    self.contactsListView.delegate = self;
    
    self.contactsListView.showsHorizontalScrollIndicator = NO;
    self.contactsListView.showsVerticalScrollIndicator = NO;
    self.contactsListView.backgroundColor = [UIColor clearColor];
    
    self.contactsListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self addSubview:self.contactsListView];
    
    [self.contactsListView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getCurrentuserContacts)];
    [self.contactsListView.header beginRefreshing];

}

///创建无联系人页面
- (void)createNoContactUI:(BOOL)flag
{
    
    for (UIView *obj in [self subviews]) {
        
        [obj removeFromSuperview];
        
    }

    ///提示图片
    QSImageView *tipsImageView = [[QSImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0f - 37.5f, 80.0f, 75.0f, 85.0f)];
    tipsImageView.image = [UIImage imageNamed:IMAGE_CHAT_NOCONTACTS];
    [self addSubview:tipsImageView];
    
    ///提示信息
    UILabel *tipsLabel = [[QSLabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0f - 80.0f, tipsImageView.frame.origin.y + tipsImageView.frame.size.height + 10.0f, 160.0f, 20.0f)];
    tipsLabel.text = @"您暂无联系人";
    tipsLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_18];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.textColor = COLOR_CHARACTERS_BLACK;
    [self addSubview:tipsLabel];
    
    ///按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerYellow];
    buttonStyle.title = @"看看二手房源";
    UIButton *lookButton = [UIButton createBlockButtonWithFrame:CGRectMake(30.0f, tipsLabel.frame.origin.y + tipsLabel.frame.size.height + 25.0f, SIZE_DEVICE_WIDTH - 60.0f, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        if (self.contactListCallBack) {
            
            self.contactListCallBack(cContactListActionTypeLookSecondHandHouse,nil);
            
        }
        
    }];
    [self addSubview:lookButton];

}

#pragma mark - 设置列表
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return [self.contactDataSource count];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    NSArray *tempArray = self.contactDataSource[section];
    return ([tempArray count] > 0) ? [tempArray count] : 1;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 80.0f;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 44.0f;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    if (section == 0) {
        
        static NSString *importView = @"import";
        UILabel *titleLabel = [tableView dequeueReusableHeaderFooterViewWithIdentifier:importView];
        if (nil == titleLabel) {
            
            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 11.0f, SIZE_DEFAULT_MAX_WIDTH - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 20.0f)];
            titleLabel.backgroundColor = COLOR_CHARACTERS_LIGHTYELLOW;
            titleLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_16];
            
        }
        int persionNum = [self.contactDataSource[section] count];
        titleLabel.text = [NSString stringWithFormat:@"        重点关注联系人(%d)",persionNum];
        
        return titleLabel;
        
    }
    
    if (section == 1) {
        
        static NSString *normalView = @"normal";
        UILabel *titleLabel = [tableView dequeueReusableHeaderFooterViewWithIdentifier:normalView];
        if (nil == titleLabel) {
            
            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 11.0f, SIZE_DEFAULT_MAX_WIDTH - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 20.0f)];
            titleLabel.backgroundColor = COLOR_CHARACTERS_LIGHTYELLOW;
            titleLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_16];
            
        }
        int persionNum = [self.contactDataSource[section] count];
        titleLabel.text = [NSString stringWithFormat:@"        普通联系人(%d)",persionNum];
        
        return titleLabel;
        
    }
    
    return nil;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ///当前联系人数量
    NSInteger personNum = [self.contactDataSource[indexPath.section] count];
    if (personNum <= 0) {
        
        static NSString *noRecordCell = @"noRecordCell";
        UITableViewCell *cellNoRecord = [tableView dequeueReusableCellWithIdentifier:noRecordCell];
        
        if (nil == cellNoRecord) {
            
            cellNoRecord = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noRecordCell];
            cellNoRecord.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        UILabel *titleLabel = (UILabel *)[cellNoRecord.contentView viewWithTag:300];
        if (nil == titleLabel) {
            
            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 25.0f, SIZE_DEFAULT_MAX_WIDTH - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 30.0f)];
            titleLabel.textColor = COLOR_CHARACTERS_LIGHTLIGHTGRAY;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_16];
            titleLabel.tag = 300;
            [cellNoRecord.contentView addSubview:titleLabel];
            
        }
        
        ///更新提示信息
        titleLabel.text = indexPath.section == 0 ? @"暂无重点关注联系人" : @"暂无普通联系人";
        return cellNoRecord;
        
    }

    static NSString *normalCell = @"normalCell";
    QSYContactListTableViewCell *cellNormal = [tableView dequeueReusableCellWithIdentifier:normalCell];
    if (nil == cellNormal) {
        
        cellNormal = [[QSYContactListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCell];
        cellNormal.selectionStyle = UITableViewCellSelectionStyleNone;
        cellNormal.backgroundColor = [UIColor clearColor];
        
    }
    
    ///刷新数据
    [cellNormal updateContacterInfoWithModel:self.contactDataSource[indexPath.section][indexPath.row]];
    
    ///注册删除事件
    cellNormal.deleteConactCallBack = ^(BOOL isDelete){
    
        
    
    };
    
    return cellNormal;

}

#pragma mark - 点击联系人
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    QSYContactInfoSimpleModel *tempModel = self.contactDataSource[indexPath.section][indexPath.row];
    if (tempModel) {
        
        if (self.contactListCallBack) {
            
            self.contactListCallBack(cContactListActionTypeGotoContactDetail,tempModel);
            
        }
        
    }

}

#pragma mark - 请求联系人信息
- (void)getCurrentuserContacts
{

    [QSRequestManager requestDataWithType:rRequestTypeChatContactList andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        if (rRequestResultTypeSuccess == resultStatus) {
            
            QSYContactsListReturnData *tempModel = resultData;
            if ([tempModel.headerData.contactsList count] > 0) {
                
                ///重构数据源
                [self repackedContacts:tempModel.headerData.contactsList];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    ///刷新数据
                    [self.contactsListView reloadData];
                    
                    [self.contactsListView.header endRefreshing];
                    
                });
                
            } else {
            
                [self.contactsListView.header endRefreshing];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self createNoContactUI:YES];
                    
                });
            
            }
            
        } else {
        
            [self.contactsListView.header endRefreshing];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self createNoContactUI:YES];
                
            });
        
        }
        
    }];

}

#pragma mark - 处理请求回来的联系人数据
///处理请求回来的联系人数据
- (void)repackedContacts:(NSArray *)originalArray
{

    NSMutableArray *importArray = [NSMutableArray array];
    NSMutableArray *normalArray = [NSMutableArray array];
    for (int i = 0; i < [originalArray count]; i++) {
        
        QSYContactInfoSimpleModel *contactModel = originalArray[i];
        if ([contactModel.is_import intValue] == 1) {
            
            [importArray addObject:contactModel];
            
        } else {
        
            [normalArray addObject:contactModel];
            
        }
        
    }
    
    ///添加数据源
    [self.contactDataSource addObject:importArray];
    [self.contactDataSource addObject:normalArray];

}

@end
