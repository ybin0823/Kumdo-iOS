//
//  YBImageManager.h
//  Kumdo
//
//  Created by Jang Young bin on 2015. 11. 5..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol YBImageManagerDelegate <NSObject>

@optional
- (void)didLoadImage:(UIImage * _Nonnull)image withObject:(nullable id)object;
- (void)didLoadImage:(UIImage * _Nonnull)image withArray:(nullable NSArray *)array;

@end

@interface YBImageManager : NSObject

@property (nonatomic, weak) id <YBImageManagerDelegate> delegate;

- (void)loadImageWithURL:(NSURL * _Nonnull)url receiveMainThread:(BOOL)isMainThread withObject:(nullable id)object;
- (void)loadImageWithURL:(NSURL * _Nonnull)url receiveMainThread:(BOOL)isMainThread withArray:(nullable NSArray *)array;

- (UIImage * _Nonnull)scaleImageWith:(UIImage * _Nonnull)image toSize:(CGSize)size;
- (UIImage * _Nonnull)maintainScaleRatioImage:(UIImage * _Nonnull)image withWidth:(CGFloat)width;
- (UIImage * _Nonnull)scaleImageWithNamed:(NSString * _Nonnull)name toSize:(CGSize)size;

- (UIImage * _Nonnull)centerCroppingImage:(UIImage * _Nonnull)image toSize:(CGSize)size;

@end
