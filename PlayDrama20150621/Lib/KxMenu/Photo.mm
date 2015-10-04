//
//  Photo.m
//  Components
//  照片处理对象
//  Created by chenhairong on 10-9-15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Photo.h"


float _kilobytes_ = 1024;

@interface NSData (MBBase64)

+ (id)dataWithBase64EncodedString:(NSString *)string;     //  Padding '=' characters are optional. Whitespace is ignored.
- (NSString *)base64Encoding;
@end

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation NSData (MBBase64)

+ (id)dataWithBase64EncodedString:(NSString *)string;
{
	if (string == nil)
		[NSException raise:NSInvalidArgumentException format:@""];
	if ([string length] == 0)
		return [NSData data];
	
	static char *decodingTable = NULL;
	if (decodingTable == NULL)
	{
		decodingTable = (char *)malloc(256);
		if (decodingTable == NULL)
			return nil;
		memset(decodingTable, CHAR_MAX, 256);
		NSUInteger i;
		for (i = 0; i < 64; i++)
			decodingTable[(short)encodingTable[i]] = i;
	}
	
	const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
	if (characters == NULL)     //  Not an ASCII string!
		return nil;
	char *bytes = (char *)malloc((([string length] + 3) / 4) * 3);
	if (bytes == NULL)
		return nil;
	NSUInteger length = 0;
	
	NSUInteger i = 0;
	while (YES)
	{
		char buffer[4];
		short bufferLength;
		for (bufferLength = 0; bufferLength < 4; i++)
		{
			if (characters[i] == '\0')
				break;
			if (isspace(characters[i]) || characters[i] == '=')
				continue;
			buffer[bufferLength] = decodingTable[(short)characters[i]];
			if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
			{
				free(bytes);
				return nil;
			}
		}
		
		if (bufferLength == 0)
			break;
		if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
		{
			free(bytes);
			return nil;
		}
		
		//  Decode the characters in the buffer to bytes.
		bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
		if (bufferLength > 2)
			bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
		if (bufferLength > 3)
			bytes[length++] = (buffer[2] << 6) | buffer[3];
	}
	
	realloc(bytes, length);
	return [NSData dataWithBytesNoCopy:bytes length:length];
}

- (NSString *)base64Encoding;
{
	if ([self length] == 0)
		return @"";
	
    char *characters = (char *)malloc((([self length] + 2) / 3) * 4);
	if (characters == NULL)
		return nil;
	NSUInteger length = 0;
	
	NSUInteger i = 0;
	while (i < [self length])
	{
		char buffer[3] = {0,0,0};
		short bufferLength = 0;
		while (bufferLength < 3 && i < [self length])
			buffer[bufferLength++] = ((char *)[self bytes])[i++];
		
		//  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
		characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
		characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
		if (bufferLength > 1)
			characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
		else characters[length++] = '=';
		if (bufferLength > 2)
			characters[length++] = encodingTable[buffer[2] & 0x3F];
		else characters[length++] = '=';	
	}
	
	return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}

@end


@implementation Photo

#pragma mark -
#pragma mark 内部方法

+(NSString *) image2String:(UIImage *)image{
	NSMutableDictionary *systeminfo = [NSMutableDictionary dictionaryWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"systeminfo"]];
    float o = 0.1;
	if (!image){//如果没有图则不操作
		return @"";
	}
	image = [self scaleImage:image toWidth:image.size.width/3 toHeight:image.size.height/3];
	if (systeminfo){//如果有系统设置信息
		if ([[systeminfo objectForKey:@"imagesize"] isEqualToString:@"大"]){
			o=0.7;
		}
		if ([[systeminfo objectForKey:@"imagesize"] isEqualToString:@"中"]){
			o=0.5;
		}
		if ([[systeminfo objectForKey:@"imagesize"] isEqualToString:@"小"]){
			o=0.2;
		}
	}
	NSData* pictureData = UIImageJPEGRepresentation(image,o);
	NSString* pictureDataString = [pictureData base64Encoding];
	
	return pictureDataString;
}

+(UIImage *) string2Image:(NSString *)string{
	UIImage *image = [UIImage imageWithData:[NSData dataWithBase64EncodedString:string]];
	return image;
}

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,float ovalHeight){
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
		CGContextAddRect(context, rect);
		return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}


