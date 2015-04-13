//
//  QSYMySettingViewController.m
//  House
//
//  Created by ysmeng on 15/3/16.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYMySettingViewController.h"

#import "QSYPopCustomView.h"
#import "QSYMySettingChangeUserReadNameTipsPopView.h"
#import "QSYMySettingChangeUserGenderPopView.h"
#import "QSCustomHUDView.h"

#import "QSBlockButtonStyleModel+Normal.h"
#import "UITextField+CustomField.h"
#import "QSImageView+Block.h"
#import "NSString+Calculation.h"

#import "UIImage+Orientaion.h"
#import "UIImage+Thumbnail.h"

#import "QSYLoadImageReturnData.h"
#import "QSUserDataModel.h"

#import "QSCoreDataManager+User.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <objc/runtime.h>

///不过的自定义按钮tag
typedef enum
{

    sSelfSettingFieldActionTypeName = 99,   //!<姓名
    sSelfSettingFieldActionTypeSex,         //!<性别
    sSelfSettingFieldActionTypePhone,       //!<手机号码
    sSelfSettingFieldActionTypePassword,    //!<账号密码

}SELFSETTING_FIELD_ACTION_TYPE;

///关联
static char IconImageViewKey;   //!<头像关联
static char UserNameKey;        //!<用户名
static char UserGenderKey;      //!<性别

@interface QSYMySettingViewController () <UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,retain) QSUserDataModel *userModel;    //!<用户信息数据模型

@end

@implementation QSYMySettingViewController

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"个人设置"];

}

