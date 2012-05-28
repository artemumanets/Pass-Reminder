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

#import "OwnerNameCell.h"

@implementation OwnerNameCell

@synthesize passInfo;
- (id)init
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil leftFields:nil placeHolder:nil];
    if (self) {
        self.leftLabel.text = NSLocalizedString(@"Owner", nil);
    }
    return self;
}

-(void)reloadCellContent{
    if(!self.passInfo.owner.name || [self.passInfo.owner.name isEqualToString:@""]){
        self.rightTextField.placeholder = NSLocalizedString(@"Owner's name", nil);
    }else
        self.rightTextField.text = self.passInfo.owner.name;
}



@end