+ (id) createRoundedRectImage:(UIImage*)image size:(CGSize)size{
    // the size of CGContextRef
    int w = size.width;
    int h = size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, 10, 10);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
	UIImage *result= [UIImage imageWithCGImage:imageMasked];
	CGImageRelease(imageMasked);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return result;
}

+(id) circleImage:(UIImage*)image
{
    float scaleFactor = [[UIScreen mainScreen] scale];
    CGFloat w = image.size.width;
    CGFloat h = image.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w * scaleFactor, h * scaleFactor, 8, w * scaleFactor * 4,
                                                 colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextScaleCTM(context, scaleFactor, scaleFactor);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, w/2, w/2);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, rect, image.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    UIImage *result = [UIImage imageWithCGImage:imageMasked scale:scaleFactor orientation:image.imageOrientation];
	CGImageRelease(imageMasked);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return result;
}

+(id) squareImage:(UIImage *)image
{
    float scaleFactor = [[UIScreen mainScreen] scale];
    CGFloat w = image.size.width;
    CGFloat h = image.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w * scaleFactor, h * scaleFactor, 8, w * scaleFactor * 4,
                                                 colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextScaleCTM(context, scaleFactor, scaleFactor);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
//    addRoundedRectToPath(context, rect, w/2, w/2);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, rect, image.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    UIImage *result = [UIImage imageWithCGImage:imageMasked scale:scaleFactor orientation:image.imageOrientation];
	CGImageRelease(imageMasked);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return result;
}

+(UIImage *)getSubImageFromOriginImage:(UIImage *)originImage subImageSize:(CGSize)size
{
    CGSize retainSize = CGSizeMake(size.width*2, size.height*2);
    CGRect myImageRect = CGRectMake((originImage.size.width*2 - retainSize.width)/2, (originImage.size.height*2 - retainSize.height)/2, retainSize.width, retainSize.height);
    CGImageRef imageRef = originImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    UIGraphicsBeginImageContext(retainSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    return smallImage;
}

+(UIImage *)getSubImageFromOriginImage1:(UIImage *)originImage subImageSize:(CGSize)size
{
    CGSize retainSize = CGSizeMake(size.width, size.height);
    CGRect myImageRect = CGRectMake((originImage.size.width - retainSize.width)/2, (originImage.size.height - retainSize.height)/2, retainSize.width, retainSize.height);
    CGImageRef imageRef = originImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    UIGraphicsBeginImageContext(retainSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    return smallImage;
}
+(UIImage *)scaleImage:(UIImage *)image toWidth:(int)toWidth toHeight:(int)toHeight{
	int width=0;
	int height=0;
	int x=0;
	int y=0;
	
	if (image.size.width<toWidth){
	    width = toWidth;
		height = image.size.height*(toWidth/image.size.width);
		y = (height - toHeight)/2;
	}else if (image.size.height<toHeight){
		height = toHeight;
		width = image.size.width*(toHeight/image.size.height);
		x = (width - toWidth)/2;
	}else if (image.size.height>toHeight){
        height = toHeight;
		width = image.size.width*(toHeight/image.size.height);
		x = (width - toWidth)/2;
	}else if (image.size.width>toWidth){
		width = toWidth;
		height = image.size.height*(toWidth/image.size.width);
		y = (height - toHeight)/2;
	}else{
		height = toHeight;
		width = toWidth;
	}
	
	CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
	CGSize subImageSize = CGSizeMake(toWidth, toHeight);
    CGRect subImageRect = CGRectMake(x, y, toWidth, toHeight);
    CGImageRef imageRef = image.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, subImageRect);
    UIGraphicsBeginImageContext(subImageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, subImageRect, subImageRef);
    UIImage* subImage = [UIImage imageWithCGImage:subImageRef];
	CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
	return subImage;
}


+(NSData *)scaleData:(NSData *)imageData toWidth:(int)toWidth toHeight:(int)toHeight{
	UIImage *image = [[UIImage alloc] initWithData:imageData];
	int width=0;
	int height=0;
	int x=0;
	int y=0;
	
	if (image.size.width<toWidth){
	    width = toWidth;
		height = image.size.height*(toWidth/image.size.width);
		y = (height - toHeight)/2;
	}else if (image.size.height<toHeight){
		height = toHeight;
		width = image.size.width*(toHeight/image.size.height);
		x = (width - toWidth)/2;
	}else if (image.size.width>toWidth){
	    width = toWidth;
		height = image.size.height*(toWidth/image.size.width);
		y = (height - toHeight)/2;
	}else if (image.size.height>toHeight){
		height = toHeight;
		width = image.size.width*(toHeight/image.size.height);
		x = (width - toWidth)/2;
	}else{
		height = toHeight;
		width = toWidth;
	}
	
	CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
	CGSize subImageSize = CGSizeMake(toWidth, toHeight);
    CGRect subImageRect = CGRectMake(x, y, toWidth, toHeight);
    CGImageRef imageRef = image.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, subImageRect);
    UIGraphicsBeginImageContext(subImageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, subImageRect, subImageRef);
    UIImage* subImage = [UIImage imageWithCGImage:subImageRef];
	CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
	
	NSData *data = UIImageJPEGRepresentation(subImage,1.0);
	return data;
}

