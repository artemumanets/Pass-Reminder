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

#import "PassDetails.h"

@interface PassDetails ()

- (void)fadeOutTrips;

- (void)fadeDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

// reload data regarding number of trips and montly data
-(void)reloadNumTripsAndMontlyData;

-(void)actionSaveUpdatePassRenewDate:(id)sender;

-(void)actionCancelUpdatePassRenewDate:(id)sender;

@end

@implementation PassDetails

@synthesize monthlyVC;

@synthesize pass;
@synthesize userPhoto;
@synthesize transportationTypeIcon;
@synthesize ownerName;
@synthesize companyName;
@synthesize colorString;
@synthesize backgroundImageView;

@synthesize renewDateOrNumTrips;
@synthesize passExpirationDate;

@synthesize labelData;
@synthesize labelTrips;
@synthesize labelDayCount;
@synthesize labelInformativeMessage;

@synthesize backupPassRenewDate;

@synthesize buttonPassRenew, buttonTicketUpgrade;
@synthesize mainView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithCleanPass{
    self = [self initWithNibName:@"PassDetails" bundle:nil];
    if(self){
        isCleanPass = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(isCleanPass){
        NSBundle *defaultBundle = [NSBundle mainBundle];
        
        // load images for buttons
        NSString *passCleanBg = [defaultBundle pathForResource:@"PassCardClean" ofType:@"png"];
        self.backgroundImageView.image = [UIImage imageWithContentsOfFile:passCleanBg];
        
        // clean label texts
        self.labelData.hidden = YES;
        self.labelTrips.hidden = YES;
        self.labelDayCount.hidden = YES;
        self.userPhoto.hidden = YES;
        self.transportationTypeIcon.hidden = YES;
        self.ownerName.hidden = YES;
        self.companyName.hidden = YES;
        self.renewDateOrNumTrips.hidden = YES;
        self.passExpirationDate.hidden = YES;
        self.buttonPassRenew.hidden = YES;
        self.buttonTicketUpgrade.hidden = YES;
        self.labelInformativeMessage.text = NSLocalizedString(@"Tap information button to add new passes.", nil);
        
        return;
    }
    
    self.labelInformativeMessage.hidden = YES;
    
    // load pass content by first time
    self.userPhoto.layer.masksToBounds = YES;
    self.userPhoto.layer.cornerRadius = 7;
    
    [self reloadContent];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)reloadContent{
    NSBundle *defaultBundle = [NSBundle mainBundle];

    // load images for buttons
    NSString *buttonRenewPath = [defaultBundle pathForResource:NSLocalizedString(@"ButtonRenew", nil) ofType:@"png"];
    NSString *buttonTicketPath = [defaultBundle pathForResource:NSLocalizedString(@"ButtonTicket", nil) ofType:@"png"];

    [self.buttonPassRenew setBackgroundImage:[UIImage imageWithContentsOfFile:buttonRenewPath] forState:UIControlStateNormal];
    [self.buttonTicketUpgrade setBackgroundImage:[UIImage imageWithContentsOfFile:buttonTicketPath] forState:UIControlStateNormal];
    
    // load user photo
    self.userPhoto.image = [UIImage imageWithData:self.pass.owner.photo.photoData];
    
    // load transporation icon
    NSString *iconPath = [defaultBundle pathForResource:self.pass.transportType.desc ofType:@"png"];
    self.transportationTypeIcon.image = [[[UIImage alloc] initWithContentsOfFile:iconPath] autorelease];
    
    // load color string
    NSString *stringPath = [defaultBundle pathForResource:[NSString stringWithFormat:@"%@-string", self.pass.transportType.desc] ofType:@"png"];
    self.colorString.image = [[[UIImage alloc] initWithContentsOfFile:stringPath] autorelease];
    
    // set owner's name
    self.ownerName.text = self.pass.owner.name;
    
    // set comapny name
    NSString *compName = self.pass.company; 
    if(self.pass.company == nil || [self.pass.company isEqualToString:@""])
        compName = NSLocalizedString(@"Unknown Company", nil);
    self.companyName.text = [NSString stringWithFormat:compName];
    
    // set pass expriration date
    NSString * renewDateText;
    if(!self.pass.dateCardRenew)
        renewDateText = NSLocalizedString(@"Never", nil);
    else{
        renewDateText = [Utils dateFormatSimple: self.pass.dateCardRenew];
        if([Utils daysRemainValue:[NSDate date] dateTo:self.pass.dateCardRenew] < MINIMUM_NUMBER_OF_TRIPS_BEFORE_ALERT){
            self.passExpirationDate.textColor = [UIColor colorWithRed:.839 green:0.2 blue:0.2 alpha:1];
        }
    }
    
    self.passExpirationDate.text = renewDateText;
    self.labelData.text = NSLocalizedString(@"Renew", nil);
    
    [self reloadNumTripsAndMontlyData];
}

-(void)reloadNumTripsAndMontlyData{
    if([self.pass.isMontlyPass boolValue]){
        self.labelTrips.text = NSLocalizedString(@"Valid Until", nil);
        self.renewDateOrNumTrips.text = [Utils dateFormatSimple:self.pass.dateMontlyRenew];
        NSInteger numDaysLeft = [Utils daysRemainValue:[NSDate date] dateTo:self.pass.dateMontlyRenew];
        self.labelDayCount.text = [NSString stringWithFormat: [Utils daysRemain:[NSDate date] dateTo:self.pass.dateMontlyRenew]];
        if(numDaysLeft < RENEW_DATE_DAYS_REMAIN_TO_NOTIFY_USER)
            self.labelDayCount.textColor = [UIColor colorWithRed:.839 green:0.2 blue:0.2 alpha:1];
    }else{
        self.labelTrips.text = NSLocalizedString(@"No. of Trips", nil);
        self.renewDateOrNumTrips.text = [NSString stringWithFormat:@"%@", self.pass.numOfTrips];    
        self.labelDayCount.text = @"";
        
        // if number of trips is 0, disable update button
        int tripLeft =[self.pass.numOfTrips intValue];
        self.buttonTicketUpgrade.enabled = (tripLeft > 0);
        if(tripLeft < MINIMUM_NUMBER_OF_TRIPS_BEFORE_ALERT){
            self.renewDateOrNumTrips.textColor = [UIColor colorWithRed:.839 green:0.2 blue:0.2 alpha:1];
        }
    }
    
    // activate one of the buttons (monthly pass or ticket based)
    self.buttonPassRenew.hidden = ![self.pass.isMontlyPass boolValue];
    self.buttonTicketUpgrade.hidden = !self.buttonPassRenew.hidden;
}

-(IBAction)actionMontlhyPassRenew:(id)sender{
    DebugLog(@"Renew pass date pressed");
    self.backupPassRenewDate = self.pass.dateMontlyRenew;
    UIBarButtonItem *buttonDone  = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                                             target:self action:@selector(actionSaveUpdatePassRenewDate:)] autorelease];
    UIBarButtonItem *buttonCancel  = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                                              target:self action:@selector(actionCancelUpdatePassRenewDate:)] autorelease];
    
    MontlyPassRenewDateViewController *renewDateVC = [[[MontlyPassRenewDateViewController alloc] init] autorelease];
    renewDateVC.parentVC = self;
    renewDateVC.currentTransportPass = self.pass;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:renewDateVC];
    renewDateVC.title = NSLocalizedString(@"Renew Date", nil);
    navController.navigationBar.barStyle = UIBarStyleBlack;
    renewDateVC.navigationItem.rightBarButtonItem = buttonDone;
    renewDateVC.navigationItem.leftBarButtonItem = buttonCancel;
    
    self.monthlyVC = renewDateVC;
    [self.mainView presentModalViewController:navController animated:YES];
    [navController release];
}

