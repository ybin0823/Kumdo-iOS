//
//  Writing.h
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 19..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Writing : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *sentence;
@property (strong, nonatomic) NSArray *words;
@property (strong, nonatomic) NSString *imageUrl;
@property int category;
@property (strong, nonatomic) NSDate *date;

+(instancetype)writingWithJSON:(id)json;

- (NSString *)stringWithCommaFromWords;

@end
