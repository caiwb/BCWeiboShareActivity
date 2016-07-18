//
//  BCWBLoginProvider.h
//  Pods
//
//  Created by caiwb on 16/7/18.
//
//

#import <Foundation/Foundation.h>
#import "WeiboUser.h"

@interface BCWBLoginProvider : NSObject

+ (void)loginWithCompleteBlock:(void(^)(BOOL suc, NSString *accessToken, NSString *openId, NSString *errMsg))complete;

+ (void)getUserInfoWithCompleteBlock:(void(^)(BOOL suc, WeiboUser *userInfo))complete;

@end
