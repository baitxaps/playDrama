//
//  Photo.h
//  Components
//  照片处理对象
//  Created by chenhairong on 10-9-15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

@interface Photo : NSObject {

}
/*
 * 重图片中间截取图片
 * originImage 图片对象
 * size 截取区域
 * return 返回图片对象
 */
+(UIImage *)getSubImageFromOriginImage1:(UIImage *)originImage subImageSize:(CGSize)size;


+(UIImage *)getSubImageFromOriginImage:(UIImage *)originImage subImageSize:(CGSize)size;
/*
 * 缩放图片
 * image 图片对象
 * toWidth 宽
 * toHeight 高
 * return 返回图片对象
 */
+(UIImage *)scaleImage:(UIImage *)image toWidth:(int)toWidth toHeight:(int)toHeight;

/*
 * 缩放图片数据
 * imageData 图片数据
 * toWidth 宽
 * toHeight 高
 * return 返回图片数据对象
 */
+(NSData *)scaleData:(NSData *)imageData toWidth:(int)toWidth toHeight:(int)toHeight;

/*
 * 圆角
 * image 图片对象
 * size 尺寸
 */
+(id) createRoundedRectImage:(UIImage*)image size:(CGSize)size;


/*
 * 圆形
 * image 图片对象
 */
+(id) circleImage:(UIImage*)image;

/*
 * 方形
 * image 图片对象
 */
+(id) squareImage:(UIImage*)image;

/*
 * 图片转换为字符串
 */
+(NSString *) image2String:(UIImage *)image;

/*
 * 字符串转换为图片
 */
+(UIImage *) string2Image:(NSString *)string;

//roate image
+(UIImage *)rotateImage:(UIImage *)aImage;

+ (UIImage*)thumbnailOfImage:(UIImage*)image;
+(UIImage *)addBackgroundToImage:(UIImage *)image;
+(UIImage  *)createThumbImage:(NSURL *)path;
+(UIImage *)getLocationImgFromImage:(UIImage *)img;
+ (UIImage*)thumbnailOfHeith:(UIImage*)image height:(float)_height;
+ (UIImage*)thumbnailOfWidth:(UIImage*)image width:(float)_width;
+ (UIImage*)thumbnailOfWidth:(UIImage*)image;
+ (UIImage*)thumbnailOfImage:(UIImage*)image height:(float)_height width:(float)_width;

+ (NSData *)compressedImage:(UIImage *)image withLimitedDataSize:(float)sizeKb;
+ (NSData *)compressedImage:(UIImage *)image;
+ (NSData *)compressedHeadImage:(UIImage *)image;
@end