- (void)createMainShowUI
{
    
    ///获取用户信息数据
    self.userModel = [QSCoreDataManager getCurrentUserDataModel];
    
    ///头像
    UILabel *msgTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 85.0f / 2.0f + 64.0f - 15.0f, 80.0f, 30.0f)];
    msgTipsLabel.text = @"头       像";
    msgTipsLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    msgTipsLabel.textColor = COLOR_CHARACTERS_GRAY;
    [self.view addSubview:msgTipsLabel];
    
    ///头像图片
    UIImageView *iconImageView = [QSImageView createBlockImageViewWithFrame:CGRectMake(SIZE_DEVICE_WIDTH - 65.0f - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 64.0f + 10.0f, 65.0f, 65.0f) andSingleTapCallBack:^{
        
        ///弹出图片选择提示
        [self popPickedImageTipsView];
        
    }];
    iconImageView.image = [UIImage imageNamed:IMAGE_USERICON_DEFAULT_158];
    if ([self.userModel.avatar length] > 0) {
        
        [iconImageView loadImageWithURL:[self.userModel.avatar getImageURL] placeholderImage:[UIImage imageNamed:IMAGE_USERICON_DEFAULT_158]
         ];
    }
    [self.view addSubview:iconImageView];
    objc_setAssociatedObject(self, &IconImageViewKey, iconImageView, OBJC_ASSOCIATION_ASSIGN);
    
    ///头像六角
    QSImageView *iconSixformImageView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, iconImageView.frame.size.width, iconImageView.frame.size.height)];
    iconSixformImageView.image = [UIImage imageNamed:IMAGE_USERICON_HOLLOW_80];
    [iconImageView addSubview:iconSixformImageView];
    
    ///分隔线
    UILabel *iconSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(msgTipsLabel.frame.origin.x, iconImageView.frame.origin.y + iconImageView.frame.size.height + 10.0f, SIZE_DEFAULT_MAX_WIDTH - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 0.25f)];
    iconSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:iconSepLabel];
    
    ///姓名
    UITextField *nameField = [UITextField createCustomTextFieldWithFrame:CGRectMake(2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, iconSepLabel.frame.origin.y + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, SIZE_DEFAULT_MAX_WIDTH - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andPlaceHolder:@"" andLeftTipsInfo:@"姓      名" andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleRightArrowLeftTipsGray];
    nameField.delegate = self;
    nameField.tag = sSelfSettingFieldActionTypeName;
    nameField.text = [self.userModel.realname length] > 0 ? self.userModel.realname : APPLICATION_NSSTRING_SETTING_NIL(self.userModel.username);
    [self.view addSubview:nameField];
    objc_setAssociatedObject(self, &UserNameKey, nameField, OBJC_ASSOCIATION_ASSIGN);
    
    ///分隔线
    UILabel *nameSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameField.frame.origin.x + 5.0f, nameField.frame.origin.y + nameField.frame.size.height + 3.5f, nameField.frame.size.width - 10.0f, 0.25f)];
    nameSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:nameSepLabel];
    
    ///别性
    UITextField *genderField = [UITextField createCustomTextFieldWithFrame:CGRectMake(nameField.frame.origin.x, nameField.frame.origin.y + nameField.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, nameField.frame.size.width, nameField.frame.size.height) andPlaceHolder:@"" andLeftTipsInfo:@"性       别" andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleRightArrowLeftTipsGray];
    genderField.delegate = self;
    genderField.tag = sSelfSettingFieldActionTypeSex;
    genderField.text = [self.userModel.sex intValue] == 1 ? @"男" : ([self.userModel.sex intValue] == 0 ? @"女" : nil);
    [self.view addSubview:genderField];
    objc_setAssociatedObject(self, &UserGenderKey, genderField, OBJC_ASSOCIATION_ASSIGN);
    
    ///分隔线
    UILabel *genderSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(genderField.frame.origin.x + 5.0f, genderField.frame.origin.y + genderField.frame.size.height + 3.5f, genderField.frame.size.width - 10.0f, 0.25f)];
    genderSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:genderSepLabel];
    
    ///手机
    UITextField *phoneField = [UITextField createCustomTextFieldWithFrame:CGRectMake(genderField.frame.origin.x, genderField.frame.origin.y + genderField.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, genderField.frame.size.width, genderField.frame.size.height) andPlaceHolder:@"" andLeftTipsInfo:@"手机号码" andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleRightArrowLeftTipsGray];
    phoneField.delegate = self;
    phoneField.tag = sSelfSettingFieldActionTypePhone;
    phoneField.text = [NSString stringWithFormat:@"%@******%@",[self.userModel.mobile substringToIndex:3],[self.userModel.mobile substringFromIndex:9]];
    [self.view addSubview:phoneField];
    
    ///分隔线
    UILabel *phoneSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(phoneField.frame.origin.x + 5.0f, phoneField.frame.origin.y + phoneField.frame.size.height + 3.5f, phoneField.frame.size.width - 10.0f, 0.25f)];
    phoneSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:phoneSepLabel];
    
    ///账户密码
    UITextField *passwordField = [UITextField createCustomTextFieldWithFrame:CGRectMake(phoneField.frame.origin.x, phoneField.frame.origin.y + phoneField.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, phoneField.frame.size.width, phoneField.frame.size.height) andPlaceHolder:@"" andLeftTipsInfo:@"账户密码" andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleRightArrowLeftTipsGray];
    passwordField.delegate = self;
    passwordField.tag = sSelfSettingFieldActionTypeName;
    passwordField.text = @"******";
    [self.view addSubview:passwordField];
    
    ///分隔线
    UILabel *pswSepLabel = [[UILabel alloc] initWithFrame:CGRectMake(passwordField.frame.origin.x + 5.0f, passwordField.frame.origin.y + passwordField.frame.size.height + 3.5f, passwordField.frame.size.width - 10.0f, 0.25f)];
    pswSepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:pswSepLabel];

}

