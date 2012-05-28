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
#import "CustomCell.h"
#import "RenewDateCell.h"
#import "Utils.h"

@interface MontlyPassRenewDateViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    UITableViewCell *infoCell;
    BOOL isIOS5;
}

// current transport pass
@property (nonatomic, assign) Pass *currentTransportPass;

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;

// required for PassDetails to be retained
@property (nonatomic, retain) UIViewController *parentVC;


// action triggered when value in date picker view is changed
-(IBAction)datePicketViewValueChanged:(id)selector;

@end