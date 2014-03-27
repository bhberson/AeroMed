//
//  AMFileManagerViewController.m
//  AeroMed
//
//  Copyright (c) 2014 GVSU. All rights reserved.

#import "AMFileManagerViewController.h"
#import "AMDocumentViewControllerOld.h"

#import "SWRevealViewController.h"
#import "OperatingProcedure.h"
#import "AMCheckListTableViewController.h"
#import "Folder.h"


@interface AMFileManagerViewController ()
@property (strong, nonatomic) NSArray *documents;
@property (nonatomic) BOOL tooManyDocuments;
@property (nonatomic) BOOL isSubFolder;
@property (strong, nonatomic) NSMutableArray *viewControllerData;
@property (strong, nonatomic) NSArray *topFolders;
@property (atomic) BOOL isClearingViews;
@property (strong, nonatomic) NSArray *checkList;

@end

@implementation AMFileManagerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UIBarButtonItem *sidebarButton = [self.navigationItem leftBarButtonItem];
    // Set the side bar button action to show slide out menu
    sidebarButton.target = self.revealViewController;
    sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
   
    // Setup notification for if user selects a card in the subfiew folder card
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showSelectedDocument:)
                                                 name:@"tappedCard" object:nil];

    // Setup another notification for if the user selects to open up the checklist for a document
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCheckList:) name:@"checkTapped" object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    NSLog(@"view will appear");
    [self queryForDocuments];
    [self queryForFiles];
    
    // If we are in the main folder structure
    if (!_isSubFolder) {
        
        // If we do not have a structure then query the database
        if (_topFolders == nil) {
         
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// Go back to main navigation folders
- (void)upButtonTapped:(id)sender {
    _isSubFolder = NO;
    
    UIBarButtonItem *sidebarButton = [self.navigationItem leftBarButtonItem];
    sidebarButton.target = self.revealViewController;
    sidebarButton.action = @selector(revealToggle:);
    sidebarButton.title = @"Menu";

    [self removeAllCards];
    _viewControllerData = [[NSMutableArray alloc] initWithArray:_topFolders];
    NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:@"OperatingProcedures"];
    
    _documents = [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (void)showCheckList:(NSNotification *)notification {
    
    NSDictionary *info = [notification userInfo];
    _checkList = [info valueForKey:@"checkList"];
    [self performSegueWithIdentifier:@"toCheckList" sender:self];
}

- (void)showSelectedDocument:(NSNotification *)notification {
    [self removeAllCards];
    NSDictionary *info = [notification userInfo];
    PFObject *card = [info valueForKey:@"cardSelected"];
    self.viewControllerData = [[NSMutableArray alloc] initWithObjects:card, nil];
    self.documents = [[NSArray alloc] initWithObjects:card, nil];
   
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"toCheckList"]) {
        AMCheckListTableViewController *vc = (AMCheckListTableViewController *)segue.destinationViewController;
        [vc setCheckList:_checkList];
        [vc setTitle:@"Checklist"];
    }
}

#pragma mark - Note card control

- (NSInteger)numberOfControllerCardsInNoteView:(KLNoteViewController*) noteView {
    NSInteger numCards =[_viewControllerData count];
    
    // Limit the number of cards to display
    if (numCards > 7) {
        numCards = 7;
        _tooManyDocuments = YES;
    }
    
    return numCards;
}
- (UIViewController *)noteView:(KLNoteViewController*)noteView viewControllerAtIndex:(NSInteger)index {
    
    // Get the relevant data for the navigation controller
    NSDictionary *navDict = [_viewControllerData objectAtIndex: index];
    PFObject *cardData = [_documents objectAtIndex:index];
    
    // Get the storyboard
    UIStoryboard *st = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
    
    // Determine if it is a folder or a document
    NSString *type = [navDict objectForKey:@"type"];
    AMDocumentViewControllerOld *viewController;
    
    // If we are the 10th card in too many documents we want to show All Documents in the folder
//    if (_tooManyDocuments && index == 6) {
//        AMFolderViewController *viewController = [st instantiateViewControllerWithIdentifier:@"FolderViewController"];
//        [viewController setAllDocuments:_documents];
//        return [[UINavigationController alloc] initWithRootViewController:viewController];
//    }
//
//    if ([type isEqualToString:@"folder"]) {
//        AMFolderViewController *viewController = [st instantiateViewControllerWithIdentifier:@"FolderViewController"];
//        [viewController setInfo: navDict];
//        return [[UINavigationController alloc] initWithRootViewController:viewController];
//    } else {
//        viewController = [st instantiateViewControllerWithIdentifier:@"DocumentViewController"];
//  
//        [viewController setDoc:cardData];
//        [viewController setShouldDisplayChecklist:self.shouldDisplayChecklist];
//        return [[UINavigationController alloc] initWithRootViewController:viewController];
//    }
//    
  
    //Return the custom view controller wrapped in a UINavigationController
    return [[UINavigationController alloc] initWithRootViewController:viewController];
}

-(void) noteViewController: (KLNoteViewController*) noteViewController didUpdateControllerCard:(KLControllerCard*)controllerCard toDisplayState:(KLControllerCardState) toState fromDisplayState:(KLControllerCardState) fromState {
    
    if (!_isClearingViews) {
        NSInteger index = [noteViewController indexForControllerCard: controllerCard];
        NSDictionary* navDict = [_viewControllerData objectAtIndex: index];
        

        // If it is a folder, moves into the full screen state, and has elements to contain then procede to subfolders
        if (toState == 3 && [[navDict objectForKey:@"type"] isEqualToString:@"folder"] && [[navDict objectForKey:@"contains"] count] > 0) {
          
            _viewControllerData = [[NSMutableArray alloc] initWithArray:[navDict objectForKey:@"contains"]];
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

    UIBarButtonItem *sidebarButton = [self.navigationItem leftBarButtonItem];
    [self reloadDataAnimated:YES];
    if (!_isSubFolder) {
    
        sidebarButton.target = self.revealViewController;
        sidebarButton.action = @selector(revealToggle:);
        sidebarButton.title = @"Menu";
        
    } else {

        // Set the side bar button to go back up
        sidebarButton.target = self;
        sidebarButton.title = @"Back";
        sidebarButton.action = @selector(upButtonTapped:);
        NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:@"OperatingProcedures"];
        
        _documents = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
}

#pragma mark -Search delegate methods
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    
    if (!_documents) {
        _documents = [NSKeyedUnarchiver unarchiveObjectWithFile:[OperatingProcedure getPathToArchive]];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
   
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Cancel clicked");
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    [self upButtonTapped:self];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
    NSLog(@"Searched text: %@", searchBar.text);
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
   [self removeAllCards];
    NSMutableArray *filteredData = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < _documents.count; i++) {
        PFObject *doc = [_documents objectAtIndex: i];
        NSString *title = [[doc objectForKey:@"title"] lowercaseString];
        NSString *check = [searchBar.text lowercaseString];
        if ([title rangeOfString:check].location != NSNotFound) {
            [filteredData addObject:doc];
        }
    }
    _viewControllerData = [[NSMutableArray alloc] initWithArray:filteredData];
    _documents = [[NSArray alloc] initWithArray:filteredData];
    
    // Set the side bar button to go back up
    UIBarButtonItem *sidebarButton = [self.navigationItem leftBarButtonItem];
    sidebarButton.target = self;
    sidebarButton.title = @"Back";
    sidebarButton.action = @selector(upButtonTapped:);
   
    
}


#pragma mark - Queries

// Query for the document contents
-(void) queryForDocuments {
    
    PFQuery *query = [PFQuery queryWithClassName:@"OperatingProcedure"];
    [query whereKeyExists:@"title"];
    query.cachePolicy = kPFCachePolicyCacheOnly;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            // Save an array of PFObjects
            NSMutableArray *operatingProcedures = [[NSMutableArray alloc] initWithCapacity:[objects count]];
            
            for (int i = 0; i < objects.count; i++) {
                OperatingProcedure *op = objects[i];
                [operatingProcedures addObject:op];
            }
            _documents = operatingProcedures;
            _viewControllerData = operatingProcedures;
            [self reloadDataAnimated:YES];
        }
        
    }];
}

// Query for all the filenames and structure
- (void) queryForFiles {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Folder"];
    [query whereKeyExists:@"title"];
    query.cachePolicy = kPFCachePolicyCacheOnly;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            // Save an array of PFObjects
            NSMutableArray *folders = [[NSMutableArray alloc] initWithCapacity:[objects count]];
            
            for (int i = 0; i < objects.count; i++) {
                Folder *op = objects[i];
                [folders addObject:op];
            }
//            _viewControllerData = folders;
//            [self reloadDataAnimated:YES];
            
        }
    }];
}
@end
