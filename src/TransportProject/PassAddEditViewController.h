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

#import <UIKit/UIKit.h>
#import "Pass.h"

#import "Constants.h"
#import "TransportationTypeViewController.h"
#import "PassRenewDateViewController.h"
#import "MontlyPassRenewDateViewController.h"
#import "NoOfTripViewController.h"
#import "UserPhotoViewControllerViewController.h"

#import "CustomCell.h"
#import "OwnerNameCell.h"
#import "TransportTypeCell.h"
#import "OwnerPhotoCell.h"
#import "CompanyNameCell.h"
#import "RenewDateCell.h"
#import "PassTypeCell.h"
#import "ValidUntilCell.h"
#import "NumberOfTripsCell.h"
#import "Settings.h"

#import "ManagedObjectCloner.h"

@interface PassAddEditViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, TableCellWithTextDelegate, TableCellSegmenetedDelegate>{
    NSMutableDictionary *configCells;
    NSMutableDictionary *sectionTitles;
    
    TableCellWithText *currentKeyboardOwner;
    
    BOOL isMonthlyVisible;
    
    BOOL isEditMode;
}
// object used to managed data while it is being edited
@property (nonatomic, retain) Pass *editablePass;

// information regarding to pass that is being created or edted
@property (nonatomic, retain) Pass *pass;

// ui table view with setting options
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, retain) ValidUntilCell *monthPass;
@property (nonatomic, retain) NumberOfTripsCell *ticketBased; 

@end
