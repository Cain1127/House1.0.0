//
//  QSYContactComplaintViewController.m
//  House
//
//  Created by ysmeng on 15/4/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYContactComplaintViewController.h"
#import "QSPOrderBottomButtonView.h"
#import "QSCustomHUDView.h"
#import "QSPOrderDetailActionReturnBaseDataModel.h"
#import "QSPOrderSubmitResultViewController.h"
#import "QSYShakeRecommendHouseViewController.h"
#import "QSPOrderDetailBookedViewController.h"

@interface QSYContactComplaintViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,copy) NSString *viewTitle;     //!<界面标题
@property (nonatomic,copy) NSString *actionTitle;   //!<选择的类别
@property (nonatomic,strong) NSArray *reasonList;   //!<投诉原因
@property (nonatomic,copy) NSString *contactID;     //!<被投诉人ID
//@property (nonatomic,copy) NSString *contactName;   //!<被投诉人姓名
@property (nonatomic,copy) NSString *orderID;       //!<订单ID
@property (nonatomic,copy) NSString *complain_type; //!<投诉原因
@property (nonatomic,copy) NSString *desc;          //!<投诉的附加内容
@property (nonatomic,copy) NSString *sueder;        //!<投诉者，BUYER:买家投诉卖家，SALER:卖家投诉买家
///投诉后的回调
@property (nonatomic,copy) void(^complaintCallBack)(BOOL isComplaint);


@property (nonatomic,strong) UITableView *complaintListTableView;

@end

@implementation QSYContactComplaintViewController

#pragma mark - 初始化
/**
 *  @author             yangshengmeng, 15-04-13 16:04:57
 *
 *  @brief              根据联系人的ID和姓名，显示投诉页面
 *
 *  @param contactID    联系人ID
 *  @param contactName  联系人姓名
 *
 *  @return             返回当前联系人的投诉页面
 *
 *  @since              1.0.0
 */
- (instancetype)initWithContactID:(NSString *)contactID andContactName:(NSString *)contactName
{

    return [self initWithContactID:contactID andContactName:contactName andOrderID:nil andCallBack:nil];

}

/**
 *  @author             yangshengmeng, 15-04-14 11:04:08
 *
 *  @brief              创建订单投诉页面
 *
 *  @param contactID    被投诉人的ID
 *  @param contactName  被投诉人的姓名
 *  @param orderID      订单ID
 *  @param callBack     投诉完成后的回调
 *
 *  @return             返回当前创建的投诉页面
 *
 *  @since              1.0.0
 */
- (instancetype)initWithContactID:(NSString *)contactID andContactName:(NSString *)contactName andOrderID:(NSString *)orderID andCallBack:(void(^)(BOOL isComplaint))callBack
{

    if (self = [super init]) {
        
        ///保存参数
        self.contactID = contactID;
//        self.contactName = contactName;
        self.orderID = orderID;
        
        self.viewTitle = @"投诉举报";
        self.actionTitle = @"投诉";
        
        if (callBack) {
            
            self.complaintCallBack = callBack;
            
        }
        
    }
    
    return self;

}

/**
 *  根据传入字段创建投诉页面
 *
 *  @param indicteeId 被投诉者id（在处理投诉联系人时，此参数必须要传）
 *  @param sueder     投诉者，BUYER:买家投诉卖家，SALER:卖家投诉买家
 *  @param orderID    订单id（在处理订单投诉时，此参数必须要传）
 *  @param desc       投诉的附加内容
 *  @param callBack   回调
 *
 *  @return 返回当前联系人的投诉页面
 */
