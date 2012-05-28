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

#import "MyPhotoPickerPhotoSelectionViewController.h"

#define PHOTO_SIZE CGSizeMake(75,75)
#define PHOTO_ROW_COL_OFFSET 4
#define PHOTO_NUMBER_OF_PHOTOS_PER_ROW 6

@interface MyPhotoPickerPhotoSelectionViewController ()

// load photos based on scroll view offset 
-(void)loadPhotosBasedOnScrollViewOffset;

// action triggered when photo button is pressed
-(void)photoButtonAction:(id)sender;

@end

@implementation MyPhotoPickerPhotoSelectionViewController

@synthesize scrollView;
@synthesize assetsGroup;
@synthesize passInfo;
@synthesize activity;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    screenSize = [[UIScreen mainScreen] size];
    self.title = [NSString stringWithFormat:NSLocalizedString(@"Album - %@", nil), [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName]]; 
    
    [self.scrollView setScrollEnabled:NO];
    [self.activity startAnimating];
    
    assets = [[NSMutableArray alloc] init];
    library = [[ALAssetsLibrary alloc] init];
    
    void (^assetEnumerator)(ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if(result == NULL){
            [assets reverse];
            [self.activity stopAnimating];
            [self.scrollView setScrollEnabled:YES];
            int numRows = (assets.count / PHOTO_NUMBER_OF_PHOTOS_PER_ROW);
            if(assets.count % PHOTO_NUMBER_OF_PHOTOS_PER_ROW != 0)
                numRows++;

            self.scrollView.contentSize = CGSizeMake(screenSize.width, (numRows*PHOTO_ROW_COL_OFFSET + numRows + PHOTO_ROW_COL_OFFSET) + (numRows*PHOTO_SIZE.height));
            [self loadPhotosBasedOnScrollViewOffset];
            return;
        }
        
        [assets addObject:result];
    };
    
    
    void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) =  ^(ALAssetsGroup *group, BOOL *stop) {
        if(group){
            NSString *groupId = [group valueForProperty:ALAssetsGroupPropertyPersistentID];
            NSString *myGroupId = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyPersistentID];
            // found matching album
            if([groupId isEqualToString:myGroupId]){ 
                [group enumerateAssetsUsingBlock:assetEnumerator];
            }
        }
    };
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAll
                           usingBlock:assetGroupEnumerator
                         failureBlock: ^(NSError *error) {
                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"AppName", nil)
                                                                                 message:[NSString stringWithFormat:NSLocalizedString(@"%@ doesn't have permission to access photos from your photo album. You can give these permissions in Settings App.", nil), NSLocalizedString(@"AppName", nil)] 
                                                                                delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil];
                             alertView.delegate = self;
                             [alertView show];
                             [alertView release];
                             
                             DebugLog(@"Failure retreiving photos from album.");
                             
                         }];
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

-(void)loadPhotosBasedOnScrollViewOffset{
    CGSize photoSize = PHOTO_SIZE;
    int xOffset = PHOTO_ROW_COL_OFFSET + 1;
    int yOffset = PHOTO_ROW_COL_OFFSET + 1;
    
    for(int i = 0; i < assets.count; ++i){
        PhotoButton *button = [[[PhotoButton alloc] initWithAsset:[assets objectAtIndex:i]] autorelease];
        [button addTarget:self action:@selector(photoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        button.frame = CGRectMake(xOffset, yOffset, photoSize.width, photoSize.height);
        xOffset +=PHOTO_ROW_COL_OFFSET + photoSize.width;
        
        if((i+1) % PHOTO_NUMBER_OF_PHOTOS_PER_ROW == 0){
            yOffset += PHOTO_ROW_COL_OFFSET + 1 + photoSize.height;
            xOffset = PHOTO_ROW_COL_OFFSET + 1;
        }
        
        [self.scrollView addSubview:button];
    }
}

-(void)photoButtonAction:(id)sender{
    PhotoButton *button = (PhotoButton*)sender;

    ALAssetRepresentation * defaultRpresentation = [button.asset defaultRepresentation];
    ALAssetOrientation orientation = defaultRpresentation.orientation;

    UIImage *image = [UIImage imageWithCGImage:defaultRpresentation.fullScreenImage scale:1.0 orientation:orientation];
    
    Photo* photo = [CoreDataUtils createNewPhotoEntry];
    photo.photoData = UIImagePNGRepresentation(image);
    photo.photoThumbnail = UIImagePNGRepresentation([Utils imageByScalingAndCroppingForSize:[UIImage imageWithData:photo.photoData] toTargetSize:CGSizeMake(35, 35)]);
    self.passInfo.owner.photo = photo;
    
    [self.navigationController dismissModalViewControllerAnimated:YES];   
}

- (void)dealloc
{
    [assets release];
    [library release];
    self.scrollView = nil;
    self.assetsGroup = nil;
    self.activity = nil;
    [super dealloc];
}

@end
