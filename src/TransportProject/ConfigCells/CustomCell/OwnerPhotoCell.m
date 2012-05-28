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

#import "OwnerPhotoCell.h"

@interface OwnerPhotoCell (Private)
-(void)loadPhoto;
@end

@implementation OwnerPhotoCell

@synthesize passInfo;

- (id)init
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (self) {
        needPhotoUpdate = YES;
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.textLabel.text = NSLocalizedString(@"Owner's Photo", nil);
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.cornerRadius = 5;
    }
    return self;
}

-(void)loadPhoto{
    UIImage *userPhoto = [UIImage imageWithData:self.passInfo.owner.photo.photoThumbnail];
   self.imageView.image = userPhoto;
}

-(void)reloadCellContent{
    if(needPhotoUpdate)
        [self loadPhoto];
}

-(void)executeAction:(UINavigationController *)parentNavigationController{
    UserPhotoViewControllerViewController *userPhotoVC = [[UserPhotoViewControllerViewController alloc] init];
    userPhotoVC.passInfo = self.passInfo;
    userPhotoVC.title = NSLocalizedString(@"Owner's Photo", nil);
    [parentNavigationController pushViewController:userPhotoVC animated:YES];
    [userPhotoVC release];
    needPhotoUpdate = YES;
}


@end
