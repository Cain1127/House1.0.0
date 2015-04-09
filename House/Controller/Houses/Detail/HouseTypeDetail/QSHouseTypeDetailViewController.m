//
//  QSHouseTypeDetailViewController.m
//  House
//
//  Created by 王树朋 on 15/3/30.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHouseTypeDetailViewController.h"

#import "QSHouseTypeDetailReturnData.h"
#import "QSHouseTypeDetailDataModel.h"
#import "QSLoupanHouseListDataModel.h"
#import "QSPhotoDataModel.h"
#import "QSRequestManager.h"

#import "QSImageView+Block.h"
#import "UIImageView+CacheImage.h"
#import "NSString+Calculation.h"
#import "URLHeader.h"
#import "QSBlockButton.h"
#import "QSBlockButtonStyleModel.h"
#import "URLHeader.h"

#import "QSScrollView.h"

#import "MJRefresh.h"

#import <objc/runtime.h>

@interface QSHouseTypeDetailViewController ()

@property (nonatomic,copy) NSString *loupan_id;             //!<楼盘ID
@property (nonatomic,copy) NSString *loupan_building_id;    //!<期数ID
//@property (nonatomic,copy) NSString *loupan_house_id;       //!<户型ID

@property (nonatomic,strong) QSScrollView *rootView;        //!<主UI
@property (nonatomic,strong) QSScrollView *topView;         //!<导航UI
@property (nonatomic,strong) QSScrollView *mainView;        //!<内容UI

@property (nonatomic,retain) QSHouseTypeDetailDataModel *detailInfo; //!<数据模型信息

@end

@implementation QSHouseTypeDetailViewController

-(instancetype)initWithLoupan_id:(NSString *)loupan_id andLoupan_building_id:(NSString *)loupan_building_id
{
    
    if (self = [super init]){
        
        self.loupan_id=loupan_id;
        self.loupan_building_id=loupan_building_id;
        //self.loupan_house_id=loupan_house_id;
        
        
    }
    
    return self;
    
}


-(void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    
    [self setNavigationBarTitle:@"户型详情"];
}

-(void)createMainShowUI
{
    
    _rootView=[[QSScrollView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT-64.0f)];
    
    [self.view addSubview:_rootView];
    
    ///添加刷新
    [_rootView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getHouseTypeDetailInfo)];
    
    ///一开始就头部刷新
    [_rootView.header beginRefreshing];
    
}


#pragma mark - 显示信息UI:网络请求成功后才显示UI
///显示信息UI:网络请求成功后才显示UI
- (void)showInfoUI:(BOOL)flag
{
    
    if (flag) {
        
        _rootView.hidden=NO;
        
    }
    
    else {
        
        _rootView.hidden=YES;
        
    }
    
}
//
#pragma mark - 创建数据UI：网络请求后，按数据创建不同的UI
///创建数据UI：网络请求后，按数据创建不同的UI
- (void)createHouseTypeDetailInfoViewUI
{
    
    ///清空原UI
    for (UIView *obj in [_rootView subviews]) {
        
        [obj removeFromSuperview];
        
    }
    
    
    _topView=[[QSScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, 50.0f)];
    [_rootView addSubview:_topView];
    [self createHouseTypeUI:_topView];
    
    
    //    self.mainView = [[QSScrollView alloc] initWithFrame:CGRectMake(0.0f, _topView.frame.origin.y+_topView.frame.size.height, SIZE_DEVICE_WIDTH, _rootView.frame.size.height-_topView.frame.size.height)];
    //    self.mainView.pagingEnabled = YES;
    //    [_rootView addSubview:self.mainView];
    
    
    
}

