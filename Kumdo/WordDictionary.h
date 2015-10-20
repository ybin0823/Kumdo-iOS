//
//  Word.h
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 20..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WordDictionary : NSObject

- (NSString *)randomNonunWord;
- (NSString *)randomVerbWord;
- (NSString *)randomAdjectiveOrAdverbWord;

@end
