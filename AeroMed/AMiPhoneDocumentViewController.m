//
//  AMiPhoneDocumentViewController.m
//  AeroMed
//
//  Created by Michael Torres on 3/25/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import "AMiPhoneDocumentViewController.h"
#import "SWRevealViewController.h"
#import "AMDocumentCellView.h"
#import "Folder.h"
#import "OperatingProcedure.h"


@interface AMiPhoneDocumentViewController ()

@property (strong, nonatomic) NSMutableArray *topFolders;
@property (strong, nonatomic) NSMutableArray *showingData;

@end

@implementation AMiPhoneDocumentViewController

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
    
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"FolderCell"];
    _topFolders = [[NSMutableArray alloc] init];
    _showingData = [[NSMutableArray alloc] init];
   
    
//    AMiPadFlowLayout *layout = (AMiPadFlowLayout *)self.collectionView.collectionViewLayout;
//    [layout registerClass:[AMDecorationView class]  forDecorationViewOfKind:@"helicopter"];
    
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
    return _showingData.count;
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
    return CGSizeMake(130, 130);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(50, 20, 50, 20);
}


@end
