//
//  QSYReleaseRentHouseImageViewController.m
//  House
//
//  Created by ysmeng on 15/3/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYReleaseRentHouseImageViewController.h"
#import "QSYReleaseRentHouseContactInfoViewController.h"
#import "QSYShowImageDetailViewController.h"

#import "QSCustomHUDView.h"

#import "QSBlockButtonStyleModel+Normal.h"
#import "UITextField+CustomField.h"
#import "UIImage+Orientaion.h"
#import "UIImage+Thumbnail.h"

#import "QSRequestManager.h"

#import "QSReleaseRentHouseDataModel.h"
#import "QSYLoadImageReturnData.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <objc/runtime.h>

///关联
static char PickedImageRootViewKey;//!<添加图片的底view

@interface QSYReleaseRentHouseImageViewController () <UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

///发布出租房时的暂存模型
@property (nonatomic,retain) QSReleaseRentHouseDataModel *rentHouseReleaseModel;

///临时图片数据模型
@property (nonatomic,retain) QSReleaseRentHousePhotoDataModel *tempPhotoModel;
@property (assign) BOOL isAddNewPhoto;                      //!<是否上传新图片

@property (nonatomic,strong) UITextField *titleField;       //!<标题输入框
@property (nonatomic,strong) UITextView *detailInfoField;   //!<详细信息输入框

@end

@implementation QSYReleaseRentHouseImageViewController

#pragma mark - 初始化
/**
 *  @author             yangshengmeng, 15-03-26 09:03:39
 *
 *  @brief              创建发布出租物业时的图片标题等信息填写窗口
 *
 *  @param saleModel    发布出租物业时的填写数据模型
 *
 *  @return             返回当前创建的图片标题等信息窗口
 *
 *  @since              1.0.0
 */
- (instancetype)initWithRentHouseModel:(QSReleaseRentHouseDataModel *)model
{
    
    if (self = [super init]) {
        
        ///保存数据模型
        self.rentHouseReleaseModel = model;
        
    }
    
    return self;
    
}

#pragma mark - UI搭建
///UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"发布出租物业"];
    
}

- (void)createMainShowUI
{
    
    ///过滤条件的底view
    QSScrollView *pickedRootView = [[QSScrollView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f - 44.0f - 25.0f)];
    [self createSettingInputUI:pickedRootView];
    [self.view addSubview:pickedRootView];
    
    ///分隔线
    UILabel *sepLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, pickedRootView.frame.origin.y + pickedRootView.frame.size.height, SIZE_DEVICE_WIDTH, 0.5f)];
    sepLineLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:sepLineLabel];
    
    ///底部确定按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
    buttonStyle.title = @"下一步";
    UIButton *commitButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_HEIGHT - 44.0f - 15.0f, SIZE_DEFAULT_MAX_WIDTH, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///判断是否已上传图片
        if ([self.rentHouseReleaseModel.imagesList count] <= 1) {
            
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"最少上传两张图片", 1.0f, ^(){})
            return;
            
        }
        
        ///回收键盘
        [self.titleField resignFirstResponder];
        [self.detailInfoField resignFirstResponder];
        
        ///封装标题
        NSString *titleString = self.titleField.text;
        if ([titleString length] <= 0) {
            
            ///区域+小区+街道+价格
            titleString = [NSString stringWithFormat:@"%@%@%@%@万",self.rentHouseReleaseModel.district,self.rentHouseReleaseModel.community,self.rentHouseReleaseModel.street,self.rentHouseReleaseModel.rentPrice];
            
        }
        self.rentHouseReleaseModel.title = titleString;
        
        ///进入联系信息填写窗口
        QSYReleaseRentHouseContactInfoViewController *pictureAddVC = [[QSYReleaseRentHouseContactInfoViewController alloc] initWithRentHouseModel:self.rentHouseReleaseModel];
        [self.navigationController pushViewController:pictureAddVC animated:YES];
        
    }];
    [self.view addSubview:commitButton];
    
}

