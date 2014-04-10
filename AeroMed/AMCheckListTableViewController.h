//
//  AMCheckListTableViewController.h
//  AeroMed
//
//  Created by Michael Torres on 3/16/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Transport.h"

@interface AMCheckListTableViewController : UITableViewController
@property (strong, nonatomic) NSArray *checkList;
@property (strong, nonatomic) PFObject *transportData;
@end
