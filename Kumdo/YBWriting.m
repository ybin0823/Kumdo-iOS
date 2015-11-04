//
//  Writing.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 19..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "YBWriting.h"

@implementation YBWriting
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

+(instancetype)writingWithJSON:(id)json
{
    return [[self alloc] initWithJSON:json];
}

-(instancetype)initWithJSON:(id)json
{
    self = [super init];
    
    if (self) {
        name = [json valueForKey:@"name"];
        email = [json valueForKey:@"email"];
        sentence = [json valueForKey:@"sentence"];
        imageUrl = [json valueForKey:@"imageUrl"];
        category = (int)[[json valueForKey:@"category"] integerValue];
        words = [[json valueForKey:@"words"] componentsSeparatedByString:@","];
        
        // 서버에는 시간이 milisecond 단위로 저장되어 있기 때문에 second 단위로 바꿔줘야 한다
        date = [NSDate dateWithTimeIntervalSince1970:[[json valueForKey:@"date"] doubleValue] / 1000];
    }
    
    return self;
}

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