+(UIImage *)rotateImage:(UIImage *)aImage

{
    
    CGImageRef imgRef = aImage.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    CGFloat scaleRatio = 1;
    CGFloat boundHeight;
    UIImageOrientation orient = aImage.imageOrientation;
    switch(orient)
    
    {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            
            break;
            
        default:
            
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
        
    }
    
    else {
        
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
        
    }
    
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}


+ (UIImage*)thumbnailOfImage:(UIImage*)image
{
    UIImage *img = nil;
//    CGSize itemSize = CGSizeMake(170, 170);
    CGSize itemSize = CGSizeMake(340, 340);

    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [image drawInRect:imageRect];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
	return img;
}


+ (UIImage*)thumbnailOfImage:(UIImage*)image height:(float)_height width:(float)_width
{
    UIImage *img = nil;
    CGSize itemSize = CGSizeMake(_width, _height);
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [image drawInRect:imageRect];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
	return img;
}


+ (UIImage*)thumbnailOfHeith:(UIImage*)image height:(float)_height
{
    UIImage *img = nil;
    float height = CGImageGetHeight(image.CGImage);
    float with = CGImageGetWidth(image.CGImage);
    
    float factor = _height/height;
    float drawWidth = with * factor;
    
    
    CGSize itemSize = CGSizeMake(drawWidth, _height);
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [image drawInRect:imageRect];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
	return img;
}

+ (UIImage*)thumbnailOfWidth:(UIImage*)image width:(float)_width
{
    UIImage *img = nil;
    float height = CGImageGetHeight(image.CGImage);
    float with = CGImageGetWidth(image.CGImage);
    
    float factor = _width/with;
    float drawHeight = height * factor;
    
    CGSize itemSize = CGSizeMake(_width, drawHeight);
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [image drawInRect:imageRect];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
	return img;
}

+ (UIImage*)thumbnailOfWidth:(UIImage*)image
{
    UIImage *img = nil;
    float height = CGImageGetHeight(image.CGImage);
    float width = CGImageGetWidth(image.CGImage);
    
    float drawWidth = width * 2;
    float drawHeight = height * 2;
    
    CGSize itemSize = CGSizeMake(drawWidth, drawHeight);
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [image drawInRect:imageRect];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
	return img;
}

+(UIImage *)addBackgroundToImage:(UIImage *)image
{
	if (!image)
		return nil;
	
	CGImageRef imageRef = [image CGImage];
	UIImage *thumb = nil;
	
	//	struct CGSize imgSize = [imageRef size];
//	float _width = 240;
//	float _height = 190;
    float _width = 260;
	float _height = 214;
//    float _width = 130;
//	float _height = 107;

	
	// hardcode width and height for now, shouldn't stay like that
	CGContextRef bitmap = CGBitmapContextCreate(NULL,
												_width,
												_height,
												CGImageGetBitsPerComponent(imageRef),
												CGImageGetBitsPerPixel(imageRef)*_width,
                                                CGColorSpaceCreateDeviceRGB(),
												kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big
												);
	// now center the image
	
	//CGContextRotateCTM( bitmap, 180*(M_PI/180));
	CGContextDrawImage( bitmap, CGRectMake(0, 0, _width, _height), [UIImage imageNamed:@"GOVidePreBg.png"].CGImage);
	CGContextDrawImage( bitmap, CGRectMake(30, 20, 200, 174), imageRef );
    CGContextDrawImage( bitmap, CGRectMake(0, 0, _width, _height), [UIImage imageNamed:@"GOVieoPrePlayBg.png"].CGImage);
	
	// create a templete imageref.
	CGImageRef ref = CGBitmapContextCreateImage( bitmap );
	thumb = [UIImage imageWithCGImage:ref];
	
	// release the templete imageref.
	CGContextRelease( bitmap );
	CGImageRelease( ref );
	return thumb;
}


