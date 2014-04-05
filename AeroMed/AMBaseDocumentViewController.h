//
//  AMiPhoneDocumentViewController.h
//  AeroMed
//
//  Created by Michael Torres on 3/25/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMDocumentViewController.h"

@interface AMBaseDocumentViewController : UIViewController <UITextFieldDelegate,
UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextViewDelegate , UIAlertViewDelegate, UIGestureRecognizerDelegate, ChecklistProtocol>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
