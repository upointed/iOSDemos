//
//  WebInteractManager.m
//  Lianxi
//
//  Created by 222 on 15/2/12.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import "WebInteractManager.h"
#import "WebAppManager.h"
#import "NSObject+SBJson.h"
#import "AccountManager.h"

@interface WebInteractManager ()
{
    NSString* _action; 
    NSString* _callback;
    NSString* _url;
    NSString* _surplus;
}
@end


@implementation WebInteractManager

- (WebInteractManager *)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

- (NSDictionary *)disposeParameterWithURL:(NSString *)h5URL
{
    //取得 "" = "" 形式的数据
    NSString* parameterSet = [h5URL componentsSeparatedByString:@"?"].lastObject;
    NSArray* resultArray = [parameterSet componentsSeparatedByString:@"&"];
    NSLog(@"URL解析结果：%@",resultArray);
    
    if (resultArray.count >= 2)
    {
        //将解析的结果保存为字典
        NSMutableDictionary* resultDic = [[NSMutableDictionary alloc] init];
        for (int i=0; i<resultArray.count; i++)
        {
            NSString* item = resultArray[i];
            NSString* value = [item componentsSeparatedByString:@"="].lastObject;
            NSString* key = [item componentsSeparatedByString:@"="][0];
            [resultDic setValue:value forKey:key];
        }
        NSLog(@"最终解析到的参数值：\n%@",resultDic);
        return resultDic;
    }
    else
    {
        NSLog(@"JS传输参数格式错误！");
        return NULL;
    }
}

//回传事件
- (NSString *)JavaScriptCallBackWithInfo:(NSString *)info
{
    NSString* returnScript;
    if (_callback)
    {
        returnScript = [NSString stringWithFormat:@"%@('%@')", _callback,info];
        NSLog(@"returnScript = %@",returnScript);
    }
    else
    {
        NSLog(@"callback is nil!");
    }
    return returnScript;
}

//分发事件
- (void)distributeJSEventWithDictionary:(NSDictionary *)dic
{
    _action = dic[@"action"];
    _callback = dic[@"callback"];
    _url = dic[@"url"];
    _surplus = dic[@"list"];
    
    
    //显示日期
    if ([_action isEqualToString:@"dataPicker"])
    {
        [self.delegate showDataPicker];
    }
    //获取当前用户信息
    else if ([_action isEqualToString:@"getUserInfo"])
    {
        AccountManager* am = [AccountManager defaultManager];
        LXAccount* user_info = [am queryAccountWithSpaceID:@"1" accountID:[am loginAccountID]];
        
        NSDictionary* userDic = @{ @"name":user_info.name,
                                   @"gender":[NSString stringWithFormat:@"%d",user_info.gender],
                                   @"mobile":user_info.username,
                                   @"logo":user_info.headPath,
                                   @"accountId":[am loginAccountID]
                                   };
        [self.delegate transformUserInfoToJS:userDic];
    }
    //弹出底部ActionSheet
    else if ([_action isEqualToString:@"showDialog"])
    {
        //处理参数列表
        NSMutableString* transString = [NSMutableString stringWithString:_surplus];
        NSString* newString = [transString stringByAppendingString:@",取消"];
        NSArray* jsListArray = [newString componentsSeparatedByString:@","];

        [self.delegate callActionSheetWithList:jsListArray];
    }
    //转入选择列表页
    else if ([_action isEqualToString:@"showScrollList"])
    {
        NSString* timeList = dic[@"list"];
        NSString* title = dic[@"title"];
        NSArray* list = [timeList componentsSeparatedByString:@","];
        
        [self.delegate showScrollListWithList:list title:title];
    }
    //转入选择城市页
    else if ([_action isEqualToString:@"cityList"])
    {
        [[WebAppManager defaultManager] queryCityInfoSuccess:^(NSString* city,NSString* code) {
            
            NSDictionary* dic = @{ @"city":city ,
                                   @"cityCode":code };
            [self.delegate transformInfo:dic];
            
        } failure:nil];
    }
    //转入行业列表页
    else if ([_action isEqualToString:@"occupationList"])
    {
        [[WebAppManager defaultManager] queryIndustryInfoSuccess:^(NSString* value,int code) {
            
            NSDictionary* dic = @{ @"occupationName":value,
                                   @"occupationCode":[NSString stringWithFormat:@"%d",code] };
            [self.delegate transformInfo:dic];
            
        } failure:nil];
    }
    //获取地理位置信息
    else if ([_action isEqualToString:@"getLocation"])
    {
        [[WebAppManager defaultManager] queryLocationInfoSuccess:^(NSString *address, double lat, double lng) {
            
            NSDictionary* dic = @{ @"address":address,
                                   @"lat":[NSString stringWithFormat:@"%lf",lat],
                                   @"lng":[NSString stringWithFormat:@"%lf",lng]};
            [self.delegate transformInfo:dic];
            
        } failure:^(NSString *error) {
            
            NSDictionary* dic = @{@"error":@"获取位置失败!"};
            [self.delegate transformInfo:dic];
            
        }];
    }
    //进入个人页
    else if ([_action isEqualToString:@"personalPage"])
    {
        [self.delegate showPersonalPageWithContactID:dic[@"accountId"]];
    }
    //返回上一页
    else if ([_action isEqualToString:@"goBackApp"])
    {
        [self.delegate h5AppShouldGoBack];
    }
    //获取Token信息，该Token用于安全验证，程序中其他接口中需要使用该Token值
    else if ([_action isEqualToString:@"getToken"])
    {
        [[WebAppManager defaultManager] queryAppToken:nil andAppType:dic[@"appType"] success:^(id jsonValue) {
            
            NSString* jsonback = [jsonValue JSONRepresentation];
            [self.delegate transformToken:jsonback];
            
        } failure:^(NSString* error) {
            
            NSDictionary* dic = @{@"error":error};
            [self.delegate transformInfo:dic];
            
        }];
    }
    else
    {
        NSLog(@"js事件不存在!");
    }
}


