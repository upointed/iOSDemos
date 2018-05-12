//
//  GMHRequestUrl.h
//  GomeHigo
//
//  Created by liuda on 16/10/11.
//  Copyright © 2016年 gomehigo. All rights reserved.
//  请求的URL

#import <Foundation/Foundation.h>

@interface GMHRequestUrl : NSObject

/** 用户登录 */
+(NSString *)httpMothed_userLoginUrl;
/** 用户注册 */
+(NSString *)httpMothed_userRegisterUrl;
/** 重置密码 */
+(NSString *)httpMothed_userResetPwdUrl;
/** 用户第三方登录 */
+(NSString *)httpMothed_userSNSLoginUrl;
/** 用户退出 */
+(NSString *)httpMothed_userLogoutUrl;
/** 更换手机号 */
+(NSString *)httpMothed_updateMobilePhoneUrl;

#pragma mark - <SMS接口>
/** 注册发送验证码 */
+(NSString*)httpMothed_sendByRegisterUrl;
/** 重置密码发送验证码 */
+(NSString*)httpMothed_sendByResetPwdUrl;
/** 绑定手机号发送验证码 */
+(NSString *)httpMothed_sendByUpdateMobilePhoneUrl;
/** 手机号快速登录发送验证码 */
+(NSString *)httpMothed_PhoneNumberQuickUrl;

/** 商品一级分类 */
+(NSString *)httpMothed_shopFirstCategoryUrl;
@end