- (instancetype)initWithIndicteeId:(NSString *)indicteeId andSueder:(NSString *)sueder andOrderID:(NSString *)orderID WithDesc:(NSString*)desc andCallBack:(void(^)(BOOL isComplaint))callBack
{
    
    if (self = [super init]) {
        
        ///保存参数
        self.contactID = indicteeId;
        self.orderID = orderID;
        self.sueder = sueder;
        self.desc = desc;
        
        self.viewTitle = @"投诉举报";
        self.actionTitle = @"投诉";
        
        self.reasonList = [NSArray array];
        
        if (self.contactID) {
            
            //投诉联系人
            self.reasonList = [NSArray arrayWithObjects:@"中介骚扰", @"虚假房源", @"爽约，不诚实", @"态度恶劣", @"广告骚扰", nil];
            
        } else {
            
            if ([self.sueder isEqualToString:@"BUYER"]) {
                
                //买家投诉卖家
                self.reasonList = [NSArray arrayWithObjects:@"中介骚扰", @"描述不符，虚假房源", @"业主爽约，不诚实", @"业主态度恶劣", @"广告骚扰", nil];
                
            }else if ([self.sueder isEqualToString:@"SALER"]) {
                
                //卖家投诉买家
                self.reasonList = [NSArray arrayWithObjects:@"中介骚扰", @"房客爽约，不诚实",  @"房客态度恶劣", @"广告骚扰", nil];
                
            }
            
        }
        
        if (callBack) {
            
            self.complaintCallBack = callBack;
            
        }
        
    }
    
    return self;
    
}

- (instancetype)initWithCancelOrderWithSueder:(NSString *)sueder andOrderID:(NSString *)orderID WithDesc:(NSString*)desc andCallBack:(void(^)(BOOL isComplaint))callBack
{
    
    if (self = [super init]) {
        
        ///保存参数
        self.orderID = orderID;
        self.sueder = sueder;
        self.desc = desc;
        
        self.viewTitle = @"取消预约";
        self.actionTitle = @"取消预约";
        
        self.reasonList = [NSArray arrayWithObjects:@"中介骚扰", @"发布虚假信息", @"没有空", @"不想看了", @"其他原因", nil];
        
        if (callBack) {
            
            self.complaintCallBack = callBack;
            
        }
        
    }
    
    return self;
    
}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    [self setNavigationBarTitle:self.viewTitle];

}

///搭建主展示UI
- (void)createMainShowUI
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, 40.0f)];
    [titleLabel setBackgroundColor:COLOR_CHARACTERS_GRAY];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:FONT_BODY_18]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:[NSString stringWithFormat:@"请选择%@原因",self.actionTitle]];
    
    [self.view addSubview:titleLabel];
    
    QSPOrderBottomButtonView *submitBtView = [[QSPOrderBottomButtonView alloc] initAtTopLeft:CGPointMake(0.0f, 0.0f) withButtonCount:1 andCallBack:^(BOTTOM_BUTTON_TYPE buttonType, UIButton *button) {
        
        switch (buttonType) {
            case bBottomButtonTypeOne:
                
                [self submitComlaintInfo];
                
                break;
                
            default:
                break;
        }
        
    }];
    [submitBtView setCenterBtTitle:@"提交"];
    
    ///原因列表
    self.complaintListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, titleLabel.frame.origin.y+titleLabel.frame.size.height, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f - 40.0f-submitBtView.frame.size.height)];
    
    ///取消滚动条
    self.complaintListTableView.showsHorizontalScrollIndicator = NO;
    self.complaintListTableView.showsVerticalScrollIndicator = NO;
    
    ///数据源
    self.complaintListTableView.dataSource = self;
    self.complaintListTableView.delegate = self;
    
    self.complaintListTableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:self.complaintListTableView];
    
    [submitBtView setFrame:CGRectMake(submitBtView.frame.origin.x, self.complaintListTableView.frame.origin.y+self.complaintListTableView.frame.size.height, submitBtView.frame.size.width, submitBtView.frame.size.height)];
    [self.view addSubview:submitBtView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSInteger count = 0;
    if (self.reasonList) {
        count = [self.reasonList count];
    }
    
    return count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ///复用标签
    static NSString *BookingOrderListsTableViewCellName = @"reasonListsTableViewCell";
    
    ///从复用队列中获取cell
    UITableViewCell *cellSystem = [tableView dequeueReusableCellWithIdentifier:BookingOrderListsTableViewCellName];
    
    ///判断是否需要重新创建
    if (nil == cellSystem) {
        
        cellSystem = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BookingOrderListsTableViewCellName];
        
        ///取消选择状态
//        [cellSystem setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cellSystem.textLabel setTextAlignment:NSTextAlignmentCenter];
        [cellSystem.textLabel setFont:[UIFont systemFontOfSize:FONT_BODY_16]];
        
    }
    
    [cellSystem.textLabel setText:[self.reasonList objectAtIndex:indexPath.row]];
    
    return cellSystem;
    
}


