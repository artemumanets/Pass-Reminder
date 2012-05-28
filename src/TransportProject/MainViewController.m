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

#import "MainViewController.h"
#import "AppDelegate.h"

@interface MainViewController(Private)

// removes loaded view at specific index if it's possible 
-(void)tryRemoveLoadedViewAtIndex:(int)index;

// try to load details view into specific 
-(void)tryLoadViewIntoIndex:(int)index;

// initializ pass structure when app launchoes or when some additions and removes were made
-(void)passInitialization;

// perform load of current page and it's neigbours
-(void)loadCurrentPageWithNeigbours:(int)currentPage;

// obtain scroll frame to perform scroll to correct position
-(CGRect)getScrollFrame;

@end

@implementation MainViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize scrollView, pageControl;
@synthesize resultsController;
@synthesize settings;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    self.settings = [CoreDataUtils settings];
    self.resultsController = [CoreDataUtils passFetchResults];
    self.resultsController.delegate = self;
    
    loadedPassViews = [[NSMutableArray alloc] init];
    
    [self passInitialization];
    
    appearButNotAfterLoad = NO;
}

-(void)passInitialization{
    NSError *error;
    BOOL success = [self.resultsController performFetch: &error];
    if(!success){
        // Handle the error
        DebugLog(@"Error ocurred fetching passes types.");
    }
    CGSize size = [[UIScreen mainScreen] size];
    offset = 6;
    
    numberOfPasses = self.resultsController.fetchedObjects.count;
    
    if(loadedPassViews.count > 0)
        [loadedPassViews removeAllObjects];
    
    if(numberOfPasses == 0){
        // load indications pass
        PassDetails *details = [[[PassDetails alloc] initWithCleanPass] autorelease];
        details.mainView = self;
        self.pageControl.numberOfPages = 0;
        self.scrollView.frame = CGRectMake(0, 0, size.width - offset, size.height);
        self.scrollView.contentSize = CGSizeMake((size.width-offset), size.height);
        [self.scrollView addSubview:details.view];
        return;
    }
    // fill other pass position with nil
    for(int i = 0; i < numberOfPasses; ++i){
        [loadedPassViews addObject:[NSNull null]];
    }
    
    [pageControl setHidden: numberOfPasses < 2];
    pageControl.numberOfPages = numberOfPasses;

    self.scrollView.frame = CGRectMake(3, 0, size.width - offset, size.height);
    self.scrollView.contentSize = CGSizeMake((size.width-offset) * numberOfPasses, size.height);

    [self loadCurrentPageWithNeigbours:[self.settings.selectedPassOrder intValue]];
    self.pageControl.currentPage = [self.settings.selectedPassOrder intValue];
    CGRect frame = [self getScrollFrame];
    [self.scrollView scrollRectToVisible:frame animated:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if(!appearButNotAfterLoad){
        appearButNotAfterLoad = YES;
        return;
    }
    
    for (UIView *view in scrollView.subviews) {
        [view removeFromSuperview];
    }
    // reload passes
    [self passInitialization];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return !UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark - Flipside View

- (void)passListViewControllerDidFinish:(PassListViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    float fractionalPage = self.scrollView.contentOffset.x / pageWidth;
    NSInteger pageFract = lround(fractionalPage);
    NSInteger page = (int)fractionalPage;
    // to update page controller more accuretly
    if(pageFractPrevious != pageFract){
        pageFractPrevious = pageFract;
        self.pageControl.currentPage = pageFract;
    }
    if (previousPage != page) {
        
        // page contains current index
        [self loadCurrentPageWithNeigbours:page];
        
        self.settings.selectedPassOrder = [NSNumber numberWithInt:page];
        [CoreDataUtils saveCoreData];
    }
}

-(void)loadCurrentPageWithNeigbours:(int)currentPage{
    previousPage = currentPage;
    pageFractPrevious = currentPage;
    //pageControl.currentPage = currentPage;
    int prevIndex = currentPage - 1;
    int nextIndex = currentPage + 1;
    
    int idxUnload1 = currentPage + 2;
    int idxUnload2 = currentPage - 2;
    
    [self tryRemoveLoadedViewAtIndex:idxUnload1];
    [self tryRemoveLoadedViewAtIndex:idxUnload2];

    [self tryLoadViewIntoIndex:currentPage];    
    [self tryLoadViewIntoIndex:prevIndex];
    [self tryLoadViewIntoIndex:nextIndex];
}

-(void)tryRemoveLoadedViewAtIndex:(int)index{
    if(index < loadedPassViews.count && index >= 0){
        id object = [loadedPassViews objectAtIndex:index];
        if([object isKindOfClass:[NSNull class]]) return;
            
        PassDetails *detailsToRemove = (PassDetails*)object;
        [detailsToRemove.view removeFromSuperview];
        [loadedPassViews replaceObjectAtIndex:index withObject:[NSNull null]];
    }
}

-(void)tryLoadViewIntoIndex:(int)index{
    if(index < numberOfPasses && index >= 0){
        id object = [loadedPassViews objectAtIndex:index];
        if(![object isKindOfClass:[NSNull class]]) return;

        PassDetails *details = [[[PassDetails alloc] init] autorelease];
        details.mainView = self;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        details.pass = [self.resultsController objectAtIndexPath:indexPath];

        CGSize size = [[UIScreen mainScreen] size];
        [details view].frame = CGRectMake(size.width*index - ((index*offset) + offset / 2) , 0, size.width-offset, size.height);
        [scrollView addSubview:details.view];
        [loadedPassViews replaceObjectAtIndex:index withObject:details];
    }
}

- (IBAction)pageChanged:(id)sender{
    CGRect frame = [self getScrollFrame];
    [self.scrollView scrollRectToVisible:frame animated:YES];
}

-(CGRect)getScrollFrame{
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    return frame;
}

- (IBAction)showInfo:(id)sender
{    
    PassListViewController *controller = [[[PassListViewController alloc] initWithNibName:@"PassListViewController" bundle:nil] autorelease];
    
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:controller] autorelease];
    navController.navigationBar.barStyle = UIBarStyleBlack;

    controller.navController = navController;
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:navController animated:YES];
}


- (void)dealloc
{
    [loadedPassViews release];
    self.settings = nil;
    self.resultsController = nil;

    [_managedObjectContext release];
    self.pageControl = nil;
    self.scrollView = nil;
    [super dealloc];
}

@end
