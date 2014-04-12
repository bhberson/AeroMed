//
//  AMiPhoneDocumentViewController.m
//  AeroMed
//
//  Created by Michael Torres on 3/25/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import "AMBaseDocumentViewController.h"
#import "SWRevealViewController.h"
#import "AMDocumentCellView.h"

#import "UIAlertView+AMBlocks.h"
#import "AMCheckListTableViewController.h"

@interface AMBaseDocumentViewController ()

@property (strong, nonatomic) NSMutableArray *topFolders;
@property (strong, nonatomic) NSMutableArray *showingData;
@property BOOL isTopFolder;
@property BOOL shouldShowChecklist;
@property (strong, nonatomic) NSMutableArray *allDocs;
@property (strong, nonatomic) PFObject *selectedDocument;
@property (strong, nonatomic) NSString *subFolderType;

@property (strong, nonatomic) NSMutableArray *totalCheckListItems;
@property (strong, nonatomic) NSMutableArray *selectedTransportCells;
@end

@implementation AMBaseDocumentViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.totalCheckListItems = [[NSMutableArray alloc] init];
    self.selectedTransportCells = [[NSMutableArray alloc] init];
    
    
    self.shouldShowChecklist = YES;
    NSMutableArray *barButtons = [[NSMutableArray alloc] init];
    if (self.shouldShowChecklist) {
        UIBarButtonItem *checkButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"checklist.png"]
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(showChecklist)];
                                        
        [barButtons addObject:checkButton];
    }
    
    // If we are in a subfolder then this will be the document class type
    self.subFolderType = [[NSString alloc] init];
    
    UIBarButtonItem *sidebarButton = [self.navigationItem leftBarButtonItem];
    
    if (sidebarButton == nil) {
        sidebarButton = [[UIBarButtonItem alloc] init];
        sidebarButton.title = @"Menu";
        [self.navigationItem setLeftBarButtonItem:sidebarButton];
    }
    // Set the side bar button action to show slide out menu
    sidebarButton.target = self.revealViewController;
    sidebarButton.action = @selector(revealToggle:);
    
    // Set the add button if the user is an admin
    if ([[PFUser currentUser] objectForKey:@"isAdmin"]) {
        
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                  target:self
                                                                                   action:@selector(showAlertForAdding)];
        [barButtons addObject:addButton];
    }
    
    if (barButtons.count > 0) {
        [self.navigationItem setRightBarButtonItems:barButtons animated:YES];
    }
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // Long press for deleting cells
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showAlertForDeleting:)];
    longPress.delegate = self;
    [self.collectionView addGestureRecognizer:longPress];
    

    self.topFolders = [[NSMutableArray alloc] init];
    self.showingData = [[NSMutableArray alloc] init];
   

    PFQuery *query = [PFQuery queryWithClassName:@"Folder"];
    [query whereKeyExists:@"title"];
    [query orderByAscending:@"title"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    
    __weak AMBaseDocumentViewController *weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       
        if (!error) {
            [weakSelf setUpFolders:objects];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

- (void)setUpFolders:(NSArray *)objects {
    // Save an array of PFObjects
    NSMutableArray *folders = [[NSMutableArray alloc] initWithCapacity:[objects count]];
    
    for (int i = 0; i < objects.count; i++) {
        PFObject *op = objects[i];
        [folders addObject:op];
    }
    
    self.topFolders = folders;
    self.showingData = self.topFolders;
    self.isTopFolder = YES;
    [self.collectionView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"view will appear");
    [self.collectionView reloadData]; 
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.showingData.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AMDocumentCellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FolderCell" forIndexPath:indexPath];

    PFObject *data = [self.showingData objectAtIndex:indexPath.row];
    cell.headerLabel.text = [data objectForKey:@"title"];
    
    if ([self.selectedTransportCells containsObject:data[@"title"]]) {
        cell.backgroundColor = [UIColor orangeColor]; 
    } else {
        cell.backgroundColor = [UIColor colorWithRed:0.212 green:0.725 blue:1.000 alpha:1.000];
    }
    
    return cell;
}

                                        
- (void)showChecklist {
    [self performSegueWithIdentifier:@"toCheckList" sender:self]; 
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected cell %d", indexPath.row);
    PFObject *data = [self.showingData objectAtIndex:indexPath.row];
    
    // if we are a top level folder then query the type it contains
    if (self.isTopFolder) {
        [self queryForDocument:[data objectForKey:@"Contains"]];
        
        // Set the side bar button to go back up
        UIBarButtonItem *sidebarButton = [self.navigationItem leftBarButtonItem];
        sidebarButton.target = self;
        sidebarButton.title = @"Back";
        sidebarButton.action = @selector(upButtonTapped:);
        self.subFolderType = [data objectForKey:@"Contains"];
        
    // Show the selected document 
    } else {
        self.selectedDocument = data; 
        [self performSegueWithIdentifier:@"showDoc" sender:self];
    }
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size;
    // Bigger for iPad
    UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? (size = CGSizeMake(200, 200)) : (size = CGSizeMake(130, 130));
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets insets;
    // Bigger for iPad
    UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? (insets = UIEdgeInsetsMake(50, 30, 50, 30)) : (insets = UIEdgeInsetsMake(50, 20, 50, 20));
    return UIEdgeInsetsMake(50, 20, 50, 20);
}

#pragma mark - Queries

- (void)queryForDocument:(NSString *)searchFor {
   
    PFQuery *query = [PFQuery queryWithClassName:searchFor];
    [query orderByAscending:@"title"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    
    __weak AMBaseDocumentViewController *weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       
        if (!error) {
            [weakSelf setupDocuments:objects];
            
        } else {
            NSLog(@"%@", error);
            
        }
    }];
}

- (void)setupDocuments:(NSArray *)objects {
    self.showingData = [[NSMutableArray alloc] initWithArray:objects];
    self.isTopFolder = NO;
    [self.collectionView reloadData];
}

#pragma mark -Search delegate methods
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    
    // If we need to get all the documents
    if (!self.allDocs) {
        self.allDocs = [[NSMutableArray alloc] init];
        
        for (PFObject *folder in self.topFolders) {
            PFQuery *q = [PFQuery queryWithClassName:[folder objectForKey:@"Contains"]];
            q.cachePolicy = kPFCachePolicyCacheElseNetwork;
            [q findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    [self.allDocs addObjectsFromArray:objects];
                    
                } else {
                    NSLog(@"%@", error);
                    
                }
            }];
        }
        NSLog(@"All docs downloaded");
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

    NSMutableArray *filteredData = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.allDocs.count; i++) {
        PFObject *doc = [self.allDocs objectAtIndex: i];
        NSString *title = [[doc objectForKey:@"title"] lowercaseString];
        NSString *check = [searchBar.text lowercaseString];
        if ([title rangeOfString:check].location != NSNotFound) {
            [filteredData addObject:doc];
        }
    }
     self.showingData = [[NSMutableArray alloc] initWithArray:filteredData];
    self.isTopFolder = NO; 
    [self.collectionView reloadData];
    
    // Set the side bar button to go back up
    UIBarButtonItem *sidebarButton = [self.navigationItem leftBarButtonItem];
    sidebarButton.target = self;
    sidebarButton.title = @"Back";
    sidebarButton.action = @selector(upButtonTapped:);
    
    
}

