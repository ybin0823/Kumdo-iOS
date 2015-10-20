//
//  User.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 20..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "User.h"

@implementation User
{
    // 주석의 데이터는 유효하지 않은 샘플 데이터. 어떤 형식으로 파악하기 위한 주석
    NSString *email;        // test@naver.com
    NSString *nickname;     // nickname
    NSString *enc_id;       // 9ef4bf4edd82f792df764494295dddd30dc1369fb0c69fc2130ae1a1832cd1db
    NSURL *profile_image;   // https://ssl.pstatic.net/static/pwe/address/deskhome/ico_default1.jpg
    NSString *age;          // 20-29
    NSString *gender;       // M
    NSString *userId;       // 14924867
    NSString *name;         // 홍길동
    NSString *birthday;       // 01-01
}

@synthesize email = email;
@synthesize nickname = nickname;
@synthesize enc_id = enc_id;
@synthesize profile_image = profile_image;
@synthesize age = age;
@synthesize gender = gender;
@synthesize userId = userId;
@synthesize name = name;
@synthesize birthday = birthday;


+ (instancetype)sharedInstance
{
    static dispatch_once_t oncePredicate;
    static User *shared = nil;
    
    dispatch_once(&oncePredicate, ^{
        shared = [[self alloc] init];
    });
    
    return shared;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"User : [email = %@, nickname = %@, enc_id = %@, profile_image = %@, age = %@, gender = %@, userId = %@, name = %@, birthday = %@]",
            email, nickname, enc_id, profile_image, age, gender, userId, name, birthday];
}

@end
