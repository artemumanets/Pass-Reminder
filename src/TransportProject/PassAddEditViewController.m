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

#import "PassAddEditViewController.h"

@interface PassAddEditViewController ()
// obtain key for @configCell dictionary by passing section number of UITableView
-(NSString*)keyForSection:(NSInteger)section;

// setting up and populate table view with general information
-(void)loadGeneralInformation;

// setting up and populate table view with pass information
-(void)loadPassInformation;

// action for canceling add/edit process
-(void)cancelAction:(id)selector;

// action for saving pass information
-(void)saveAction:(id)selector;

@end

@implementation PassAddEditViewController

@synthesize pass;
@synthesize tableView;
@synthesize editablePass;

@synthesize ticketBased, monthPass;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // init cell config container
        configCells= [[NSMutableDictionary alloc] init];
        
        // init section dictionary
        sectionTitles = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    if(self.pass){
        // Edit Mode
        isEditMode = YES;
        self.title = NSLocalizedString(@"Edit Pass", nil);
        
        // copy data to editablePass
        self.editablePass = [CoreDataUtils initDefaultPass];
        
        self.editablePass.company = self.pass.company;
        self.editablePass.dateCardRenew = self.pass.dateCardRenew;
        self.editablePass.dateMontlyRenew = self.pass.dateMontlyRenew;
        self.editablePass.isMontlyPass = self.pass.isMontlyPass;
        self.editablePass.numOfTrips = self.pass.numOfTrips;
        self.editablePass.order = self.pass.order;
        
        self.editablePass.owner.name = self.pass.owner.name;
        self.editablePass.owner.photo = self.pass.owner.photo;
        
        self.editablePass.transportType = self.pass.transportType;
    }else{
        // add mode
        isEditMode = NO;
        self.title = NSLocalizedString(@"Add Pass", nil);
        // init pass data with default values
        self.editablePass = [CoreDataUtils initDefaultPass];
        isMonthlyVisible = YES;
    }
    
     // load and setup cels
    [self loadGeneralInformation];
    [self loadPassInformation];
    
    // setup navigation controller bar
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIBarButtonItem *cancelButton  = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                                               target:self action:@selector(cancelAction:)] autorelease];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *saveButton  = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
                                                             target:self action:@selector(saveAction:)] autorelease];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    // register for notification center to catch keyboard events
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    // unregister from notification center
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return !UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma UITableView Delegate and DataSource

-(int)numberOfSectionsInTableView:(UITableView *)tableView{
    return sectionTitles.count;
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *confCellsInSection = [configCells objectForKey:[self keyForSection:section]];
    return confCellsInSection.count; // because monthy pass and ticket based are not displayed simultaneosl
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *confCellsInSection = [configCells objectForKey:[self keyForSection:indexPath.section]];
    UITableViewCell<CustomCell> *cell = [confCellsInSection objectAtIndex:indexPath.row];
    [cell reloadCellContent];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1 && indexPath.row == 3)
        return 50;
    else
        return 44;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [sectionTitles objectForKey:[self keyForSection:section]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell<CustomCell> *cell = (UITableViewCell<CustomCell>*)[self.tableView cellForRowAtIndexPath:indexPath];
    if([cell respondsToSelector:@selector(executeAction:)])
        [cell executeAction:self.navigationController];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    NSString *sectionTitle = [self tableView:self.tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    // Create label with section title
    UILabel *label = [[[UILabel alloc] init] autorelease];
    label.frame = CGRectMake(20, 6, 480, 30);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:1.0f];
    label.shadowColor = [UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = sectionTitle;
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [view autorelease];
    [view addSubview:label];
    
    return view;
}

-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if(currentKeyboardOwner){
        [currentKeyboardOwner.rightTextField resignFirstResponder];
    }
}

-(NSString*)keyForSection:(NSInteger)section{
    if(section == 0) return kOwnerInfo;
    if (section == 1) return kPassInfo;
    return @"";
}

#pragma Custom Cells Delegate

