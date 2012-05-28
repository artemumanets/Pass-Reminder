/*
 
 Copyright (c) 2012 Artem Umanets. The MIT License 
 
 Permission is hereby granted, free of charge, to any person obtaining a copy 
 of this software and associated documentation files (the "Software"), to deal 
 in the Software without restriction, including without limitation the rights 
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
 of the Software, and to permit persons to whom the Software is furnished to do so, 
 subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all 
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
 INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
 PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
 LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE 
 OR OTHER DEALINGS IN THE SOFTWARE.
 
 More info: http://www.opensource.org/licenses/MIT
 
 */

#import "UserPhotoViewControllerViewController.h"

@interface UserPhotoViewControllerViewController ()

-(void)photoAction:(id)sender;

// show existent photos
-(void)loadExistenPhotoView;

// allow user to pick photos from album
-(void)loadPhotosFromAlbum;

@end

@implementation UserPhotoViewControllerViewController

@synthesize passInfo;
@synthesize userPhoto;
@synthesize labelName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *cameraButton  = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(photoAction:)] autorelease];
    self.navigationItem.rightBarButtonItem = cameraButton;
    
    self.labelName.text = self.passInfo.owner.name;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.userPhoto.image = [UIImage imageWithData:self.passInfo.owner.photo.photoData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return !UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];

    if(hasCamera){
        if(buttonIndex == 0){
            DebugLog(@"->User wants to take new picture");
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentModalViewController:picker animated:YES];
            return;
        }else if(buttonIndex == 1){
            DebugLog(@"->User wants to choose picture from library.");
            [self loadPhotosFromAlbum];
            return;
        }else if(buttonIndex == 2){
            DebugLog(@"->User wants to choose picture existing photos.");
            [self loadExistenPhotoView];
            return;
        }
        // otherwise, cancel button was pressed, do nothing!
    }else {
        if(buttonIndex == 0){
            DebugLog(@"->User wants to choose picture from library.");
            [self loadPhotosFromAlbum];
            return;
        }else if(buttonIndex == 1){
            DebugLog(@"->User wants to choose picture existing photos.");
            [self loadExistenPhotoView];
            return;
        }
        // otherwise, cancel button was pressed, do nothing!
    }
}

-(void)loadExistenPhotoView{
    PhotoSelectorViewController *photoSelectorView = [[PhotoSelectorViewController alloc] init];
    photoSelectorView.title = NSLocalizedString(@"Local photo", nil);
    photoSelectorView.passInfo = self.passInfo;
    [self.navigationController pushViewController:photoSelectorView animated:YES];
    [photoSelectorView release];
}

-(void)loadPhotosFromAlbum{
    MyPhotoPickerAlbumSelectionViewController *photoPicker = [[MyPhotoPickerAlbumSelectionViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc ] initWithRootViewController:photoPicker];
    navController.navigationBar.barStyle = UIBarStyleBlack;
    
    photoPicker.title = NSLocalizedString(@"Photo Albums", nil);
    photoPicker.passInfo = self.passInfo;
    
    [self presentModalViewController:navController animated:YES];
    [photoPicker release];
    [navController release];
}


// once image is choosen, this method gets called
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    NSData *imageData = UIImagePNGRepresentation(image);

    Photo* photo = [CoreDataUtils createNewPhotoEntry];
    photo.photoData = imageData;
    photo.photoThumbnail = UIImagePNGRepresentation([Utils imageByScalingAndCroppingForSize:image toTargetSize:CGSizeMake(35, 35)]);
    
    self.userPhoto.image = [UIImage imageWithData:self.passInfo.owner.photo.photoData];
    self.passInfo.owner.photo = photo;
    self.userPhoto.image = [UIImage imageWithData:self.passInfo.owner.photo.photoData];
    [self dismissModalViewControllerAnimated:YES];
    [picker release];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissModalViewControllerAnimated:YES];
    [picker release];
}

-(void)photoAction:(id)sender{
    DebugLog(@"Taking Picture");
    
    NSString *title = NSLocalizedString(@"Select Owner's Photo", nil);
    NSString *takeNewPhoto = NSLocalizedString(@"Take new photo", nil);
    NSString *chooseFromAlbum = NSLocalizedString(@"Choose photo from album", nil);
    NSString *chooseExisting = NSLocalizedString(@"Choose photo from local library", nil);
    
    BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    UIActionSheet *photoSourceSheet;
    if(hasCamera){
        photoSourceSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) 
                                             destructiveButtonTitle:nil otherButtonTitles:takeNewPhoto, chooseFromAlbum, chooseExisting, nil];
    }
    else {
        photoSourceSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) 
                                             destructiveButtonTitle:nil otherButtonTitles:chooseFromAlbum, chooseExisting, nil];
    }
    
    [photoSourceSheet showFromToolbar:self.navigationController.toolbar];
    [photoSourceSheet release];
}

- (void)dealloc
{
    self.labelName = nil;
    self.userPhoto = nil;
    [super dealloc];
}
@end
