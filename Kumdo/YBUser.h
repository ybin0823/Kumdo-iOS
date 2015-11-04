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
@property NSString *email;
@property NSString *nickname;
@property NSString *enc_id;
@property NSURL *profile_image;
@property NSString *age;
@property NSString *gender;
@property NSString *userId;
@property NSString *name;
@property NSString *birthday;

+ (instancetype)sharedInstance;

@end
