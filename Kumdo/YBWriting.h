//
//  Writing.h
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 19..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBWriting : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *sentence;
@property (nonatomic) NSArray *words;
@property (nonatomic) NSString *imageUrl;
@property NSInteger category;
@property (nonatomic) NSDate *date;

+(instancetype)writingWithJSON:(id)json;

- (NSString *)stringWithCommaFromWords;

@end