#pragma mark -添加顶部户型UI
///添加户型UI
-(void)createHouseTypeUI:(QSScrollView *)view
{
    
    ///每个控件的宽度
    CGFloat width = 35.0f;
    ///每个户型信息项之间的间隙
    CGFloat gap = 40.0f;
    
    CGFloat listYPoint = 50.0f ;
    
    
    ///总的户型信息个数
    int sum = (int)[self.detailInfo.loupanHouse_list count];
    
    ///底图
    UIImageView *sixFormImage = [[UIImageView alloc]initWithFrame:CGRectMake(gap, 5.0f, width, 40.0f)];
    sixFormImage.image = [UIImage imageNamed:IMAGE_HOUSES_DETAIL_HOUSETYPE_SIXFORM];
    [view addSubview:sixFormImage];
    
    
    ///循环创建户型信息
    for (int i = 0; i < sum; i++) {
        
        ///获取模型
        QSLoupanHouseListDataModel *houseTypeModel = self.detailInfo.loupanHouse_list[i];
        
        QSBlockButtonStyleModel *buttonStyle = [[QSBlockButtonStyleModel alloc] init];
        buttonStyle.title=[NSString stringWithFormat:@"%@室",houseTypeModel.house_shi ? houseTypeModel.house_shi : @"0"];
        buttonStyle.titleNormalColor=COLOR_CHARACTERS_BLACK;
        buttonStyle.bgColor = [UIColor clearColor];
        buttonStyle.titleFont=[UIFont boldSystemFontOfSize:FONT_BODY_14];
        
        ///主标题信息
        UIButton *titleButton = [QSBlockButton createBlockButtonWithFrame:CGRectMake(gap+(gap + width) *i-4.5f, 5.0f, 44.0f , 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
            
            NSLog(@"点击户型事件");
            ///如果已点击直接返回
            if (button.selected) {
                
                return ;
                
            }
            
            [_mainView removeFromSuperview];
            
            ///切换列表
            _mainView = [[QSScrollView alloc] initWithFrame:CGRectMake(0.0f, listYPoint, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - listYPoint-64.0f)];
            [_rootView addSubview:_mainView];
            
            [_mainView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getRefresh)];
            [_mainView.header beginRefreshing];
            
            [self createHouseMainView:_mainView andModel:houseTypeModel];
            
            ///移动指示器
            [UIView animateWithDuration:0.3f animations:^{
                
                sixFormImage.frame = CGRectMake(gap+ (gap + width)*i, sixFormImage.frame.origin.y, sixFormImage.frame.size.width, sixFormImage.frame.size.height);
                
                
            } completion:^(BOOL finished) {
                
                
            }];
            
            
        }];
        
        [titleButton addTarget:self action:@selector(changeChannelBarButtonStatus:) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:titleButton];
        
    }
    
    ///获取模型
    QSLoupanHouseListDataModel *houseTypeModel = self.detailInfo.loupanHouse_list[0];
    
    ///初始化时，加载商业贷款列表
    _mainView = [[QSScrollView alloc] initWithFrame:CGRectMake(0.0f, listYPoint, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - listYPoint-64.0f)];
    
    [_rootView addSubview:_mainView];
    
    [self createHouseMainView:_mainView andModel:houseTypeModel];
    
    ///判断导航栏是否需要开启滚动
    if ((width * sum + gap * (sum + 1)) > view.frame.size.width) {
        
        view.contentSize = CGSizeMake((width * sum + gap * (sum + 1)) + 10.0f, view.frame.size.height);
        
    }
    
}

#pragma mark -不带网络刷新
-(void)getRefresh
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_mainView.header endRefreshing];
        
    });
    
}
#pragma mark -同步改变导航栏按钮的状态
-(void)changeChannelBarButtonStatus:(UIButton *)button
{
    
    for (UIView *obj in [button.superview subviews] ) {
        
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *tempButton = (UIButton *)obj;
            tempButton.selected=NO;
            
        }
    }
    button.selected = YES;
    
}

