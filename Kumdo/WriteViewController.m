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
    
    __weak IBOutlet UIImageView *backgroundImage;
    __weak IBOutlet UIButton *takePictureButton;
    __weak IBOutlet UIButton *changePictureButton;
    __weak IBOutlet UIButton *nounWordButton;
    __weak IBOutlet UIButton *verbWordButton;
    __weak IBOutlet UIButton *adjectiveOrAdverbWordButton;
    __weak IBOutlet UIButton *editButton;
    
    YBUser *user;
    YBWordDictionary *wordDictionary;
    YBFlowContentView *flowContentView;
    YBWriting *writing;
    NSMutableSet *usedWords;
}

@synthesize delegate = delegate;

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        user = [YBUser sharedInstance];
        wordDictionary = [[YBWordDictionary alloc] init];
        writing = [[YBWriting alloc] init];
        usedWords = [[NSMutableSet alloc] init];
        
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
    [backgroundImage setImage:image];
    takePictureButton.hidden = YES;
    changePictureButton.hidden = NO;
    
    // image를 선택하면, word와 edit버튼이 추가될 수 있도록 flowContentView를 생성한다.
    // 글자의 최대 길이는 200자
    // TODO method 분리. (적절한 메소드명이 떠오르지 않음)
    if (flowContentView == NULL) {
        flowContentView = [[YBFlowContentView alloc] initWithFrame:CGRectMake(0, 80, backgroundImage.frame.size.width, backgroundImage.frame.size.height)];
        [flowContentView setMaxLength:200];
        [flowContentView setDelegate:self];
        [self.view addSubview:flowContentView];
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
                    [sentence appendString:@" "];
                }
                
                if ([subView isKindOfClass:[UITextField class]]) {
                    UITextField *textField = (UITextField *)subView;
                    [sentence appendString:textField.text];
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
    [writing setDate:[NSDate date]];
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

@end
