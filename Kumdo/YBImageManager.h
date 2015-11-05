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

- (void)imageDidLoad:(UIImage *)image;

@end

@interface YBImageManager : NSObject

@property (nonatomic, weak) id <YBImageManagerDelegate> delegate;

- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size isMaintain:(BOOL)isMaintain;
- (UIImage *)scaleImageWithNamed:(NSString *)name toSize:(CGSize)size;

@end
