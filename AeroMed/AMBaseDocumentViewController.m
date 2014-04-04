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
#import "AMDocumentViewController.h"

@interface AMBaseDocumentViewController ()

@property (strong, nonatomic) NSMutableArray *topFolders;
@property (strong, nonatomic) NSMutableArray *showingData;
@property BOOL isTopFolder;
@property (strong, nonatomic) NSMutableArray *allDocs;
@property (strong, nonatomic) PFObject *selectedDocument;

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
    
    UIBarButtonItem *sidebarButton = [self.navigationItem leftBarButtonItem];
    
    // Set the side bar button action to show slide out menu
    sidebarButton.target = self.revealViewController;
    sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    

    self.topFolders = [[NSMutableArray alloc] init];
    self.showingData = [[NSMutableArray alloc] init];
   

    PFQuery *query = [PFQuery queryWithClassName:@"Folder"];
    [query whereKeyExists:@"title"];
    
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       
        if (!error) {
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
        } else {
            NSLog(@"%@", error);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"view will appear");
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
    
    return cell;
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
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       
        if (!error) {
            self.showingData = [[NSMutableArray alloc] initWithArray:objects];
            self.isTopFolder = NO;
            [self.collectionView reloadData];
            
        } else {
            NSLog(@"%@", error);
            
        }
    }];
    
    
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
         
    }
}
@end
