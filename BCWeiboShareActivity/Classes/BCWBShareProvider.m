//
//  BCWBShareProvider.m
//  Pods
//
//  Created by caiwb on 16/7/18.
//
//

#import "BCWBShareProvider.h"
#import "BCWBSocialHandler.h"
#import "WeiboSDK.h"


@implementation BCWBShareProvider

+ (BOOL)shareText:(NSString *)text complete:(void (^)(BOOL, NSString *))complete
{
    return [self shareAllWithTitle:nil text:text webUrl:nil thumbImage:nil musicUrl:nil videoUrl:nil shareImageData:nil compelet:complete];
}

+ (BOOL)shareImage:(NSData *)imageData withText:(NSString *)text complete:(void (^)(BOOL, NSString *))complete
{
    return [self shareAllWithTitle:nil text:text webUrl:nil thumbImage:nil musicUrl:nil videoUrl:nil shareImageData:imageData compelet:complete];
}

+ (BOOL)shareWebPage:(NSString *)webUrl withTitle:(NSString *)title text:(NSString *)text thumbImage:(UIImage *)thumbImage complete:(void (^)(BOOL, NSString *))complete
{
    return [self shareAllWithTitle:title text:text webUrl:webUrl thumbImage:thumbImage musicUrl:nil videoUrl:nil shareImageData:nil compelet:complete];
}

+ (BOOL)shareMusic:(NSString *)musicUrl
   withMusicWebUrl:(NSString *)musicWebUrl
             title:(NSString *)title
              text:(NSString *)text
        thumbImage:(UIImage *)thumbImage
          complete:(void (^)(BOOL, NSString *))complete
{
    return [self shareAllWithTitle:title text:text webUrl:musicWebUrl thumbImage:thumbImage musicUrl:musicUrl videoUrl:nil shareImageData:nil compelet:complete];
}

+ (BOOL)shareVideo:(NSString *)videoUrl
   withVideoWebUrl:(NSString *)videoWebUrl
             title:(NSString *)title
              text:(NSString *)text
        thumbImage:(UIImage *)thumbImage
          compelet:(void (^)(BOOL, NSString *))complete
{
    return [self shareAllWithTitle:title text:text webUrl:videoWebUrl thumbImage:thumbImage musicUrl:nil videoUrl:videoUrl shareImageData:nil compelet:complete];
}

+ (BOOL)shareAllWithTitle:(NSString *)title
                     text:(NSString *)text
                   webUrl:(NSString *)webUrl
               thumbImage:(UIImage *)thumbImage
                 musicUrl:(NSString *)musicUrl
                 videoUrl:(NSString *)videoUrl
           shareImageData:(NSData *)shareImageData
                 compelet:(void (^)(BOOL, NSString *))complete
{
    if (! complete)
    {
        complete = ^(BOOL suc, NSString *errMsg) {};
    }
    
    [BCWBSocialHandler sharedInstance].shareComplete = complete;
    
    WBMessageObject *message = [WBMessageObject message];
    
    text = text ?: title;
    title = title ?: text;
    
    if (! text)
    {
        complete(NO, @"Text is needed at leat");
        return NO;
    }
    
    if (shareImageData)
    {
        WBImageObject *imageObject = [WBImageObject object];
        imageObject.imageData = shareImageData;
        
        message.text = text;
        message.imageObject = imageObject;
    }
    else if (! thumbImage)
    {
        message.text = text;
    }
    else
    {
        message.text = @"#分享自网易有道#";
        
        NSData *thumbImageData = [self resizeWithImage: thumbImage];
        //        NSData *thumbImageData = [self compressImage: thumbImage downToSize:32 * 1024];
        
        if (! webUrl || ! title)
        {
            complete(NO, @"Params error");
            return NO;
        }
        else if (musicUrl)
        {
            WBMusicObject *musicObject = [WBMusicObject object];
            musicObject.objectID = [self getUUID];
            musicObject.title = title;
            musicObject.description = text;
            musicObject.thumbnailData = thumbImageData;
            musicObject.musicUrl = webUrl;
            musicObject.musicStreamUrl = musicUrl;
            
            message.mediaObject = musicObject;
        }
        else if (videoUrl)
        {
            WBVideoObject *videoObject = [WBVideoObject object];
            videoObject.objectID = [self getUUID];
            videoObject.title = title;
            videoObject.description = text;
            videoObject.thumbnailData = thumbImageData;
            videoObject.videoUrl = webUrl;
            videoObject.videoStreamUrl = videoUrl;
            
            message.mediaObject = videoObject;
        }
        else
        {
            WBWebpageObject *webpageObject = [WBWebpageObject object];
            webpageObject.objectID = [self getUUID];
            webpageObject.title = title;
            webpageObject.description = text;
            webpageObject.thumbnailData = thumbImageData;
            webpageObject.webpageUrl = webUrl;
            
            message.mediaObject = webpageObject;
        }
    }
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = [BCWBSocialHandler sharedInstance].redirectURI;
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:[BCWBSocialHandler sharedInstance].accessToken];
    
    BOOL suc = [WeiboSDK sendRequest:request];
    if (!suc)
    {
        complete(NO, @"share failed");
    }
    return suc;
}

+ (NSString *)getUUID
{
    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

+ (NSData *)compressImage:(UIImage *)image downToSize:(NSUInteger)size
{
    CGFloat compression = 1.0f;
    CGFloat scale = [UIScreen mainScreen].scale;
    NSData *imageData = [self resizeWithImage:image scale:scale compression:compression];
    
    while ([imageData length] > size && compression > 0.1)
    {
        compression -= 0.1;
        imageData = [self resizeWithImage:image scale:scale compression:compression];
    }
    while ([imageData length] > size && scale > 0.1)
    {
        scale -= 0.1;
        imageData = [self resizeWithImage:image scale:scale compression:compression];
    }
    return imageData;
}


+ (NSData *)resizeWithImage:(UIImage *)image scale:(CGFloat)scale compression:(CGFloat)compression
{
    CGSize newSize = CGSizeMake(image.size.width * scale, image.size.height * scale);
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImageJPEGRepresentation(newImage, compression);
}


+ (NSData *)resizeWithImage:(UIImage *)image
{
    CGFloat width = 100.0f;
    CGFloat height = image.size.height * 100.0f / image.size.width;
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [image drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImageJPEGRepresentation(scaledImage, 1.0f);
}

@end
