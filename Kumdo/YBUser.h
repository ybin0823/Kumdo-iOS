//
//  User.h
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 20..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBUser : NSObject

// XML elementName과 맞추기 위해 '_' convention을 사용.
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *nickname;
@property (nonatomic) NSString *enc_id;
@property (nonatomic) NSURL *profile_image;
@property (nonatomic) NSString *age;
@property (nonatomic) NSString *gender;
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *birthday;

+ (instancetype)sharedInstance;

@end
