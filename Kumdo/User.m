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
    NSString *email;
    NSString *nickname;
    NSString *enc_id;
    NSURL *profile_image;
    NSInteger age;
    NSString *gender;
    NSString *userId;
    NSString *name;
    NSDate *birthday;
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

@end