// Go back to main navigation folders
- (void)upButtonTapped:(id)sender {
    self.isTopFolder = YES;
    
    UIBarButtonItem *sidebarButton = [self.navigationItem leftBarButtonItem];
    sidebarButton.target = self.revealViewController;
    sidebarButton.action = @selector(revealToggle:);
    sidebarButton.title = @"Menu";
    
    self.showingData = self.topFolders;
    self.subFolderType = @"";
    
    [self.collectionView reloadData];
}

- (IBAction)showMessage:(id)sender {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"No Data"
                                                      message:@"Sorry no data. Please connect to wifi."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [message show];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDoc"]) {
        AMDocumentViewController * document = (AMDocumentViewController *)segue.destinationViewController;
        [document setDoc:self.selectedDocument];
        [document setShouldDisplayChecklist:YES];
        [document setDelegate:self]; 
         
    } else if ([segue.identifier isEqualToString:@"toCheckList"]) {
        AMCheckListTableViewController *vc = (AMCheckListTableViewController *)segue.destinationViewController;
        
        // Combine our array of arrays into one long array to send to checklist
        NSMutableArray *checklistFinal = [[NSMutableArray alloc] init];
        for (NSArray *subArray in self.totalCheckListItems) {
            [checklistFinal addObjectsFromArray:subArray];
            
        }
        
        [vc setCheckList:checklistFinal];
        [vc setTransportData:self.transportData];
    }
}