+ (UIImage  *)createThumbImage:(NSURL *)path
{
    AVURLAsset *asset2 = [AVURLAsset assetWithURL:path];
    CMTime duration = asset2.duration;
    float time = CMTimeGetSeconds(duration);
    
    CMTime startTime =  CMTimeMake(time/3, 1);
    CMTime endTime =  CMTimeMake(time/3, 1);
    
    AVAssetImageGenerator *assetImage = [[AVAssetImageGenerator alloc] initWithAsset:asset2];
    assetImage.apertureMode = AVAssetImageGeneratorApertureModeProductionAperture;
    CGImageRef imageRef = [assetImage copyCGImageAtTime:startTime actualTime:&endTime error:nil];
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:1.8 orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);
    return image;
    
    
}

+(UIImage *)getLocationImgFromImage:(UIImage *)img{
    
    float height = CGImageGetHeight(img.CGImage);
    float with = CGImageGetWidth(img.CGImage);
    
//    CGRect myImageRect = CGRectMake(with/2-180, height/2-100, 360, 200);
    CGRect myImageRect = CGRectMake(with/2-170, height/2-76, 340, 152);
    UIImage* bigImage= img;
    
    CGImageRef imageRef = bigImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    
    CGSize size;
    size.width = myImageRect.size.width;
    size.height = myImageRect.size.height;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    
    return smallImage;
}

+ (CGAffineTransform)transformImage:(UIImage *)image forOrientation:(CGSize)newSize {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    return transform;
}

+ (UIImage *)resizedImage:(UIImage *)image
                 withSize:(CGSize)newSize
                 transform:(CGAffineTransform)transform
            drawTransposed:(BOOL)transpose
      interpolationQuality:(CGInterpolationQuality)quality {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = image.CGImage;
    
    // Build a context that's the same dimensions as the new size
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(imageRef),
                                                0,
                                                CGImageGetColorSpace(imageRef),
                                                CGImageGetBitmapInfo(imageRef));
    
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}

+ (UIImage *)resizedImage:(UIImage *)image withSize:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality {
    BOOL drawTransposed;
    
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            drawTransposed = YES;
            break;
            
        default:
            drawTransposed = NO;
    }
    
    return [Photo resizedImage:image
                      withSize:newSize
                     transform:[Photo transformImage:image forOrientation:newSize]
                drawTransposed:drawTransposed
          interpolationQuality:quality];
}

+ (NSData *)compressedImage:(UIImage *)image withLimitedDataSize:(float)sizeKb
{
    NSData  *imageData    = UIImageJPEGRepresentation(image, kCGInterpolationDefault);
    double   factor       = 1.0;
    CGSize   size         = image.size;
    CGSize   currentSize  = size;
    UIImage *currentImage = image;
    double adjustment     = sizeKb/(imageData.length/_kilobytes_);
    
    if (imageData.length/_kilobytes_ > sizeKb) {
        factor      *= adjustment;
        currentSize  = CGSizeMake(roundf(size.width * factor), roundf(size.height * factor));
        currentImage = [Photo resizedImage:image withSize:currentSize interpolationQuality:kCGInterpolationDefault];
        imageData    = UIImageJPEGRepresentation(currentImage, kCGInterpolationDefault);
    }
    
    return imageData;
}

+ (NSData *)compressedHeadImage:(UIImage *)image
{
    //头像图片50kb限制
    return [Photo compressedImage:image withLimitedDataSize:50];
}

+ (NSData *)compressedImage:(UIImage *)image
{
    //普通图片300kb限制
    return [Photo compressedImage:image withLimitedDataSize:300];
}

@end
