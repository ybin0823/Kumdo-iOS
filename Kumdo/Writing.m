//
//  Writing.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 19..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "Writing.h"

@implementation Writing
{
    NSString *name;
    NSString *email;
    NSString *sentence;
    NSArray *words;
    NSString *imageUrl;
    int category;
    NSDate *date;
    
}

@synthesize name = name;
@synthesize email = email;
@synthesize sentence = sentence;
@synthesize words = words;
@synthesize imageUrl = imageUrl;
@synthesize category = category;
@synthesize date = date;

- (NSString *)stringWithCommaFromWords
{
    NSMutableString *wordsWithComma = [[NSMutableString alloc] init];
    for (int i = 0; i < [words count]; i++) {
        [wordsWithComma appendString:[words objectAtIndex:i]];
        
        // words가 한개가 아닐 경우 ,를 append한다. 마지막 word일 경우(단어는 최대 3개)는 붙이지 않는다
        if ([words count] > 1 && (i + 1 != [words count])) {
            [wordsWithComma appendString:@", "];
        }
    }
    
    return [NSString stringWithString:wordsWithComma];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Writing : [ name = %@, email = %@, sentence = %@, words = %@, imageUrl = %@, category = %d, date = %@",
            name, email, sentence, [self stringWithCommaFromWords], imageUrl, category, date];
}

@end
