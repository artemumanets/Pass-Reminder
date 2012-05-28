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

#import "CoreDataUtils.h"

@implementation CoreDataUtils

+(NSFetchedResultsController*)transportationTypesFetchResults{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedContext = delegate.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TransportType" inManagedObjectContext:managedContext];
    
    NSSortDescriptor *descriptors = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:descriptors, nil];
    [request setSortDescriptors:sortDescriptors];
    
    [request setEntity:entity];
    
    NSFetchedResultsController *result = [[[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedContext sectionNameKeyPath:nil cacheName:@"transport_list.cache"] autorelease];
    
    [request release];
    [descriptors release];
    [sortDescriptors release];
    
    return result;
}

+(NSArray*)transportationTypes{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedContext = delegate.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TransportType" inManagedObjectContext:managedContext];
    
    NSSortDescriptor *descriptors = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:descriptors, nil];
    [request setSortDescriptors:sortDescriptors];
    
    [request setEntity:entity];
    
    NSError *error;
    NSArray *array = [[[managedContext executeFetchRequest:request error:&error] mutableCopy] autorelease];
    if(error != nil){
        // Handle the error somehow
    }
    [request release];
    [sortDescriptors release];
    [descriptors release];
    return array;
}  

+(TransportType*)transportationTypesByDesc:(NSString*)description{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedContext = delegate.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TransportType" inManagedObjectContext:managedContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"desc == %@", description];
    [request setPredicate:predicate];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *array = [[[managedContext executeFetchRequest:request error:&error] mutableCopy] autorelease];
    if(error != nil){
        // Handle the error somehow
    }
    [request release];
    
    return [array objectAtIndex:0];
}

+(TransportType*)transportationTypesByOrder:(int)order{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedContext = delegate.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TransportType" inManagedObjectContext:managedContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"order == %d", order];
    [request setPredicate:predicate];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *array = [[[managedContext executeFetchRequest:request error:&error] mutableCopy] autorelease];
    if(error != nil){
        // Handle the error somehow
    }
    [request release];
    
    return [array objectAtIndex:0];
}

+(NSArray*)passes{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedContext = delegate.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Pass" inManagedObjectContext:managedContext];
    
    NSSortDescriptor *descriptors = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:descriptors, nil];
    [request setSortDescriptors:sortDescriptors];
    
    [request setEntity:entity];
    
    NSError *error;
    NSArray *array = [[[managedContext executeFetchRequest:request error:&error] mutableCopy] autorelease];
    if(error != nil){
        // Handle the error somehow
    }
    [request release];
    [sortDescriptors release];
    [descriptors release];
    return array;
}

+(NSNumber*)autoPassId{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedContext = delegate.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Pass" inManagedObjectContext:managedContext];
    
    NSSortDescriptor *descriptors = [[NSSortDescriptor alloc] initWithKey:@"passId" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:descriptors, nil];
    [request setSortDescriptors:sortDescriptors];
    
    [request setEntity:entity];
    
    NSError *error;
    NSArray *array = [[[managedContext executeFetchRequest:request error:&error] mutableCopy] autorelease];
    if(error != nil){
        // Handle the error somehow
    }
    [request release];
    [sortDescriptors release];
    [descriptors release];
    if(array.count == 0)
        return [NSNumber numberWithInt:0];
    
    Pass *pass = [array objectAtIndex:0];
    int nextId = [pass.passId intValue] + 1;
    return [NSNumber numberWithInt:nextId];
}

+(NSArray*)photos{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedContext = delegate.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Photo" inManagedObjectContext:managedContext];
    
    NSSortDescriptor *descriptors = [[NSSortDescriptor alloc] initWithKey:@"dateCreated" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:descriptors, nil];
    [request setSortDescriptors:sortDescriptors];
    
    [request setEntity:entity];
    
    NSError *error;
    NSArray *array = [[[managedContext executeFetchRequest:request error:&error] mutableCopy] autorelease];
    if(error != nil){
        // Handle the error somehow
    }
    [request release];
    [sortDescriptors release];
    [descriptors release];
    return array;
}

