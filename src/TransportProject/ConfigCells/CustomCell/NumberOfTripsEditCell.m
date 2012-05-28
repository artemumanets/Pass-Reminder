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

#import "NumberOfTripsEditCell.h"

@interface NumberOfTripsEditCell(Private)
-(void)textDidChange:(NSNotification*)notification;

@end

@implementation NumberOfTripsEditCell

@synthesize passInfo;

- (id)init
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil leftFields:nil placeHolder:nil keyboardType:UIKeyboardTypeNumberPad];
    if (self) {
        [self.rightTextField becomeFirstResponder];
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.leftLabel.text = NSLocalizedString(@"No. of Trips", nil);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:self.rightTextField];
    }
    return self;
}

-(void)reloadCellContent{
    self.rightTextField.text = [NSString stringWithFormat:@"%@", self.passInfo.numOfTrips];
}

-(void)textDidChange:(NSNotification*)notification{
    int value = 0;
    if(self.rightTextField.text.length > 0){
        value = [self.rightTextField.text intValue];
        if(value > 9999)
            value = 9999;
    }
    self.passInfo.numOfTrips = [NSNumber numberWithInt:value];
}

 
@end
