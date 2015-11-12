//
//  YBWaterFallViewCell.h
//  Kumdo
//
//  Created by Jang Young bin on 2015. 11. 4..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBWaterFallViewCell : UICollectionViewCell

@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, readonly) UILabel *label;

- (void)setDefaultImage;
- (void)setImageWithAnimation:(UIImage *)image;

@end
