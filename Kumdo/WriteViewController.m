//
//  WriteViewController.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 12..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "WriteViewController.h"
#import "User.h"
#import "Writing.h"
#import "YBCategory.h"
#import "WordDictionary.h"
#import "FlowContentViewController.h"

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
    
    User *user;
    WordDictionary *wordDictionary;
    FlowContentViewController *flowContentViewController;
    Writing *writing;
    NSMutableSet *usedWords;
}

@synthesize delegate = delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    user = [User sharedInstance];
    wordDictionary = [[WordDictionary alloc] init];
    writing = [[Writing alloc] init];
    usedWords = [[NSMutableSet alloc] init];
    
    NSLog(@"%@", [user description]);
    
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
    flowContentViewController = nil;
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
    [flowContentViewController addTextField];
}

// Word1, Word2, Word3 버튼을 클릭하면 Image위에 UILabel이 생긴다
- (IBAction)addWord:(id)sender
{
    if (flowContentViewController != NULL) {
        [usedWords addObject:[[sender titleLabel] text]];
        [flowContentViewController addLabelWithText:[[sender titleLabel] text]];
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
    
    // image를 선택하면, word와 edit버튼이 추가될 수 있도록 flowContentViewController를 생성한다
    // TODO method 분리. (적절한 메소드명이 떠오르지 않음)
    if (flowContentViewController == NULL) {
        flowContentViewController = [[FlowContentViewController alloc] initWithFrame:CGRectMake(0, 80, backgroundImage.frame.size.width, backgroundImage.frame.size.height)];
        [self addChildViewController:flowContentViewController];
        [self.view addSubview:flowContentViewController.view];
        [flowContentViewController didMoveToParentViewController:self];
    }
}

- (NSString *)makeSentenceFromSubViews
{
    if (flowContentViewController != NULL) {
        NSArray *subViews = [NSArray arrayWithArray:[flowContentViewController.view subviews]];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