- (NSString *)JavaScriptForWebViewSetup
{
    NSString* jsScript =
    @"\
    var script = document.createElement('script');\
    script.text = 'var lxjs = {};' +\
    \
    'var none = \"nothing\";' +\
    \
    'lxjs.showDataPicker = function(){' +\
        'window.location.href = \"luosuo://?action=dataPicker&callback=\"+arguments[0]+\"&url=\"+none;' +\
    '};' +\
    \
    'lxjs.startActivityResultCallBackTime = function(){' +\
        'document.location.href=\"luosuo://?action=showScrollList&callback=\"+arguments[1]+\"&url=nothing&list=\"+arguments[2]+\"&title=\"+arguments[3];' +\
    '};' +\
    \
    'lxjs.showBottomDialog = function(){' +\
        'document.location=\"luosuo://?action=showDialog&callback=\"+arguments[1]+\"&url=nothing&list=\"+arguments[0];' +\
    '};' +\
    \
    'lxjs.getToken = function(){' +\
        'window.location.href=\"luosuo://?action=getToken&callback=\"+arguments[2]+\"&url=\"+arguments[0]+\"&\"+arguments[1];' +\
    '};' +\
    \
    'lxjs.getUserInfo = function(){' +\
        'window.location.href=\"luosuo://?action=getUserInfo&callback=\"+arguments[0]+\"&url=\"+none;' +\
    '};' +\
    \
    'lxjs.getLocationMessage = function(){' +\
        'window.location.href=\"luosuo://?action=getLocation&callback=\"+arguments[0]+\"&url=\"+none+\"\";' +\
    '};' +\
    \
    'lxjs.seeContact = function(){' +\
        'window.location.href=\"luosuo://?action=personalPage&callback=nothing&url=\"+none+\"&accountId=\"+arguments[0];' +\
    '};' +\
    \
    'lxjs.startActivityResultCallBack = function(){' +\
        'if(arguments[0] == \"com.tixa.activity.citylist\"){' +\
            'window.location.href = \"luosuo://?action=cityList&callback=\"+arguments[1]+\"&url=\"+none+\"\";' +\
        '}else if(arguments[0] == \"com.tixa.activity.occupation\"){' +\
            'window.location.href = \"luosuo://?action=occupationList&callback=\"+arguments[1]+\"&url=\"+none+\"\";' +\
        '}' +\
    '};' +\
    \
    'lxjs.goBackApp = function(){' +\
        'window.location.href=\"luosuo://?action=goBackApp&callback=nothing&url=\"+none+\"\";' +\
    '};';\
    document.querySelector('head').appendChild(script);";
    
    return jsScript;
}

- (NSString *)JavaScriptForH5BodyTop
{
    NSString* script = @"LS.Page.initBodyTop();";
    return script;
}

//获得星座
-(NSString *)getAstroWithDate:(NSDate *)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit|kCFCalendarUnitMonth|kCFCalendarUnitDay;
    NSDateComponents *dd2 = [cal components:unitFlags fromDate:date];
    
    int birthMonth = [dd2 month];
    int birthDay = [dd2 day];
    
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    
    result=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(birthMonth*2-(birthDay < [[astroFormat substringWithRange:NSMakeRange((birthMonth-1), 1)] intValue] - (-19))*2,2)]];
    return result;
}



@end

