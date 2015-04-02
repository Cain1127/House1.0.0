//
//  QSUserAssessViewController.m
//  House
//
//  Created by 王树朋 on 15/3/23.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSUserAssessViewController.h"
#import "DeviceSizeHeader.h"
#import "QSUserAssessCell.h"

#import "QSHouseCommentDataModel.h"

#include <objc/runtime.h>

static char AssessTableKey;   //!<评论内容关联key

#define SIZE_DEFAULT_MARGIN_TAP (SIZE_DEVICE_WIDTH > 320.0f ? 30.0f : 20.0f)

@interface QSUserAssessViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) NSMutableArray *dataSource;            //!<数据源
@property (nonatomic,retain) QSHouseCommentDataModel *commentDataModel;    //!<模型数据

@end

@implementation QSUserAssessViewController

-(instancetype)initWithModel:(QSHouseCommentDataModel*) dataModel
{

    if (self=[super init]) {
        
        self.commentDataModel=dataModel;
        
    }

    return self;
}

-(void)createNavigationBarUI
{

    [super createNavigationBarUI];
    
    [self setNavigationBarTitle:@"用户评价"];

}

-(void)createMainShowUI
{
    
    UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_TAP, 15.0f, SIZE_DEVICE_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_TAP, SIZE_DEVICE_HEIGHT-64.0f)];
    [self.view addSubview:tableView];
    objc_setAssociatedObject(self, &AssessTableKey, tableView, OBJC_ASSOCIATION_ASSIGN);

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 40.0f+2.0f*SIZE_DEFAULT_MARGIN_TAP;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * CellIdentifier = @"normalInfoCell";
    
    QSUserAssessCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[QSUserAssessCell alloc] init];
        
    }
    
    ///获取模型
    QSHouseCommentDataModel *tempModel = self.dataSource[indexPath.row];
    
    [cell updateAssessCellInfo:tempModel];
    
    ///取消选择样式
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 10;

}
@end
