//
//  WriteViewController.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 12..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "WriteViewController.h"
#import "User.h"
#import "WordDictionary.h"

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
}

@synthesize delegate = delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    user = [User sharedInstance];
    wordDictionary = [[WordDictionary alloc] init];
    
    NSLog(@"%@", [user description]);
    
    // 랜덤하게 불러온 글자로 word1, word2, word3의 텍스트를 변화해준다
    [nounWordButton setTitle:[wordDictionary randomNonunWord] forState:UIControlStateNormal];
    [verbWordButton setTitle:[wordDictionary randomVerbWord] forState:UIControlStateNormal];
    [adjectiveOrAdverbWordButton setTitle:[wordDictionary randomAdjectiveOrAdverbWord] forState:UIControlStateNormal];
    
    // Edit 버튼을 클릭하면 Image위에 Text Field가 생긴다
    
    // Word1, Word2, Word3 버튼을 클릭하면 Image위에 Text View가 생긴다
    
    // Save 버튼을 클릭하면 Category를 선택하는 창이 나온 후 저장이 된다
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    wordDictionary = nil;
}

- (IBAction)save:(id)sender
{
    NSLog(@"Save");
}

- (IBAction)addEdit:(id)sender
{
    NSLog(@"Edit");
}

- (IBAction)addWord:(id)sender
{
    NSLog(@"Word : %@", [[sender titleLabel] text]);
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
