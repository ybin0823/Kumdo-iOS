//
//  YBImageManager.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 11. 5..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "YBImageManager.h"

@implementation YBImageManager
{
    __weak id <YBImageManagerDelegate> delegate;
}

@synthesize delegate = delegate;

#pragma mark load

- (void)loadImageWithURL:(NSURL *)url receiveMainThread:(BOOL)isMainThread withObject:(nullable id)object
{
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[defaultSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        UIImage *image = [UIImage imageWithData:data];
        
        if (isMainThread) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate imageDidLoad:image withObject:object];
            });
        }
    }] resume];
}

#pragma mark scale & resize

- (UIImage *)scaleImageWith:(UIImage *)image toSize:(CGSize)size
{
    CGFloat resizeWidth = size.width;
    CGFloat resizeHeight = size.height;
    
    // Create bitmap context with size, opaque, scale and push it onto the graphics stack
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(resizeWidth, resizeHeight), NO, [UIScreen mainScreen].scale);
    
    [image drawInRect:CGRectMake(0, 0, resizeWidth, resizeHeight)];
    
    // Generate and return UIImage
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Pop the context from the graphics stack
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size isMaintain:(BOOL)isMaintain
{
    if (!isMaintain) {
        return [self scaleImageWith:image toSize:size];
    }
    
    CGFloat scaleFactor = size.width / image.size.width;
    CGFloat resizeWidth = size.width;
    CGFloat resizeHeight = image.size.height * scaleFactor;
    
    return [self scaleImageWith:image toSize:CGSizeMake(resizeWidth, resizeHeight)];
}

- (UIImage *)scaleImageWithNamed:(NSString *)name toSize:(CGSize)size
{
    return [self scaleImageWith:[UIImage imageNamed:name] toSize:size];
}

#pragma mark crop
- (UIImage *)centerCroppingImage:(UIImage *)image toSize:(CGSize)size
{
    float x = (image.size.width - size.width) / 2;
    float y = (image.size.height - size.height) / 2;
    
    CGRect cropRect = CGRectMake(x, y, size.width, size.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    
    UIImage *ceterCroppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return ceterCroppedImage;
}

@end
