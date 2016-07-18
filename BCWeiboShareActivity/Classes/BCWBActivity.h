//
//  BCWBActivity.h
//  Pods
//
//  Created by caiwb on 16/7/18.
//
//

#import <UIKit/UIKit.h>

@interface BCWBActivity : UIActivity

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *thumbImage;
@property (nonatomic, strong) NSString *webUrl;
@property (nonatomic, strong) NSString *musicUrl;
@property (nonatomic, strong) NSString *videoUrl;
@property (nonatomic, strong) NSData *shareImageData;

@property (nonatomic, strong) void (^completeBlock)(BOOL suc, NSString *errMsg);
@property (nonatomic, strong) void (^actionBlock)(Class activityClass);


@end
