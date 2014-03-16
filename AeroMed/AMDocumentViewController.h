//
//  AMDocumentViewController.h
//  AeroMed
//
//  Copyright (c) 2014 GVSU. All rights reserved.

#import <UIKit/UIKit.h>

@interface AMDocumentViewController : UITableViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSDictionary* info;
@property (weak, atomic) PFObject *doc;
@end
