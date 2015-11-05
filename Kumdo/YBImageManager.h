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

- (void)imageDidLoad:(UIImage * _Nonnull)image withObject:(nullable id)object;

@end

@interface YBImageManager : NSObject

@property (nonatomic, weak) id <YBImageManagerDelegate> delegate;

- (void)loadImageWithURL:(NSURL * _Nonnull)url receiveMainThread:(BOOL)isMainThread withObject:(nullable id)object;

- (UIImage * _Nonnull)scaleImage:(UIImage * _Nonnull)image toSize:(CGSize)size isMaintain:(BOOL)isMaintain;
- (UIImage * _Nonnull)scaleImageWithNamed:(NSString * _Nonnull)name toSize:(CGSize)size;

- (UIImage * _Nonnull)centerCroppingImage:(UIImage * _Nonnull)image toSize:(CGSize)size;

@end
