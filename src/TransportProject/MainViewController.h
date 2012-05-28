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

#import "PassListViewController.h"
#import "UIScreen+Dimensions.h"
#import "PassDetails.h"
#import <CoreData/CoreData.h>
#import "CoreDataUtils.h"

@interface MainViewController : UIViewController <PassListViewControllerDelegate, UIScrollViewDelegate, NSFetchedResultsControllerDelegate>{
    NSMutableArray  *loadedPassViews;
    
    // previously selected page in @pageControl
    int previousPage;
     // used to update page controller more accuretly
    int pageFractPrevious;

    // top offset of pass view
    int offset;
    
    // number of passes
    int numberOfPasses;
    
    BOOL appearButNotAfterLoad;
    // indication if it is necessary to preload neighbours
    // when view was scrolled
    BOOL needToPreloadContentAfterScroll;
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (retain, nonatomic) IBOutlet UIScrollView  *scrollView;
@property (retain, nonatomic) IBOutlet UIPageControl *pageControl;

@property (retain, nonatomic) NSFetchedResultsController *resultsController;

@property (retain, nonatomic) Settings *settings;


// button action to show information about all passes
- (IBAction)showInfo:(id)sender;

// action to select page inside a UIScrollView. Triggered by UIPageControl.
- (IBAction)pageChanged:(id)sender;


@end
