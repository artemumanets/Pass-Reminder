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

#import "RenewDateCell.h"

@implementation RenewDateCell

@synthesize passInfo;

- (id)init
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil leftText:nil rightText:nil];
    if (self) {
        showDayCount = NO;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.leftLabel.text = NSLocalizedString(@"Renew", nil);
    }
    return self;
}

-(id)initWithDayCount:(BOOL)presentDayCount{
    id result = [self init];
    if(result){
        showDayCount = presentDayCount;
    }
    return result;
}

-(void)reloadCellContent{
    if(!self.passInfo.dateCardRenew){
        self.rightLabel.text = NSLocalizedString(@"Never", nil);
        return;
    }
    
    self.rightLabel.text = [Utils dateFormatWithRemainingDays:[NSDate date] dateTo:self.passInfo.dateCardRenew];
}

-(void)executeAction:(UINavigationController *)parentNavigationController{
    PassRenewDateViewController *renewDateVC = [[PassRenewDateViewController alloc] init];
    renewDateVC.currentTransportPass = self.passInfo;
    renewDateVC.title = NSLocalizedString(@"Renew Date", nil);
    [parentNavigationController pushViewController:renewDateVC animated:YES];
    [renewDateVC release];
}
 
@end
