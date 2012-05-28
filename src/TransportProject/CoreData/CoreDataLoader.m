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

#import "CoreDataLoader.h"

@interface CoreDataLoader(Private)

// perform load of default set of transportation types
-(void)loadTransportationTypes;

// perform load of default settings of the application
-(void)loadSettings;

// perform load of default settings photo
-(void)loadPhoto;

@end

@implementation CoreDataLoader

@synthesize managedObjectContext;

- (id)init
{
    self = [super init];
    if (self) {
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        self.managedObjectContext = delegate.managedObjectContext;
    }
    return self;
}

-(void)loadDefaultSchema{
    // load transportation tpytes if required
    [self loadTransportationTypes];
    
    // load settings if required
    [self loadSettings];
    
    // load default user photo
    [self loadPhoto];
    
    // save data
    [CoreDataUtils saveCoreData]; 
}

-(void)loadSettings{
    if([CoreDataUtils settings]) return;
    DebugLog(@"Loading core data settings.");
    // insert initial configuration
    Settings *newSettings = (Settings*)[NSEntityDescription insertNewObjectForEntityForName:@"Settings" inManagedObjectContext:managedObjectContext];
    newSettings.selectedPassOrder = [NSNumber numberWithInt:0];
}

-(void)loadPhoto{
    if([CoreDataUtils photos].count > 0) return;
    Photo *newPhoto = (Photo*)[NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:managedObjectContext];
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *defaultPhotoPath  = [mainBundle pathForResource:@"DefaultPhoto" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:defaultPhotoPath];
    newPhoto.photoData = UIImagePNGRepresentation(image);
    newPhoto.photoThumbnail = UIImagePNGRepresentation([Utils imageByScalingAndCroppingForSize:image toTargetSize:CGSizeMake(35, 35)]);
    newPhoto.dateCreated = [NSDate dateWithTimeIntervalSince1970:0];
}


-(void)loadTransportationTypes{
    NSArray *existingTrasportationTypes = [CoreDataUtils transportationTypes];
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *filePath   = [mainBundle pathForResource:@"TransportationTypes" ofType:@"plist"];
    NSArray *allTrasponrtationTypes = [[NSArray alloc] initWithContentsOfFile:filePath];
    
    DebugLog(@"Loading core data transportation types!");
    for (NSDictionary *dict in allTrasponrtationTypes) {
        // check if traposrt type within specific description already exists
        NSString *desc = [dict objectForKey:@"description"];
        BOOL add = YES;
        for (TransportType *transpExist in existingTrasportationTypes) {
            if([desc isEqualToString:transpExist.desc]){
                add = NO;
                break;
            }
        }
        if(!add) continue;
        
        TransportType *newTransportType = (TransportType*)[NSEntityDescription insertNewObjectForEntityForName:@"TransportType" inManagedObjectContext:managedObjectContext];
        newTransportType.order = [dict valueForKey:@"order"];
        newTransportType.desc = desc;
    }
    [allTrasponrtationTypes release];
}

@end
