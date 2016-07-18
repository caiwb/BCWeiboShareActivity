//
//  BCWBSocialHandler.m
//  Pods
//
//  Created by caiwb on 16/7/18.
//
//

#import "BCWBSocialHandler.h"

@implementation BCWBSocialHandler

+ (instancetype)sharedInstance
{
    static BCWBSocialHandler *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[BCWBSocialHandler alloc] init];
    });
    return handler;
}

- (instancetype)init
{
    if (self = [super init])
    {
        /*
         WeiboSDKResponseStatusCodeSuccess               = 0,//成功
         WeiboSDKResponseStatusCodeUserCancel            = -1,//用户取消发送
         WeiboSDKResponseStatusCodeSentFail              = -2,//发送失败
         WeiboSDKResponseStatusCodeAuthDeny              = -3,//授权失败
         WeiboSDKResponseStatusCodeUserCancelInstall     = -4,//用户取消安装微博客户端
         WeiboSDKResponseStatusCodePayFail               = -5,//支付失败
         WeiboSDKResponseStatusCodeShareInSDKFailed      = -8,//分享失败 详情见response UserInfo
         WeiboSDKResponseStatusCodeUnsupport             = -99,//不支持的请求
         WeiboSDKResponseStatusCodeUnknown               = -100,
         */
        self.errList = @[   @"WeiboSDKResponseStatusCodeUserCancel",
                            @"WeiboSDKResponseStatusCodeSentFail",
                            @"WeiboSDKResponseStatusCodeAuthDeny",
                            @"WeiboSDKResponseStatusCodeUserCancelInstall",
                            @"WeiboSDKResponseStatusCodePayFail",
                            @"WeiboSDKResponseStatusCodeShareInSDKFailed",
                            @"WeiboSDKResponseStatusCodeUnsupport",
                            @"WeiboSDKResponseStatusCodeUnknown"];
    }
    return self;
}

- (BOOL)setWBAppKey:(NSString *)appKey redirectURI:(NSString *)redirectURI
{
    [WeiboSDK registerApp:appKey];
    
    self.appKey = appKey;
    self.redirectURI = redirectURI;
    
    self.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:WB_ACCESS_TOKEN];
    self.refreshToken = [[NSUserDefaults standardUserDefaults] objectForKey:WB_REFRESH_TOKEN];
    self.expirationDate = [[NSUserDefaults standardUserDefaults] objectForKey:WB_EXPIRATION_DATE];
    
    return YES;
}

- (BOOL)reAuthorize
{
    return ([self.expirationDate compare:[NSDate date]] == NSOrderedAscending) || !self.accessToken || _reAuthorize;
}

- (BOOL)isWBInstall
{
    return [WeiboSDK isWeiboAppInstalled] && [WeiboSDK isCanShareInWeiboAPP];
}

- (BOOL)handleOpenURL:(NSURL *)url
{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

#pragma WeiboSDKDelegate

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess)
        {
            self.shareComplete(YES, nil);
            
            WBAuthorizeResponse *aResp = sendMessageToWeiboResponse.authResponse;
            
            if (aResp && aResp.accessToken && aResp.accessToken.length)
            {
                self.accessToken = aResp.accessToken;
                self.refreshToken = aResp.refreshToken;
                self.expirationDate = aResp.expirationDate;
                
                [[NSUserDefaults standardUserDefaults] setObject:self.accessToken forKey:WB_ACCESS_TOKEN];
                [[NSUserDefaults standardUserDefaults] setObject:self.refreshToken forKey:WB_REFRESH_TOKEN];
                [[NSUserDefaults standardUserDefaults] setObject:self.expirationDate forKey:WB_EXPIRATION_DATE];
            }
        }
        else
        {
            self.shareComplete(NO, self.errList[[self getErrlistIndex:response.statusCode ]]);
        }
    }
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        WBAuthorizeResponse *aResp = (WBAuthorizeResponse *)response;
        
        if (aResp.statusCode == WeiboSDKResponseStatusCodeSuccess && aResp.accessToken && aResp.accessToken.length)
        {
            self.accessToken = aResp.accessToken;
            self.refreshToken = aResp.refreshToken;
            self.expirationDate = aResp.expirationDate;
            
            [[NSUserDefaults standardUserDefaults] setObject:self.accessToken forKey:WB_ACCESS_TOKEN];
            [[NSUserDefaults standardUserDefaults] setObject:self.refreshToken forKey:WB_REFRESH_TOKEN];
            [[NSUserDefaults standardUserDefaults] setObject:self.expirationDate forKey:WB_EXPIRATION_DATE];
            
            self.loginComplete(YES, self.accessToken, nil, nil);
        }
        else
        {
            self.loginComplete(NO, nil, nil, self.errList[[self getErrlistIndex:response.statusCode]]);
        }
    }
}


- (int)getErrlistIndex:(int)statusCode
{
    if (statusCode > -10)
    {
        return abs(statusCode);
    }
    else
    {
        return abs(statusCode) % 10;
    }
}


@end
