//
//  CategoryViewCell.h
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 16..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryViewCell : UITableViewCell

@property (nonatomic, readonly) UILabel *label;
@property (nonatomic, readonly) UIImageView *imageView;

- (void)setAttributedText:(NSString *)text;

@end
