//
//  QSOpinionFeedbackViewController.m
//  House
//
//  Created by 王树朋 on 15/5/2.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSOpinionFeedbackViewController.h"

#import "QSCustomHUDView.h"

#import "QSBlockButtonStyleModel+Normal.h"

@interface QSOpinionFeedbackViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView* contentTextView;      //!<内容UI
@property (nonatomic, strong) UILabel *placeholderLabel;        //!<站位UI

@end

@implementation QSOpinionFeedbackViewController

-(void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"意见反馈"];
    
}

-(void)createMainShowUI
{
    
    self.contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, SIZE_DEFAULT_MARGIN_LEFT_RIGHT+64.0f, SIZE_DEVICE_WIDTH-2*CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, 150)];
    [self.contentTextView setBackgroundColor:[UIColor clearColor]];
    [self.contentTextView setFont:[UIFont systemFontOfSize:FONT_BODY_16]];
    [self.contentTextView setDelegate:self];
    [self.contentTextView setReturnKeyType:UIReturnKeyDone];
    [self.contentTextView.layer setBorderColor:[COLOR_CHARACTERS_LIGHTGRAY CGColor]];
    [self.contentTextView.layer setBorderWidth:1.0f];
    [self.contentTextView.layer setCornerRadius:5.0f];
    [self.view addSubview:self.contentTextView];
    
    self.placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, -15, SIZE_DEVICE_WIDTH-12, 32*2)];
    [self.placeholderLabel setBackgroundColor:[UIColor clearColor]];
    [self.placeholderLabel setText:@"用得怎样,说两句"];
    [self.placeholderLabel setNumberOfLines:0];
    [self.placeholderLabel setFont:[UIFont systemFontOfSize:FONT_BODY_16]];
    [self.placeholderLabel setTextColor:COLOR_CHARACTERS_LIGHTGRAY];
    [self.contentTextView addSubview:self.placeholderLabel];
    
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
    buttonStyle.titleNormalColor = COLOR_CHARACTERS_BLACK;
    buttonStyle.title = @"发表";
    
    UIButton *publishButton = [QSBlockButton createBlockButtonWithFrame:CGRectMake(CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, self.contentTextView.frame.origin.y+self.contentTextView.frame.size.height+10.0f, SIZE_DEVICE_WIDTH-2.0f*CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///判断内容
        if ([self.contentTextView.text length] <= 0) {
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"请先填写意见内容", 1.0f, ^(){})
            return;
            
        }
        
        ///回收键盘
        [self.contentTextView resignFirstResponder];
        [[NSUserDefaults standardUserDefaults] setObject:self.contentTextView.text forKey:@"publishString"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self postRequesPublishInfo];
        
    }];
    
    [self.view addSubview:publishButton];
}

#pragma mark -- textView代理方法
- (void)textViewDidBeginEditing:(UITextView *)textView;
{
    if (textView.text.length != 0)
    {
        [self.placeholderLabel setHidden:YES];
    }
    else
    {
        [self.placeholderLabel setHidden:NO];
    }
    
}

- (void)textViewDidChange:(UITextView *)textView;
{
    if (textView.text.length != 0)
    {
        [self.placeholderLabel setHidden:YES];
    }
    else
    {
        [self.placeholderLabel setHidden:NO];
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark -- 网络请求发表意见信息
-(void)postRequesPublishInfo
{

    QSCustomHUDView *hud = [QSCustomHUDView showCustomHUD];
    
    [QSRequestManager requestDataWithType:rRequestTypeCompanyComment andParams:@{@"discuss" : APPLICATION_NSSTRING_SETTING(self.contentTextView.text, @"")} andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        if (rRequestResultTypeSuccess == resultStatus) {
            
            [hud hiddenCustomHUDWithFooterTips:@"谢谢您的支持！" andDelayTime:1.5f andCallBack:^(BOOL isFinish){
            
                ///返回上一页
                [self.navigationController popViewControllerAnimated:YES];
            
            }];
            
        } else {
        
            [hud hiddenCustomHUDWithFooterTips:@"提交失败" andDelayTime:1.0f];
        
        }
        
    }];

}
@end