#pragma mark -添加户型图片
///添加户型图片
-(void)createHouseMainView:(QSScrollView *)view andModel:(QSLoupanHouseListDataModel *)houseTypeModel
{
    
    QSImageView *headerImageView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT-50.0f-64.0f-104.0f)];
    
    [headerImageView setImage:[UIImage imageNamed:IMAGE_HOUSES_DETAIL_HEADER_DEFAULT_BG]];
    
    NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",houseTypeModel.attach_file]];
    
    [headerImageView loadImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:IMAGE_HOUSES_DETAIL_HEADER_DEFAULT_BG]];
    
    [view addSubview:headerImageView];
    
    //    QSPhotoDataModel *photoModel=[[QSPhotoDataModel alloc] init];
    //
    //    for (int i = 0; i < [houseTypeModel.photo count]; i++) {
    //
    //        photoModel =houseTypeModel.photo[i];
    //
    //        QSImageView *headerImageView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, _mainView.frame.size.height-104.0f)];
    //        [headerImageView loadImageWithURL:[photoModel.attach_file getImageURL] placeholderImage:[UIImage imageNamed:IMAGE_HOUSES_DETAIL_HEADER_DEFAULT_BG]];
    //
    //        [_mainView addSubview:headerImageView];
    //
    //    }
    ///添加底部UI
    UILabel *hoeseTotalLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0f, 0.0f+view.frame.size.height-84.0f, 100.0f, 20.0f)];
    hoeseTotalLabel.text=@"参考价格";
    hoeseTotalLabel.textAlignment=NSTextAlignmentLeft;
    hoeseTotalLabel.font=[UIFont systemFontOfSize:14.0f];
    [view addSubview:hoeseTotalLabel];
    
    UILabel *areaSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width-100.0f-30.0f, hoeseTotalLabel.frame.origin.y, 100.0f, 20.0f)];
    areaSizeLabel.text=[NSString stringWithFormat:@"%@室%@厅",houseTypeModel.house_shi,houseTypeModel.house_ting];
    areaSizeLabel.textAlignment=NSTextAlignmentRight;
    areaSizeLabel.font=[UIFont systemFontOfSize:14.0f];
    [view addSubview:areaSizeLabel];
    
    ///总计底view
    UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(30.0f, hoeseTotalLabel.frame.origin.y+hoeseTotalLabel.frame.size.height, view.frame.size.width/2.0f-3.0f-30.0f, 44.0f)];
    rootView.layer.cornerRadius = VIEW_SIZE_NORMAL_CORNERADIO;
    rootView.backgroundColor = COLOR_CHARACTERS_LIGHTYELLOW;
    [view addSubview:rootView];
    
    ///价钱信息
    UILabel *priceLabel=[[UILabel alloc] init];
    priceLabel.translatesAutoresizingMaskIntoConstraints=NO;
    priceLabel.textAlignment=NSTextAlignmentRight;
    priceLabel.text = @"150";
    priceLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_25];
    priceLabel.textColor = COLOR_CHARACTERS_BLACK;
    [rootView addSubview:priceLabel];
    
    ///单位
    UILabel *unitPriceLabel=[[UILabel alloc] init];
    unitPriceLabel.translatesAutoresizingMaskIntoConstraints=NO;
    unitPriceLabel.text = @"万";
    unitPriceLabel.textAlignment=NSTextAlignmentLeft;
    unitPriceLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_14];
    unitPriceLabel.textColor = COLOR_CHARACTERS_BLACK;
    [rootView addSubview:unitPriceLabel];
    
    ///约束参数
    NSDictionary *___viewsVFL = NSDictionaryOfVariableBindings(priceLabel,unitPriceLabel);
    
    ///约束
    NSString *___hVFL_all = @"H:|-(>=2)-[priceLabel(>=50)]-2-[unitPriceLabel(20)]-(>=25)-|";
    NSString *___vVFL_priceLabel = @"V:|-0-[priceLabel(44)]";
    NSString *___vVFL_unitPriceLabel = @"V:|-14-[unitPriceLabel(20)]";
    
    ///添加约束
    [rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_all options:0 metrics:nil views:___viewsVFL]];
    [rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_priceLabel options:0 metrics:nil views:___viewsVFL]];
    [rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_unitPriceLabel options:0 metrics:nil views:___viewsVFL]];
    
    ///面积底view
    UIView *rootView1 = [[UIView alloc] initWithFrame:CGRectMake(rootView.frame.origin.x+rootView.frame.size.width+6.0f, hoeseTotalLabel.frame.origin.y+hoeseTotalLabel.frame.size.height, rootView.frame.size.width, 44.0f)];
    rootView1.layer.cornerRadius = VIEW_SIZE_NORMAL_CORNERADIO;
    rootView1.backgroundColor = COLOR_CHARACTERS_LIGHTYELLOW;
    [view addSubview:rootView1];
    
    ///面积信息
    UILabel *areaLabel = [[UILabel alloc] init];
    areaLabel.translatesAutoresizingMaskIntoConstraints=NO;
    areaLabel.textAlignment=NSTextAlignmentRight;
     NSString *areaString= [NSString stringWithFormat:@"%d",[houseTypeModel.house_area intValue]];
    areaLabel.text = areaString ? areaString : @"0";
    areaLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_25];
    areaLabel.textColor = COLOR_CHARACTERS_BLACK;
    [rootView1 addSubview:areaLabel];
    
    ///单位
    UILabel *unitPriceLabel1 = [[UILabel alloc] init];
    unitPriceLabel1.translatesAutoresizingMaskIntoConstraints=NO;
    unitPriceLabel1.text = [NSString stringWithFormat:@"/%@",APPLICATION_AREAUNIT];
    unitPriceLabel1.font = [UIFont boldSystemFontOfSize:FONT_BODY_14];
    unitPriceLabel1.textColor = COLOR_CHARACTERS_BLACK;
    unitPriceLabel1.textAlignment=NSTextAlignmentLeft;
    [rootView1 addSubview:unitPriceLabel1];
    
    ///约束参数
    NSDictionary *___viewsVFL1 = NSDictionaryOfVariableBindings(areaLabel,unitPriceLabel1);
    
    ///约束
    NSString *___hVFL_all1 = @"H:|-(>=2)-[areaLabel(>=50)]-2-[unitPriceLabel1(20)]-(>=25)-|";
    NSString *___vVFL_areaLabel = @"V:|-0-[areaLabel(44)]";
    NSString *___vVFL_unitPriceLabel1 = @"V:|-14-[unitPriceLabel1(20)]";
    
    ///添加约束
    [rootView1 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_all1 options:0 metrics:nil views:___viewsVFL1]];
    [rootView1 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_areaLabel options:0 metrics:nil views:___viewsVFL1]];
    [rootView1 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_unitPriceLabel1 options:0 metrics:nil views:___viewsVFL1]];
    
    
}

#pragma mark -网络数据请求
-(void)getHouseTypeDetailInfo
{
    
    ///封装参数
    NSDictionary *params = @{@"loupan_id" : self.loupan_id ? self.loupan_id : @"",
                             @"loupan_building_id" : self.loupan_building_id ? self.loupan_building_id : @""
                             };
    
    
    ///进行请求
    [QSRequestManager requestDataWithType:rRequestHouseTypeDetail andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///请求成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///转换模型
            QSHouseTypeDetailReturnData *tempModel = resultData;
            
            ///保存数据模型
            self.detailInfo = tempModel.houseTypeDetailModel;
            
            ///创建详情UI
            [self createHouseTypeDetailInfoViewUI];
            [_rootView.header endRefreshing];
            
            ///1秒后停止动画，并显示界面
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self showInfoUI:YES];
                
                
            });
            
        } else {
            
            [_rootView.header endRefreshing];
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(TIPS_NEWHOUSE_DETAIL_LOADFAIL,1.0f,^(){
                
                ///推回上一页
                [self.navigationController popViewControllerAnimated:YES];
                
            })
            
        }
        
    }];
    
}

@end
