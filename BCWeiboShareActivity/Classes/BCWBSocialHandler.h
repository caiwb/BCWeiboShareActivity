//
//  BCWBSocialHandler.h
//  Pods
//
//  Created by caiwb on 16/7/18.
//
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"

#define WB_ACCESS_TOKEN     @"WB_ACCESS_TOKEN"
#define WB_REFRESH_TOKEN    @"WB_REFRESH_TOKEN"
#define WB_EXPIRATION_DATE  @"WB_EXPIRATION_DATE"
#define WB_USERID           @"WB_USERID"

#define weaklyBCWBHandler() __weak BCWBSocialHandler *weakHandler = [BCWBSocialHandler sharedInstance]

@interface BCWBSocialHandler : NSObject <WeiboSDKDelegate, WBHttpRequestDelegate>

@property (nonatomic, strong) NSString *appKey;

@property (nonatomic, strong) NSString *redirectURI;

@property (nonatomic, strong) NSString *accessToken;

@property (nonatomic, strong) NSString *refreshToken;

@property (nonatomic, strong) NSDate *expirationDate;

@property (nonatomic, strong) NSString *userID;

@property (nonatomic, strong) NSArray *errList;

@property (nonatomic, assign) BOOL reAuthorize;

@property (nonatomic, assign) BOOL isWBInstall;

@property (nonatomic, strong) void (^loginComplete)(BOOL suc, NSString *accessToken, NSString *openId, NSString *errMsg);

@property (nonatomic, strong) void (^shareComplete)(BOOL suc, NSString *errMsg);

+ (instancetype)sharedInstance;

- (BOOL)setWBAppKey:(NSString *)appKey redirectURI:(NSString *)redirectURI;

- (BOOL)handleOpenURL:(NSURL *)url;

@end
