//
//  WebInteractManager.h
//  Lianxi
//
//  Created by 222 on 15/2/12.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  这个类用于与JavaScript进行交互使用，它定义了为Html5页面插入的脚本方法，这些方法供JS调用，
    并通过监听WebView window.location.href来获取参数，调用客户端方法，并在之后为JS提供回传参数
 */

@protocol WebInteractDelegate<NSObject>

- (void)showDataPicker;//显示日期选择器
- (void)showPersonalPageWithContactID:(NSString *)ID;//显示个人页
- (void)callActionSheetWithList:(NSArray *)listArr;//底部弹出列表选择，此方法弃用，改为下面的方法
- (void)showScrollListWithList:(NSArray *)listArr title:(NSString *)title;//显示选择页


- (void)transformToken:(NSString *)token;//向js回传token
- (void)transformUserInfoToJS:(NSDictionary *)userDic;//向js传送当前用户信息
- (void)transformInfo:(NSDictionary *)dicInfo;//向js回传信息，此方法独立于以上俩个回传参数

- (void)h5AppShouldGoBack;//webapp返回上一级

@end

@interface WebInteractManager : NSObject

- (WebInteractManager *)init;
@property (nonatomic,weak) id<WebInteractDelegate> delegate;

//从WebView获取到的url解析出参数
- (NSDictionary *)disposeParameterWithURL:(NSString *)h5URL;

//分发监听到的JS事件
- (void)distributeJSEventWithDictionary:(NSDictionary *)dic;


//WebView初始化创建的脚本
- (NSString *)JavaScriptForWebViewSetup;
//回传事件
- (NSString *)JavaScriptCallBackWithInfo:(NSString *)info;
//改变h5头部脚本事件
- (NSString *)JavaScriptForH5BodyTop;


//判断星座
- (NSString *)getAstroWithDate:(NSDate *)date;

@end