///搭建设置信息输入栏
- (void)createSettingInputUI:(QSScrollView *)view
{
    
    ///标题
    self.titleField = [UITextField createCustomTextFieldWithFrame:CGRectMake(2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, SIZE_DEVICE_WIDTH - 4.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 44.0f) andPlaceHolder:@"简要描述20字以内" andLeftTipsInfo:@"标       题" andLeftTipsTextAlignment:NSTextAlignmentLeft andTextFieldStyle:cCustomTextFieldStyleLeftTipsLightGray];
    self.titleField.delegate = self;
    if ([self.rentHouseReleaseModel.title length] > 0) {
        
        self.titleField.text = self.rentHouseReleaseModel.title;
        
    }
    [view addSubview:self.titleField];
    
    ///分隔线
    UILabel *sepLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleField.frame.origin.x, self.titleField.frame.origin.y + self.titleField.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP / 2.0f, self.titleField.frame.size.width, 0.25f)];
    sepLineLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [view addSubview:sepLineLabel];
    
    ///详细描述
    self.detailInfoField = [[UITextView alloc] initWithFrame:CGRectMake(self.titleField.frame.origin.x, self.titleField.frame.origin.y + self.titleField.frame.size.height + 2.0f * VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, self.titleField.frame.size.width, 120.0f)];
    self.detailInfoField.delegate = self;
    self.detailInfoField.showsHorizontalScrollIndicator = NO;
    self.detailInfoField.showsVerticalScrollIndicator = NO;
    self.detailInfoField.layer.cornerRadius = VIEW_SIZE_NORMAL_CORNERADIO;
    self.detailInfoField.layer.borderWidth = 0.5f;
    self.detailInfoField.layer.borderColor = [COLOR_CHARACTERS_BLACKH CGColor];
    self.detailInfoField.font = [UIFont systemFontOfSize:FONT_BODY_16];
    self.detailInfoField.text = @"房屋详细描述";
    self.detailInfoField.textColor = COLOR_CHARACTERS_LIGHTGRAY;
    if ([self.rentHouseReleaseModel.detailComment length] > 0) {
        
        self.detailInfoField.text = self.rentHouseReleaseModel.detailComment;
        self.detailInfoField.textColor = COLOR_CHARACTERS_BLACK;
        
    }
    [view addSubview:self.detailInfoField];
    
    ///添加图片
    UILabel *addImageLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.detailInfoField.frame.origin.x, self.detailInfoField.frame.origin.y + self.detailInfoField.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, self.detailInfoField.frame.size.width, 30.0f)];
    addImageLabel.text = @"添加图片";
    addImageLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    addImageLabel.textColor = COLOR_CHARACTERS_GRAY;
    [view addSubview:addImageLabel];
    
    ///添加图片按钮底view
    QSScrollView *addImageRootView = [[QSScrollView alloc] initWithFrame:CGRectMake(addImageLabel.frame.origin.x, addImageLabel.frame.origin.y + addImageLabel.frame.size.height +  VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, addImageLabel.frame.size.width, 60.0f)];
    [view addSubview:addImageRootView];
    objc_setAssociatedObject(self, &PickedImageRootViewKey, addImageRootView, OBJC_ASSOCIATION_ASSIGN);
    
    ///创建图片添加按钮
    [self createImagePickedView];
    
    ///添加视频
    UILabel *addVedioLabel = [[UILabel alloc] initWithFrame:CGRectMake(addImageLabel.frame.origin.x, addImageRootView.frame.origin.y + addImageRootView.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, addImageLabel.frame.size.width, 30.0f)];
    addVedioLabel.text = @"添加视频";
    addVedioLabel.font = [UIFont systemFontOfSize:FONT_BODY_16];
    addVedioLabel.textColor = COLOR_CHARACTERS_GRAY;
    [view addSubview:addVedioLabel];
    
    ///添加视频按钮
    UIButton *addVedioButton = [UIButton createBlockButtonWithFrame:CGRectMake(addVedioLabel.frame.origin.x, addVedioLabel.frame.origin.y + addVedioLabel.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, 60.0f, 60.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        ///回收键盘
        [self.titleField resignFirstResponder];
        [self.detailInfoField resignFirstResponder];
        
    }];
    addVedioButton.layer.cornerRadius = VIEW_SIZE_NORMAL_CORNERADIO;
    addVedioButton.layer.borderColor = [COLOR_CHARACTERS_BLACKH CGColor];
    addVedioButton.layer.borderWidth = 0.5f;
    [addVedioButton setTitle:@"+" forState:UIControlStateNormal];
    [addVedioButton setTitleColor:COLOR_CHARACTERS_BLACKH forState:UIControlStateNormal];
    [addVedioButton setTitleColor:COLOR_CHARACTERS_YELLOW forState:UIControlStateHighlighted];
    [view addSubview:addVedioButton];
    
    ///判断滚动
    if (addVedioButton.frame.origin.y + addVedioButton.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP > view.frame.size.height) {
        
        view.contentSize = CGSizeMake(view.frame.size.width, addVedioButton.frame.origin.y + addVedioButton.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP + 15.0f);
        
    }
    
}

