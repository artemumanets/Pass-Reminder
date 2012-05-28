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

#import "PhotoSelectorViewController.h"

@interface PhotoSelectorViewController ()

-(void)actionEdit:(id)selector;

@end

@implementation PhotoSelectorViewController

@synthesize tableView;
@synthesize resultsController;
@synthesize passInfo;
@synthesize selectedCell;
@synthesize editButton, doneButton;
@synthesize labelRemovalNotification;

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
    
    // add edti button
    self.editButton  = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(actionEdit:)] autorelease];
    self.doneButton  = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionEdit:)] autorelease];
    self.labelRemovalNotification.text = @"";
    
    self.tableView.layer.masksToBounds = YES;
    self.tableView.layer.cornerRadius = 10;
    

    NSFetchedResultsController *fetchResultsController = [CoreDataUtils photosFetchResult];
    fetchResultsController.delegate = self;
    
    NSError *error;
    BOOL success = [fetchResultsController performFetch: &error];
    if(!success){
        // Handle the error
        DebugLog(@"Error ocurred fetching transportation types.");
    }
    self.resultsController = fetchResultsController;
    [self.tableView reloadData];
    
    // add button if there is more then 1 photo
    if(self.resultsController.fetchedObjects.count > 1)
        self.navigationItem.rightBarButtonItem = editButton;
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

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    if (!self.tableView.editing){ 
        [self.tableView reloadData];
    }
}

#pragma UITableViewCell
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // return number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.resultsController fetchedObjects] count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if(self.selectedCell){
        // remove checkmark of previously selected cell
        self.selectedCell.accessoryType = UITableViewCellAccessoryNone;    
    }
    
    self.selectedCell = cell;
    
    // add checkamrk indicator to selected cell 
    self.selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // update transport type
    self.passInfo.owner.photo = [self.resultsController objectAtIndexPath:indexPath];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.imageView.layer.masksToBounds = YES;
        cell.imageView.layer.cornerRadius = 5;
    }
    
    // Configure the cell...
    Photo *photo = [self.resultsController objectAtIndexPath:indexPath];
    
    int photoCount = photo.owner.count;
    if(photo == self.passInfo.owner.photo){
        photoCount--;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.selectedCell = cell;
    }
    
    NSString *usedStr = [NSString stringWithFormat:NSLocalizedString(@"Used in %d %@", nil) , photoCount, (photoCount == 1 ? NSLocalizedString(@"pass", nil) : NSLocalizedString(@"passes", nil)) ];
    cell.textLabel.text = usedStr;
    
    // set user photo
    UIImage *photoData = [UIImage imageWithData:photo.photoThumbnail];
    
    cell.imageView.image = photoData;
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Photo* photoToDelete = [self.resultsController objectAtIndexPath:indexPath];
        Photo *defaultPhoto = [CoreDataUtils defaultPhoto];
        
        // apply default photo to passes which are using photo that is being removed
        // workaround beacuse collection cannot be updated while is iterated
        NSMutableArray *ownerPhotosToUpdate = [NSMutableArray array];
        for (Owner *owner in photoToDelete.owner) {
            [ownerPhotosToUpdate addObject:owner];
        }
        
        for(int i = 0; i < ownerPhotosToUpdate.count; ++i){
            Owner *owner = [ownerPhotosToUpdate objectAtIndex:i];
            owner.photo = defaultPhoto;
        }
        
        [CoreDataUtils removeFromStorage:photoToDelete];
        [CoreDataUtils saveCoreData];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        // update status of first cell to not be editable
        UITableViewCell *firstCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        firstCell.editing = NO;
    }
}

-(void)actionEdit:(id)selector{
    if(!self.tableView.isEditing){
        // enable edit mode
        [self.tableView setEditing:YES animated:YES];
        self.navigationItem.rightBarButtonItem = self.doneButton;
        self.labelRemovalNotification.text = NSLocalizedString(@"If photo to be removed is in use by some pass, it will be replaced with default photo.", nil);
        UITableViewCell *firstCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        firstCell.editing = NO;       
    }else{
        // disable edit mode
        [self.tableView setEditing:NO animated:YES];
        self.navigationItem.rightBarButtonItem = self.editButton;
        self.labelRemovalNotification.text = @""; 
    }
}

- (void)dealloc
{
    self.tableView = nil;
    self.resultsController = nil;
    self.passInfo = nil;
    self.selectedCell = nil;
    self.doneButton = nil;
    self.editButton = nil;
    self.labelRemovalNotification = nil;
    [super dealloc];
}

@end
