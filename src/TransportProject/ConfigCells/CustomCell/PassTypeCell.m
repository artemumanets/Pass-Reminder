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

#import "PassTypeCell.h"

@implementation PassTypeCell

@synthesize pass;

- (id)init
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil 
                         value1:NSLocalizedString(@"Monthly", nil) 
                         value2:NSLocalizedString(@"Tickets", nil) 
                     labelTitle:NSLocalizedString(@"Pass Type", nil)];
    if (self) {
        
    }
    return self;
}

-(void)reloadCellContent{
    if([self.pass.isMontlyPass boolValue])
        self.segmentedControl.selectedSegmentIndex = 0;
    else 
        self.segmentedControl.selectedSegmentIndex = 1;
}

@end
