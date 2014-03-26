//
//  AMCollectionViewViewController.h
//  AeroMed
//
//  Created by Michael Torres on 3/25/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMiPadDocumentViewController : UIViewController <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
