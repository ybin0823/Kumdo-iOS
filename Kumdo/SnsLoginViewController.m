//
//  SNSLoginController.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 12..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "SnsLoginViewController.h"
#import "MenuViewController.h"
#import "YBUser.h"

@interface SnsLoginViewController ()

@end

@implementation SnsLoginViewController
{
    NaverThirdPartyLoginConnection *thirdPartyLoginConn;
    YBUser *user;
    NSString *currentString;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        thirdPartyLoginConn = [NaverThirdPartyLoginConnection getSharedInstance];
        thirdPartyLoginConn.delegate = self;
    }
    return self;
}


#pragma mark - Override method

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Naver Login API를 활용해서 로그인을 한다
    [[NaverThirdPartyLoginConnection getSharedInstance] setIsNaverAppOauthEnable:YES];
    [[NaverThirdPartyLoginConnection getSharedInstance] setIsInAppOauthEnable:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    [super shouldPerformSegueWithIdentifier:identifier sender:sender];
    
    if (YES == [thirdPartyLoginConn isValidAccessTokenExpireTimeNow]) {
        [self requestUserProfile];
        return YES;
    }
    
    [self requestThirdPartyLogin];
    return NO;
}


#pragma mark - ThirdPartyLogin using Naver Login

- (void)requestThirdPartyLogin
{
    // NaverThirdPartyLoginConnection의 인스턴스에 서비스앱의 url scheme와 consumer key, consumer secret, 그리고 appName을 파라미터로 전달하여 3rd party OAuth 인증을 요청한다.
    NaverThirdPartyLoginConnection *tlogin = [NaverThirdPartyLoginConnection getSharedInstance];
    [tlogin setConsumerKey:kConsumerKey];
    [tlogin setConsumerSecret:kConsumerSecret];
    [tlogin setAppName:kServiceAppName];
    [tlogin setServiceUrlScheme:kServiceAppUrlScheme];
    
    [tlogin requestThirdPartyLogin];
}


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


#pragma mark - Request user profile and parse

- (void)requestUserProfile
{
    NSString *urlString = @"https://openapi.naver.com/v1/nid/getUserProfile.xml";
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSString *authValue = [NSString stringWithFormat:@"Bearer %@", thirdPartyLoginConn.accessToken];
    
    [urlRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *receivedData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    
    if (error) {
        NSLog(@"Error happened - %@", [error description]);
    } else {
        [self userProfileParse:receivedData];
    }
}

- (void)userProfileParse:(NSData *)data
{
    NSXMLParser *userParser = [[NSXMLParser alloc] initWithData:data];
    [userParser setDelegate:self];
    [userParser setShouldResolveExternalEntities:YES];
    
    if ([userParser parse]) {
        NSLog(@"%@", [user description]);
    }
}


#pragma mark - XML parser delegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict
{
    if ([elementName isEqualToString:@"response"]) {
        user = [YBUser sharedInstance];
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

@end
