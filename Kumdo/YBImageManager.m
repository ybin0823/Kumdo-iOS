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
    NSURLSessionConfiguration *defaultSessionConfiguration;
    NSURLSession *defaultSession;
}

@synthesize delegate = delegate;

+ (instancetype)sharedInstance
{
    static dispatch_once_t oncePredicate;
    static YBImageManager *shared = nil;
    
    dispatch_once(&oncePredicate, ^{
        shared = [[self alloc] init];
    });
    
    return shared;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        defaultSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        defaultSession = [NSURLSession sessionWithConfiguration:defaultSessionConfiguration];
    }
    
    return self;
}

#pragma mark load

- (void)loadImageWithURL:(NSURL *)url receiveMainThread:(BOOL)isMainThread withObject:(nullable id)object
{
    [[defaultSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        UIImage *image = [UIImage imageWithData:data];
        
        if (isMainThread) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate didLoadImage:image withObject:object];
            });
        }
    }] resume];
}

- (void)loadImageWithURL:(NSURL *)url receiveMainThread:(BOOL)isMainThread withArray:(NSArray *)array
{
    [[defaultSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        UIImage *image = [UIImage imageWithData:data];
        
        if (isMainThread) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate didLoadImage:image withArray:array];
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

- (UIImage *)maintainScaleRatioImage:(UIImage *)image withWidth:(CGFloat)width
{
    CGFloat scaleFactor = width / image.size.width;
    CGFloat resizeHeight = image.size.height * scaleFactor;
    
    return [self scaleImageWith:image toSize:CGSizeMake(width, resizeHeight)];
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
