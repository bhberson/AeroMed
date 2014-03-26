//
//  AMCollectionViewViewController.m
//  AeroMed
//
//  Created by Michael Torres on 3/25/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import "AMiPadDocumentViewController.h"
#import "SWRevealViewController.h"
#import "AMiPadFlowLayout.h"
#import "AMDecorationView.h"
#import "Folder.h"
#import "AMDocumentCellView.h"


@interface AMiPadDocumentViewController ()

@property (strong, nonatomic) NSMutableArray *showingData;
@property (strong, nonatomic) NSMutableArray *topFolders;


@end

@implementation AMiPadDocumentViewController

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
    
    query.cachePolicy = kPFCachePolicyCacheOnly;
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

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.showingData.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AMDocumentCellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FolderCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:0.176 green:0.690 blue:1.000 alpha:1.000];
    PFObject *data = [_showingData objectAtIndex:indexPath.row];
    cell.headerLabel.text = [data objectForKey:@"title"];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(200, 200);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(150, 20, 50, 20);
}

@end
