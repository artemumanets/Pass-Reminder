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
#import "PassListViewController.h"
#import "Pass.h"
#import "TransportType.h"
#import "Owner.h"
#import "Utils.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>
#import "CoreDataUtils.h"
#import "Photo.h"

#import "MontlyPassRenewDateViewController.h"

@interface PassDetails : UIViewController{
    BOOL isCleanPass;
}
@property (nonatomic, retain) MontlyPassRenewDateViewController *monthlyVC;

@property (nonatomic, assign) MainViewController *mainView;


@property (nonatomic, retain) Pass *pass;

@property (nonatomic, retain) IBOutlet UIImageView *userPhoto;

@property (nonatomic, retain) IBOutlet UIImageView *transportationTypeIcon;

@property (nonatomic, retain) IBOutlet UIImageView *colorString;

@property (nonatomic, retain) IBOutlet UIImageView *backgroundImageView;

@property (nonatomic, retain) IBOutlet UILabel *ownerName;

@property (nonatomic, retain) IBOutlet UILabel *companyName;

@property (nonatomic, retain) IBOutlet UILabel *passExpirationDate;

@property (nonatomic, retain) IBOutlet UILabel *renewDateOrNumTrips;

@property (nonatomic, retain) IBOutlet UILabel *labelData;
@property (nonatomic, retain) IBOutlet UILabel *labelTrips;
@property (nonatomic, retain) IBOutlet UILabel *labelDayCount;

@property (nonatomic, retain) IBOutlet UILabel *labelInformativeMessage;

@property (nonatomic, retain) IBOutlet UIButton *buttonTicketUpgrade;

@property (nonatomic, retain) IBOutlet UIButton *buttonPassRenew;

// used to restore data if during pass update date user has canceled changes
@property (nonatomic, retain) NSDate *backupPassRenewDate;


// send request to perform content reload
-(void)reloadContent;

// action is triggered when ticket based button is pressed
-(IBAction)actionTicketBasedTouched:(id)sender;

// action is triggered when monthly pass renew button is pressed
-(IBAction)actionMontlhyPassRenew:(id)sender;

// initializer should be used when no passes are present in core data
-(id)initWithCleanPass;

@end
