//
//  WriteViewController.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 12..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "WriteViewController.h"
#import "YBUser.h"
#import "YBWriting.h"
#import "YBCategory.h"
#import "YBWordDictionary.h"

@interface WriteViewController ()

@end

@implementation WriteViewController
{
    __weak id<WriteViewControllerDelegate> delegate;
    
    __weak IBOutlet UIButton *takePictureButton;
    
    __weak IBOutlet UIButton *nounWordButton;
    __weak IBOutlet UIButton *verbWordButton;
    __weak IBOutlet UIButton *adjectiveOrAdverbWordButton;
    __weak IBOutlet UIButton *editButton;
    
    YBUser *user;
    YBWordDictionary *wordDictionary;
    YBWriting *writing;
    NSMutableSet *usedWords;
    
    UIScrollView *scrollView;
    UIImageView *imageView;
    YBFlowContentView *flowContentView;
}

@synthesize delegate = delegate;

static NSString * const UPLOAD_DATA_TO_SERVER = @"http://125.209.198.90:3000/upload";

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        user = [YBUser sharedInstance];
        wordDictionary = [[YBWordDictionary alloc] init];
        writing = [[YBWriting alloc] init];
        usedWords = [[NSMutableSet alloc] init];
        
        scrollView = [[UIScrollView alloc] init];
        
        NSLog(@"%@", [user description]);
    }
    
    return self;
}

#pragma mark - Override method

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 랜덤하게 불러온 글자로 word1, word2, word3의 텍스트를 변화해준다
    [nounWordButton setTitle:[wordDictionary randomNonunWord] forState:UIControlStateNormal];
    [verbWordButton setTitle:[wordDictionary randomVerbWord] forState:UIControlStateNormal];
    [adjectiveOrAdverbWordButton setTitle:[wordDictionary randomAdjectiveOrAdverbWord] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    wordDictionary = nil;
    flowContentView = nil;
}


#pragma mark - Button method

// Save 버튼을 클릭하면 Category를 선택하는 창이 나온 후 저장이 된다
- (IBAction)save:(id)sender
{
    NSLog(@"Save");
    [self setWriting];
    if (writing.sentence.length == 0) {
        [self displayEmptyContentWarningAlert];
        return;
    }
    [self displayCategorySelectAlert];
}

// Edit 버튼을 클릭하면 Image위에 UITextField가 생긴다
- (IBAction)addEdit:(id)sender
{
    [flowContentView addTextField];
}

// Word1, Word2, Word3 버튼을 클릭하면 Image위에 UILabel이 생긴다
- (IBAction)addWord:(id)sender
{
    if (flowContentView != NULL) {
        [usedWords addObject:[[sender titleLabel] text]];
        [flowContentView addLabelWithText:[[sender titleLabel] text]];
    }
}

- (IBAction)cancel:(id)sender
{
    [[self delegate] writeViewControllerDidCancel:self];
}


#pragma mark - Pick image

- (IBAction)showImagePickerForPhotoPicker:(id)sender
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    takePictureButton.hidden = YES;
    
    // Set ScrollView
    CGFloat width = self.view.frame.size.width;
    CGFloat height = image.size.height;
    CGFloat scale = width / image.size.width;
    
    [scrollView setFrame:CGRectMake(0, 80, width, 450)];
    [scrollView setContentSize:CGSizeMake(width, height * scale)];
    [self.view addSubview:scrollView];
    
    // Set ImageView
    if (width > height * scale) {
        // image 높이가 작을 경우 scrollView의 가운데 위치한다
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, scrollView.frame.size.height / 2 - (height * scale / 2), width, height * scale)];
    } else {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height * scale)];
    }

    [imageView setImage:image];
    [scrollView addSubview:imageView];

    
    // Set flowContentView
    // image를 선택하면, word와 edit버튼이 추가될 수 있도록 flowContentView를 생성한다.
    // 글자의 최대 길이는 200자 or 이미지 높이만큼 추가된다.
    if (flowContentView == NULL) {
        flowContentView = [[YBFlowContentView alloc] initWithFrame:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
        [flowContentView setMaxLength:200];
        [flowContentView setDelegate:self];
        [imageView addSubview:flowContentView];
    }
}

