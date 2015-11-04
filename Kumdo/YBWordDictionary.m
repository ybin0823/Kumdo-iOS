//
//  Word.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 20..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "YBWordDictionary.h"

@implementation YBWordDictionary
{
    NSArray *nounWords;
    NSArray *verbWords;
    NSArray *adjectiveWords;
    NSArray *adverbWords;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        nounWords = [NSArray arrayWithObjects:@"새", @"게임", @"달", @"무지개", @"공부", @"취업", nil];
        verbWords = [NSArray arrayWithObjects:@"되다", @"선택하다", @"믿다", @"가지다", @"원하다", @"보다", nil];
        adjectiveWords = [NSArray arrayWithObjects:@"다른", @"중요한", @"아름다운", @"똑똑한", @"귀여운", @"순수한", nil];
        adverbWords = [NSArray arrayWithObjects:@"자주", @"때때로", @"항상", @"갑자기", @"매우", @"절대", nil];
    }
    
    return self;
}

- (NSString *)randomNonunWord
{
    int index = arc4random() % [nounWords count];
    return [nounWords objectAtIndex:index];
}

- (NSString *)randomVerbWord
{
    int index = arc4random() % [verbWords count];
    return [verbWords objectAtIndex:index];
}

- (NSString *)randomAdjectiveOrAdverbWord
{
    int flag = arc4random() % 2;
    int index;
    NSLog(@"flag is %d", flag);
    if (flag == 1) {
        index = arc4random() % [adjectiveWords count];
        return [adjectiveWords objectAtIndex:index];
    }
    
    index = arc4random() % [adverbWords count];
    return [adverbWords objectAtIndex:index];
}
@end
