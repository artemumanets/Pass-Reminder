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

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "Pass.h"
#import "TransportType.h"
#import "Owner.h"
#import "Pass.h"
#import "Utils.h"
#import "ManagedObjectCloner.h"
#import "Settings.h"
#import "Photo.h"

@interface CoreDataUtils : NSObject

// retreive all trasportation types from storage
+(NSArray*)transportationTypes;

// retreive transportation type with specific description
+(TransportType*)transportationTypesByDesc:(NSString*)description;

// retreive transportation type with specific order number
+(TransportType*)transportationTypesByOrder:(int)order;

// retreive all trasportation types from storage and present them as NSFetchedResultsController to be reused by UITableView
+(NSFetchedResultsController*)transportationTypesFetchResults;

// retreive all passes from storage and present them as NSFetchedResultsController to be reused by UITableView
+(NSFetchedResultsController*)passFetchResults;

// retreive all passes from storage
+(NSArray*)passes;

// initialize pass with default information
+(Pass*)initDefaultPass;

// retreive settings from storage
+(Settings*)settings;

// perform a clone of managed object
+(NSManagedObject *)clone:(NSManagedObject *)source;

// remove managed object from storage
+(void)removeFromStorage:(NSManagedObject*)mObject;

// perform save of core data storage in default context defined in AppDelegate
+(void)saveCoreData;

// undo core data changes
+(void)cancelCoreDataChanges;

// create new photo entry in core data  storage
+(Photo*)createNewPhotoEntry;

// cretreive default photo from storage
+(Photo*)defaultPhoto;

+(NSArray*)photos;

+(NSManagedObjectContext*)managedContext;

// retreive all photos from storage and present them as NSFetchedResultsController to be reused by UITableView
+(NSFetchedResultsController*)photosFetchResult;

// calculate next id number for pass
+(NSNumber*)autoPassId;

@end
