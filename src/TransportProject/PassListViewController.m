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

#import "PassListViewController.h"
#import "PassAddEditViewController.h"
@interface PassListViewController ()

// perform update of order indexes in each pass and correspondatly updates currentOrder in settings.
-(void)updateOrderIndexes:(NSMutableArray*)passes;
@end

@implementation PassListViewController

@synthesize delegate = _delegate;
@synthesize navController;
@synthesize resultsController;
@synthesize tableView;
@synthesize settings;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Pass Notifier", nil);
        
        UIBarButtonItem *doneButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)] autorelease];
        UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)] autorelease];
    
        self.navigationItem.rightBarButtonItem = doneButton;
        self.navigationItem.leftBarButtonItem = addButton;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.resultsController = [CoreDataUtils passFetchResults];
    self.resultsController.delegate = self;
    
    NSError *error;
    BOOL success = [self.resultsController performFetch: &error];
    if(!success){
        // Handle the error
        DebugLog(@"Error ocurred fetching passes types.");
    }
    [self.tableView reloadData];
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    // load settings
    self.settings = [CoreDataUtils settings];
    
    // enable tableView editing mode
    [self.tableView setEditing:YES animated:YES];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return !UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma UITableView

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    if (!self.tableView.editing){ 
        [self.tableView reloadData];
    }
    
}

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
    // get selected pass
    Pass *selectedPass = [self.resultsController objectAtIndexPath:indexPath];
    
    PassAddEditViewController *passEdit = [[PassAddEditViewController alloc] initWithNibName:@"PassAddEditViewController" bundle:nil];
    UINavigationController *navigatioController = [[UINavigationController alloc] initWithRootViewController:passEdit];
    passEdit.pass = selectedPass;
    [self.navController presentModalViewController:navigatioController animated:YES];
    [passEdit release];
    [navigatioController release];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    NSMutableArray *things = [[self.resultsController fetchedObjects] mutableCopy];
    
    // Grab the item we're moving.
    NSManagedObject *thing = [self.resultsController objectAtIndexPath:sourceIndexPath];
    
    // Remove the object we're moving from the array.
    [things removeObject:thing];
    // Now re-insert it at the destination.
    [things insertObject:thing atIndex:[destinationIndexPath row]];
    
    // All of the objects are now in their correct order. Update each
    // object's displayOrder field by iterating through the array.
    [self updateOrderIndexes:things];
    
    [things release], things = nil;
    
    // save context
    [CoreDataUtils saveCoreData];
}

-(void)updateOrderIndexes:(NSMutableArray*)passes{
    // reset setttings value in case that selected pass is removed

    NSNumber *newSelectedOrder = [NSNumber numberWithInt:0];
    int i = 0;
    for (Pass *pass in passes)
    {
        // update current selected index on settings with update value
        // if required
        NSNumber * newOrder = [NSNumber numberWithInt:i++];
        if([pass.order isEqualToNumber:self.settings.selectedPassOrder]){
            newSelectedOrder = newOrder;
        }
        pass.order = newOrder;
    }
    self.settings.selectedPassOrder = newSelectedOrder;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    // Configure the cell...
    Pass *pass = [self.resultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = pass.company;
    cell.detailTextLabel.text = pass.owner.name;
    
    // set transport icon
    NSString *transpIconPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@-small",pass.transportType.desc] ofType:@"png"];
    UIImage *transpIcon = [[[UIImage alloc] initWithContentsOfFile:transpIconPath] autorelease];
    cell.imageView.image = transpIcon;
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Pass* passToDelete = [self.resultsController objectAtIndexPath:indexPath];
        // unregister notification if there is any
        [Utils unregisterNotificationWithId:passToDelete.passId];
        
        // remove pass from core data storage
        [CoreDataUtils removeFromStorage:passToDelete];
        [CoreDataUtils saveCoreData];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        // update order of each elements to be consistent after removeall
        NSMutableArray *things = [[self.resultsController fetchedObjects] mutableCopy];
        [self updateOrderIndexes:things];
        [things release];
    }
}

#pragma mark - Actions

- (void)done:(id)sender
{
    [self.delegate passListViewControllerDidFinish:self];
}

- (void)add:(id)sender{
    PassAddEditViewController *passAdd = [[PassAddEditViewController alloc] initWithNibName:@"PassAddEditViewController" bundle:nil];
    UINavigationController *navigatioController = [[UINavigationController alloc] initWithRootViewController:passAdd];
    [self.navController presentModalViewController:navigatioController animated:YES];
    [passAdd release];
    [navigatioController release];
}

- (void)dealloc
{
    self.settings = nil;
    self.resultsController = nil;
    self.tableView = nil;
    self.navController = nil;
    [super dealloc];
}



@end