#pragma mark - 点击不同的控件进行不同的过滤
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    switch (textField.tag) {
            ///姓名
        case sSelfSettingFieldActionTypeName:
        {
        
            __block QSYPopCustomView *popView;
            
            QSYMySettingChangeUserReadNameTipsPopView *tipsView = [[QSYMySettingChangeUserReadNameTipsPopView alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEVICE_HEIGHT - 178.0f, SIZE_DEVICE_WIDTH, 178.0f) andCallBack:^(MYSETTING_CHANGE_NAME_ACTION_TYPE actionType, id parmas) {
                
                ///回收弹出框
                [popView hiddenCustomPopview];
                
                ///判断事件类型
                if (mMysettingChangeNameActionTypeConfirm == actionType) {
                    
                    NSString *settingName = parmas;
                    if ([settingName length] > 0) {
                        
                        [self changeUserRealName:settingName];
                        
                    }
                    
                }
                
            }];
            
            popView = [QSYPopCustomView popCustomViewWithoutChangeFrame:tipsView andPopViewActionCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
            }];
        
        }
            break;
            
            ///性别
        case sSelfSettingFieldActionTypeSex:
        {
            
            __block QSYPopCustomView *popView;
            
            QSYMySettingChangeUserGenderPopView *tipsView = [[QSYMySettingChangeUserGenderPopView alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEVICE_HEIGHT - 189.0f, SIZE_DEVICE_WIDTH, 189.0f) andSelectedGender:self.userModel.sex andCallBack:^(MYSETTING_CHANGE_GENDER_ACTION_TYPE actionType, id parmas) {
                
                ///回收弹出框
                [popView hiddenCustomPopview];
                
                ///判断事件类型
                if (mMysettingChangeGenderActionTypeConfirm == actionType) {
                    
                    NSString *settingName = parmas;
                    if ([settingName length] > 0) {
                        
                        [self changeUserGender:settingName];
                        
                    }
                    
                }
                
            }];
            
            popView = [QSYPopCustomView popCustomViewWithoutChangeFrame:tipsView andPopViewActionCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                
            }];
            
        }
            break;
            
            ///手机
        case sSelfSettingFieldActionTypePhone:
        {
            
            APPLICATION_LOG_INFO(@"手机", @"")
            
        }
            break;
            
            ///密码
        case sSelfSettingFieldActionTypePassword:
        {
            
            APPLICATION_LOG_INFO(@"密码", @"")
            
        }
            break;
            
        default:
            
            break;
    }
    
    return NO;

}

#pragma mark - 修改用户性别
- (void)changeUserGender:(NSString *)gender
{
    
    __block QSCustomHUDView *hud = [QSCustomHUDView showCustomHUDWithTips:@"正在上传图片"];

    ///封装参数
    NSDictionary *params = @{@"sex" : APPLICATION_NSSTRING_SETTING(gender, @"")};
    
    [QSRequestManager requestDataWithType:rRequestTypeUPDateuserInfo andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///更新成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            [hud hiddenCustomHUDWithFooterTips:@"修改成功" andDelayTime:1.5f andCallBack:^(BOOL flag) {
                
                if ([gender length] > 0) {
                    
                    ///更新当前保存的信息
                    self.userModel.sex = gender;
                    
                    ///修改显示的信息
                    UITextField *genderField = objc_getAssociatedObject(self, &UserGenderKey);
                    if (genderField) {
                        
                        NSString *oldGender = genderField.text;
                        genderField.text = ([self.userModel.sex intValue] == 0) ? @"女" : (([self.userModel.sex intValue] == 1) ? @"男" : oldGender);
                        
                    }
                    
                    ///更新用户信息
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        [QSCoreDataManager reloadUserInfoFromServer];
                        
                    });
                    
                }
                
            }];
            
        } else {
            
            ///提示
            NSString *tipsString = @"修改失败";
            if (resultData) {
                
                tipsString = [resultData valueForKey:@"info"];
                
            }
            [hud hiddenCustomHUDWithFooterTips:tipsString andDelayTime:1.5f];
            
        }
        
    }];

}

