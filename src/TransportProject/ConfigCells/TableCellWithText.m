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

#import "TableCellWithText.h"

@implementation TableCellWithText

@synthesize delegate;
@synthesize leftLabel;
@synthesize rightTextField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier leftFields:(NSString*)left placeHolder:(NSString*)holder{
    
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		leftLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[leftLabel setBackgroundColor:[UIColor clearColor]];
		[leftLabel setTextColor:[UIColor colorWithRed:.285 green:.376 blue:.541 alpha:1]];
		[leftLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
		[leftLabel setTextAlignment:UITextAlignmentRight];
		[leftLabel setText:left];
		[self addSubview:leftLabel];
		
		rightTextField = [[UITextField alloc] initWithFrame:CGRectZero];
		rightTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		[rightTextField setDelegate:self];
		[rightTextField setPlaceholder:holder];
		[rightTextField setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
		[rightTextField setMinimumFontSize: 15];
        [rightTextField setAutocapitalizationType:UITextAutocapitalizationTypeWords];

        // disable table selection
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
		// FOR MWF USE DONE
		[rightTextField setReturnKeyType:UIReturnKeyDone];
		[self addSubview:rightTextField];
        
        // register notification to detect when done button was pressed on kyeboard
        [rightTextField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    }
	
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier leftFields:(NSString*)left placeHolder:(NSString*)holder keyboardType:(UIKeyboardType)keyboardType{
    id result = [self initWithStyle:style reuseIdentifier:reuseIdentifier leftFields:left placeHolder:holder];
    self.rightTextField.keyboardType = keyboardType;
    return result;
}

//Layout our fields in case of a layoutchange (fix for iPad doing strange things with margins if width is > 400)
- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect origFrame = self.contentView.frame;
	if (leftLabel.text != nil) {
		leftLabel.frame = CGRectMake(origFrame.origin.x, origFrame.origin.y, LEFT_LABEL_CELL_WIDTH, origFrame.size.height-1);
		rightTextField.frame = CGRectMake(origFrame.origin.x + LEFT_LABEL_CELL_WIDTH + 15, origFrame.origin.y, origFrame.size.width - (LEFT_LABEL_CELL_WIDTH + 30), origFrame.size.height-1);
	}
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    [self.delegate textEnd:self];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.delegate textStart:self];
}

- (void)dealloc {
	
	[leftLabel release];
	[rightTextField release];
    [super dealloc];
}

@end
