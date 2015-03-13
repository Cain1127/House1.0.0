//
//  QSNetworkVerticalCodeView.h
//  House
//
//  Created by ysmeng on 15/3/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

///发送手机验证码回调类型
typedef enum
{

    sSendPhoneVerticalCodeActionTypeInvalidPhone = 0,   //!<手机号码未输入
    sSendPhoneVerticalCodeActionTypePhoneError,         //!<手机号码有误
    sSendPhoneVerticalCodeActionTypeFail,               //!<发送失败
    sSendPhoneVerticalCodeActionTypeSuccess             //!<发送成功

}SEND_PHONE_VERTICALCODE_ACTION_TYPE;

/**
 *  @author yangshengmeng, 15-03-13 18:03:50
 *
 *  @brief  手机发送的验证码
 *
 *  @since  1.0.0
 */
@interface QSNetworkVerticalCodeView : UIImageView

/**
 *  @author             yangshengmeng, 15-03-13 19:03:02
 *
 *  @brief              创建一个发送手机验证码的控件，需要绑定手机号码输入框及其他重新属性
 *
 *  @param frame        大小和位置
 *  @param sendCodeType 对应的请求枚举类型，需要配合QSRequestManager使用
 *  @param textField    绑定的手机号码输入框，用以判断当前手机号码是否有效
 *  @param imageName    背景图片
 *  @param bgColor      背景颜色
 *  @param textColor    文本的颜色
 *  @param textSize     文本的字体大小
 *  @param gapSecond    发送间隔：默认60秒
 *  @param callBack     发送后的回调
 *
 *  @return             返回当前创建的发送手机验证码view
 *
 *  @since              1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andVerticalSendNetworkType:(REQUEST_TYPE)sendCodeType andPhoneField:(UITextField *)textField andImageName:(NSString *)imageName andBackgroudColor:(UIColor *)bgColor andTextColor:(UIColor *)textColor andTextFontSize:(CGFloat)textSize andGapSecond:(int)gapSecond andSendResultCallBack:(void(^)(SEND_PHONE_VERTICALCODE_ACTION_TYPE actionType,NSString *verCode))callBack;

@end
