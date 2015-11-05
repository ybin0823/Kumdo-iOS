//
//  Category.h
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 19..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBCategory : NSObject

@property (nonatomic, readonly) NSArray *images;
@property (nonatomic, readonly) NSArray *names;

- (NSInteger)count;

@end