+(Settings*)settings{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedContext = delegate.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Settings" inManagedObjectContext:managedContext];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *array = [[[managedContext executeFetchRequest:request error:&error] mutableCopy] autorelease];
    [request release];
    if(error != nil){
        // Handle the error somehow
    }
    if(array.count == 0)
        return nil;
    return [array objectAtIndex:0];
}

+(NSFetchedResultsController*)passFetchResults{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedContext = delegate.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Pass" inManagedObjectContext:managedContext];
    
    NSSortDescriptor *descriptors = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:descriptors, nil];
    [request setSortDescriptors:sortDescriptors];
    
    [request setEntity:entity];
    
    //NSFetchedResultsController *result = [[[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedContext sectionNameKeyPath:nil cacheName:@"passes_list.cache"] autorelease];
    NSFetchedResultsController *result = [[[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedContext sectionNameKeyPath:nil cacheName:nil] autorelease];
    
    [request release];
    [descriptors release];
    [sortDescriptors release];
    
    return result;
}

+(NSFetchedResultsController*)photosFetchResult{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedContext = delegate.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Photo" inManagedObjectContext:managedContext];
    
    NSSortDescriptor *descriptors = [[NSSortDescriptor alloc] initWithKey:@"dateCreated" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:descriptors, nil];
    [request setSortDescriptors:sortDescriptors];
    
    [request setEntity:entity];
    
    //NSFetchedResultsController *result = [[[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedContext sectionNameKeyPath:nil cacheName:@"photo_cache.cache"] autorelease];
    NSFetchedResultsController *result = [[[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedContext sectionNameKeyPath:nil cacheName:nil] autorelease];
    
    [request release];
    [descriptors release];
    [sortDescriptors release];
    
    return result;
}

+(Pass*)initDefaultPass{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedContext = delegate.managedObjectContext;    
    
    NSArray *passes = [CoreDataUtils passes];
    int newOrder = 0;
    if(passes.count > 0)
        newOrder = [[((Pass*)[passes objectAtIndex:passes.count-1]) order] intValue] + 1;
    
    // retreive default tranport type
    TransportType *transp = [CoreDataUtils transportationTypesByDesc:@"Bus"];
    
    // create default owner
    Owner *owner = (Owner*)[NSEntityDescription insertNewObjectForEntityForName:@"Owner" inManagedObjectContext:managedContext];
    owner.photo = nil;
    
    // create default pass type
  
    Pass *pass = (Pass*)[NSEntityDescription insertNewObjectForEntityForName:@"Pass" inManagedObjectContext:managedContext];
    pass.order = [NSNumber numberWithInt:newOrder];
    pass.transportType = transp;
    pass.owner = owner;
    pass.owner.photo = [CoreDataUtils defaultPhoto];
    pass.isMontlyPass = [NSNumber numberWithBool:YES];
    pass.dateMontlyRenew = [Utils addToDate:[NSDate date] days:0 months:1 years:0];
    pass.numOfTrips = [NSNumber numberWithInt:10];
    pass.passId = [CoreDataUtils autoPassId];
    
    return pass;
}

+(Photo*)createNewPhotoEntry{
    NSManagedObjectContext *context = [CoreDataUtils managedContext];
    Photo *photo = (Photo*)[NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
    photo.dateCreated = [NSDate date];
    return photo;
}

+(Photo*)defaultPhoto{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedContext = delegate.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Photo" inManagedObjectContext:managedContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dateCreated == %@", [NSDate dateWithTimeIntervalSince1970:0]];
    [request setPredicate:predicate];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *array = [[[managedContext executeFetchRequest:request error:&error] mutableCopy] autorelease];
    if(error != nil){
        // Handle the error somehow
    }
    [request release];
    
    return [array objectAtIndex:0];
}

+(NSManagedObject *)clone:(NSManagedObject *)source{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedContext = delegate.managedObjectContext;
    
    return [ManagedObjectCloner clone:source inContext:managedContext];
}

+(void)removeFromStorage:(NSManagedObject*)mObject{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedContext = delegate.managedObjectContext;
    [managedContext deleteObject:mObject];
}

+(void)saveCoreData{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate saveContext];
}

+(void)cancelCoreDataChanges{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedContext = delegate.managedObjectContext;
    [managedContext undo];
}

+(NSManagedObjectContext*)managedContext{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedContext = delegate.managedObjectContext;
    return managedContext;
}

@end
