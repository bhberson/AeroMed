//
//  AMFileManagerViewController.m
//  AeroMed
//
//  Copyright (c) 2014 GVSU. All rights reserved.

#import "AMFileManagerViewController.h"
#import "AMDocumentViewController.h"
#import "AMFolderViewController.h"
#import "AMBaseDocumentViewController.h"
#import "SWRevealViewController.h"
#import "OperatingProcedure.h"

#define kStructureKey @"Structure"

@interface AMFileManagerViewController ()
@property (strong, nonatomic) NSArray *documents;
@property (nonatomic) BOOL tooManyDocuments;
@property (nonatomic) BOOL isSubFolder;
@property (strong, nonatomic) NSMutableArray *viewControllerData;
@property (strong, nonatomic) NSArray *topFolders;
@property (atomic) BOOL isClearingViews;
@end

@implementation AMFileManagerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!_isSubFolder) {
        self.upButton.hidden = YES;
    } else {
        self.upButton.hidden = NO;
    }
   
  

}

-(void)viewWillAppear:(BOOL)animated {
    NSLog(@"view will appear");
     NSUserDefaults *storedData = [NSUserDefaults standardUserDefaults];
    
    // If we are in the main folder structure
    if (!_isSubFolder) {
        
        // If we do not have a structure then query the database
        if (_topFolders == nil) {
           // [self queryForFiles];
            self.viewControllerData = [storedData objectForKey:@"structure"];
            _topFolders = self.viewControllerData;
            [self reloadDataAnimated:YES];
        // We already have a structure
        } else {
            self.viewControllerData = [[NSMutableArray alloc] initWithArray:_topFolders];
            
             [self.centerText removeFromSuperview];
        }
        
    // If we are displaying the documents in a folder
    } else {

        [self.centerText removeFromSuperview];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)upButtonTapped:(id)sender {
    _isSubFolder = NO;
    [self removeAllCards];
    _viewControllerData = [[NSMutableArray alloc] initWithArray:_topFolders];
}

#pragma mark - Note card control

- (NSInteger)numberOfControllerCardsInNoteView:(KLNoteViewController*) noteView {
    NSInteger numCards =[_viewControllerData count];
    
    // Limit the number of cards to display
    if (numCards > 10) {
        numCards = 10;
        _tooManyDocuments = YES;
    }
    
    return numCards;
}
- (UIViewController *)noteView:(KLNoteViewController*)noteView viewControllerAtIndex:(NSInteger)index {
    
    // Get the relevant data for the navigation controller
    NSDictionary *navDict = [self.viewControllerData objectAtIndex: index];
    NSArray *cardData = [self.documents objectAtIndex:index];
    
    // Get the storyboard
    UIStoryboard *st = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
    
    // Determine if it is a folder or a document
    NSString *type = [navDict objectForKey:@"type"];
    AMDocumentViewController *viewController;
    
    // If we are the 10th card in too many documents we want to show All Documents in the folder
    if (_tooManyDocuments && index == 9) {
        AMFolderViewController *viewController = [st instantiateViewControllerWithIdentifier:@"FolderViewController"];
        [viewController setAllDocuments:_documents];
        return [[UINavigationController alloc] initWithRootViewController:viewController];
    }

    if ([type isEqualToString:@"folder"]) {
        AMFolderViewController *viewController = [st instantiateViewControllerWithIdentifier:@"FolderViewController"];
        [viewController setInfo: navDict];
        return [[UINavigationController alloc] initWithRootViewController:viewController];
    } else if ([type isEqualToString:@"document"]) {
        viewController = [st instantiateViewControllerWithIdentifier:@"DocumentViewController"];
        [viewController setInfo: navDict];
        [viewController setData:cardData];
        return [[UINavigationController alloc] initWithRootViewController:viewController];
    } else {
        NSLog(@"error");
        viewController = [st instantiateViewControllerWithIdentifier:@"DocumentViewController"];
    }
    
    
    //Return the custom view controller wrapped in a UINavigationController
    return [[UINavigationController alloc] initWithRootViewController:viewController];
}

-(void) noteViewController: (KLNoteViewController*) noteViewController didUpdateControllerCard:(KLControllerCard*)controllerCard toDisplayState:(KLControllerCardState) toState fromDisplayState:(KLControllerCardState) fromState {
    
    if (!_isClearingViews) {
        NSInteger index = [noteViewController indexForControllerCard: controllerCard];
        NSDictionary* navDict = [_viewControllerData objectAtIndex: index];
        

        // If it is a folder, moves into the full screen state, and has elements to contain then procede to subfolders
        if (toState == 3 && [[navDict objectForKey:@"type"] isEqualToString:@"folder"] && [[navDict objectForKey:@"contains"] count] > 0) {
          
            self.viewControllerData = [[NSMutableArray alloc] initWithArray:[navDict objectForKey:@"contains"]];
            _isSubFolder = YES;
            [self removeAllCards];
        
        }
    }
    
}

// Remove all the cards from the view
-(void)removeAllCards {
    for (UIView *view in self.view.subviews) {
        if ([view isMemberOfClass:[KLControllerCard class]]) {
            [(KLControllerCard *)view removeFromSuperview];
        }
    }
    
    [self reloadDataAnimated:YES];
    if (!_isSubFolder) {
        self.upButton.hidden = YES;
    } else {
        self.upButton.hidden = NO;
        NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:@"OperatingProcedures"];
        
        _documents = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        OperatingProcedure *op = _documents[0];
    }
}

@end