#pragma mark - 请求投诉
- (void)submitComlaintInfo
{

    NSIndexPath *selectedIndexPath = nil;
    if (self.complaintListTableView) {
        selectedIndexPath = [self.complaintListTableView indexPathForSelectedRow];
    }
    if (selectedIndexPath) {
        NSLog(@"selectedIndexPath : %ld",(long)selectedIndexPath.row);
        
    }else{
        NSString *tipStr = [NSString stringWithFormat:@"请选择您要%@的原因",self.actionTitle];
        TIPS_ALERT_MESSAGE_ANDTURNBACK(tipStr, 1.0f, ^(){})
        return;
    }
    
    QSCustomHUDView *hud = [QSCustomHUDView showCustomHUD];
    
    //请求参数
    //必选	类型及范围	说明
    //user_id	true	string	投诉者id
    //order_id	true	string	订单id（在处理订单投诉时，此参数必须要传）
    //complain_type	true	string	字符串，对应具体什么原因，直接保存字符串
    //desc	true	string	投诉的附加内容
    //indictee_id	true	string	被投诉者id（在处理投诉联系人时，此参数必须要传）
    //sueder	true	string	投诉者，BUYER ： 买家投诉卖家，SALER ： 卖家投诉买家
    
    NSMutableDictionary *tempParam = [NSMutableDictionary dictionaryWithDictionary:0];
    
    [tempParam setObject:self.orderID?self.orderID:@"" forKey:@"order_id"];
    [tempParam setObject:[self.reasonList objectAtIndex:selectedIndexPath.row] forKey:@"complaint_type"];
    [tempParam setObject:self.desc?self.desc:@"" forKey:@"desc"];
    [tempParam setObject:self.contactID?self.contactID:@"" forKey:@"indictee_id"];
    [tempParam setObject:self.sueder?self.sueder:@"" forKey:@"sueder"];
    
    [QSRequestManager requestDataWithType:rRequestTypeChatComplainContact andParams:tempParam andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        QSPOrderDetailActionReturnBaseDataModel *headerModel = (QSPOrderDetailActionReturnBaseDataModel*)resultData;
        
        ///转换模型
        if (rRequestResultTypeSuccess == resultStatus) {
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(headerModel.info, 1.0f, ^(){
                QSPOrderSubmitResultViewController *srVc = [[QSPOrderSubmitResultViewController alloc] initWithResultType:oOrderSubmitResultTypeSubmitComplaintSuccessed andAutoBackCallBack:^(ORDER_SUBMIT_RESULT_BACK_TYPE backType){
                    
                    switch (backType) {
                        case oOrderSubmitResultBackTypeAuto:
                            
                            NSLog(@"auto back");
                            [self gotoTurnBackAction];
                            break;
                        default:
                            break;
                    }
                    
                    
                }];
                
                [self presentViewController:srVc animated:YES completion:^{
                    
                }];
            })
            
        }
        
        ///转换模型
        if (headerModel) {
            
            if (headerModel&&[headerModel isKindOfClass:[QSPOrderDetailActionReturnBaseDataModel class]]) {
                TIPS_ALERT_MESSAGE_ANDTURNBACK(headerModel.msg, 1.0f, ^(){
                    
                    
                })
            }else if (headerModel&&[headerModel isKindOfClass:[QSHeaderDataModel class]]) {
                TIPS_ALERT_MESSAGE_ANDTURNBACK(headerModel.info, 1.0f, ^(){
                    
                    
                })
            }
            
        }
        
        [hud hiddenCustomHUD];
        
    }];
}

@end
