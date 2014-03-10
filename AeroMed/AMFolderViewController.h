//
//  AMFolderViewController.h
//  AeroMed
//
//  Created by Michael Torres on 3/8/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMFolderViewController : UITableViewController
@property (nonatomic, strong) NSDictionary *info;
@property (nonatomic, strong) NSArray *allDocuments;
@end
