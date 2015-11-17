//
//  YBTableViewCell.h
//  Kumdo
//
//  Created by Jang Young bin on 2015. 11. 10..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentsView.h"
#import "SubInfoView.h"

@interface YBTableViewCell : UITableViewCell

@property (nonatomic, readonly) ContentsView *contentsView;
@property (nonatomic, readonly) SubInfoView *subInfoView;

@end