#pragma mark - 修改用户真名
- (void)changeUserRealName:(NSString *)realName
{
    
    __block QSCustomHUDView *hud = [QSCustomHUDView showCustomHUDWithTips:@"正在上传图片"];

    ///封装参数
    NSDictionary *params = @{@"username" : APPLICATION_NSSTRING_SETTING(realName, @"")};
    
    [QSRequestManager requestDataWithType:rRequestTypeUPDateuserInfo andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///更新成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            [hud hiddenCustomHUDWithFooterTips:@"修改成功" andDelayTime:1.5f andCallBack:^(BOOL flag) {
                
                if ([realName length] > 0) {
                    
                    ///更新当前保存的信息
                    self.userModel.username = realName;
                    
                    ///修改显示的信息
                    UITextField *nameField = objc_getAssociatedObject(self, &UserNameKey);
                    if (nameField) {
                        
                        NSString *oldName = nameField.text;
                        nameField.text = APPLICATION_NSSTRING_SETTING(realName, oldName);
                        
                    }
                    
                    ///更新用户信息
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        [QSCoreDataManager reloadUserInfoFromServer];
                        
                    });
                    
                }
                
            }];
            
        } else {
            
            ///提示
            NSString *tipsString = @"修改失败";
            if (resultData) {
                
                tipsString = [resultData valueForKey:@"info"];
                
            }
            [hud hiddenCustomHUDWithFooterTips:tipsString andDelayTime:1.5f];
            
        }
        
    }];

}

#pragma mark - 弹出图片选择提示
- (void)popPickedImageTipsView
{
    
    ///弹出提示
    UIActionSheet *pickedImageAskSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [pickedImageAskSheet showInView:self.view];

}

#pragma mark - 选择图片时相册/拍照提示
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    ///从新拍照
    if (0 == buttonIndex) {
        
        ///拍照：如果是要准备进行拍照，一定要判断设备是否支持拍照
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeCamera]) {
            
            ///如果是拍照
            [self loadImageWithSourceType:UIImagePickerControllerSourceTypeCamera];
            
        } else {
            
            ///如果不支持拍照
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"当前设备不支持拍照", 1.0f, ^(){})
            
        }
        
    }
    
    ///从相册选择图片
    if (1 == buttonIndex) {
        
        //需要判断是否支持取本地相册
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypePhotoLibrary]) {
            
            //如果支持取本地相册：则调用本地相册
            [self loadImageWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            
        } else {
            
            ///如果不支持读取相册
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"无法获取本地相册", 1.0f, ^(){})
            
        }
        
    }
    
}

#pragma mark - 拍照或者从相册中选择图片
///拍照 和 取本地相册，都是一个代理，不过是区分资源
///UIImagePickerController 这是管理本地的控件器
///UIImagePickerControllerSourceTypePhotoLibrary : 相册
///UIImagePickerControllerSourceTypeCamera : 照相机
///UIImagePickerControllerSourceTypeSavedPhotosAlbum : 胶卷
- (void)loadImageWithSourceType:(UIImagePickerControllerSourceType)type
{
    if (type == UIImagePickerControllerSourceTypePhotoLibrary) {
        
        //根据不同的资源类型，加载不同的界面
        UIImagePickerController *pickVC = [[UIImagePickerController alloc] init];
        pickVC.delegate = self;
        pickVC.sourceType = type;
        pickVC.allowsEditing = YES;//允许编辑
        
        //用模式跳转窗体
        [self presentViewController:pickVC animated:YES completion:^{}];
        
    } else if(type == UIImagePickerControllerSourceTypeCamera){
        
        //根据不同的资源类型，加载不同的界面
        UIImagePickerController *pickVC = [[UIImagePickerController alloc] init];
        pickVC.delegate = self;
        pickVC.sourceType = type;
        pickVC.allowsEditing = YES;//允许编辑
        
        //用模式跳转窗体
        [self presentViewController:pickVC animated:YES completion:^{}];
        
    }
    
}

