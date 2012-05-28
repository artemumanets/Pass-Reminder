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

#import "PassRenewDateViewController.h"

@interface PassRenewDateViewController ()

@end


@implementation PassRenewDateViewController

@synthesize currentTransportPass;
@synthesize tableView;
@synthesize scrollView;
@synthesize datePicker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.scrollView.contentSize = CGSizeMake(480, 320);
    self.scrollView.scrollEnabled = NO;
    CGRect frame = self.datePicker.frame; 
    self.datePicker.frame = CGRectMake(0, 110, frame.size.width, frame.size.height);

    
    // calculate max date
    self.datePicker.maximumDate = [Utils addToDate:[NSDate date] days:0 months:0 years:100];
    self.datePicker.minimumDate = [NSDate date];
    
    if(!self.currentTransportPass.dateCardRenew){
        self.datePicker.date = [Utils addToDate:[NSDate date] days:0 months:0 years:1];
    }else{
        self.datePicker.date = self.currentTransportPass.dateCardRenew;
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.datePicker sizeToFit];
    
    noExpireCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    noExpireCell.textLabel.text = NSLocalizedString(@"Never", nil);

    infoCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    if(!self.currentTransportPass.dateCardRenew){
        noExpireCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        infoCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return !UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma UITableView


-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @" ";
}


-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return noExpireCell;
    }else {
        infoCell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Renew on %@", nil), [Utils dateFormatWithRemainingDays:[NSDate date] dateTo:self.datePicker.date]];
        return infoCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        noExpireCell.accessoryType = UITableViewCellAccessoryCheckmark;
        infoCell.accessoryType =  UITableViewCellAccessoryNone;
        self.currentTransportPass.dateCardRenew = nil;
    }else {
        noExpireCell.accessoryType = UITableViewCellAccessoryNone;
        infoCell.accessoryType =  UITableViewCellAccessoryCheckmark;
        self.currentTransportPass.dateCardRenew = self.datePicker.date;
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma PicketView

-(IBAction)datePicketViewValueChanged:(id)selector{
    [self.tableView reloadData];
    
    if(infoCell.accessoryType != UITableViewCellAccessoryCheckmark){
        infoCell.accessoryType =  UITableViewCellAccessoryCheckmark;
        
        // remove checkmark 
        noExpireCell.accessoryType = UITableViewCellAccessoryNone;
    }
    // update date with current date 
    self.currentTransportPass.dateCardRenew = self.datePicker.date;
}

- (void)dealloc
{
    self.tableView = nil;
    self.scrollView = nil;
    self.datePicker = nil;
    [infoCell release];
    [noExpireCell release];
    [super dealloc];
}

@end