// Admins can add documents
- (void)addDocument:(NSString *)name {
    
    // Create a folder
    if (self.isTopFolder) {
        PFObject *newFolder = [PFObject objectWithClassName:@"Folder"];
        newFolder[@"title"] = name;
        
        // remove all whitespace for class name
        NSArray* words = [name componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceCharacterSet]];
        NSString* nospacestring = [words componentsJoinedByString:@""];
        
        newFolder[@"Contains"] = nospacestring;
        [self.showingData insertObject:newFolder atIndex:0];
        self.topFolders = self.showingData;
        
        // Haha block syntax....
        // Tries to save the model eventually, aka if we don't have a data connection. But if we do, then show a nice insert animation
        [newFolder saveEventually:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self.collectionView performBatchUpdates:^{
                    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
                } completion:nil];
            }
        }];
        
    // Create a document
    } else {
        if (self.subFolderType.length > 0) {
            PFObject *newDoc = [PFObject objectWithClassName:self.subFolderType];
            newDoc[@"title"] = name;
            
            // Set the date
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd MMMM yyyy"];
            
            NSDate *date = [[NSDate alloc] init];
            
            NSString *formattedDateString = [dateFormatter stringFromDate:date];
            newDoc[@"originalDate"] = formattedDateString;
            
            // Create the section to show date
            newDoc[@"sections"] = @{@"originalDate":@"Date Created"}; 
    
            [self.showingData insertObject:newDoc atIndex:0];
            
            // Haha block syntax....
            // Tries to save the model eventually, aka if we don't have a data connection. But if we do, then show a nice insert animation
            [newDoc saveEventually:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [self.collectionView performBatchUpdates:^{
                        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
                    } completion:nil];
                }
            }];
        }
    }
    
}

#pragma mark - AlertView delegate


- (void)showAlertForAdding {
    
    // Alert for new folder
    if (self.isTopFolder) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Folder" message:@"Folder Name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert addButtonWithTitle:@"Add"];
        [alert show];
        
    // Alert for new document
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Document" message:@"Document Name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert addButtonWithTitle:@"Add"];
        [alert show];
    }
}

- (void)showAlertForDeleting:(UILongPressGestureRecognizer *)gr {
    
    if (gr.state == UIGestureRecognizerStateBegan) {
        
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[gr locationInView:self.collectionView]];
        
        // Setup the dialog
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"DO you want to delete?" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alertView addButtonWithTitle:@"Delete"];
        
        // Block magic
        [alertView showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                
                PFObject *removed = [self.showingData objectAtIndex:indexPath.row];
                // Remove from parse
                [self.showingData removeObjectAtIndex:indexPath.row];
                [removed deleteEventually];
                
                // If it is a folder then update the folders array
                if (self.isTopFolder) {
                    self.topFolders = self.showingData;
                }
                
                // Update collection view
                [self.collectionView performBatchUpdates:^{
                    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
                } completion:nil];
            }
        }];
    }
}
                                        


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        UITextField *name = [alertView textFieldAtIndex:0];
        if (name.text.length > 0) {
            [self addDocument:name.text];
        }
    }
}

#pragma mark - Our document delegate
- (void)addChecklist:(NSArray *)items forObject:(NSString *)obj {
    NSLog(@"%@", items);
    
    
    // If it already is checked and checked again, then remove it
    if ([self.selectedTransportCells containsObject:obj]) {
        [self.selectedTransportCells removeObject:obj];
        [self.totalCheckListItems removeObject:items];
    } else {
        [self.selectedTransportCells addObject:obj];
        [self.totalCheckListItems addObject:items];
    }
    
}

@end
