//
//  BCWBLoginProvider.m
//  Pods
//
//  Created by caiwb on 16/7/18.
//
//

#import "BCWBLoginProvider.h"
#import "BCWBSocialHandler.h"
#import "WBHttpRequest.h"

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

+ (void)getUserInfoWithCompleteBlock:(void (^)(BOOL, WeiboUser *))complete
{
    NSParameterAssert(complete);
    
    [WBHttpRequest requestForUserProfile:[BCWBSocialHandler sharedInstance].userID
                         withAccessToken:[BCWBSocialHandler sharedInstance].accessToken
                      andOtherProperties:nil
                                   queue:nil
                   withCompletionHandler:^(WBHttpRequest *httpRequest, WeiboUser *result, NSError *error) {

            if (error)
            {
                complete(NO, nil);
            }
            else
            {
                complete(YES, result);
            }
    }];
}

@end
