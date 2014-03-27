//
//  AMiPhoneDocumentViewController.m
//  AeroMed
//
//  Created by Michael Torres on 3/25/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import "AMDocumentViewController.h"
#import "SWRevealViewController.h"
#import "AMDocumentCellView.h"
#import "Folder.h"
#import "OperatingProcedure.h"


@interface AMDocumentViewController ()

@property (strong, nonatomic) NSMutableArray *topFolders;
@property (strong, nonatomic) NSMutableArray *showingData;
@property BOOL isTopFolder;
@property (strong, nonatomic) NSMutableArray *allDocs;

@end

@implementation AMDocumentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    

    _topFolders = [[NSMutableArray alloc] init];
    _showingData = [[NSMutableArray alloc] init];
   

    PFQuery *query = [PFQuery queryWithClassName:@"Folder"];
    [query whereKeyExists:@"title"];
    
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       
        if (!error) {
            // Save an array of PFObjects
            NSMutableArray *folders = [[NSMutableArray alloc] initWithCapacity:[objects count]];
            
            for (int i = 0; i < objects.count; i++) {
                Folder *op = objects[i];
                [folders addObject:op];
            }
            
            _topFolders = folders;
            _showingData = _topFolders;
            _isTopFolder = YES;
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
    return _showingData.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AMDocumentCellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FolderCell" forIndexPath:indexPath];

    PFObject *data = [_showingData objectAtIndex:indexPath.row];
    cell.headerLabel.text = [data objectForKey:@"title"];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected cell %d", indexPath.row);
    PFObject *data = [_showingData objectAtIndex:indexPath.row];
    
    if (_isTopFolder) {
        [self queryForDocument:[data objectForKey:@"Contains"]];
        
        // Set the side bar button to go back up
        UIBarButtonItem *sidebarButton = [self.navigationItem leftBarButtonItem];
        sidebarButton.target = self;
        sidebarButton.title = @"Back";
        sidebarButton.action = @selector(upButtonTapped:);
    } else {
        
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
            _showingData = [[NSMutableArray alloc] initWithArray:objects];
            _isTopFolder = NO;
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
    if (!_allDocs) {
        NSMutableArray *queries = [[NSMutableArray alloc] initWithCapacity:_topFolders.count];
        _allDocs = [[NSMutableArray alloc] init];
        
        for (PFObject *folder in _topFolders) {
            PFQuery *q = [PFQuery queryWithClassName:[folder objectForKey:@"Contains"]];
            q.cachePolicy = kPFCachePolicyCacheElseNetwork;
            [q findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    [_allDocs addObjectsFromArray:objects];
                    
                } else {
                    NSLog(@"%@", error);
                    
                }
            }];
        }
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
    
    for (int i = 0; i < _allDocs.count; i++) {
        PFObject *doc = [_allDocs objectAtIndex: i];
        NSString *title = [[doc objectForKey:@"title"] lowercaseString];
        NSString *check = [searchBar.text lowercaseString];
        if ([title rangeOfString:check].location != NSNotFound) {
            [filteredData addObject:doc];
        }
    }
     _showingData = [[NSMutableArray alloc] initWithArray:filteredData];
    [self.collectionView reloadData];
    
    // Set the side bar button to go back up
    UIBarButtonItem *sidebarButton = [self.navigationItem leftBarButtonItem];
    sidebarButton.target = self;
    sidebarButton.title = @"Back";
    sidebarButton.action = @selector(upButtonTapped:);
    
    
}

// Go back to main navigation folders
- (void)upButtonTapped:(id)sender {
    _isTopFolder = YES;
    
    UIBarButtonItem *sidebarButton = [self.navigationItem leftBarButtonItem];
    sidebarButton.target = self.revealViewController;
    sidebarButton.action = @selector(revealToggle:);
    sidebarButton.title = @"Menu";
    
    _showingData = _topFolders;
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
@end
