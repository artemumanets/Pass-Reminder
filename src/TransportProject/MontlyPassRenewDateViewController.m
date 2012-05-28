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

#import "MontlyPassRenewDateViewController.h"

@interface MontlyPassRenewDateViewController ()

@end


@implementation MontlyPassRenewDateViewController

@synthesize currentTransportPass;
@synthesize tableView;
@synthesize datePicker;
@synthesize parentVC;

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
    CGRect frame = self.datePicker.frame;
    self.datePicker.frame = CGRectMake(0, 100, frame.size.width, frame.size.height);
    
    // calculate max date
    self.datePicker.maximumDate = [Utils addToDate:[NSDate date] days:0 months:0 years:2];
    self.datePicker.minimumDate = [NSDate date];
    
    if(!self.currentTransportPass.dateMontlyRenew){
        self.datePicker.date = [Utils addToDate:[NSDate date] days:0 months:1 years:0];
        self.currentTransportPass.dateMontlyRenew = self.datePicker.date;
    }else{
        self.datePicker.date = self.currentTransportPass.dateMontlyRenew;
    }
    
    infoCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    infoCell.accessoryType = UITableViewCellAccessoryNone;
    infoCell.selectionStyle = UITableViewCellSelectionStyleNone;

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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return !UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma UITableView

-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @" ";
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    infoCell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Valid Until %@", nil), [Utils dateFormatWithRemainingDays:[NSDate date] dateTo:self.currentTransportPass.dateMontlyRenew]];
    return infoCell;
}

#pragma PicketView

-(IBAction)datePicketViewValueChanged:(id)selector{
    // update date with current date 
    self.currentTransportPass.dateMontlyRenew = self.datePicker.date;
    [self.tableView reloadData];
}

- (void)dealloc
{
    self.tableView = nil;
    self.datePicker = nil;
    self.parentVC = nil;
    [infoCell release];
    
    [super dealloc];
}

@end