#pragma mark - Check of contents length

- (void)contentDidReachMaxLength
{
    [editButton setEnabled:NO];
    [nounWordButton setEnabled:NO];
    [verbWordButton setEnabled:NO];
    [adjectiveOrAdverbWordButton setEnabled:NO];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Max Length!"
                                                                             message:@"Content length is the max"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                         }];
    [alertController addAction:defaultAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - Set Writing

- (NSString *)makeSentenceFromSubViews
{
    if (flowContentView != NULL) {
        NSArray *subViews = [NSArray arrayWithArray:[flowContentView subviews]];
        NSMutableString *sentence = [[NSMutableString alloc] init];
        for (UIView *subView in subViews) {
            @autoreleasepool {
                if ([subView isKindOfClass:[UILabel class]]) {
                    UILabel *label = (UILabel *)subView;
                    [sentence appendString:label.text];
                    
                    // For add space between words
                    [sentence appendString:@" "];
                }
                
                if ([subView isKindOfClass:[UITextField class]]) {
                    UITextField *textField = (UITextField *)subView;
                    
                    if ([[textField text] length] == 0) {
                        continue;
                    }
                    
                    [sentence appendString:textField.text];
                    
                    // For add space between words
                    [sentence appendString:@" "];
                }
            }
        }
        return [NSString stringWithString:sentence];
    }
    
    return nil;
}

- (void)setWriting
{
    [writing setName:[user name]];
    [writing setEmail:[user email]];
    [writing setSentence:[self makeSentenceFromSubViews]];
    [writing setWords:[usedWords allObjects]];
}

#pragma mark - Alert

- (void)displayCategorySelectAlert
{
    YBCategory *categories = [[YBCategory alloc] init];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Category"
                                                                   message:@"Select your category"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (int i = 0; i < [categories count]; i++) {
        UIAlertAction *categoryAction = [UIAlertAction actionWithTitle:[categories.names objectAtIndex:i] style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action) {
                                                                   writing.category = i;
                                                                   NSLog(@"writing : %@", [writing description]);
                                                                   [self uploadData];
                                                               }];
        [alertController addAction:categoryAction];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {
                                                         }];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)displayEmptyContentWarningAlert
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Empty Sentence!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {

    }];
    [alertController addAction:defaultAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)uploadData
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:UPLOAD_DATA_TO_SERVER]];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = [NSString stringWithFormat:@"Boundary+%08X%08X", arc4random(), arc4random()];
    [request addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
    
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSData *imageData = UIImageJPEGRepresentation([imageView image], 1.0);
    
    NSData *data = [self createBodyWithBoundary:boundary name:writing.name email:writing.email sentence:writing.sentence words:[writing stringWithCommaFromWords] category:writing.category imageData:imageData];

    [defaultSession uploadTaskWithStreamedRequest:request];

    [[defaultSession uploadTaskWithRequest:request fromData:data completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@", response);
        if (error) {
            NSLog(@"%@", error);
        }
        
        NSLog(@"Save Success!");
        
        [self performSelectorOnMainThread:@selector(didFinishUpload:) withObject:nil waitUntilDone:NO];
    }] resume];
}

- (NSData *) createBodyWithBoundary:(NSString *)boundary name:(NSString*)name email:(NSString*)email sentence:(NSString *)sentence words:(NSString *)words category:(NSInteger)cateogry imageData:(NSData*)imageData
{
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"name\"\r\n\r\n%@\r\n", name] dataUsingEncoding:NSUTF8StringEncoding]];

    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"email\"\r\n\r\n%@\r\n", email] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"sentence\"\r\n\r\n%@\r\n", sentence] dataUsingEncoding:NSUTF8StringEncoding]];

    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"words\"\r\n\r\n%@\r\n", words] dataUsingEncoding:NSUTF8StringEncoding]];

    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"category\"\r\n\r\n%ld\r\n", (long)cateogry] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"date\"\r\n\r\n%f\r\n", [[NSDate date] timeIntervalSince1970] * 1000] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"%@.jpg\"\r\n", email] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:imageData];

    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return body;
}

- (void)didFinishUpload:(id)sender
{
    [self performSegueWithIdentifier:@"LoadMenu" sender:self];
}

@end
