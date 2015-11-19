//
//  YBCacheManager.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 11. 19..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "YBCacheManager.h"

@implementation YBCacheManager
{
    NSCache *cache;
}

@synthesize cache = cache;

+ (instancetype)sharedInstance
{
    static dispatch_once_t oncePredicate;
    static YBCacheManager *shared = nil;
    
    dispatch_once(&oncePredicate, ^{
        shared = [[self alloc] init];
    });
    
    return shared;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        cache = [[NSCache alloc] init];
        [cache setCountLimit:100];
    }
    
    return self;
}

@end
