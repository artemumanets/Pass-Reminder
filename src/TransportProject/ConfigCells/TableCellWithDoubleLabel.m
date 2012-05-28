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

#import "TableCellWithDoubleLabel.h"

@implementation TableCellWithDoubleLabel

@synthesize leftLabel;
@synthesize rightLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier leftText:(NSString*)left rightText:(NSString*)right{
    
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		leftLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[leftLabel setBackgroundColor:[UIColor clearColor]];
		[leftLabel setTextColor:[UIColor colorWithRed:.285 green:.376 blue:.541 alpha:1]];
		[leftLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
		[leftLabel setTextAlignment:UITextAlignmentRight];
		[leftLabel setText:left];
		[self addSubview:leftLabel];
		
		rightLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [rightLabel setBackgroundColor:[UIColor clearColor]];
		[rightLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
		[rightLabel setMinimumFontSize: 15];
        [rightLabel setText:right];
		[self addSubview:rightLabel];
    }
	
    return self;
}

//Layout our fields in case of a layoutchange (fix for iPad doing strange things with margins if width is > 400)
- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect origFrame = self.contentView.frame;
	if (leftLabel.text != nil) {
        leftLabel.frame = CGRectMake(origFrame.origin.x, origFrame.origin.y, LEFT_LABEL_CELL_WIDTH, origFrame.size.height-1);
		rightLabel.frame = CGRectMake(origFrame.origin.x + LEFT_LABEL_CELL_WIDTH + 15, origFrame.origin.y, origFrame.size.width - (LEFT_LABEL_CELL_WIDTH + 30), origFrame.size.height-1);
	}
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
	[leftLabel release];
	[rightLabel release];
    [super dealloc];
}

@end
