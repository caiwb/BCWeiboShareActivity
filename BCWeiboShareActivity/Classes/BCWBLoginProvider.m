//
//  BCWBLoginProvider.m
//  Pods
//
//  Created by caiwb on 16/7/18.
//
//

#import "BCWBLoginProvider.h"
#import "BCWBSocialHandler.h"

@implementation BCWBLoginProvider

+ (void)loginWithCompleteBlock:(void(^)(BOOL suc, NSString *accessToken, NSString *openId, NSString *errMsg))complete
{
    NSParameterAssert(complete);
    
    if (![BCWBSocialHandler sharedInstance].reAuthorize)
    {
        complete(YES, [BCWBSocialHandler sharedInstance].accessToken, nil, nil);
    }
    
    [BCWBSocialHandler sharedInstance].loginComplete = complete;
    
    if (![BCWBSocialHandler sharedInstance].appKey)
    {
        [BCWBSocialHandler sharedInstance].loginComplete(NO, nil, nil, @"ConfigurationError");
        return;
    }
    
    [self sendAuthRequest];
}

+ (void)sendAuthRequest
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = [BCWBSocialHandler sharedInstance].redirectURI;
    request.scope = @"all";
    [WeiboSDK sendRequest:request];
}

@end
