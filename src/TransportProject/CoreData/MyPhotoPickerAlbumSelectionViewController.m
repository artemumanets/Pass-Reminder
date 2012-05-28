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

#import "MyPhotoPickerAlbumSelectionViewController.h"

@interface MyPhotoPickerAlbumSelectionViewController ()

// action execute when done button is pressed
-(void)actionDone:(id)selector;

@end

@implementation MyPhotoPickerAlbumSelectionViewController

@synthesize tableView;
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
    [self.activity startAnimating];
    [self.tableView setScrollEnabled:NO];
    UIBarButtonItem * doneButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionDone:)] autorelease];
    self.navigationItem.rightBarButtonItem = doneButton;
   
    groups = [[NSMutableArray alloc] init];
    library = [[ALAssetsLibrary alloc] init];

    void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) =  ^(ALAssetsGroup *group, BOOL *stop) {
        if(group == nil) {
            DebugLog(@"Finished loading all albuns");
            // reverse array
            [groups reverse];
            [self.activity stopAnimating];
            [self.tableView setScrollEnabled:YES];
            [self.tableView reloadData];
            return;
        }
        [groups addObject:group];
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [groups count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }

	/*ALAsset *asset = [assets objectAtIndex:indexPath.row];
    [assets value
	[cell.imageView setImage:[UIImage imageWithCGImage:[asset thumbnail]]];
	[cell.textLabel setText:[NSString stringWithFormat:assets.]];*/
    ALAssetsGroup *assetGroup = [groups objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageWithCGImage:[assetGroup posterImage]];
    cell.textLabel.text = [assetGroup valueForProperty:ALAssetsGroupPropertyName];
    cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"(%d) Photos", nil), assetGroup.numberOfAssets];
                            
    if(assetGroup.numberOfAssets > 0){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // TODO: if has assets, redirect to photo selection screen
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ALAssetsGroup *assetGroup = [groups objectAtIndex:indexPath.row];
    if(assetGroup.numberOfAssets > 0){
        // load view with photos
        MyPhotoPickerPhotoSelectionViewController * photoSelectionVC = [[MyPhotoPickerPhotoSelectionViewController alloc] init];
        photoSelectionVC.assetsGroup = assetGroup;
        photoSelectionVC.passInfo = self.passInfo;
        [self.navigationController pushViewController:photoSelectionVC animated:YES];
        [photoSelectionVC release];
    }
        
}
    
-(void)actionDone:(id)selector{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return !UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)dealloc
{
    [library release];
    [groups release];
    self.activity = nil;
    self.tableView = nil;
    [super dealloc];
}

@end