-(void)textStart:(TableCellWithText*)cell{
    currentKeyboardOwner = cell;
    [tableView scrollToRowAtIndexPath:[tableView indexPathForCell:currentKeyboardOwner] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(void)textEnd:(TableCellWithText *)cell{
    // TODO: Está mal
    if([cell isKindOfClass:[OwnerNameCell class]]){
        self.editablePass.owner.name = cell.rightTextField.text;
    }else if([cell isKindOfClass:[CompanyNameCell class]]){
        self.editablePass.company = cell.rightTextField.text;
    }
}

-(void)keyboardDidHide:(NSNotification *)notification{
    NSValue *value = [[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    CGRect frame = self.tableView.frame;
    frame.size.height += keyboardSize.width;
    //self.tableView.frame = frame;
}

-(void)keyboardDidShow:(NSNotification *)notification{
    NSValue *value = [[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    CGRect frame = self.tableView.frame;
    frame.size.height -= keyboardSize.width;
    //self.tableView.frame = frame;

    [tableView scrollToRowAtIndexPath:[tableView indexPathForCell:currentKeyboardOwner] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(void)segmentedControlValueChanged:(NSUInteger)currentValue{
    isMonthlyVisible = currentValue == 0;
    self.editablePass.isMontlyPass = [NSNumber numberWithBool:isMonthlyVisible];
    NSArray *indexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:4 inSection:1]];
    NSMutableArray *rows = [configCells objectForKey:kPassInfo];                 
    if(isMonthlyVisible){
        if([rows containsObject:self.ticketBased]){ // if not checked, app crash on 4.3
            [self.tableView beginUpdates];
            [rows removeObject:self.ticketBased];
            [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
            [rows addObject:self.monthPass];
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationRight];                 
            [self.tableView endUpdates];
            
            self.editablePass.isMontlyPass = [NSNumber numberWithBool:YES];
        }
    }else{
        if([rows containsObject:self.monthPass]){ // if not checked, app crash on 4.3
            [self.tableView beginUpdates];
            [rows removeObject:self.monthPass];
            [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationRight];
            [rows addObject:self.ticketBased];
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];                     
            [self.tableView endUpdates];
            
            self.editablePass.isMontlyPass = [NSNumber numberWithBool:NO];
        }
    }
    for (NSString* key in configCells) {
        for (UITableViewCell *cell in [configCells objectForKey:key]) {            
            if([cell respondsToSelector:@selector(setPassInfo:)]){
                [cell performSelector:@selector(setPassInfo:) withObject:self.editablePass];
            }
        }
    }
    
    [self.tableView reloadData];
}

#pragma Loaders

-(void)loadGeneralInformation{
    // owner name cell
    OwnerNameCell *ownerName = [[[OwnerNameCell alloc] init] autorelease];
    ownerName.delegate = self;
    ownerName.passInfo = self.editablePass;
    
    // owner's photo cell
    OwnerPhotoCell *photoCell = [[[OwnerPhotoCell alloc] init] autorelease];
    photoCell.passInfo = self.editablePass;
    
    // populate array with settings
    NSMutableArray *ownerInfo = [NSMutableArray array];
    [ownerInfo addObject:ownerName];
    [ownerInfo addObject:photoCell];

    [configCells setValue:ownerInfo forKey:kOwnerInfo];
    // add section title
    [sectionTitles setValue:NSLocalizedString(@"General Information", nil) forKey:kOwnerInfo];
}

-(void)loadPassInformation{
    // company name cell
    CompanyNameCell *companyCell = [[[CompanyNameCell alloc] init] autorelease];
    companyCell.delegate = self;
    companyCell.passInfo = self.editablePass;
    
    // transport type
    TransportTypeCell *transportCell = [[[TransportTypeCell alloc] init] autorelease];
    transportCell.passInfo = self.editablePass;
    
    // card pass renew date
    RenewDateCell *cardRenewDate = [[[RenewDateCell alloc] initWithDayCount:YES] autorelease];
    cardRenewDate.passInfo = self.editablePass;

    // pass type (MOnthly, Ticket Based)
    PassTypeCell *passTypeCell = [[[PassTypeCell alloc] init] autorelease];
    passTypeCell.delegate = self;
    passTypeCell.pass = self.editablePass;
    [passTypeCell reloadCellContent];
    
    ValidUntilCell *validUntil = [[[ValidUntilCell alloc] init] autorelease];
    validUntil.passInfo = self.editablePass;
    
    NumberOfTripsCell *numberOfTrips = [[[NumberOfTripsCell alloc] init] autorelease];
    numberOfTrips.passInfo = self.editablePass;
    
    self.ticketBased = numberOfTrips;
    self.monthPass = validUntil;
    
    // populate array with settings
    NSMutableArray *passInfo = [NSMutableArray array];
    [passInfo addObject:companyCell];
    [passInfo addObject:transportCell];
    [passInfo addObject:cardRenewDate];
    [passInfo addObject:passTypeCell];
    if([self.editablePass.isMontlyPass boolValue])
        [passInfo addObject:self.monthPass];
    else 
        [passInfo addObject:self.ticketBased];
    
    [configCells setValue:passInfo forKey:kPassInfo];
    // add section title
    [sectionTitles setValue:NSLocalizedString(@"Pass Information", nil) forKey:kPassInfo];
}

#pragma MiscActions

-(void)cancelAction:(id)selector{
    DebugLog(@"Edit/Add action dismissed!");
    [CoreDataUtils removeFromStorage:self.editablePass];
    [CoreDataUtils saveCoreData];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

-(void)saveAction:(id)selector{
    DebugLog(@"Saving pass data!");
    if(isEditMode){
        // unregister notification if any
        [Utils unregisterNotificationWithId:self.pass.passId];
        [CoreDataUtils removeFromStorage:self.pass];
    }else{
        Settings *settings = [CoreDataUtils settings];
        settings.selectedPassOrder = self.editablePass.order;
    }
    
    //[Utils unregisterNotificationWithId:self.editablePass.passId];
    if([self.editablePass.isMontlyPass boolValue]){
        // register new notification
        NSString *description = [NSString stringWithFormat:NSLocalizedString(@"Validation date is near, for %@ pass.", nil), NSLocalizedString(self.editablePass.transportType.desc, nil)];
        [Utils registerNotificationForDate:self.editablePass.dateMontlyRenew withId:self.editablePass.passId descripion:description];
    }
    
    [CoreDataUtils saveCoreData];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)dealloc
{
    self.pass = nil;
    self.ticketBased = nil;
    self.monthPass = nil;
    [configCells release];
    [sectionTitles release];
    [super dealloc];
}

@end
