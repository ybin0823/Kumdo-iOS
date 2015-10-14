//
//  SNSLoginController.h
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 12..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NaverThirdPartyLoginConnection.h"
#import "NLoginThirdPartyOAuth20InAppBrowserViewController.h"

@interface SNSLoginViewController : UIViewController <NaverThirdPartyLoginConnectionDelegate>

@property (weak, nonatomic) IBOutlet UIButton *startButton;

@end
