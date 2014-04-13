//
//  AMCheckListTableViewController.h
//  AeroMed
//
//  Created by Michael Torres on 3/16/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>


@interface AMCheckListTableViewController : UITableViewController <MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) NSArray *checkList;
@property (strong, nonatomic) PFObject *transportData;

@property (strong, nonatomic) NSDictionary *completedChecklist;
@property (strong, nonatomic) NSArray *associatedTransports;
@property BOOL isDisplayingCompletedList; 
@end
