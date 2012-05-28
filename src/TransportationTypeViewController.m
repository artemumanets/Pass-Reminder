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

#import "TransportationTypeViewController.h"

@interface TransportationTypeViewController ()

@end

@implementation TransportationTypeViewController

@synthesize tableView;
@synthesize resultsController;
@synthesize selectedCell;
@synthesize currentTransportPass;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title = NSLocalizedString(@"Transportation type", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.resultsController != nil)
        return;
    
    NSFetchedResultsController *fetchResultsController = [CoreDataUtils transportationTypesFetchResults];
    fetchResultsController.delegate = self;
    
    NSError *error;
    BOOL success = [fetchResultsController performFetch: &error];
    if(!success){
        // Handle the error
        DebugLog(@"Error ocurred fetching transportation types.");
    }
    self.resultsController = fetchResultsController;
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return !UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


#pragma mark - Table view data source

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
    // remove checkmark of previously selected cell
    self.selectedCell.accessoryType = UITableViewCellAccessoryNone;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.selectedCell = cell;
    // add checkamrk indicator to selected cell 
    self.selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // update transport type
    self.currentTransportPass.transportType = [CoreDataUtils transportationTypesByOrder:indexPath.row];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    // Configure the cell...
    TransportType *transportType = [self.resultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = NSLocalizedString(transportType.desc, nil);
    
    // obtain image icon
    NSString *transpIconPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@-small",transportType.desc] ofType:@"png"];
    cell.imageView.image = [[[UIImage alloc] initWithContentsOfFile:transpIconPath] autorelease];
    
    if(!self.selectedCell){
        if([transportType.desc isEqualToString:self.currentTransportPass.transportType.desc]){
            self.selectedCell = cell;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        }
    }

    return cell;
}

- (void)dealloc
{
    self.resultsController = nil;
    self.tableView = nil;
    [super dealloc];
}

@end
