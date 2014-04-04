//
//  AMDocumentViewController.h
//  AeroMed
//
//  Copyright (c) 2014 GVSU. All rights reserved.

#import <UIKit/UIKit.h>

@interface AMDocumentViewController : UITableViewController <UITextViewDelegate>
@property (weak, atomic) PFObject *doc;
@property BOOL shouldDisplayChecklist; 
@end
