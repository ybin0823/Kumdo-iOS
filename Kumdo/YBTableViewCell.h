//
//  YBTableViewCell.h
//  Kumdo
//
//  Created by Jang Young bin on 2015. 11. 10..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBTableViewCell : UITableViewCell

@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, readonly) UILabel *sentenceLabel;
@property (nonatomic, readonly) UILabel *wordsLabel;
@property (nonatomic, readonly) UILabel *nameLabel;
@property (nonatomic, readonly) UILabel *dateLabel;

- (void)setSentenceWithAttributedText:(NSString *)text;
- (void)setWordsWithAttributedText:(NSString *)text;
- (void)setFormattedDate:(NSDate *)date;
- (void)setDefaultImage;
- (void)setImageWithAnimation:(UIImage *)image;

@end