#pragma mark - 更新图片添加的UI
- (void)createImagePickedView
{
    
    UIScrollView *rootView = objc_getAssociatedObject(self, &PickedImageRootViewKey);
    
    ///清空原UI
    for (UIView *obj in [rootView subviews]) {
        
        [obj removeFromSuperview];
        
    }
    
    ///重新按选择图片创建UI
    if ([self.rentHouseReleaseModel.imagesList count] > 0) {
        
        ///总图片个数
        NSInteger sumImageCount = [self.rentHouseReleaseModel.imagesList count];
        
        ///创建图片显示button
        for (int i = 0;i < sumImageCount && i < 12;i++) {
            
            QSReleaseRentHousePhotoDataModel *tempModel = self.rentHouseReleaseModel.imagesList[i];
            UIImage *tempImage = tempModel.image;
            UIView *imageView = [self createImageButton:CGRectMake((60.0f + 5.0f) * i, 0.0f, 60.0f, 60.0f) andImage:tempImage andIndex:i];
            [rootView addSubview:imageView];
            
        }
        
        ///宽度记录
        CGFloat widthImage = (60.0f + 5.0f) * sumImageCount;
        
        ///如果未超过12个，则创建再添加按钮
        if (sumImageCount < 12) {
            
            UIButton *addImageButton = [self createAddImageButton:CGRectMake((60.0f + 5.0f) * sumImageCount, 0.0f, 60.0f, 60.0f)];
            [rootView addSubview:addImageButton];
            widthImage = widthImage + 60.0f;
            
        }
        
        ///判断滚动
        if (widthImage > rootView.frame.size.width) {
            
            rootView.contentSize = CGSizeMake(widthImage + 10.0f, rootView.frame.size.height);
            
        }
        
        
    } else {
        
        ///添加图片按钮
        UIButton *addImageButton = [self createAddImageButton:CGRectMake(0.0f, 0.0f, 60.0f, 60.0f)];
        [rootView addSubview:addImageButton];
        
    }
    
}

///创建一个已有图片的按钮
- (UIView *)createImageButton:(CGRect)frame andImage:(UIImage *)image andIndex:(int)index
{
    
    ///底view
    UIView *rootView = [[UIView alloc] initWithFrame:frame];
    rootView.layer.cornerRadius = VIEW_SIZE_NORMAL_CORNERADIO;
    rootView.clipsToBounds = YES;
    
    UIButton *imageButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        ///回收键盘
        [self.titleField resignFirstResponder];
        [self.detailInfoField resignFirstResponder];
        
        ///查看大图
        QSYShowImageDetailViewController *showOriginalImageVC = [[QSYShowImageDetailViewController alloc] initWithImages:[self.rentHouseReleaseModel getCurrentPickedImages] andCurrentIndex:index andTitle:@"查看图片" andType:sShowImageOriginalVCTypeMultiEdit andCallBack:^(SHOW_IMAGE_ORIGINAL_ACTION_TYPE actionType, id deleteObject, int deleteIndex) {
            
            ///删除事件
            if (sShowImageOriginalActionTypeDelete == actionType) {
                
                ///删除图片
                [self.rentHouseReleaseModel.imagesList removeObjectAtIndex:deleteIndex];
                
                ///重构图片框
                [self createImagePickedView];
                
            }
            
        }];
        [self.navigationController pushViewController:showOriginalImageVC animated:YES];
        
    }];
    [imageButton setImage:image forState:UIControlStateNormal];
    [rootView addSubview:imageButton];
    
    return rootView;
    
}

