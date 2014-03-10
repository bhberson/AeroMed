//
//  AMFileManagerViewController.h
//  AeroMed
//
//  Copyright (c) 2014 GVSU. All rights reserved.

#import <UIKit/UIKit.h>
#import "KLNoteViewController.h"

@interface AMFileManagerViewController : KLNoteViewController <NSCoding>
@property (weak, nonatomic) IBOutlet UILabel *centerText;
@property (weak, nonatomic) IBOutlet UIButton *upButton;
- (IBAction)upButtonTapped:(id)sender;

@end
