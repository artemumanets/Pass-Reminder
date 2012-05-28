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

#import "TransportTypeCell.h"

@implementation TransportTypeCell

@synthesize passInfo;

- (id)init
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

-(void)reloadCellContent{
    self.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Transportation Type (%@)", nil) , NSLocalizedString(self.passInfo.transportType.desc, nil)];
    NSString * imagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@-small", self.passInfo.transportType.desc] ofType:@"png"];
    self.imageView.image = [[[UIImage alloc] initWithContentsOfFile:imagePath] autorelease];
}

-(void)executeAction:(UINavigationController *)parentNavigationController{
    TransportationTypeViewController *trpTypeVC = [[TransportationTypeViewController alloc] init];
    trpTypeVC.currentTransportPass = self.passInfo;
    [parentNavigationController pushViewController:trpTypeVC animated:YES];
    [trpTypeVC release];
}

@end