///创建一个添加图片的按钮
- (UIButton *)createAddImageButton:(CGRect)frame
{
    
    UIButton *addImageButton = [UIButton createBlockButtonWithFrame:frame andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        ///回收键盘
        [self.titleField resignFirstResponder];
        [self.detailInfoField resignFirstResponder];
        
        ///弹出提示
        UIActionSheet *pickedImageAskSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
        [pickedImageAskSheet showInView:self.view];
        
    }];
    addImageButton.layer.cornerRadius = VIEW_SIZE_NORMAL_CORNERADIO;
    addImageButton.layer.borderColor = [COLOR_CHARACTERS_BLACKH CGColor];
    addImageButton.layer.borderWidth = 0.5f;
    [addImageButton setTitle:@"+" forState:UIControlStateNormal];
    [addImageButton setTitleColor:COLOR_CHARACTERS_BLACKH forState:UIControlStateNormal];
    [addImageButton setTitleColor:COLOR_CHARACTERS_YELLOW forState:UIControlStateHighlighted];
    return addImageButton;
    
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
        UIImage *smallImage = [rightImage thumbnailWithSize:CGSizeMake(SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT * 0.5f)];
        
        ///保存图片
        self.tempPhotoModel = nil;
        self.tempPhotoModel = [[QSReleaseRentHousePhotoDataModel alloc] init];
        self.tempPhotoModel.image = smallImage;
        self.isAddNewPhoto = YES;
        
    }
    
    [self dismissViewControllerAnimated:YES completion:^{}];
    
}

#pragma mark - 标题完成输入
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if ([textField.text length] > 0) {
        
        self.rentHouseReleaseModel.title = textField.text;
        
    } else {
        
        self.rentHouseReleaseModel.title = nil;
        
    }
    
}

#pragma mark - 房源详细说明信息完成输入
- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    if ([textView.text length] > 0) {
        
        self.rentHouseReleaseModel.detailComment = textView.text;
        
    } else {
        
        self.rentHouseReleaseModel.detailComment = nil;
        
    }
    
}

#pragma mark - 回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    if ([textView.text isEqualToString:@"房屋详细描述"]) {
        
        textView.text = nil;
        textView.textColor = COLOR_CHARACTERS_BLACK;
        
    }
    return YES;
    
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    
    if ([textView.text length] <= 0) {
        
        textView.text = @"房屋详细描述";
        textView.textColor = COLOR_CHARACTERS_LIGHTGRAY;
        
    }
    return YES;
    
}

#pragma mark - 上传图片
///上传图片
- (void)loadImageToServer:(QSReleaseRentHousePhotoDataModel *)imageModel andCallBack:(void(^)(BOOL flag))callBack
{
    
    __block QSCustomHUDView *hud = [QSCustomHUDView showCustomHUDWithTips:@"正在上传图片"];
    
    ///获取图片二进制流
    NSData *imageData = UIImageJPEGRepresentation(imageModel.image, 0.5f);
    NSString *tempFilePath = NSTemporaryDirectory();
    NSString *savePath = [tempFilePath stringByAppendingString:@"temp_image.jpg"];
    if (![imageData writeToFile:savePath atomically:YES]) {
        
        return;
        
    }
    
    ///封装参数
    NSDictionary *params = @{@"source" : @"iOS",
                             @"thumb_width" : [NSString stringWithFormat:@"%.2f",imageModel.image.size.width],
                             @"thumb_height" : [NSString stringWithFormat:@"%.2f",imageModel.image.size.height],
                             @"attach_file" : savePath};
    
    ///上传图片
    [QSRequestManager requestDataWithType:rRequestTypeLoadImage andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///上传成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            [hud hiddenCustomHUDWithFooterTips:@"上传成功" andDelayTime:1.0f andCallBack:^(BOOL flag) {
                
                ///修改参数
                QSYLoadImageReturnData *tempModel = resultData;
                imageModel.smallImageURL = tempModel.imageModel.smallImageURl;
                imageModel.originalImageURL = tempModel.imageModel.originalImageURl;
                callBack(YES);
                
            }];
            
        } else {
            
            ///提示
            NSString *tipsString = @"上传失败";
            if (resultData) {
                
                tipsString = [resultData valueForKey:@"info"];
                
            }
            [hud hiddenCustomHUDWithFooterTips:tipsString andDelayTime:1.0f andCallBack:^(BOOL flag) {
                
                callBack(NO);
                
            }];
            
        }
        
    }];
    
}

#pragma mark - 视图将要显示时判断是否有上传图片任务
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    if (self.isAddNewPhoto) {
        
        self.isAddNewPhoto = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            ///上传图片
            [self loadImageToServer:self.tempPhotoModel andCallBack:^(BOOL flag) {
                
                if (flag) {
                    
                    [self.rentHouseReleaseModel.imagesList addObject:self.tempPhotoModel];
                    
                    ///修改UI
                    [self createImagePickedView];
                    
                }
                
            }];
            
        });
        
    }
    
}

@end
