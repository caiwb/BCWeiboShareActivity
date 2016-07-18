//
//  BCWBShareProvider.h
//  Pods
//
//  Created by caiwb on 16/7/18.
//
//

#import <Foundation/Foundation.h>

@interface BCWBShareProvider : NSObject

+ (BOOL)shareText:(NSString *)text complete:(void(^)(BOOL suc, NSString *errMsg))complete;


+ (BOOL)shareImage:(NSData *)imageData withText:(NSString *)text complete:(void(^)(BOOL suc, NSString *errMsg))complete;


+ (BOOL)shareWebPage:(NSString *)webUrl
           withTitle:(NSString *)title
                text:(NSString *)text
          thumbImage:(UIImage *)thumbImage
            complete:(void(^)(BOOL suc, NSString *errMsg))complete;


+ (BOOL)shareMusic:(NSString *)musicUrl
   withMusicWebUrl:(NSString *)musicWebUrl
             title:(NSString *)title
              text:(NSString *)text
        thumbImage:(UIImage *)thumbImage
          complete:(void(^)(BOOL suc, NSString *errMsg))complete;


+ (BOOL)shareVideo:(NSString *)videoUrl
   withVideoWebUrl:(NSString *)videoWebUrl
             title:(NSString *)title
              text:(NSString *)text
        thumbImage:(UIImage *)thumbImage
          compelet:(void(^)(BOOL suc, NSString *errMsg))complete;


//imageData, musicUrl, videoUrl中只能分享一个
+ (BOOL)shareAllWithTitle:(NSString *)title
                     text:(NSString *)text
                   webUrl:(NSString *)webUrl
               thumbImage:(UIImage *)thumbImage
                 musicUrl:(NSString *)musicUrl
                 videoUrl:(NSString *)videoUrl
           shareImageData:(NSData *)shareImageData
                 compelet:(void(^)(BOOL suc, NSString *errMsg))complete;

@end
