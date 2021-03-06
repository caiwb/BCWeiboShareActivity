//
//  BCWBActivity.m
//  Pods
//
//  Created by caiwb on 16/7/18.
//
//

#import <objc/runtime.h>

#import "BCWBActivity.h"
#import "BCWBShareProvider.h"

#import "WeiboSDK.h"

@implementation BCWBActivity

+ (UIActivityCategory)activityCategory
{
    return UIActivityCategoryShare;
}

- (NSString *)activityType
{
    return NSStringFromClass([self class]);
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    if ([WeiboSDK isWeiboAppInstalled] && [WeiboSDK isCanShareInWeiboAPP])
    {
        for (id activityItem in activityItems)
        {
            if ([activityItem isKindOfClass:[UIImage class]])
            {
                return YES;
            }
            else if ([activityItem isKindOfClass:[NSURL class]])
            {
                return YES;
            }
            else if ([activityItem isKindOfClass:[NSString class]])
            {
                return YES;
            }
        }
    }
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    for (id activityItem in activityItems)
    {
        if ([activityItem isKindOfClass:[UIImage class]])
        {
            UIImage *image=(UIImage *)activityItem;
            self.shareImageData = self.shareImageData ?: UIImageJPEGRepresentation(image, 1.0);
        }
        if ([activityItem isKindOfClass:[NSURL class]])
        {
            NSURL *url =(NSURL *)activityItem;
            self.webUrl = self.webUrl ?: [url absoluteString];
        }
        if ([activityItem isKindOfClass:[NSString class]])
        {
            NSString *text=(NSString *)activityItem;
            self.text = self.text ?: text;
        }
    }
}

- (void)performActivity
{
    if (! [BCWBShareProvider shareAllWithTitle: self.title
                                          text: self.text
                                        webUrl: self.webUrl
                                    thumbImage: self.thumbImage
                                      musicUrl: self.musicUrl
                                      videoUrl: self.videoUrl
                                shareImageData: self.shareImageData
                                      compelet: self.completeBlock] && self.completeBlock)
    {
        self.completeBlock(NO, @"share failed");
    }
    
    [self activityDidFinish:YES];
    
    if (self.actionBlock)
    {
        self.actionBlock([self class]);
    }
}

- (NSString *)title
{
    _title = _title ?: objc_getAssociatedObject(self, "title");
    return _title;
}

- (NSString *)text
{
    _text = _text ?: objc_getAssociatedObject(self, "text");
    return _text;
}

- (NSString *)webUrl
{
    _webUrl = _webUrl ?: objc_getAssociatedObject(self, "webUrl");
    return _webUrl;
}

- (UIImage *)thumbImage
{
    _thumbImage = _thumbImage ?: objc_getAssociatedObject(self, "thumbImage");
    return _thumbImage;
}

- (NSString *)musicUrl
{
    _musicUrl = _musicUrl ?: objc_getAssociatedObject(self, "musicUrl");
    return _musicUrl;
}

- (NSString *)videoUrl
{
    _videoUrl = _videoUrl ?: objc_getAssociatedObject(self, "videoUrl");
    return _videoUrl;
}

- (NSData *)shareImageData
{
    _shareImageData = _shareImageData ?: objc_getAssociatedObject(self, "imageData");
    return _shareImageData;
}

@end
