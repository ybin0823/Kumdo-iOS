//
//  YBCacheManager.h
//  Kumdo
//
//  Created by Jang Young bin on 2015. 11. 19..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBCacheManager : NSObject

@property (nonatomic) NSCache *cache;

+ (instancetype)sharedInstance;

@end