-(IBAction)actionTicketBasedTouched:(id)sender{
    int updateTripCount = [self.pass.numOfTrips intValue] - 1;
    if(updateTripCount >= 0){
        self.pass.numOfTrips = [NSNumber numberWithInt:updateTripCount];
        // to update be more quick
        self.buttonTicketUpgrade.enabled = (updateTripCount > 0);
        [CoreDataUtils saveCoreData];
        [self fadeOutTrips];
    }
}

- (void)fadeOutTrips {
    [self.renewDateOrNumTrips setAlpha:1];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.25];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(fadeDidStop:finished:context:)];
    [self.renewDateOrNumTrips setAlpha:0];
    [UIView commitAnimations];
}

- (void)fadeDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.25];
    [self.renewDateOrNumTrips setAlpha:1];
    [UIView commitAnimations];
    
    if (![self.pass.isMontlyPass boolValue]) {
        // update view with newly updated values regarding trip count
        [self reloadNumTripsAndMontlyData];
    }
}
-(void)actionSaveUpdatePassRenewDate:(id)sender{
    DebugLog(@"Saved update of pass renew date");
    // save core data with update date value
    [Utils unregisterNotificationWithId:self.pass.passId];
    // register new notification
    NSString *description = [NSString stringWithFormat:NSLocalizedString(@"Validation date is near, for %@ pass.", nil), NSLocalizedString(self.pass.transportType.desc, nil)];
    [Utils registerNotificationForDate:self.pass.dateMontlyRenew withId:self.pass.passId descripion:description];
    
    [CoreDataUtils saveCoreData];
    [self reloadNumTripsAndMontlyData];
    [self.mainView dismissModalViewControllerAnimated:YES];
    self.monthlyVC = nil;
}

-(void)actionCancelUpdatePassRenewDate:(id)sender{
    DebugLog(@"Canceled update of pass renew date");
    // restore previous date value
    self.pass.dateMontlyRenew = self.backupPassRenewDate;
    [CoreDataUtils saveCoreData];
    [self.mainView dismissModalViewControllerAnimated:YES];
    self.monthlyVC = nil;
}

- (void)dealloc
{
    self.monthlyVC = nil;
    self.pass = nil;
    self.userPhoto = nil;
    self.transportationTypeIcon = nil;
    self.ownerName = nil;
    self.companyName = nil;
    self.passExpirationDate = nil;
    self.renewDateOrNumTrips = nil;
    self.labelData = nil;
    self.labelTrips = nil;
    self.labelDayCount = nil;
    self.buttonTicketUpgrade = nil;
    self.buttonPassRenew = nil;
    self.backupPassRenewDate = nil;
    self.backgroundImageView = nil;
    self.labelInformativeMessage = nil;
    [super dealloc];
}


@end
