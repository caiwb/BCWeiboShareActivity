//
//  BCViewController.m
//  BCWeiboShareActivity
//
//  Created by caiwenbo on 07/18/2016.
//  Copyright (c) 2016 caiwenbo. All rights reserved.
//

#import "BCViewController.h"
#import "BCWBShareActivity.h"

@interface BCViewController ()

@end

@implementation BCViewController

- (void)loginAndGetUserInfo
{
    [BCWBLoginProvider loginWithCompleteBlock:^(BOOL suc, NSString *accessToken, NSString *openId, NSString *errMsg) {
        if (suc)
        {
            [BCWBLoginProvider getUserInfoWithCompleteBlock:^(BOOL suc, WeiboUser *userInfo) {
                if (suc)
                {
                    //use userInfo
                }
            }];
        }
    }];
}

- (void)share
{
    [BCWBShareProvider shareWebPage:@"分享到微博"
                          withTitle:@"标题"
                               text:@"内容"
                         thumbImage:[UIImage imageNamed:@"thumbImage"]
                           complete:^(BOOL suc, NSString *errMsg) {
                             //to do after share
                         }];
}

- (void)shareOnActivityController
{
    BCWBActivity *item = [[BCWBActivity alloc] init];
    
    item.title = @"title";
    item.text = @"content";
    item.thumbImage = [UIImage new];
    item.webUrl = @"github.com";
    [item setCompleteBlock:^(BOOL suc, NSString *errMsg) {
        //to do after share
    }];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[item.title, item.webUrl, item.thumbImage] applicationActivities:@[item]];
    [self presentViewController:activityVC animated:YES completion:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loginAndGetUserInfo];
}

@end
