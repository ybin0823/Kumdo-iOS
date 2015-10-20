//
//  WriteViewController.m
//  Kumdo
//
//  Created by Jang Young bin on 2015. 10. 12..
//  Copyright © 2015년 Jang Young bin. All rights reserved.
//

#import "WriteViewController.h"
#import "User.h"

@interface WriteViewController ()

@end

@implementation WriteViewController
{
    __weak id<WriteViewControllerDelegate> delegate;
    __weak IBOutlet UIImageView *backgroundImage;
    __weak IBOutlet UIButton *takePictureButton;
    __weak IBOutlet UIButton *changePictureButton;
    User *user;
}

@synthesize delegate = delegate;
@synthesize backgroundImage = backgroundImage;
@synthesize takePictureButton = takePictureButton;
@synthesize changePictureButton = changePictureButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    user = [User sharedInstance];
    
    NSLog(@"%@", [user description]);
    
    // 랜덤하게 불러온 글자로 word1, word2, word3의 텍스트를 변화해준다
    
    // image를 클릭하면 Gallery App으로부터 Image를 가져온다
    
    // Edit 버튼을 클릭하면 Image위에 Text Field가 생긴다
    
    // Word1, Word2, Word3 버튼을 클릭하면 Image위에 Text View가 생긴다
    
    // Save 버튼을 클릭하면 Category를 선택하는 창이 나온 후 저장이 된다
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [[self backgroundImage] setImage:image];
    self.takePictureButton.hidden = YES;
    self.changePictureButton.hidden = NO;
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
