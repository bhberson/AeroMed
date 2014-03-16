//
//  AMFileManagerViewController.h
//  AeroMed
//
//  Copyright (c) 2014 GVSU. All rights reserved.

#import <UIKit/UIKit.h>
#import "KLNoteViewController.h"

@interface AMFileManagerViewController : KLNoteViewController <UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *centerText;
- (IBAction)upButtonTapped:(id)sender;

@end