#pragma mark - 获取拍照/本地图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    /*
     *  将图片转化成NSData 存入应用的沙盒中
     */
    NSString *sourceType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([sourceType isEqualToString:(NSString *)kUTTypeImage]) {
        
        ///原图片
        UIImage *pickedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
        
        ///修改图片
        UIImage *rightImage = [pickedImage fixOrientation:pickedImage];
        
        ///压缩图片
        UIImage *smallImage = [rightImage thumbnailWithSize:CGSizeMake(SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT * 0.8f)];
        
        ///将图片写入本地
        NSData *imageData = UIImageJPEGRepresentation(smallImage, 0.8f);
        NSString *tempFilePath = NSTemporaryDirectory();
        NSString *savePath = [tempFilePath stringByAppendingString:@"temp_image.jpg"];
        BOOL isSave = [imageData writeToFile:savePath atomically:YES];
        if (isSave) {
            
            [self updateUserIconImage:savePath];
            
        }
        
    }
    
    [self dismissViewControllerAnimated:YES completion:^{}];
    
}

///联网更新用户图片
- (void)updateUserIconImage:(NSString *)filePath
{

    __block QSCustomHUDView *hud = [QSCustomHUDView showCustomHUDWithTips:@"正在上传图片"];
    
    ///获取图片
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [UIImage imageWithData:imageData];
    
    ///获取图片二进制流
    
    
    if (!image) {
        
        return;
        
    }
    
    ///封装参数
    NSDictionary *params = @{@"source" : @"iOS",
                             @"thumb_width" : [NSString stringWithFormat:@"%.2f",image.size.width],
                             @"thumb_height" : [NSString stringWithFormat:@"%.2f",image.size.height],
                             @"attach_file" : filePath};
    
    ///上传图片
    [QSRequestManager requestDataWithType:rRequestTypeLoadImage andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///上传成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            ///修改参数
            QSYLoadImageReturnData *tempModel = resultData;
            [self updateUserIconImage:tempModel.imageModel.smallImageURl andSmallPath:tempModel.imageModel.originalImageURl andHUD:hud];
            
        } else {
            
            ///提示
            NSString *tipsString = @"上传失败";
            if (resultData) {
                
                tipsString = [resultData valueForKey:@"info"];
                
            }
            [hud hiddenCustomHUDWithFooterTips:tipsString andDelayTime:1.5f];
            
        }
        
    }];

}

///更新用户的头像
- (void)updateUserIconImage:(NSString *)originalPath andSmallPath:(NSString *)smallPath andHUD:(QSCustomHUDView *)hud
{
    
    ///封装参数
    NSDictionary *params = @{@"big_avatar" : APPLICATION_NSSTRING_SETTING(originalPath, @""),
                             @"avatar" : APPLICATION_NSSTRING_SETTING(smallPath, @"")};

    [QSRequestManager requestDataWithType:rRequestTypeUPDateuserInfo andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///更新成功
        if (rRequestResultTypeSuccess == resultStatus) {
    
            [hud hiddenCustomHUDWithFooterTips:@"上传成功" andDelayTime:1.5f andCallBack:^(BOOL flag) {
                
                if ([smallPath length] > 0) {
                    
                    UIImageView *iconView = objc_getAssociatedObject(self, &IconImageViewKey);
                    [iconView loadImageWithURL:[smallPath getImageURL] placeholderImage:[UIImage imageNamed:IMAGE_USERICON_DEFAULT_158]];
                    
                    ///更新用户信息
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        [QSCoreDataManager reloadUserInfoFromServer];
                        
                    });
                    
                }
                
            }];
            
        } else {
        
            ///提示
            NSString *tipsString = @"上传失败";
            if (resultData) {
                
                tipsString = [resultData valueForKey:@"info"];
                
            }
            [hud hiddenCustomHUDWithFooterTips:tipsString andDelayTime:1.5f];
        
        }
        
    }];

}

@end
