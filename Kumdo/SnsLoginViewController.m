//
//  SNSLoginController.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 12..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "SnsLoginViewController.h"
#import "MenuViewController.h"
#import "User.h"

@interface SnsLoginViewController ()

@end

@implementation SnsLoginViewController
{
    NaverThirdPartyLoginConnection *_thirdPartyLoginConn;
    User *user;
    NSString *currentString;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        _thirdPartyLoginConn = [NaverThirdPartyLoginConnection getSharedInstance];
        _thirdPartyLoginConn.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Naver Login API를 활용해서 로그인을 한다
    [[NaverThirdPartyLoginConnection getSharedInstance] setIsNaverAppOauthEnable:YES];
    [[NaverThirdPartyLoginConnection getSharedInstance] setIsInAppOauthEnable:YES];
    
    // 로그인하여 받아온 유저 정보를 NSLog로 출력한다
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    [super shouldPerformSegueWithIdentifier:identifier sender:sender];
    
    if (YES == [_thirdPartyLoginConn isValidAccessTokenExpireTimeNow]) {
        [self requestUserProfile];
        return YES;
    }
    
    [self requestThirdPartyLogin];
    return NO;
}

- (void)requestThirdPartyLogin
{
    // NaverThirdPartyLoginConnection의 인스턴스에 서비스앱의 url scheme와 consumer key, consumer secret, 그리고 appName을 파라미터로 전달하여 3rd party OAuth 인증을 요청한다.
    NSLog(@"requestThirdPartyLogin");
    NaverThirdPartyLoginConnection *tlogin = [NaverThirdPartyLoginConnection getSharedInstance];
    [tlogin setConsumerKey:kConsumerKey];
    [tlogin setConsumerSecret:kConsumerSecret];
    [tlogin setAppName:kServiceAppName];
    [tlogin setServiceUrlScheme:kServiceAppUrlScheme];
    [tlogin requestThirdPartyLogin];
}

- (IBAction)didClickLoginBtn:(id)sender
{
    if (YES == [_thirdPartyLoginConn isValidAccessTokenExpireTimeNow]) {
        [self requestUserProfile];
        return;
    }

    [self requestThirdPartyLogin];
}

- (void)requestUserProfile
{
    // 사용자 프로필 호출
    NSString *urlString = @"https://openapi.naver.com/v1/nid/getUserProfile.xml";
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSString *authValue = [NSString stringWithFormat:@"Bearer %@", _thirdPartyLoginConn.accessToken];
    
    [urlRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *receivedData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    
    if (error) {
        NSLog(@"Error happened - %@", [error description]);
    } else {
        BOOL success;
        NSXMLParser *userParser = [[NSXMLParser alloc] initWithData:receivedData];
        [userParser setDelegate:self];
        [userParser setShouldResolveExternalEntities:YES];
        success = [userParser parse];
        
        if (success) {
            NSLog(@"user : %@, %@, %@, %@, %@, %@", user.email, user.nickname, user.name, user.birthday, user.age, user.gender);
        }
    }
}

#pragma mark - XML parser delegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict
{
    if ([elementName isEqualToString:@"response"]) {
        if (!user) {
            user = [[User alloc] init];
            return;
        }
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (!currentString) {
        currentString = [[NSString alloc] initWithString:string];
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"resultcode"]) {
        currentString = nil;
    } else if([elementName isEqualToString:@"message"]) {
        currentString = nil;
    } else if ([elementName isEqualToString:@"email"]) {
        [user setEmail:currentString];
        currentString = nil;
    } else if ([elementName isEqualToString:@"nickname"]) {
        [user setNickname:currentString];
        currentString = nil;
    } else if ([elementName isEqualToString:@"enc_id"]) {
        [user setEnc_id:currentString];
    } else if ([elementName isEqualToString:@"profile_image"]) {
        [user setProfile_image:[NSURL URLWithString:currentString]];
        currentString = nil;
    } else if ([elementName isEqualToString:@"age"]) {
        [user setAge:currentString];
        currentString = nil;
    } else if ([elementName isEqualToString:@"gender"]) {
        [user setGender:currentString];
        currentString = nil;
    } else if ([elementName isEqualToString:@"id"]) {
        [user setUserId:currentString];
        currentString = nil;
    } else if ([elementName isEqualToString:@"name"]) {
        [user setName:currentString];
        currentString = nil;
    } else if ([elementName isEqualToString:@"birthday"]) {
        [user setBirthday:currentString];
        currentString = nil;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - SampleOAuthConnectionDelegate
- (void) presentWebviewControllerWithRequest:(NSURLRequest *)urlRequest   {
    // FormSheet모달위에 FullScreen모달이 뜰 떄 애니메이션이 이상하게 동작하여 애니메이션이 없도록 함
    
    NLoginThirdPartyOAuth20InAppBrowserViewController *inAppBrowserViewController = [[NLoginThirdPartyOAuth20InAppBrowserViewController alloc] initWithRequest:urlRequest];
    inAppBrowserViewController.parentOrientation = (UIInterfaceOrientation)[[UIDevice currentDevice] orientation];
    [self presentViewController:inAppBrowserViewController animated:NO completion:nil];
}

#pragma mark - OAuth20 deleagate

- (void)oauth20ConnectionDidOpenInAppBrowserForOAuth:(NSURLRequest *)request {
    [self presentWebviewControllerWithRequest:request];
}

- (void)oauth20Connection:(NaverThirdPartyLoginConnection *)oauthConnection didFailWithError:(NSError *)error {
    NSLog(@"%s=[%@]", __FUNCTION__, error);
}

- (void)oauth20ConnectionDidFinishRequestACTokenWithAuthCode {
   NSLog(@"OAuth Success!");
    [self requestUserProfile];
    [self performSegueWithIdentifier:@"Start" sender:nil];
}

- (void)oauth20ConnectionDidFinishRequestACTokenWithRefreshToken {
    NSLog(@"Refresh Success!");
    [self requestUserProfile];
    [self performSegueWithIdentifier:@"Start" sender:nil];
}
- (void)oauth20ConnectionDidFinishDeleteToken {
    NSLog(@"로그아웃 완료");
}

@end
