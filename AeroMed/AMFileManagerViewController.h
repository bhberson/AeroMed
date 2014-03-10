//
//  AMFileManagerViewController.h
//  AeroMed
//
//  Copyright (c) 2014 GVSU. All rights reserved.

#import <UIKit/UIKit.h>
#import "KLNoteViewController.h"

@interface AMFileManagerViewController : KLNoteViewController <NSCoding>
@property (weak, nonatomic) IBOutlet UILabel *centerText;
@property (strong, nonatomic) NSMutableArray *viewControllerData;
@property (strong, nonatomic) NSArray *navigationStructure;
@property (nonatomic) BOOL isSubFolder;
@property (nonatomic) BOOL isLoadingDocuments;
@end
